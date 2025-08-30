#define KNOTTED_NULL 0
#define KNOTTED_AS_TOP 1
#define KNOTTED_AS_BTM 2

/datum/sex_controller
	/// The user and the owner of the controller
	var/mob/living/user
	/// Target of our actions, can be ourself
	var/mob/living/target
	/// Whether the user desires to stop his current action
	var/desire_stop = FALSE
	/// What is the current performed action
	var/current_action = null
	/// Enum of desired speed
	var/speed = SEX_SPEED_MID
	/// Enum of desired force
	var/force = SEX_FORCE_MID
	/// Enum of manual arousal state
	var/manual_arousal = SEX_MANUAL_AROUSAL_DEFAULT
	/// Our arousal
	var/arousal = 0
	/// Our charge
	//var/charge = 0
	/// Whether we want to screw until finished, or non stop
	var/do_until_finished = TRUE
	/// Arousal won't change if active.
	var/arousal_frozen = FALSE
	var/last_arousal_increase_time = 0
	var/last_climax_time = 0
	var/last_reset_time = 0
	var/last_moan = 0
	var/last_pain = 0
	var/msg_signature = ""
	var/last_msg_signature = 0
	/// 40% arousal loss after each orgasm
	var/arousal_falloff_coeff = 0.6
	var/recent_orgasm_count = 0
	var/aphrodisiac = 1
	var/knotted_status = KNOTTED_NULL // knotted state and used to prevent multiple knottings when we do not handle that case
	var/tugging_knot = FALSE
	var/tugging_knot_check = 0
	var/tugging_knot_blocked = FALSE
	var/mob/living/carbon/knotted_owner = null // whom has the knot
	var/mob/living/carbon/knotted_recipient = null // whom took the knot
	var/has_statuses = FALSE
	/// Which zones we are using in the current action.
	var/using_zones = list()
	var/edging_charge = 0
	var/resistance_to_pleasure = RESIST_NONE


/datum/sex_controller/New(mob/living/owner)
	user = owner

/datum/sex_controller/Destroy()
	user = null
	target = null
	. = ..()

/proc/do_thrust_animate(atom/movable/user, atom/movable/target, pixels = 4, time = 2.7)
	var/oldx = user.pixel_x
	var/oldy = user.pixel_y
	var/target_x = oldx
	var/target_y = oldy
	var/dir = get_dir(user, target)
	if(user.loc == target.loc)
		dir = user.dir
	switch(dir)
		if(NORTH)
			target_y += pixels
		if(SOUTH)
			target_y -= pixels
		if(WEST)
			target_x -= pixels
		if(EAST)
			target_x += pixels

	animate(user, pixel_x = target_x, pixel_y = target_y, time = time)
	animate(pixel_x = oldx, pixel_y = oldy, time = time)

/datum/sex_controller/proc/do_message_signature(sigkey)
	var/properkey = "[speed][force][sigkey]"
	if(user.rogue_sneaking || user.alpha <= 100) //stealth sex les go
		return FALSE
	if(properkey == msg_signature && last_msg_signature + 8 SECONDS >= world.time)
		if(prob(40))
			user.balloon_alert_to_viewers(pick("*plap*","*plop*","*slap*","*pap*","*slick*"))
		return FALSE
	msg_signature = properkey
	last_msg_signature = world.time
	return TRUE

/datum/sex_action/proc/check_location_accessible(mob/living/carbon/human/user, mob/living/carbon/human/target, location = BODY_ZONE_CHEST, grabs = FALSE, skipundies = TRUE) //move to this check later
	var/obj/item/bodypart/bodypart = target.get_bodypart(location)

	var/self_target = FALSE
	var/datum/sex_controller/user_controller = user.sexcon
	if(user_controller.target == user)
		self_target = TRUE

	var/signalargs = list(src, bodypart, self_target)
	signalargs += args

	var/sigbitflags = SEND_SIGNAL(target, COMSIG_ERP_LOCATION_ACCESSIBLE, signalargs)
	bodypart = signalargs[ERP_BODYPART]

	if(sigbitflags & SIG_CHECK_FAIL)
		return FALSE

	if(!user.Adjacent(target) && !(sigbitflags & SKIP_ADJACENCY_CHECK))
		return FALSE

	if(!bodypart)
		return FALSE

	if(src.check_same_tile && (user != target || self_target) && !(sigbitflags & SKIP_TILE_CHECK))
		var/same_tile = (get_turf(user) == get_turf(target))
		var/grab_bypass = (src.aggro_grab_instead_same_tile && user.get_highest_grab_state_on(target) == GRAB_AGGRESSIVE)
		if(!same_tile && !grab_bypass)
			return FALSE

	if(src.require_grab && (user != target || self_target) && !(sigbitflags & SKIP_GRAB_CHECK))
		var/grabstate = user.get_highest_grab_state_on(target)
		if((grabstate == null || grabstate < src.required_grab_state))
			return FALSE

	var/result = get_location_accessible(target, location = location, grabs = grabs, skipundies = skipundies)
	if(result && user == target && !(bodypart in user_controller.using_zones) && user_controller.current_action == SEX_ACTION(src))
		user_controller.using_zones += location
	
	return result

/datum/sex_controller/proc/finished_check()
	if(!do_until_finished)
		return FALSE
	if(!just_climaxed())
		return FALSE
	return TRUE

/datum/sex_controller/proc/can_violate_victim(mob/living/victim)
	if(!victim.mind)
		return FALSE
	if(!victim.mind.key)
		return FALSE
	if(!user.client.prefs.violated[victim.mind.key])
		return FALSE
	if(user.client.prefs.violated[victim.mind.key] + VIOLATED_ALLOWED_TIME < world.time)
		return FALSE
	return TRUE

/datum/sex_controller/proc/need_to_be_violated(mob/living/victim)
	// Dont need to violate self
	if(user == victim)
		return FALSE
	// If user and victim both are not defiant, then no violation needs to happen
	if(!user.client?.prefs.defiant && !victim.client?.prefs.defiant)
		return FALSE
	// Need to violate AFK clients
	if(!victim.mind || !victim.mind.key || !victim.client) // Changed to OR statements to remove ZAPE of mobs without minds or keys
		return TRUE
	// Need to violate combat mode people - Include user to remove ZAPE
	if(victim.cmode || user.cmode)
		return TRUE
	// Need to violate unconscious people, or those surrendering to remove ZAPE
	if(victim.stat || victim.surrendering)
		return TRUE
	return FALSE

/datum/sex_controller/proc/violate_victim(mob/living/victim)
	if(!user.client)
		return
	if(!victim.mind)
		return
	if(!victim.mind.key)
		return
	if(user.client.prefs.violated[victim.mind.key] && user.client.prefs.violated[victim.mind.key] + VIOLATED_ALLOWED_TIME >= world.time)
		return
	var/pq_warning = pick(list("If I continue down this road, my soul will be burdened.", "I feel a terrible omen watching me...", "The forces of dark feel heavy on my soul."))
	to_chat(user, span_userdanger(pq_warning))
	var/alert = alert(user, "Do I really want to do this?", "Violate", "Yes", "No")
	if(alert != "Yes")
		return
	user.visible_message(span_boldwarning("[user] begins to violate [victim]!"))
	if(!do_after(user, 5 SECONDS, target = victim))
		return
	if(!need_to_be_violated(victim))
		return
	if(!user.client)
		return
	if(!victim.mind)
		return
	if(!victim.mind.key)
		return
	if(user.client.prefs.violated[victim.mind.key] && user.client.prefs.violated[victim.mind.key] + VIOLATED_ALLOWED_TIME >= world.time)
		return
	// ZAPED
	to_chat(user, span_boldwarning(pick(list("I feel tainted...", "I feel less human..."))))
	if(!issimple(target) && !issimple(victim))
		log_combat(user, victim, "Initiated rape against")
	//adjust_playerquality(-4, user.ckey, reason = "Initiated rape on an AFK/resisting person.")
	user.client.prefs.violated[victim.mind.key] = world.time

/datum/sex_controller/proc/adjust_speed(amt)
	speed = clamp(speed + amt, SEX_SPEED_MIN, SEX_SPEED_MAX)

/datum/sex_controller/proc/adjust_force(amt)
	force = clamp(force + amt, SEX_FORCE_MIN, SEX_FORCE_MAX)

/datum/sex_controller/proc/adjust_arousal_manual(amt)
	manual_arousal = clamp(manual_arousal + amt, SEX_MANUAL_AROUSAL_MIN, SEX_MANUAL_AROUSAL_MAX)

/datum/sex_controller/proc/adjust_resist(amt)
	resistance_to_pleasure = clamp(resistance_to_pleasure + amt, RESIST_NONE, RESIST_HIGH)

/datum/sex_controller/proc/update_pink_screen()
	var/severity = 0
	switch(arousal)
		if(1 to 20)
			severity = 1
		if(20 to 40)
			severity = 2
		if(40 to 60)
			severity = 3
		if(60 to 80)
			severity = 4
		if(80 to 100)
			severity = 5
		if(100 to 120)
			severity = 6
		if(120 to 140)
			severity = 7
		if(140 to 160)
			severity = 8
		if(160 to 180)
			severity = 9
		if(180 to INFINITY)
			severity = 10
	if(severity > 0)
		user.overlay_fullscreen("horny", /atom/movable/screen/fullscreen/love, severity)
	else
		user.clear_fullscreen("horny")

/datum/sex_controller/proc/start(mob/living/new_target)
	/*if(HAS_TRAIT(user, TRAIT_EORA_CURSE))
		to_chat(user, "<span class='warning'>The idea repulses me!</span>")
		user.cursed_freak_out()
		return FALSE*/

	set_target(new_target)
	show_ui()

/datum/sex_controller/proc/cum_onto()
	if(!issimple(target) && target.mind)
		log_combat(user, target, "Came onto [target]")
		if(HAS_TRAIT(target, TRAIT_GOODLOVER))
			if(!user.mob_timers["cumtri"])
				user.mob_timers["cumtri"] = world.time
				user.adjust_triumphs(1)
				user.add_stress(/datum/stressevent/cummax)
				to_chat(user, span_love("Our sex was a true TRIUMPH!"))
		else
			user.add_stress(/datum/stressevent/cumok)
	if(!issimple(user) && user.mind)
		log_combat(target, user, "Came inside [user]")
		if(HAS_TRAIT(user, TRAIT_GOODLOVER))
			if(!target.mob_timers["cumtri"])
				target.mob_timers["cumtri"] = world.time
				target.adjust_triumphs(1)
				target.add_stress(/datum/stressevent/cummax)
				to_chat(target, span_love("Our sex was a true TRIUMPH!"))
	else
		target.add_stress(/datum/stressevent/cumok)
	playsound(target, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
	add_cum_floor(get_turf(target))
	//if(splashed_user && !splashed_user.sexcon.knotted_status)
	//	splashed_user.apply_status_effect(/datum/status_effect/facial)
	after_climax()

/datum/sex_controller/proc/cum_into(oral = FALSE, vaginal = FALSE, anal = FALSE, nipple = FALSE, girljuice = FALSE)
	var/obj/item/organ/filling_organ/testicles/testes = user.getorganslot(ORGAN_SLOT_TESTICLES)
	if(target.mind)
		if(!issimple(target))
			log_combat(user, target, "Came inside [target]")
			if(HAS_TRAIT(target, TRAIT_GOODLOVER))
				if(!user.mob_timers["cumtri"])
					user.mob_timers["cumtri"] = world.time
					user.adjust_triumphs(1)
					user.add_stress(/datum/stressevent/cummax)
					to_chat(user, span_love("Our sex was a true TRIUMPH!"))
			else
				user.add_stress(/datum/stressevent/cumok)
	if(user.mind)
		if(!issimple(user))
			log_combat(target, user, "Came inside [user]")
			if(HAS_TRAIT(user, TRAIT_GOODLOVER))
				if(!target.mob_timers["cumtri"])
					target.mob_timers["cumtri"] = world.time
					target.adjust_triumphs(1)
					target.add_stress(/datum/stressevent/cummax)
					to_chat(target, span_love("Our sex was a true TRIUMPH!"))
				else
					target.add_stress(/datum/stressevent/cumok)
	if(girljuice)
		if(!issimple(target))
			target.reagents.add_reagent(/datum/reagent/water/pussjuice, 10)
			after_climax()
		else
			after_climax()
		return
	if(issimple(target))
		if(testes) //simple target just remove the coom.
			var/cum_to_take = CLAMP((testes.reagents.maximum_volume/2), 1, testes.reagents.total_volume)
			if(testes.reagents)
				testes.reagents.remove_reagent(testes.reagent_to_make, cum_to_take)
			user.add_stress(/datum/stressevent/cumok)
			after_climax()
			return
	if(!issimple(target) && testes)
		if(oral)
			playsound(target, pick(list('sound/misc/mat/mouthend (1).ogg','sound/misc/mat/mouthend (2).ogg')), 100, FALSE, ignore_walls = FALSE)
			if(testes.reagents)
				var/cum_to_take = CLAMP((testes.reagents.maximum_volume/2), 1, testes.reagents.total_volume)
				testes.reagents.trans_to(target, cum_to_take, transfered_by = user, method = INGEST)
		else
			var/obj/item/organ/filling_organ/cameloc
			if(vaginal)
				cameloc = target.getorganslot(ORGAN_SLOT_VAGINA)
			if(anal)
				cameloc = target.getorganslot(ORGAN_SLOT_ANUS)
			if(nipple)
				cameloc = target.getorganslot(ORGAN_SLOT_BREASTS)
			if(vaginal || anal || nipple)
				if(testes.reagents)
					var/cum_to_take = CLAMP((testes.reagents.maximum_volume/4), 1, min(testes.reagents.total_volume, cameloc.reagents.maximum_volume - cameloc.reagents.total_volume))
					testes.reagents.trans_to(cameloc, cum_to_take, transfered_by = user, method = INGEST)
			else
				if(testes.reagents)
					var/cum_to_take = CLAMP((testes.reagents.maximum_volume/4), 1, testes.reagents.total_volume)
					testes.reagents.trans_to(target,  cum_to_take, transfered_by = user, method = INGEST) //digest anyway if none of those.

		playsound(target, 'sound/misc/mat/endin.ogg', 50, TRUE, ignore_walls = FALSE)
	if(user != target)
		knot_try()
	if(testes)
		if(testes.reagents)
			if(testes.reagents.total_volume <= testes.reagents.maximum_volume / 4)
				to_chat(user, span_info("Damn, my [pick(testes.altnames)] are pretty dry now."))
	after_climax()
	if(!oral)
		after_intimate_climax()

/datum/sex_controller/proc/climax()
	if(!issimple(user))
		log_combat(user, user, "Orgasmed")
	user.visible_message(span_love("[user] makes a mess!"))
	//small heal burst, this should not happen often due the delay on how often one can cum.
	var/sexhealrand = rand(5, 15)
	/*if(!issimple(user))
		if(HAS_TRAIT(user, TRAIT_SEXDEVO) && !issimple(user))
			var/sexhealmult = user.mind.get_skill_level(/datum/skill/magic/holy)
			if(sexhealmult < 2) //so its never below 2 for ones with trait.
				sexhealmult = 2
			sexhealrand *= sexhealmult
			to_chat(user, span_green("I feel Viiritri's blessing."))*/
	user.adjustBruteLoss(-sexhealrand)
	sexhealrand *= 0.5
	user.adjustFireLoss(-sexhealrand)

	playsound(user, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
	add_cum_floor(get_turf(user))
	after_climax()

/datum/sex_controller/proc/ejaculate_container(obj/item/reagent_containers/glass/C)
	log_combat(user, user, "Ejaculated into a container")
	user.visible_message(span_love("[user] spills into [C]!"))
	playsound(user, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
	var/obj/item/organ/filling_organ/testicles/testes = user.getorganslot(ORGAN_SLOT_TESTICLES)
	var/cum_to_take = CLAMP((testes.reagents.maximum_volume), 1, min(testes.reagents.total_volume, C.volume - C.reagents.total_volume))
	testes.reagents.trans_to(C, cum_to_take, transfered_by = user)
	after_climax()

/datum/sex_controller/proc/milk_container(obj/item/reagent_containers/glass/C)
	log_combat(user, user, "Was milked into a container")
	user.visible_message(span_love("[user] lactates into [C]!"))
	playsound(user, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
	var/obj/item/organ/filling_organ/breasts/tiddies = user.getorganslot(ORGAN_SLOT_BREASTS) // tiddy hehe
	var/milk_to_take = CLAMP((tiddies.reagents.maximum_volume), 1, min(tiddies.reagents.total_volume, C.volume - C.reagents.total_volume))
	tiddies.reagents.trans_to(C, milk_to_take, transfered_by = user)
	after_climax()

/datum/sex_controller/proc/after_climax()
	switch(edging_charge)
		if(0 to 20)
			to_chat(user, span_love("Feels good to finally cum!"))
		if(21 to 50)
			to_chat(user, span_love("Oh gods, I came!"))
		if(51 to MAX_EDGING)
			to_chat(user, span_love("Finally finally finally!"))
	if(user.has_penis())
		user.apply_status_effect(/datum/status_effect/edged_penis_cooldown)
		set_edging(0)
	else
		set_edging(edging_charge * 0.70)
	set_arousal(arousal * (arousal_falloff_coeff + edging_charge / MAX_EDGING))//set_arousal(arousal * (arousal_falloff_coeff + (1 - arousal_falloff_coeff) * edging_charge / MAX_EDGING))
	if(user.has_flaw(/datum/charflaw/addiction/lovefiend))
		user.sate_addiction()
	if(!user.rogue_sneaking && user.alpha > 100) //stealth sex, keep your voice down.
		if(!user.can_speak())
			user.emote("sexmoangag_org", forced = TRUE)
		else
			user.emote("sexmoanhvy", forced = TRUE)
	user.playsound_local(user, 'sound/misc/mat/end.ogg', 100)
	last_climax_time = world.time
	recent_orgasm_count += 1

/datum/sex_controller/proc/after_intimate_climax()
	if(user == target)
		return
	if(HAS_TRAIT(target, TRAIT_GOODLOVER))
		if(!user.mob_timers["cumtri"])
			user.mob_timers["cumtri"] = world.time
			user.adjust_triumphs(1)
			user.add_stress(/datum/stressevent/cummax)
			to_chat(user, span_love("Our sex was a true TRIUMPH!"))
		else
			user.add_stress(/datum/stressevent/cumok)
	if(!issimple(user) && user.mind)
		log_combat(target, user, "Came inside [user]")
		if(HAS_TRAIT(user, TRAIT_GOODLOVER))
			if(!target.mob_timers["cumtri"])
				target.mob_timers["cumtri"] = world.time
				target.adjust_triumphs(1)
				target.add_stress(/datum/stressevent/cummax)
				to_chat(target, span_love("Our sex was a true TRIUMPH!"))
	else
		target.add_stress(/datum/stressevent/cumok)

/datum/sex_controller/proc/just_climaxed()
	return (last_climax_time + 2 SECONDS >= world.time)


/datum/sex_controller/proc/set_arousal(amount)
	if(amount > arousal)
		last_arousal_increase_time = world.time
	arousal = clamp(amount, 0, MAX_AROUSAL)
	update_pink_screen()
	update_erect_state()

/datum/sex_controller/proc/update_erect_state()
	var/obj/item/organ/penis/penis = user.getorganslot(ORGAN_SLOT_PENIS)
	
	if(user.mind)
		var/datum/antagonist/werewolf/W = user.mind.has_antag_datum(/datum/antagonist/werewolf/)
		if(W && W.transformed == TRUE)
			user.regenerate_icons()

	if(penis && hascall(penis, "update_erect_state") && !istype(penis, /obj/item/organ/penis/internal))//if(penis && hascall(penis, "update_erect_state"))
		penis.update_erect_state()

/datum/sex_controller/proc/adjust_arousal(amount)
	set_arousal(arousal + amount)

/datum/sex_controller/proc/perform_deepthroat_oxyloss(mob/living/action_target, oxyloss_amt)
	var/oxyloss_multiplier = 0
	switch(force)
		if(SEX_FORCE_LOW)
			oxyloss_multiplier = 0
		if(SEX_FORCE_MID)
			oxyloss_multiplier = 0
		if(SEX_FORCE_HIGH)
			oxyloss_multiplier = 0.5
		if(SEX_FORCE_EXTREME)
			oxyloss_multiplier = 1.0
	oxyloss_amt *= oxyloss_multiplier
	if((oxyloss_amt <= 0) || (action_target.getOxyLoss() > 30))
		return
	action_target.adjustOxyLoss(oxyloss_amt)
	// Indicate someone is choking through sex
	if(action_target.oxyloss >= 50 && prob(33))
		action_target.emote(pick(list("gag", "choke", "gasp")), forced = TRUE)

//To show that they are choking
	var/choke_message = pick("gasps for air!", "chokes!")
	if(prob(33) && oxyloss_amt >= 1)
		action_target.visible_message(span_warning("[action_target] [choke_message]"))
		action_target.emote("gasp", forced = TRUE)

/datum/sex_controller/proc/perform_sex_action(mob/living/action_target, arousal_amt, pain_amt, giving)
	if(HAS_TRAIT(user, TRAIT_GOODLOVER))
		arousal_amt *= 1.5
		if(prob(10)) //10 perc chance each action to emit the message so they know who the fuckin' wituser.
			var/lovermessage = pick("This feels so good!","I am in nirvana!","This is too good to be possible!","By the Gods!","I can't stop, too good!~")
			to_chat(action_target, span_love(lovermessage))
	/*if(HAS_TRAIT(user, TRAIT_DEATHBYSNOOSNOO))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			pain_amt *= 2.5*/

	action_target.sexcon.receive_sex_action(arousal_amt, pain_amt, giving, force, speed, resistance_to_pleasure)

/datum/sex_controller/proc/receive_sex_action(arousal_amt, pain_amt, giving, applied_force, applied_speed, applied_resist)
	arousal_amt *= get_force_pleasure_multiplier(applied_force, giving)
	pain_amt *= get_force_pain_multiplier(applied_force)
	pain_amt *= get_speed_pain_multiplier(applied_speed)

	if(user.stat == DEAD)
		if(prob(2)) //since there is no proper diseases....
			target.reagents.add_reagent(/datum/reagent/toxin/organpoison, 1)

	var/sexhealrand = rand(0.2, 0.4)
	//go go gadget sex healing.. magic?
	if(user.buckled?.sleepy) //gooder healing in bed
		sexhealrand *= 4
	/*if(!issimple(user)||!issimple(target))
		if(user.health < user.maxHealth) //so its not spammy
			if(HAS_TRAIT(user, TRAIT_SEXDEVO))
				var/sexhealmult = user.mind.get_skill_level(/datum/skill/magic/holy)
				if(sexhealmult < 2) //so its never below 2 for ones with trait.
					sexhealmult = 2
				sexhealrand *= sexhealmult
				//heals target unless user zaping.
				if(!user.cmode)
					if(!issimple(target))
						target.adjustBruteLoss(-sexhealrand)
						target.adjustFireLoss(-sexhealrand/2)
				if(prob(4))
					to_chat(user, span_green("I feel Viiritri's miracle upon me."))
					sexhealrand *= 2*/
	if(!user.cmode && prob(1)) //surprise heal burst at 1% chance
		to_chat(user, span_greentextbig("I suddenly feel much better thanks to this act..."))
		sexhealrand *= 5
	user.heal_wounds(sexhealrand)
	user.heal_overall_damage(sexhealrand, sexhealrand/2, updating_health = TRUE)

	//grant devotion through sex because who needs praying.
	//not sure if it works right but i dont need to test cuz its asked to be commented out anyway, ffs.
	/*if(!issimple(user))
		var/mob/living/carbon/human/devouser = user
		var/datum/devotion/C = devouser.devotion
		if(devouser && C?.devotion)
			if(devouser.mind?.get_skill_level(/datum/skill/magic/holy))
				if(C.devotion < C.max_devotion)
					C.update_devotion(rand(1,2))
					if(HAS_TRAIT(devouser, TRAIT_SEXDEVO))
						C.update_devotion(rand(4,8))
						if(prob(3))
							to_chat(devouser, span_info("I feel Viiritri guide me."))*/

	var/isnymph = 0
	if(HAS_TRAIT(user, TRAIT_NYMPHO_CURSE) || user.has_flaw(/datum/charflaw/addiction/lovefiend))
		isnymph = 2
	if(user.has_status_effect(/datum/status_effect/debuff/orgasmbroken))
		if(isnymph)
			arousal_amt *= 2
		else
			arousal_amt *= 1.5
		update_aching(1)
		var/lovermessage = pick("This feels too good!", "I must never stop!", "I want MORE!", "I need this!")
		if(prob(15))
			to_chat(user, span_love(lovermessage))
	else if(user.has_status_effect(/datum/status_effect/debuff/cumbrained))
		update_aching(5)
		var/lovermessage
		if(!isnymph)
			arousal_amt *= 0.5
			lovermessage = pick("My mind is going blank!", "I'm too spent!", "This is too much!")
		else
			lovermessage = pick("My mind is getting fucked out!", "I'm soo full!", "I LOVE this!")
		if(prob(15))
			to_chat(user, span_love(lovermessage))
	else if(user.has_status_effect(/datum/status_effect/debuff/loinspent))
		update_aching(2)
		var/lovermessage
		if(!isnymph)
			arousal_amt *= 0.8
			lovermessage = pick("This is starting to feel unpleasant...", "Maybe I should rest soon...", "My loins are starting to chafe a bit.")
		else
			lovermessage = pick("This is starting to feel interesting.", "We're getting there...", "I love this feeling.")
		if(prob(15))
			to_chat(user, span_love(lovermessage))
	if(arousal > AROUSAL_EDGING_THRESHOLD)
		adjust_edging(arousal_amt / 2)
	if(arousal > 45)
		arousal_amt *= get_resist_multiplier(applied_resist)
	if(!arousal_frozen)
		adjust_arousal(arousal_amt)
	damage_from_pain(pain_amt)
	try_do_moan(arousal_amt, pain_amt, applied_force, giving)
	try_do_pain_effect(pain_amt, giving)

/datum/sex_controller/proc/damage_from_pain(pain_amt)
	if(pain_amt < PAIN_MINIMUM_FOR_DAMAGE)
		return
	//var/damage = (pain_amt / PAIN_DAMAGE_DIVISOR)
	var/obj/item/bodypart/part = user.get_bodypart(BODY_ZONE_CHEST)
	if(!part)
		return
	//user.apply_damage(damage, BRUTE, part)
	update_aching(pain_amt)

/datum/sex_controller/proc/try_do_moan(arousal_amt, pain_amt, applied_force, giving)
	if(arousal_amt < 1.5)
		return
	if(user.stat != CONSCIOUS)
		return
	if(user.rogue_sneaking || user.alpha <= 100) //stealth sex, keep your voice down.
		return
	if(last_moan + MOAN_COOLDOWN >= world.time)
		return
	if(prob(15))
		return
	if(user.gender == MALE && prob(50))
		return
	var/chosen_emote
	switch(arousal)
		if(0 to 40)
			if(!user.can_speak())
				chosen_emote = "sexmoangag"
			else
				chosen_emote = "sexmoanlight"
		if(40 to 75)
			if(!user.can_speak())
				chosen_emote = "sexmoangag"
			else
				chosen_emote = "sexmoanmed"
		if(75 to INFINITY)
			if(!user.can_speak())
				chosen_emote = "sexmoangag"
			else
				chosen_emote = "sexmoanhvy"

	if(pain_amt >= PAIN_MILD_EFFECT)
		if(giving)
			if(!user.can_speak())
				chosen_emote = "sexmoangag"
			else
				if(prob(15))
					chosen_emote = "sexmoanhvy"
				else
					chosen_emote = "sexmoanmed"
	if(pain_amt >= PAIN_MED_EFFECT)
		if(giving)
			if(!user.can_speak())
				chosen_emote = "sexmoangag"
			else
				if(prob(20))
					chosen_emote = "sexmoanhvy"
				else
					chosen_emote = "sexmoanmed"
		else
			if(!user.can_speak())
				chosen_emote = "sexmoangag"
			else
				if(prob(60))
					// Because males have atrocious whimper noise
					if(user.gender == FEMALE && prob(15))
						chosen_emote = "whimper"
					else
						chosen_emote = "sexmoanhvy"

	last_moan = world.time
	user.emote(chosen_emote, forced = TRUE)

/datum/sex_controller/proc/try_do_pain_effect(pain_amt, giving)
	if(pain_amt < PAIN_MILD_EFFECT)
		return
	if(last_pain + PAIN_COOLDOWN >= world.time)
		return
	if(prob(50))
		return
	last_pain = world.time
	if(!user.has_flaw(/datum/charflaw/addiction/masochist))
		if(pain_amt >= PAIN_HIGH_EFFECT)
			var/pain_msg = pick(list("IT HURTS!!!", "IT NEEDS TO STOP!!!", "I CAN'T TAKE IT ANYMORE!!!"))
			to_chat(user, span_boldwarning(pain_msg))
			user.flash_fullscreen("redflash2")
			if(prob(70) && user.stat == CONSCIOUS)
				user.visible_message(span_warning("[user] shudders in pain!"))
		else if(pain_amt >= PAIN_MED_EFFECT)
			var/pain_msg = pick(list("It hurts!", "It pains me!"))
			to_chat(user, span_boldwarning(pain_msg))
			user.flash_fullscreen("redflash1")
			if(prob(40) && user.stat == CONSCIOUS)
				user.visible_message(span_warning("[user] shudders in pain!"))
		else
			var/pain_msg = pick(list("It hurts a little...", "It stings...", "I'm aching..."))
			to_chat(user, span_warning(pain_msg))
	else
		if(pain_amt >= PAIN_HIGH_EFFECT)
			var/pain_msg = pick(list("IT HURTS, DON'T STOP!!!", "DON'T STOP!!!", "MORE, MORE!!!"))
			to_chat(user, span_boldgreen(pain_msg))
			user.flash_fullscreen("redflash2")
			if(prob(70) && user.stat == CONSCIOUS)
				user.visible_message(span_warning("[user] shudders in pain!"))
		else if(pain_amt >= PAIN_MED_EFFECT)
			var/pain_msg = pick(list("It hurts!", "It pains me!"))
			to_chat(user, span_boldgreen(pain_msg))
			user.flash_fullscreen("redflash1")
			if(prob(40) && user.stat == CONSCIOUS)
				user.visible_message(span_warning("[user] shudders in pain!"))
		else
			var/pain_msg = pick(list("It hurts a little...", "It stings...", "I'm aching..."))
			to_chat(user, span_boldgreen(pain_msg))

/datum/sex_controller/proc/update_aching(pain_amt)
	if(pain_amt >= LOINHURT_GAIN_THRESHOLD)
		if(user.has_flaw(/datum/charflaw/addiction/masochist))
			user.sate_addiction()
			user.add_stress(/datum/stressevent/loinachegood)
			return
		if(user.has_flaw(/datum/charflaw/addiction/lovefiend))
			user.add_stress(/datum/stressevent/loinachegood)
			return
		user.add_stress(/datum/stressevent/loinache)
	else if (pain_amt <= LOINHURT_LOSE_THRESHOLD)
		user.remove_stress(/datum/stressevent/loinache)

/datum/sex_controller/proc/check_active_orgasm()
	if(arousal < ACTIVE_ORGASM_THRESHOLD)
		return FALSE
	//if(is_spent() && !issimple(user))
	//	return FALSE
	if(!can_climax())
		return FALSE
	if(last_climax_time + ORGASM_COOLDOWN_TIME - clamp(edging_charge, 0, ORGASM_COOLDOWN_TIME - 10) >= world.time)
		return FALSE
	return TRUE

/datum/sex_controller/proc/can_climax()
	if(user.seeksfuck) //should filter down to only npcs with seeksfuck behavior.
		return TRUE
	if(!user.getorganslot(ORGAN_SLOT_TESTICLES) && !user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_LIMPDICK))
		return FALSE
	return TRUE

/datum/sex_controller/proc/handle_passive_orgasm()
	if(arousal < PASSIVE_ORGASM_THRESHOLD)
		return
	//if(is_spent() && !issimple(user))
	//	return
	if(!can_climax())
		return FALSE
	if(last_climax_time + ORGASM_COOLDOWN_TIME - clamp(edging_charge, 0, ORGASM_COOLDOWN_TIME - 10) >= world.time)
		return FALSE
	climax()

/datum/sex_controller/proc/handle_container_ejaculation()
	if(arousal < PASSIVE_ORGASM_THRESHOLD)
		return
	if(!can_climax())
		return FALSE
	ejaculate_container(user.get_active_held_item())

/datum/sex_controller/proc/handle_container_milk()
	if(arousal < PASSIVE_ORGASM_THRESHOLD)
		return
	milk_container(user.get_active_held_item())

/datum/sex_controller/proc/handle_cock_milking(mob/living/carbon/human/milker)
	if(arousal < ACTIVE_ORGASM_THRESHOLD)
		return
	//if(is_spent())
	//	return
	if(!can_climax())
		return FALSE
	ejaculate_container(milker.get_active_held_item())

/datum/sex_controller/proc/handle_breast_milking(mob/living/carbon/human/milker)
	if(arousal < ACTIVE_ORGASM_THRESHOLD)
		return
	milk_container(milker.get_active_held_item())

/datum/sex_controller/proc/can_use_penis()
	if(HAS_TRAIT(user, TRAIT_LIMPDICK))
		return FALSE
	var/obj/item/organ/penis/penor = user.getorganslot(ORGAN_SLOT_PENIS)
	if(!penor)
		return FALSE
	return TRUE

/datum/sex_controller/proc/considered_limp()
	if(arousal >= AROUSAL_HARD_ON_THRESHOLD)
		return FALSE
	return TRUE
/*
/datum/sex_controller/proc/is_spent()
	if(charge < CHARGE_FOR_CLIMAX)
		return TRUE
	return FALSE

/datum/sex_controller/proc/set_charge(amount)
	var/empty = (charge < CHARGE_FOR_CLIMAX)
	charge = clamp(amount, 0, SEX_MAX_CHARGE)
	var/after_empty = (charge < CHARGE_FOR_CLIMAX)
	if(empty && !after_empty)
		to_chat(user, span_notice("I feel like I'm not so spent anymore"))
	if(!empty && after_empty)
		to_chat(user, span_notice("I'm spent!"))

/datum/sex_controller/proc/adjust_charge(amount)
	set_charge(charge + amount)

/datum/sex_controller/proc/handle_charge(dt)
	if(user.has_flaw(/datum/charflaw/addiction/lovefiend))
		dt *= 2
	adjust_charge(dt * CHARGE_RECHARGE_RATE)
	if(is_spent())
		if(arousal > 60)
			to_chat(user, span_warning("I'm too spent!"))
			adjust_arousal(-20)
		adjust_arousal(-dt * SPENT_AROUSAL_RATE)*/

/datum/sex_controller/proc/process_sexcon(dt)
	handle_arousal_unhorny(dt)
	//handle_charge(dt)
	handle_orgasm_charge()
	handle_statuses()
	handle_passive_orgasm()

/datum/sex_controller/proc/handle_orgasm_charge()
	//if(user.has_status_effect(/datum/status_effect/debuff/orgasmbroken))
	//	adjust_arousal(AROUSAL_HIGH_UNHORNY_RATE - 0.1) //too many orgasms keeps arousal at the edge //maybe a little bit hacky, we'll see
	if(!recent_orgasm_count)
		return
	if(last_reset_time + ORGASM_RESET_TIME < world.time)
		recent_orgasm_count -= 1
		last_reset_time = world.time

/datum/sex_controller/proc/handle_arousal_unhorny(dt)
	if(arousal_frozen)
		return
	if(!can_climax())
		adjust_arousal(-dt * IMPOTENT_AROUSAL_LOSS_RATE)
	if(last_arousal_increase_time + AROUSAL_TIME_TO_UNHORNY >= world.time)
		return
	var/rate
	switch(arousal)
		if(-INFINITY to 25)
			rate = AROUSAL_LOW_UNHORNY_RATE
		if(25 to 40)
			rate = AROUSAL_MID_UNHORNY_RATE
		if(40 to INFINITY)
			rate = AROUSAL_HIGH_UNHORNY_RATE
	adjust_arousal(-dt * rate)

	adjust_edging(-dt * 0.01)

/datum/sex_controller/proc/adjust_edging(amount)
	set_edging(edging_charge + amount)

/datum/sex_controller/proc/set_edging(amount)
	edging_charge = clamp(amount, 0, MAX_EDGING)

/datum/sex_controller/proc/show_ui()
	if(!target.erpable && issimple(target))
		to_chat(src, span_info("I can't do anything to this creature."))
		return
	var/list/dat = list()
	var/force_name = get_force_string()
	var/speed_name = get_speed_string()
	var/manual_arousal_name = get_manual_arousal_string()
	var/resist_name = get_resist_string()
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		dat += "<center><a href='?src=[REF(src)];task=speed_down'>\<</a> [speed_name] <a href='?src=[REF(src)];task=speed_up'>\></a> ~|~ <a href='?src=[REF(src)];task=force_down'>\<</a> [force_name] <a href='?src=[REF(src)];task=force_up'>\></a></center>"
	else
		dat += "<center><a href='?src=[REF(src)];task=speed_down'>\<</a> [speed_name] <a href='?src=[REF(src)];task=speed_up'>\></a> ~|~ <a href='?src=[REF(src)];task=force_down'>\<</a> [force_name] <a href='?src=[REF(src)];task=force_up'>\></a> ~|~ <a href='?src=[REF(src)];task=manual_arousal_down'>\<</a> [manual_arousal_name] <a href='?src=[REF(src)];task=manual_arousal_up'>\></a></center>"
	dat += "<center>| <a href='?src=[REF(src)];task=toggle_finished'>[do_until_finished ? "UNTIL IM FINISHED" : "UNTIL I STOP"]</a> |</center>"
	//dat += "<center><a href='?src=[REF(src)];task=set_arousal'>SET AROUSAL</a> | <a href='?src=[REF(src)];task=freeze_arousal'>[arousal_frozen ? "UNFREEZE AROUSAL" : "FREEZE AROUSAL"]</a></center>"
	dat += "<center>Holding pleasure: <a href='?src=[REF(src)];task=resist_down'>\<</a> [resist_name] <a href='?src=[REF(src)];task=resist_up'>\></a></center>"
	if(target == user)
		dat += "<center>Doing unto yourself</center>"
	else
		dat += "<center>Doing unto [target]'s</center>"
	if(current_action)
		dat += "<center><a href='?src=[REF(src)];task=stop'>Stop</a></center>"
	else
		dat += "<br>"
	dat += "<table width='100%'><td width='50%'></td><td width='50%'></td><tr>"
	var/i = 0
	for(var/action_type in GLOB.sex_actions)
		var/datum/sex_action/action = SEX_ACTION(action_type)
		if(!action.shows_on_menu(user, target))
			continue
		dat += "<td>"
		var/link = ""
		if(!can_perform_action(action_type))
			link = "linkOff"
		if(current_action == action_type)
			link = "linkOn"
		dat += "<center><a class='[link]' href='?src=[REF(src)];task=action;action_type=[action_type]'>[action.name]</a></center>"
		dat += "</td>"
		i++
		if(i >= 2)
			i = 0
			dat += "</tr><tr>"

	dat += "</tr></table>"
	var/datum/browser/popup = new(user, "sexcon", "<center>Sate Desire</center>", 490, 550)
	popup.set_content(dat.Join())
	popup.open()
	return

/datum/sex_controller/Topic(href, href_list)
	if(usr != user)
		return
	switch(href_list["task"])
		if("action")
			var/action_path = text2path(href_list["action_type"])
			var/datum/sex_action/action = SEX_ACTION(action_path)
			if(!action)
				return
			try_start_action(action_path)
		if("stop")
			try_stop_current_action()
		if("speed_up")
			adjust_speed(1)
		if("speed_down")
			adjust_speed(-1)
		if("force_up")
			adjust_force(1)
		if("force_down")
			adjust_force(-1)
		if("manual_arousal_up")
			adjust_arousal_manual(1)
		if("manual_arousal_down")
			adjust_arousal_manual(-1)
		if("manual_arousal_up")
			adjust_arousal_manual(1)
		if("manual_arousal_down")
			adjust_arousal_manual(-1)
		if("toggle_finished")
			do_until_finished = !do_until_finished
		if("set_arousal")
			var/amount = input(user, "Value above 120 will immediately cause orgasm!", "Set Arousal", arousal) as num
			set_arousal(amount)
		if("freeze_arousal")
			arousal_frozen = !arousal_frozen
		if("resist_up")
			adjust_resist(1)
		if("resist_down")
			adjust_resist(-1)
	show_ui()

/datum/sex_controller/proc/try_stop_current_action()
	if(!current_action)
		return
	desire_stop = TRUE
	user.doing = FALSE

/datum/sex_controller/proc/stop_current_action()
	if(!current_action)
		return
	var/datum/sex_action/action = SEX_ACTION(current_action)
	if (!user.sexcon.knotted_status) // never show the remove message, unless unknotted
		action.on_finish(user, target)
	desire_stop = FALSE
	user.doing = FALSE
	current_action = null
	using_zones = list()

/datum/sex_controller/proc/try_start_action(action_type)
	if(action_type == current_action)
		try_stop_current_action()
		return
	if(current_action != null)
		try_stop_current_action()
		return
	if(!action_type)
		return
	if(!can_perform_action(action_type))
		return
	if(knotted_status)
		knot_remove()
		return
//	if(need_to_be_violated(target) && !can_violate_victim(target))
//		violate_victim(target) - Commented out to disable the pop up and just disable all defiant ZAPE
	if(need_to_be_violated(target) && !can_violate_victim(target))
		return
	// Set vars
	desire_stop = FALSE
	current_action = action_type
	var/datum/sex_action/action = SEX_ACTION(current_action)
	if(!issimple(target) && !issimple(user))
		log_combat(user, target, "Started sex action: [action.name]")
	INVOKE_ASYNC(src, PROC_REF(sex_action_loop))

/datum/sex_controller/proc/sex_action_loop()
	// Do action loop
	var/performed_action_type = current_action
	var/datum/sex_action/action = SEX_ACTION(current_action)
	action.on_start(user, target)
	while(TRUE)
		if(!user.stamina_add(action.stamina_cost * get_stamina_cost_multiplier()))
			break
		if(user.mind)
			user.adjust_experience(/datum/skill/misc/athletics, (user.STAINT*0.04)*get_stamina_cost_multiplier()) //endurance training boiii
		if(!do_after(user, (action.do_time / get_speed_multiplier()), target = target))
			break
		if(current_action == null || performed_action_type != current_action)
			break
		if(need_to_be_violated(target) && !can_violate_victim(target))
			break
		if(!can_perform_action(current_action))
			break
		if(action.is_finished(user, target))
			break
		if(desire_stop)
			break
		action.on_perform(user, target)
		// It could want to finish afterwards the performed action
		if(action.is_finished(user, target))
			break
		if(!action.continous)
			break
	stop_current_action()

/datum/sex_controller/proc/can_perform_action(action_type)
	if(!action_type)
		return FALSE
	var/datum/sex_action/action = SEX_ACTION(action_type)
	if(!inherent_perform_check(action_type))
		return FALSE
	if(!action.can_perform(user, target))
		return FALSE
	return TRUE

/datum/sex_controller/proc/inherent_perform_check(action_type)
	var/datum/sex_action/action = SEX_ACTION(action_type)
	if(!target)
		return FALSE
	if(user.stat != CONSCIOUS)
		return FALSE
	if(!user.Adjacent(target))
		return FALSE
	if(action.check_incapacitated && user.incapacitated())
		return FALSE
	var/mob/living/carbon/human/userino = user
	if(action.check_same_tile)
		var/same_tile = (get_turf(user) == get_turf(target))
		var/grab_bypass = (action.aggro_grab_instead_same_tile && userino.get_highest_grab_state_on(target) == GRAB_AGGRESSIVE)
		if(!same_tile && !grab_bypass)
			return FALSE
	if(action.require_grab)
		var/grabstate = userino.get_highest_grab_state_on(target)
		if(grabstate == null || grabstate < action.required_grab_state)
			return FALSE
	return TRUE

/datum/sex_controller/proc/set_target(mob/living/new_target)
	target = new_target

/datum/sex_controller/proc/get_speed_multiplier()
	switch(speed)
		if(SEX_SPEED_LOW)
			return 1.5
		if(SEX_SPEED_MID)
			return 2.5
		if(SEX_SPEED_HIGH)
			return 3
		if(SEX_SPEED_EXTREME)
			return 4

/datum/sex_controller/proc/get_stamina_cost_multiplier()
	switch(force)
		if(SEX_FORCE_LOW)
			return 0.5
		if(SEX_FORCE_MID)
			return 1
		if(SEX_FORCE_HIGH)
			return 1.25
		if(SEX_SPEED_EXTREME)
			return 1.5

/datum/sex_controller/proc/get_force_pleasure_multiplier(passed_force, giving)
	switch(passed_force)
		if(SEX_FORCE_LOW)
			if(giving)
				return 0.6
			else
				return 0.6
		if(SEX_FORCE_MID)
			if(giving)
				return 1.0
			else
				return 1.0
		if(SEX_FORCE_HIGH)
			if(giving)
				return 1.4
			else
				return 1.0
		if(SEX_FORCE_EXTREME)
			if(giving)
				return 1.8
			else
				return 0.6

/datum/sex_controller/proc/get_force_pain_multiplier(passed_force)
	switch(passed_force)
		if(SEX_FORCE_LOW)
			return 0.5
		if(SEX_FORCE_MID)
			return 1.0
		if(SEX_FORCE_HIGH)
			return 2.0
		if(SEX_FORCE_EXTREME)
			return 3.0

/datum/sex_controller/proc/get_speed_pain_multiplier(passed_speed)
	switch(passed_speed)
		if(SEX_SPEED_LOW)
			return 0.8
		if(SEX_SPEED_MID)
			return 1.0
		if(SEX_SPEED_HIGH)
			return 1.2
		if(SEX_SPEED_EXTREME)
			return 1.4

/datum/sex_controller/proc/get_force_string()
	switch(force)
		if(SEX_FORCE_LOW)
			return "<font color='#eac8de'>GENTLE</font>"
		if(SEX_FORCE_MID)
			return "<font color='#e9a8d1'>FIRM</font>"
		if(SEX_FORCE_HIGH)
			return "<font color='#f05ee1'>ROUGH</font>"
		if(SEX_FORCE_EXTREME)
			return "<font color='#d146f5'>BRUTAL</font>"

/datum/sex_controller/proc/get_speed_string()
	switch(speed)
		if(SEX_SPEED_LOW)
			return "<font color='#eac8de'>SLOW</font>"
		if(SEX_SPEED_MID)
			return "<font color='#e9a8d1'>STEADY</font>"
		if(SEX_SPEED_HIGH)
			return "<font color='#f05ee1'>QUICK</font>"
		if(SEX_SPEED_EXTREME)
			return "<font color='#d146f5'>UNRELENTING</font>"

/datum/sex_controller/proc/get_manual_arousal_string()
	switch(manual_arousal)
		if(SEX_MANUAL_AROUSAL_DEFAULT)
			return "<font color='#eac8de'>NATURAL</font>"
		if(SEX_MANUAL_AROUSAL_UNAROUSED)
			return "<font color='#e9a8d1'>UNAROUSED</font>"
		if(SEX_MANUAL_AROUSAL_PARTIAL)
			return "<font color='#f05ee1'>PARTIALLY ERECT</font>"
		if(SEX_MANUAL_AROUSAL_FULL)
			return "<font color='#d146f5'>FULLY ERECT</font>"

/datum/sex_controller/proc/get_generic_force_adjective()
	switch(force)
		if(SEX_FORCE_LOW)
			return pick(list("gently", "carefully", "tenderly", "gingerly", "delicately", "lazingly"))
		if(SEX_FORCE_MID)
			return pick(list("firmly", "vigorously", "eagerly", "steadily", "intently"))
		if(SEX_FORCE_HIGH)
			return pick(list("roughly", "carelessly", "forcefully", "fervently", "fiercely"))
		if(SEX_FORCE_EXTREME)
			return pick(list("brutally", "violently", "relentlessly", "savagely", "mercilessly"))

/datum/sex_controller/proc/spanify_force(string)
	switch(force)
		if(SEX_FORCE_LOW)
			return "<span class='love_low'>[string]</span>"
		if(SEX_FORCE_MID)
			return "<span class='love_mid'>[string]</span>"
		if(SEX_FORCE_HIGH)
			return "<span class='love_high'>[string]</span>"
		if(SEX_FORCE_EXTREME)
			return "<span class='love_extreme'>[string]</span>"

/datum/sex_controller/proc/get_resist_multiplier(passed_res)
	switch(passed_res)
		if(RESIST_NONE)
			return 1
		if(RESIST_LOW)
			return 0.7
		if(RESIST_MEDIUM)
			return 0.4
		if(RESIST_HIGH)
			return 0.2

/datum/sex_controller/proc/get_resist_string()
	switch(resistance_to_pleasure)
		if(RESIST_NONE)
			return "<font color='#eac8de'>NONE</font>"
		if(RESIST_LOW)
			return "<font color='#e9a8d1'>LOW</font>"
		if(RESIST_MEDIUM)
			return "<font color='#f05ee1'>MEDIUM</font>"
		if(RESIST_HIGH)
			return "<font color='#d146f5'>HIGH</font>"

/datum/sex_controller/proc/handle_statuses()

	var/nymph_mod = 0
	if(HAS_TRAIT(user, TRAIT_NYMPHO_CURSE) || user.has_flaw(/datum/charflaw/addiction/lovefiend))
		nymph_mod = 2

	//Sorry but idk how else to do this
	if(user.has_status_effect(/datum/status_effect/debuff/loinspent))
		if(recent_orgasm_count <= LOW_ORGASM_THRESHOLD_LOSS + nymph_mod)
			user.remove_status_effect(/datum/status_effect/debuff/loinspent)
	else
		if(recent_orgasm_count >= LOW_ORGASM_THRESHOLD_GAIN + nymph_mod)
			user.apply_status_effect(/datum/status_effect/debuff/loinspent)

	if(user.has_status_effect(/datum/status_effect/debuff/cumbrained))
		if(recent_orgasm_count <= MED_ORGASM_THRESHOLD_LOSS + nymph_mod)
			user.remove_status_effect(/datum/status_effect/debuff/cumbrained)
	else
		if(recent_orgasm_count >= MED_ORGASM_THRESHOLD_GAIN + nymph_mod)
			user.apply_status_effect(/datum/status_effect/debuff/cumbrained)
	
	if(user.has_status_effect(/datum/status_effect/debuff/orgasmbroken))
		if(recent_orgasm_count <= HIGH_ORGASM_THRESHOLD_LOSS + nymph_mod)
			user.remove_status_effect(/datum/status_effect/debuff/orgasmbroken)
	else
		if(recent_orgasm_count >= HIGH_ORGASM_THRESHOLD_GAIN + nymph_mod)
			user.apply_status_effect(/datum/status_effect/debuff/orgasmbroken)
	
	if(user.has_status_effect(/datum/status_effect/debuff/nympho_addiction))
		if(recent_orgasm_count <= OVER_THE_TOP_ORGASM_THRESHOLD_LOSS + nymph_mod)
			user.remove_status_effect(/datum/status_effect/debuff/nympho_addiction)
	else
		if(recent_orgasm_count >= OVER_THE_TOP_ORGASM_THRESHOLD_GAIN + nymph_mod)
			user.apply_status_effect(/datum/status_effect/debuff/nympho_addiction)

	if(user.has_penis())
		if(user.has_status_effect(/datum/status_effect/blue_balls))
			if(edging_charge <= 15)
				user.remove_status_effect(/datum/status_effect/blue_balls)
		else
			if(edging_charge >= 20)
				user.apply_status_effect(/datum/status_effect/blue_balls)
	if(user.has_vagina())
		if(user.has_status_effect(/datum/status_effect/blue_bean))
			if(edging_charge <= 15)
				user.remove_status_effect(/datum/status_effect/blue_bean)
		else
			if(edging_charge >= 20)
				user.apply_status_effect(/datum/status_effect/blue_bean)
/*
/datum/sex_controller/proc/try_pelvis_crush(mob/living/carbon/human/target)
	if(istype(user.rmb_intent, /datum/rmb_intent/strong))
		if(!target.has_wound(/datum/wound/fracture/groin))
			if(prob(5)){
				var/obj/item/bodypart/groin = target.get_bodypart(check_zone(BODY_ZONE_PRECISE_GROIN))
				groin.add_wound(/datum/wound/fracture)
			}*/

/datum/sex_controller/proc/knot_penis_type()
	var/obj/item/organ/penis/penis = user.getorganslot(ORGAN_SLOT_PENIS)
	if(!penis)
		return FALSE
	switch(penis.penis_type)
		if(PENIS_TYPE_KNOTTED)
			return TRUE
		if(PENIS_TYPE_TAPERED_KNOTTED)
			return TRUE
		if(PENIS_TYPE_TAPERED_DOUBLE_KNOTTED)
			return TRUE
		if(PENIS_TYPE_BARBED_KNOTTED)
			return TRUE
	return FALSE

/datum/sex_controller/proc/knot_try()
	if(!user.sexcon.can_use_penis())
		return
	if(!user.sexcon.knot_penis_type()) // don't have that dog in 'em
		return
	if(!user.sexcon.current_action)
		return
	var/datum/sex_action/action = SEX_ACTION(user.sexcon.current_action)
	if(!action.knot_on_finish) // the current action does not support knot climaxing, abort
		return
	if(user.sexcon.considered_limp())
		if(!user.sexcon.knotted_status)
			to_chat(user, span_notice("My knot was too soft to tie."))
		if(!target.sexcon.knotted_status)
			to_chat(target, span_notice("I feel their deflated knot slip out."))
		return
	if(target.sexcon.knotted_status) // only one knot at a time, you slut
		var/repeated_customer = target.sexcon.knotted_owner == user ? TRUE : FALSE // we're knotting the same character we were already knotted to, don't remove the status effects (this fixes a weird perma stat debuff if we try to remove/apply the same effect in the same tick)
		var/target_is_a_bottom = target.sexcon.knotted_status == KNOTTED_AS_BTM // keep the same status effect in place, they're still getting topped
		target.sexcon.knot_remove(keep_btm_status = target_is_a_bottom, keep_top_status = repeated_customer)
		if(target_is_a_bottom && !target.has_status_effect(/datum/status_effect/knot_fucked_stupid)) // if the target is getting double teamed, give them the fucked stupid status
			target.apply_status_effect(/datum/status_effect/knot_fucked_stupid)
	if(user.sexcon.knotted_status)
		var/top_still_topping = user.sexcon.knotted_status == KNOTTED_AS_TOP // top just reknotted a different character, don't retrigger the same status (this fixes a weird perma stat debuff if we try to remove/apply the same effect in the same tick)
		user.sexcon.knot_remove(keep_top_status = top_still_topping)
	if((target.compliance || user.patron && istype(user.patron, /datum/patron/inhumen/baotha)) && !target.has_status_effect(/datum/status_effect/knot_fucked_stupid)) // as requested, if the top is of the baotha faith, or the target has compliance mode on
		target.apply_status_effect(/datum/status_effect/knot_fucked_stupid)
	user.sexcon.knotted_owner = user
	user.sexcon.knotted_recipient = target
	user.sexcon.knotted_status = KNOTTED_AS_TOP
	user.sexcon.tugging_knot_blocked = FALSE
	target.sexcon.knotted_owner = user
	target.sexcon.knotted_recipient = target
	target.sexcon.knotted_status = KNOTTED_AS_BTM
	log_combat(user, target, "Started knot tugging")
	if(force > SEX_FORCE_MID) // if using force above default
		if(force == SEX_FORCE_EXTREME) // damage if set to max force
			//target.apply_damage(30, BRUTE, BODY_ZONE_CHEST)
			target.sexcon.try_do_pain_effect(PAIN_HIGH_EFFECT, FALSE)
		else
			target.sexcon.try_do_pain_effect(PAIN_MILD_EFFECT, FALSE)
		target.Stun(80) // stun for dramatic effect
	user.visible_message(span_notice("[user] ties their knot inside of [target]!"), span_notice("I tie my knot inside of [target]."))
	if(target.stat != DEAD)
		to_chat(target, span_userdanger("You have been knotted!"))
	if(!target.has_status_effect(/datum/status_effect/knot_tied)) // only apply status if we don't have it already
		target.apply_status_effect(/datum/status_effect/knot_tied)
	if(!user.has_status_effect(/datum/status_effect/knotted)) // only apply status if we don't have it already
		user.apply_status_effect(/datum/status_effect/knotted)
	target.remove_status_effect(/datum/status_effect/knot_gaped)
	RegisterSignal(user.sexcon.knotted_owner, COMSIG_MOVABLE_MOVED, PROC_REF(knot_movement), override = TRUE)
	RegisterSignal(user.sexcon.knotted_recipient, COMSIG_MOVABLE_MOVED, PROC_REF(knot_movement), override = TRUE)
	//GLOB.scarlet_round_stats[STATS_KNOTTED]++

/*/datum/sex_controller/proc/knot_movement_mods_remove_his_knot_ty(var/mob/living/carbon/human/top, var/mob/living/carbon/human/btm)
	var/obj/item/organ/penis/penor = top.getorganslot(ORGAN_SLOT_PENIS)
	if(!penor)
		return FALSE
	penor.Remove(top)
	penor.forceMove(top.drop_location())
	penor.add_mob_blood(top)
	playsound(get_turf(top), 'sound/combat/dismemberment/dismem (5).ogg', 80, TRUE)
	playsound(get_turf(top), 'sound/vo/male/tomscream.ogg', 80, TRUE)
	to_chat(top, span_userdanger("You feel a sharp pain as your knot is torn asunder!"))
	to_chat(btm, span_userdanger("You feel their knot withdraw faster than you can process!"))
	knot_remove(forceful_removal = TRUE, notify = FALSE)
	log_combat(btm, top, "Top had their cock ripped off (knot tugged too far)")
	return TRUE*/

/datum/sex_controller/proc/knot_movement(atom/movable/mover, atom/oldloc, direction)
	SIGNAL_HANDLER
	if(QDELETED(mover))
		return
	if(!ishuman(mover)) // this should never hit, but if it does remove callback
		UnregisterSignal(mover, COMSIG_MOVABLE_MOVED)
		return
	var/mob/living/carbon/human/user = mover
	switch(user.sexcon.knotted_status)
		if(KNOTTED_AS_TOP)
			addtimer(CALLBACK(user.sexcon, PROC_REF(knot_movement_top)), 1)
		if(KNOTTED_AS_BTM)
			if(user.sexcon.tugging_knot) // we're currently moving the bottom back to the top, don't run proc until we've finished
				return
			addtimer(CALLBACK(user.sexcon, PROC_REF(knot_movement_btm)), 1)
		if(KNOTTED_NULL) // this should never hit, but if it does remove callback
			UnregisterSignal(user.sexcon.user, COMSIG_MOVABLE_MOVED)

/datum/sex_controller/proc/knot_movement_top()
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient
	if(!ishuman(btm) || QDELETED(btm) || !ishuman(top) || QDELETED(top))
		knot_exit()
		return
	//if(isnull(top.client) || isnull(btm.client)) // we respect safewords here, let the players untie themselves
	//	knot_remove()
	//	return
	if(prob(10) && top.m_intent == MOVE_INTENT_WALK && (btm in top.buckled_mobs)) // if the two characters are being held in a fireman carry, let them muturally get pleasure from it
		var/obj/item/organ/penis/penis = user.getorganslot(ORGAN_SLOT_PENIS)
		top.sexcon.perform_sex_action(btm, penis?.organ_size > DEFAULT_PENIS_SIZE ? 6.0 : 3.0, 2, FALSE)
		btm.sexcon.handle_passive_orgasm()
		if(prob(50))
			to_chat(top, span_love("I feel [btm] tightening over my knot."))
			to_chat(btm, span_love("I feel [top] rubbing inside."))
		return
	if(btm.pulling == top || top.pulling == btm)
		return
	if(top.sexcon.considered_limp())
		knot_remove()
		return
	if(top.sexcon.tugging_knot_check == 0) // check clothes layer connection every 5 steps and update tugging_knot_blocked
		top.sexcon.tugging_knot_blocked = !get_location_accessible(top, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE)
		top.sexcon.tugging_knot_check = 5
	else
		top.sexcon.tugging_knot_check--
	var/lupineisop = top.STASTR > (btm.STACON + 3) // if the stat difference is too great, don't attempt to disconnect on run
	if(!lupineisop && top.m_intent == MOVE_INTENT_RUN && (top.mobility_flags & MOBILITY_STAND)) // pop it
		knot_remove(forceful_removal = TRUE)
		return
	var/dist = get_dist(top, btm)
	if(dist > 1 &&  dist < 6) // attempt to move the knot recipient to a minimum of 1 tiles away from the knot owner, so they trail behind
		btm.sexcon.tugging_knot = TRUE
		for(var/i in 1 to 3) // try moving three times
			step_towards(btm, top)
			dist = get_dist(top, btm)
			if(dist <= 1)
				break
		btm.sexcon.tugging_knot = FALSE
	if(dist > 1) // if we couldn't move them closer, force the knot out
		//if(dist > 10) // teleported or something else
		//	if(knot_movement_mods_remove_his_knot_ty(top, btm))
		//		return
		knot_remove(forceful_removal = TRUE)
		return
	btm.face_atom(top)
	top.set_pull_offsets(btm, GRAB_AGGRESSIVE)
	if(!top.IsStun()) // randomly stun our top so they cannot simply drag without any penality (combat mode doubles the chances)
		if(prob(!top.cmode && !top.sexcon.tugging_knot_blocked ? 7 : 20))
			top.sexcon.try_do_pain_effect(PAIN_MILD_EFFECT, FALSE)
			if(top.sexcon.tugging_knot_blocked && (top.mobility_flags & MOBILITY_STAND)) // only knock down if standing and knot area is blocked
				top.Knockdown(10)
				to_chat(top, span_warning("I trip trying to move while my knot is covered."))
				top.sexcon.tugging_knot_blocked = FALSE // reset blocked state in the case either character stip off again
				top.sexcon.tugging_knot_check = 0 // check clothes again on the next step
			top.Stun(15)
	if(!btm.IsStun())
		if(prob(5))
			btm.emote("groan")
			btm.sexcon.try_do_pain_effect(PAIN_MED_EFFECT, FALSE)
			btm.Stun(15)
		else if(prob(3))
			btm.emote("painmoan")

/datum/sex_controller/proc/knot_movement_btm()
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient
	if(!ishuman(btm) || QDELETED(btm) || !ishuman(top) || QDELETED(top))
		knot_exit()
		return
	//if(isnull(top.client) || isnull(btm.client)) // we respect safewords here, let the players untie themselves
	//	knot_remove()
	//	return
	if(top.stat >= SOFT_CRIT) // only removed if the knot owner is injured/asleep/dead
		knot_remove()
		return
	if(btm.pulling == top || top.pulling == btm)
		return
	if(top.sexcon.considered_limp())
		knot_remove()
		return
	if(get_dist(top, btm) > 2)
		//if(get_dist(top, btm) > 10) // teleported or something else
		//	if(knot_movement_mods_remove_his_knot_ty(top, btm))
		//		return
		knot_remove(forceful_removal = TRUE)
		return
	for(var/i in 2 to get_dist(top, btm)) // Move the knot recipient to a minimum of 1 tiles away from the knot owner, so they trail behind
		step_towards(btm, top)
	top.set_pull_offsets(btm, GRAB_AGGRESSIVE)
	if(btm.mobility_flags & MOBILITY_STAND)
		if(btm.m_intent == MOVE_INTENT_RUN) // running only makes this worse, darling
			btm.Knockdown(10)
			btm.Stun(30)
			btm.emote("groan", forced = TRUE)
			return
	if(!btm.IsStun())
		if(prob(10))
			btm.emote("groan")
			btm.sexcon.try_do_pain_effect(PAIN_MED_EFFECT, FALSE)
			btm.Stun(15)
		else if(prob(4))
			btm.emote("painmoan")
	addtimer(CALLBACK(src, PROC_REF(knot_movement_btm_after)), 0.1 SECONDS)

/datum/sex_controller/proc/knot_movement_btm_after()
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient
	if(!ishuman(btm) || QDELETED(btm) || !ishuman(top) || QDELETED(top))
		return
	btm.face_atom(top)

/datum/sex_controller/proc/knot_remove(forceful_removal = FALSE, notify = TRUE, keep_top_status = FALSE, keep_btm_status = FALSE)
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient
	if(ishuman(btm) && !QDELETED(btm) && ishuman(top) && !QDELETED(top))
		if(forceful_removal)
			//var/damage = 40
			if (top.sexcon.arousal > MAX_AROUSAL / 2) // still hard, let it rip like a beyblade
				//damage += 30
				btm.Knockdown(10)
				if(notify && !keep_btm_status && !btm.has_status_effect(/datum/status_effect/knot_gaped)) // apply gaped status if extra forceful pull (only if we're not reknotting target)
					btm.apply_status_effect(/datum/status_effect/knot_gaped)
			//btm.apply_damage(damage, BRUTE, BODY_ZONE_CHEST)
			btm.Stun(80)
			playsound(btm, 'sound/misc/mat/pop.ogg', 100, TRUE, -2, ignore_walls = FALSE)
			playsound(top, 'sound/misc/mat/segso.ogg', 50, TRUE, -2, ignore_walls = FALSE)
			btm.emote("paincrit", forced = TRUE)
			if(notify)
				top.visible_message(span_notice("[top] yanks their knot out of [btm]!"), span_notice("I yank my knot out from [btm]."))
				btm.sexcon.try_do_pain_effect(PAIN_HIGH_EFFECT, FALSE)
		else if(notify)
			playsound(btm, 'sound/misc/mat/insert (1).ogg', 50, TRUE, -2, ignore_walls = FALSE)
			top.visible_message(span_notice("[top] slips their knot out of [btm]!"), span_notice("I slip my knot out from [btm]."))
			btm.emote("painmoan", forced = TRUE)
			btm.sexcon.try_do_pain_effect(PAIN_MILD_EFFECT, FALSE)
		add_cum_floor(get_turf(btm))
		btm.apply_status_effect(/datum/status_effect/facial/internal)
	knot_exit(keep_top_status, keep_btm_status)

/datum/sex_controller/proc/knot_exit(var/keep_top_status = FALSE, var/keep_btm_status = FALSE)
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient
	if(istype(top) && top.sexcon.knotted_status)
		if(!keep_top_status) // only keep the status if we're reapplying the knot
			top.remove_status_effect(/datum/status_effect/knotted)
		UnregisterSignal(top.sexcon.user, COMSIG_MOVABLE_MOVED)
		top.sexcon.knotted_owner = null
		top.sexcon.knotted_recipient = null
		top.sexcon.knotted_status = KNOTTED_NULL
		log_combat(top, top, "Stopped knot tugging")
	if(istype(btm) && btm.sexcon.knotted_status)
		if(!keep_btm_status) // only keep the status if we're reapplying the knot
			btm.remove_status_effect(/datum/status_effect/knot_tied)
		UnregisterSignal(btm.sexcon.user, COMSIG_MOVABLE_MOVED)
		btm.sexcon.knotted_owner = null
		btm.sexcon.knotted_recipient = null
		btm.sexcon.knotted_status = KNOTTED_NULL
		log_combat(btm, btm, "Stopped knot tugging")
	if(knotted_status) // this should never trigger, but if it does clear up the invalid state
		if(src.user)
			src.user.remove_status_effect(/datum/status_effect/knot_tied)
			src.user.remove_status_effect(/datum/status_effect/knotted)
			UnregisterSignal(src.user, COMSIG_MOVABLE_MOVED)
		knotted_owner = null
		knotted_recipient = null
		knotted_status = KNOTTED_NULL

/mob/living/carbon/human/werewolf_transform() // needed to ensure that we safely remove the tie before transitioning
	if(src.sexcon.knotted_status)
		src.sexcon.knot_remove()
	return ..()

/mob/living/carbon/human/werewolf_untransform(dead,gibbed) // needed to ensure that we safely remove the tie after transitioning
	if(src.sexcon.knotted_status)
		src.sexcon.knot_remove()
	return ..()

#undef KNOTTED_NULL
#undef KNOTTED_AS_TOP
#undef KNOTTED_AS_BTM
