/obj/item/clothing/suit/roguetown/armor/gambeson/explorer
	name = "explorer's vest"
	slot_flags = ITEM_SLOT_ARMOR
	desc = "A dashing outfit for an experienced tomb raider."
	//sleeved = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/noble.dmi'
	icon_state = "vest"
	item_state = "vest"
	icon = 'modular_rmh/icons/obj/clothes/explorer.dmi'
	mob_overlay_icon = 'modular_rmh/icons/obj/clothes/onmob/explorer.dmi'

/obj/item/clothing/suit/roguetown/armor/gambeson/explorer/update_icon()
	. = ..()
	
/obj/item/clothing/under/roguetown/trou/leather/explorer
	icon = 'modular_rmh/icons/obj/clothes/explorer.dmi'
	mob_overlay_icon = 'modular_rmh/icons/obj/clothes/onmob/explorer.dmi'
	name = "explorer's trousers"
	desc = "Hardy yet comfortable leather pants, suited even for hardest field work."
	armor = ARMOR_PANTS_LEATHER
	icon_state = "pants"
	item_state = "vest"
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	max_integrity = ARMOR_INT_LEG_LEATHER
	resistance_flags = FIRE_PROOF
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/head/roguetown/explorer
	icon = 'modular_rmh/icons/obj/clothes/explorer.dmi'
	mob_overlay_icon = 'modular_rmh/icons/obj/clothes/onmob/explorer.dmi'
	name = "explorer's hat"
	desc = "The perfect protection both from heat and things falling on your head."
	icon_state = "hat"
	item_state = "vest"
	sewrepair = TRUE
	armor = ARMOR_HEAD_LEATHER
	color = COLOR_DARK_BROWN
	salvage_result = /obj/item/natural/hide/cured
