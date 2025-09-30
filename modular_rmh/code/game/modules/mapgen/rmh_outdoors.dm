/obj/effect/landmark/mapGenerator/rogue/rmh_field
	mapGeneratorType = /datum/mapGenerator/rmh_field
	endTurfX = 155
	endTurfY = 155
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/rmh_field
	modules = list(/datum/mapGeneratorModule/rmh_field/grass,/datum/mapGeneratorModule/rmh_fieldgrass,/datum/mapGeneratorModule/rmh_field,/datum/mapGeneratorModule/rmh_field/road)


/datum/mapGeneratorModule/rmh_field
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/newtree = 5,
							/obj/structure/flora/roguegrass/bush = 13,
							/obj/structure/flora/roguegrass = 40,
							///obj/structure/flora/roguegrass/maneater = 16,
							/obj/item/natural/stone = 18,
							/obj/item/natural/rock = 2,
							/obj/item/grown/log/tree/stick = 3,
							/obj/structure/closet/dirthole/closed/loot=3,
							/obj/structure/flora/roguegrass/pyroclasticflowers = 3)
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=5)
	allowed_areas = list(/area/rogue/outdoors/rmh_field)

/datum/mapGeneratorModule/rmh_field/road
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	excluded_turfs = list()
	spawnableAtoms = list(/obj/item/natural/stone = 18,
							/obj/item/grown/log/tree/stick = 3)
	allowed_areas = list(/area/rogue/outdoors/rmh_field)

/datum/mapGeneratorModule/rmh_field/grass
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/dirt)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableTurfs = list(/turf/open/floor/rogue/grass = 15)
	spawnableAtoms = list()
	allowed_areas = list(/area/rogue/outdoors/rmh_field)

/datum/mapGeneratorModule/rmh_fieldgrass
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt,/turf/open/floor/rogue/grass,/turf/open/floor/rogue/grassred,/turf/open/floor/rogue/grassyel,/turf/open/floor/rogue/grasscold)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/roguegrass = 40,
						///obj/structure/flora/roguegrass/maneater = 7,
							/obj/item/natural/stone = 18,
							/obj/item/grown/log/tree/stick = 3)
	allowed_areas = list(/area/rogue/outdoors/rmh_field)
