//SWAMP MAP AREAS

/area/rogue/outdoors/bog/rmh
	name = "Green Swamps"
	first_time_text = "GREEN SWAMPS"
	icon_state = "bog"
	warden_area = TRUE
	ambientsounds = AMB_BOGDAY
	ambientnight = AMB_BOGNIGHT
	spookysounds = SPOOKY_FROG
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	//Minotaurs too strong for the lazy amount of places this area covers
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/spider = 40,
				/mob/living/carbon/human/species/skeleton/npc/bogguard = 20,
				/mob/living/carbon/human/species/goblin/npc/ambush/cave = 30,
				new /datum/ambush_config/bog_guard_deserters = 50,
				new /datum/ambush_config/bog_guard_deserters/hard = 25,
				new /datum/ambush_config/mirespiders_ambush = 110,
				new /datum/ambush_config/mirespiders_crawlers = 25,
				new /datum/ambush_config/mirespiders_aragn = 10,
				new /datum/ambush_config/mirespiders_unfair = 5)
	converted_type = /area/rogue/indoors/shelter/bog
	deathsight_message = "a swamp"

/area/rogue/indoors/shelter/bog/rmh
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "indoors"
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/outdoors/bog/rmh/north
	name = "Northern Green Swamps"
	first_time_text = "NORTHERN GREEN SWAMPS"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "n_basin"

/area/rogue/outdoors/bog/rmh/south
	name = "Southern Green Swamps"
	first_time_text = "SOUTHERN GREEN SWAMPS"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "s_basin"

/area/rogue/indoors/shelter/bog/rmh/fort
	name = "The Dark Fort"
	first_time_text = "THE DARK FORT"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "village"
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "Dark Fort"

//FOREST AREAS

/area/rogue/outdoors/woods/rmh
	name = "The Dark Forest"
	icon_state = "woods"
	ambientsounds = AMB_FORESTDAY
	ambientnight = AMB_FORESTNIGHT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_FOREST
	droning_sound = 'sound/music/area/forest.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/forestnight.ogg'
	soundenv = 15
	warden_area = TRUE
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
				/mob/living/carbon/human/species/skeleton/npc/easy = 10,
				/mob/living/carbon/human/species/goblin/npc/ambush = 30,
				/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30)
	first_time_text = "THE DARK FOREST"
	converted_type = /area/rogue/indoors/shelter/woods
	deathsight_message = "somewhere in the forest"

/area/rogue/indoors/shelter/woods/rmh
	name = "Dark Forest"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "indoors"
	droning_sound = 'sound/music/area/forest.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/forestnight.ogg'

/area/rogue/under/cave/rmh/goblindungeon
	name = "Goblin Dungeon"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "camp"
	first_time_text = "GOBLIN DUNGEON"
	droning_sound = 'sound/music/area/dungeon.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/dungeon1
	ceiling_protected = TRUE
	deathsight_message = "goblin dungeon"

/area/rogue/outdoors/woods/rmh/goblincampfire
	name = "Goblin Camp"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "camp"
	first_time_text = "GOBLIN CAMP"
	name = "goblin campfire"
	deathsight_message = "goblin camp"

//CAVES AREAS
/area/rogue/under/cavewet/rmh/swamp_caves
	name = "Moist Tunnels"
	first_time_text = "MOIST TUNNELS"
	icon_state = "cavewet"
	warden_area = TRUE
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/caves.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/carbon/human/species/skeleton/npc/easy = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 30,
				/mob/living/carbon/human/species/goblin/npc/sea = 20,
				/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/troll = 15)
	converted_type = /area/rogue/outdoors/caves_rmh
	deathsight_message = "moist tunnels"

/area/rogue/indoors/cave/rmh_cave/wet/mindflayer
	name = "Mindflayer Colony"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "living"
	first_time_text = "MINDFLAYER COLONY"
	deathsight_message = "Mindflayer Colony"
	ceiling_protected = TRUE


/area/rogue/under/cave/spider/rmh
	name = "Spider Caves"
	icon_state = "spidercave"
	first_time_text = "SPIDER CAVES"
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/spider = 100)
	droning_sound = 'sound/music/area/spidercave.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/spidercave/rmh
	deathsight_message = "Spider Caves"

/area/rogue/outdoors/spidercave/rmh
	name = "Spider Caves"
	icon_state = "Spider Caves"
	first_time_text = "SPIDER CAVES"
	icon_state = "spidercave"
	droning_sound = 'sound/music/area/spidercave.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "Spider Caves"

/area/rogue/under/cavewet/rmh/wolf
	name = "Wolf Den"
	first_time_text = "WOLF DEN"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "wolf"

/area/rogue/under/cavewet/rmh/werewolf
	name = "Werewolf Den"
	first_time_text = "WEREWOLF DEN"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "wolf"

//TRANSITIONS

/area/rogue/outdoors/bog/rmh/travel/main
	name = "To Rivermist Hollow"
	first_time_text = "TO RIVERMIST HOLLOW"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "travel"

/area/rogue/outdoors/bog/rmh/travel/swamp_to_main
	name = "Green Swamp To Rivermist Hollow"
	first_time_text = "TO RIVERMIST HOLLOW"

/area/rogue/outdoors/bog/rmh/travel/forest_to_main
	name = "Dark Forest To Rivermist Hollow"
	first_time_text = "TO RIVERMIST HOLLOW"

/area/rogue/outdoors/bog/rmh/travel/underdark
	name = "Swamp Forest Descend To Underdark"
	first_time_text = "DESCEND TO UNDERDARK"
