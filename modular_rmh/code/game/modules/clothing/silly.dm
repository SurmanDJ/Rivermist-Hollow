/obj/item/clothing/mask/rogue/facemask/snmask
	name = "traveler silly mask"
	desc = "A silver mask, forever locked in a rigor of uncontestable joy. The Order of Saint Xylix can't decide on whether it's meant to represent Psydon's 'mirthfulness,' 'theatricality,' or the unpredictable melding of both."
	icon_state = "nmask"
	item_state = "nmask"
	icon = 'modular_rmh/icons/obj/clothes/karatur.dmi'
	mob_overlay_icon = 'modular_rmh/icons/obj/clothes/onmob/karatur.dmi'
	slot_flags = ITEM_SLOT_MASK
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/neck/roguetown/collar/snscarf
	name = "scarf"
	desc = "A sturdy scarf made of dense fur."
	icon_state = "nscarf"
	item_state = "nscarf"
	icon = 'modular_rmh/icons/obj/clothes/karatur.dmi'
	mob_overlay_icon = 'modular_rmh/icons/obj/clothes/onmob/karatur.dmi'
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_MASK
	body_parts_covered = NECK|FACE

/obj/item/clothing/head/roguetown/sillyhat
	name = "bamboo hat"
	desc = "A reinforced bamboo hat."
	icon_state = "nhat"
	item_state = "nhat"
	icon = 'modular_rmh/icons/obj/clothes/karatur.dmi'
	mob_overlay_icon = 'modular_rmh/icons/obj/clothes/onmob/karatur.dmi'
	armor = ARMOR_SPELLSINGER
	max_integrity = ARMOR_INT_HELMET_LEATHER
	blocksound = SOFTHIT
	sewrepair = TRUE
	flags_inv = HIDEEARS
	body_parts_covered = HEAD|HAIR|EARS|NOSE|EYES
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/roguetown/armor/plate/snakekini
	name = "segmented cuirass"
	desc = "A high breastplates and hip armor allowing flexibility and great protection. Your abs is your shield."
	body_parts_covered = CHEST|GROIN
	icon = 'modular_rmh/icons/obj/clothes/snake.dmi'
	mob_overlay_icon = 'modular_rmh/icons/obj/clothes/onmob/snake.dmi'
	icon_state = "armor"
	item_state = "armor"
	armor = ARMOR_CUIRASS // Identical to steel cuirass, but covering the groin instead of the vitals.
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL	// Identical to steel cuirasss. Same steel price.
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/snakeshell
	name = "naga's head-shell"
	desc = "Segmented helm shaped to the curve of a naga’s hood."
	icon_state = "head"
	item_state = "head"
	icon = 'modular_rmh/icons/obj/clothes/snake.dmi'
	mob_overlay_icon = 'modular_rmh/icons/obj/clothes/onmob/snake.dmi'
	emote_environment = 3
	flags_inv = HIDEHAIR
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2
