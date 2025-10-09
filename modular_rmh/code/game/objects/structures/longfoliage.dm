/obj/structure/flora/roguegrass/bush/wall/long
	icon = 'modular_rmh/icons/obj/structures/longfoliage.dmi'
	icon_state = "tallbush1"
	opacity = 1
	pixel_y = -16
	debris = null
	static_debris = null

/obj/structure/flora/roguegrass/bush/wall/long/Initialize()
	. = ..()
	icon_state = "tallbush[pick(1,2)]"
