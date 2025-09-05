//DESERT MAP AREAS//


//DESERT

/area/rogue/outdoors/rmh_desert
	name = "Desert"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "desert"
	soundenv = 19
	ambush_mobs = null
	first_time_text = "CURSED DESERT"
	droning_sound = 'sound/music/area/field.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/indoors/shelter/rmh_desert
	deathsight_message = "somewhere far in sands"

/area/rogue/outdoors/rmh_desert/valley
	name = "Desert Valley"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "lowdesert"
	soundenv = 19
	ambush_mobs = null
	first_time_text = "DESERT VALLEY"
	droning_sound = 'sound/music/area/field.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/indoors/shelter/rmh_desert
	deathsight_message = "somewhere far in lowsands"

// УБЕЖИЩЕ
/area/rogue/indoors/shelter/rmh_desert
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "shelter"
	droning_sound = 'sound/music/area/field.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'

// МОРЕ
/area/rogue/outdoors/rmh_desert/sea
	name = "Saltsea"
	first_time_text = "FAR SALTSEA"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "sea"

// ПОРТ - ДОМА
/area/rogue/indoors/rmh_desert_phouse
	name = "indoors"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "house"
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/outdoors/rmh_desert/port
	town_area = TRUE
	deathsight_message = "the port point between sand and salty water"

/area/rogue/outdoors/rmh_desert/roofs
	name = "Seaport Roofs"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "roofs"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/field.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	soundenv = 17
	converted_type = /area/rogue/indoors/shelter/town/rmh/roofs

/area/rogue/indoors/shelter/rmh_desert/roofs
	name = "Rivermist Hollow Rooftops"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "roofs"
	droning_sound = 'sound/music/area/field.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'

// ПОРТ
/area/rogue/outdoors/rmh_desert/port
	name = "Sea Port"
	first_time_text = "SEASIDE PORT"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "seaport"
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'

/area/rogue/under/rmh_desert/ziqurat
	name = "ziqurat"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "ziqurat"
	first_time_text = "ZIQURAT"
	droning_sound = 'sound/music/area/dungeon2.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/rmh_desert/dungeon1
	ceiling_protected = TRUE
	deathsight_message = "a dark cave where Abyssor's dream echoes"

/area/rogue/outdoors/rmh_desert/dungeon1
	name = "outdesertdungeon"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "spidercave"
	droning_sound = 'sound/music/area/dungeon.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ceiling_protected = TRUE

/area/rogue/outdoors/rmh_desert/oasis
	name = "oasis"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "oasis"
	warden_area = TRUE
	ambientsounds = AMB_RIVERDAY
	ambientnight = AMB_RIVERNIGHT
	spookysounds = SPOOKY_FROG
	spookynight = SPOOKY_FOREST
	droning_sound = 'sound/music/area/forest.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/forestnight.ogg'
	converted_type = /area/rogue/indoors/shelter/rmh_desert

/area/rogue/indoors/cave/rmh_desertcaves
	name = "Dusted Caves"
	first_time_text = "DUSTED CAVES"
