//genstuff
/obj/effect/landmark/mapGenerator/rogue/rmh_mountains
	mapGeneratorType = /datum/mapGenerator/rmh_mountains
	endTurfX = 255
	endTurfY = 255
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/rmh_mountains
	modules = list(/datum/mapGeneratorModule/rmh_mountainssnow,/datum/mapGeneratorModule/rmh_mountainsroad, /datum/mapGeneratorModule/rmh_mountainsgrass)


/datum/mapGeneratorModule/rmh_mountainssnow
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/snow)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/grass/both = 15,
	/obj/structure/flora/grass/brown = 20,
	/obj/structure/flora/grass/green = 20,
	/obj/item/grown/log/tree/stick = 16,
	/obj/structure/flora/roguegrass/pyroclasticflowers = 3,
	///obj/structure/flora/roguegrass/maneater/real=3,
	/obj/structure/flora/roguegrass/herb/random = 5)
	spawnableTurfs = list(/turf/open/floor/rogue/snowpatchy=15)
	allowed_areas = list(/area/rogue/outdoors/mountains/rmh_mountains)

/datum/mapGeneratorModule/rmh_mountainsroad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/item/natural/stone = 15,/obj/item/natural/rock = 3,/obj/item/grown/log/tree/stick = 6)
	allowed_areas = list(/area/rogue/outdoors/mountains/rmh_mountains)

/datum/mapGeneratorModule/rmh_mountainsgrass
	clusterCheckFlags =  CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/grass, /turf/open/floor/rogue/grassred, /turf/open/floor/rogue/grassyel, /turf/open/floor/rogue/grasscold)
	excluded_turfs = list()
	allowed_areas = list(/area/rogue/outdoors/mountains/rmh_mountains)
	spawnableAtoms = list(/obj/structure/flora/roguegrass = 25,
							/obj/structure/flora/roguegrass/herb/random = 2,
							/obj/structure/flora/roguegrass/bush/westleach = 2,
							/obj/item/natural/stone = 6,
							/obj/item/natural/rock = 1,
							/obj/item/grown/log/tree/stick = 3)
