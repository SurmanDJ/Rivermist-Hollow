/datum/sex_action/force_cunnilingus
	name = "Force them to suck clit"
	require_grab = TRUE
	stamina_cost = 1.0
	gags_target = TRUE

/datum/sex_action/force_cunnilingus/shows_on_menu(mob/living/user, mob/living/target)
	if(!target.erpable && issimple(target))
		return FALSE
	if(user.client.prefs.defiant && issimple(target))
		return FALSE
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	//if(HAS_TRAIT(user, TRAIT_TINY)) //Fairy is too small and weak to force this
	//	return FALSE
	return TRUE

/datum/sex_action/force_cunnilingus/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/userhuman = user
		if(userhuman.wear_pants)
			var/obj/item/clothing/under/roguetown/pantsies = userhuman.wear_pants
			if(pantsies.flags_inv & HIDECROTCH)
				if(!pantsies.genitalaccess)
					return FALSE
	if(!get_location_accessible(target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_action/force_cunnilingus/on_start(mob/living/user, mob/living/target)
	..()
	user.visible_message(span_warning("[user] forces [target]'s head against her cunt!"))

/datum/sex_action/force_cunnilingus/on_perform(mob/living/user, mob/living/target)
	if(user.sexcon.do_message_signature("[type]"))
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] forces [target] to suck her cunt."))
	target.make_sucking_noise()
	do_thrust_animate(target, user)

	user.sexcon.perform_sex_action(user, 2, 4, TRUE)
	if(prob(25))
		var/obj/item/organ/filling_organ/vagina/vag = user.getorganslot(ORGAN_SLOT_VAGINA)
		var/gj_to_add = min(1.5, vag.reagents.total_volume)
		vag.reagents.trans_to(target, gj_to_add, TRUE, TRUE, FALSE, user, FALSE, INGEST)
	if(user.sexcon.check_active_orgasm())
		user.visible_message(span_love("[user] orgasms into [target]'s mouth!"))
		user.sexcon.cum_into(cum_target = target, girljuice = TRUE)

	user.sexcon.perform_sex_action(target, 0, 2, FALSE)
	target.sexcon.handle_passive_orgasm()

/datum/sex_action/force_cunnilingus/on_finish(mob/living/user, mob/living/target)
	..()
	user.visible_message(span_warning("[user] pulls [target]'s head away."))

/datum/sex_action/force_cunnilingus/is_finished(mob/living/user, mob/living/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
