/*//visibility toggles defines to avoid errors typos code errors.
#define GEN_VISIBLE_ALWAYS "Always visible"
#define GEN_VISIBLE_NO_CLOTHES "Hidden by clothes"
#define GEN_VISIBLE_NO_UNDIES "Hidden by underwear"
#define GEN_VISIBLE_NEVER "Always hidden"

GLOBAL_LIST_INIT(genitals_visibility_toggles, list(GEN_VISIBLE_ALWAYS, GEN_VISIBLE_NO_CLOTHES, GEN_VISIBLE_NO_UNDIES, GEN_VISIBLE_NEVER))*/


/mob/living
	var/defiant = TRUE

/obj/item/organ
	var/visible_through_clothes = FALSE

/obj/item/organ/proc/toggle_visibility()
	visible_through_clothes = !visible_through_clothes

/mob/living/carbon/verb/toggle_genitals()
	set category = "Options"
	set name = "Expose/Hide genitals"
	set desc = "Allows you to toggle which genitals should show through clothes or not."

	if(stat != CONSCIOUS)
		to_chat(usr, "<span class='warning'>You can toggle genitals visibility right now...</span>")
		return

	var/list/genital_list = list()
	for(var/obj/item/organ/G in internal_organs)
		if(G.visible_organ && !istype(G, /obj/item/organ/eyes) && !istype(G, /obj/item/organ/ears) && !istype(G, /obj/item/organ/filling_organ/anus))
			genital_list += G
	if(!genital_list.len) //There is nothing to expose
		return
	//Full list of exposable genitals created
	var/obj/item/organ/picked_organ
	picked_organ = input(src, "Choose which genitalia to expose/hide", "Expose/Hide genitals") as null|anything in genital_list
	if(picked_organ && (picked_organ in internal_organs))
		picked_organ.toggle_visibility()
		regenerate_icons()

