//UNDERDARK MAP AREAS

/area/rogue/under/underdark/rmh
	name = "The Underdark"
	first_time_text = "THE UNDERDARK"
	icon_state = "cavewet"
	warden_area = FALSE
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/underdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated = 20,
				/mob/living/carbon/human/species/elf/dark/drowraider/ambush = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 25,
				/mob/living/carbon/human/species/goblin/npc/ambush/moon = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/troll = 15)
	converted_type = /area/rogue/outdoors/caves
	deathsight_message = "Depths of Underdark"

/area/rogue/under/underdark/rmh/caves
	name = "The Underdark"
	first_time_text = "THE UNDERDARK"
	icon_state = "caves"
	droning_sound = 'sound/music/area/caves.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/troll/cave = 15)

/area/rogue/under/underdark/rmh/glimmerlakes
	name = "The Glimmerlakes"
	first_time_text = "THE GLIMMERLAKES"
	icon_state = "lake"
	droning_sound = 'sound/music/area/underdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = null 
	ambush_mobs = null
	deathsight_message = "Glimmerlakes"

/area/rogue/under/underdark/rmh/shrub
	name = "The Shrub Depth"
	first_time_text = "THE SHRUB DEPTH"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "outdoors"
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite = 40,
				/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad = 5)
	deathsight_message = "Shrubdepth"

/area/rogue/under/underdark/rmh/deepwastes
	name = "The Deep Wastes"
	first_time_text = "THE DEEP WASTES"
	icon_state = "woods"
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/spider = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated = 25)
	deathsight_message = "Deep Wastes"

/area/rogue/under/underdark/rmh/flow
	name = "Flow Tunnels"
	first_time_text = "FLOW TUNNELS"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "living"
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/troll/cave = 15)
	deathsight_message = "Flow Tunnels"

/area/rogue/under/cavelava/rmh/lava_hollows
	name = "Lava Hollows"
	first_time_text = "LAVA HOLLOWS"
	icon_state = "cavelava"
	first_time_text = "MOUNT DECAPITATION"
	ambientsounds = AMB_CAVELAVA
	ambientnight = AMB_CAVELAVA
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp = 50)
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "Lava Hollows"

/area/rogue/under/underdark/rmh/shar
	name = "Gauntlet Of Shar"
	first_time_text = "GAUNTLET OF SHAR"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/underdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/rogue/dreamfiend/unbound = 50)
	deathsight_message = "Gauntlet of Shar"
	ceiling_protected = TRUE


//TRANSITIONS

/area/rogue/under/underdark/rmh/tavel
	name = "Underdark Travel"
	first_time_text = "UNDERDARK TRAVEL"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "travel"

/area/rogue/under/underdark/rmh/desert
	name = "Ascend To Coastal Desert"
	first_time_text = "ASCEND TO COASTAL DESERT"

/area/rogue/under/underdark/rmh/swamps
	name = "Ascend To Green Swamps"
	first_time_text = "ASCEND TO GREEN SAWMPS"

/area/rogue/under/underdark/rmh/forest
	name = "Ascend To Dark Forest"
	first_time_text = "ASCEND TO DARK FOREST"

/area/rogue/under/underdark/rmh/mountain
	name = "Ascend To Dusk Spire"
	first_time_text = "ASCEND TO DUSK SPIRE"

/area/rogue/under/underdark/rmh/main
	name = "Ascend To Rivermist Hollow"
	first_time_text = "ASCEND TO RIVERMIST HOLLOW"
