/datum/sex_action/force_crotch_nuzzle
	name = "Force them to nuzzle"
	require_grab = TRUE
	stamina_cost = 1.0
	gags_target = TRUE

/datum/sex_action/force_crotch_nuzzle/shows_on_menu(mob/living/user, mob/living/target)
	if(!target.erpable && issimple(target))
		return FALSE
	if(user.client.prefs.defiant && issimple(target))
		return FALSE
	if(user == target)
		var/mob/living/carbon/human/user_d
		if(isdullahan(user))
			var/datum/species/dullahan/dullahan = user_d.dna.species
			if(dullahan.headless && !user.is_holding(dullahan.my_head))
				return FALSE
		else
			return FALSE
	return TRUE

/datum/sex_action/force_crotch_nuzzle/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		var/mob/living/carbon/human/user_d
		if(isdullahan(user))
			var/datum/species/dullahan/dullahan = user_d.dna.species
			if(dullahan.headless && !user.is_holding(dullahan.my_head))
				return FALSE
		else
			return FALSE
	/*if(ishuman(user))
		var/mob/living/carbon/human/userhuman = user
		if(userhuman.wear_pants)
			var/obj/item/clothing/under/roguetown/pantsies = userhuman.wear_pants
			if(pantsies.flags_inv & HIDECROTCH)
				if(!pantsies.genitalaccess)
					return FALSE
	if(!get_location_accessible(target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE*/
	return TRUE

/datum/sex_action/force_crotch_nuzzle/on_start(mob/living/user, mob/living/target)
	..()
	user.visible_message(span_warning("[user] forces [target]'s head against their crotch!"))

/datum/sex_action/force_crotch_nuzzle/on_perform(mob/living/user, mob/living/target)
	if(user.sexcon.do_message_signature("[type]"))
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] forces [target] to nuzzle their crotch."))

	user.sexcon.perform_sex_action(user, 0.5, 0, TRUE)
	target.sexcon.handle_passive_orgasm()

/datum/sex_action/force_crotch_nuzzle/on_finish(mob/living/user, mob/living/target)
	..()
	user.visible_message(span_warning("[user] pulls [target]'s head away from their crotch."))

/datum/sex_action/force_crotch_nuzzle/is_finished(mob/living/user, mob/living/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
