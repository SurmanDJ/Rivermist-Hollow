//MAIN MAP AREAS//


//FORESTS

/area/rogue/outdoors/rmh_field
	name = "Rivermist Hollow Outskirts"
	icon_state = "rtfield"
	soundenv = 19
	ambush_mobs = null
	first_time_text = "RIVERMIST HOLLOW OUTSKIRTS"
	droning_sound = 'sound/music/area/field.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/indoors/shelter/rmh_field
	deathsight_message = "somewhere nar the town"
	warden_area = TRUE

/area/rogue/indoors/shelter/rmh_field
	icon_state = "rtfield"
	droning_sound = 'sound/music/area/field.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'

/area/rogue/outdoors/rmh_field/north
	name = "North Forest"
	first_time_text = "NORTH FOREST"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "woods_n"

/area/rogue/outdoors/rmh_field/west
	name = "West Forest"
	first_time_text = "WEST FOREST"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "woods_w"

/area/rogue/outdoors/rmh_field/east
	name = "East Forest"
	first_time_text = "EAST FOREST"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "woods_e"

/area/rogue/outdoors/rmh_field/camp
	name = "Encampment On The Hill"
	first_time_text = "ENCAMPMENT ON THE HILL"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "camp"

/area/rogue/outdoors/rmh_field/druid
	name = "Druid Grove"
	first_time_text = "DRUID GROVE"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "druid"

//CAVES

/area/rogue/indoors/cave/rmh_cave
	name = "Caves"
	first_time_text = "CAVES"
	icon_state = "cave"
	ambientsounds = AMB_GENCAVE
	ambientnight = AMB_GENCAVE
	soundenv = 8
	deathsight_message = "a dark cave"
	converted_type = /area/rogue/outdoors/caves

/area/rogue/outdoors/caves_rmh
	name = "Caves"
	first_time_text = "CAVES"
	icon_state = "caves"
	droning_sound = 'sound/music/area/caves.ogg'
	droning_sound_dusk = null
	droning_sound_night = null


/area/rogue/indoors/cave/rmh_cave/mine
	name = "Abandoned Mines"
	first_time_text = "ABANDONED MINES"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "mine"
	deathsight_message = "a dark mine"
	ceiling_protected = TRUE

/area/rogue/indoors/cave/rmh_cave/to_underdark
	name = "UNDERDARK DESCENT"
	first_time_text = "UNDERDARK DESCENT"
	icon_state = "underworld"

/area/rogue/outdoors/beach/rmh_beach
	name = "Misty Lake"
	icon_state = "beach"
	first_time_text = "MISTY LAKE"
	ambush_mobs = null

/area/rogue/indoors/cave/rmh_cave/wet
	name = "Southern Caves"
	icon_state = "cavewet"
	warden_area = TRUE
	first_time_text = "SOUTHERN CAVES"
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	droning_sound = 'sound/music/area/caves.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "wet caverns"

/area/rogue/indoors/cave/rmh_cave/wet/lake
	name = "Hidden Lake"
	icon_state = "lake"
	first_time_text = "HIDDEN LAKE"

//MOUNTAINS

/area/rogue/outdoors/mountains/rmh_mountains
	name = "Dusk Spire Mountains Pass"
	icon_state = "decap"
	ambush_mobs = null
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "DUSK SPIRE PASS"
	ambush_times = null
	converted_type = /area/rogue/indoors/shelter/mountains/rmh_mountains
	deathsight_message = "a spire pass"

/area/rogue/indoors/shelter/mountains/rmh_mountains
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "indoors"
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/outdoors/rmh_field/north_mountain
	name = "Northern Mountains Basin"
	first_time_text = "NORTHERN MOUNTAINS BASIN"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "n_basin"

//TRANSITIONS

/area/rogue/outdoors/rmh_field/tavel
	name = "Travel"
	first_time_text = "TRAVEL"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "travel"

/area/rogue/outdoors/rmh_field/tavel/desert
	name = "To Coastal Desert"
	first_time_text = "TO COASTAL DESERT"

/area/rogue/outdoors/rmh_field/tavel/swamps
	name = "To Green Swamps"
	first_time_text = "TO GREEN SWAMPS"

/area/rogue/outdoors/rmh_field/tavel/forest
	name = "To Dark Forest"
	first_time_text = "TO DARK FOREST"

/area/rogue/outdoors/rmh_field/tavel/mountain
	name = "To Mountain Pass"
	first_time_text = "TO MOUNTAIN PASS"

/area/rogue/outdoors/rmh_field/tavel/vampires
	name = "To Dusk Spire"
	first_time_text = "TO DUSK SPIRE"

//ANTAGS
/area/rogue/indoors/cave/rmh_cave/minotaur
	name = "Abandoned Hall"
	first_time_text = "ABANDONED HALL"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "minotaur"
	deathsight_message = "a minotaur camp"
	ceiling_protected = TRUE


/area/rogue/indoors/cave/rmh_cave/greenskins
	name = "Greenskins Encampment"
	first_time_text = "GREENSKINS ENCAMPMENT"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "orc"
	deathsight_message = "a greenskins camp"

//TOWN

/area/rogue/indoors/town/rmh
	name = "indoors"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "indoors"
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/outdoors/exposed/town/rmh
	town_area = TRUE
	deathsight_message = "the town of Rivermist Hollow and all its bustling souls"

/area/rogue/outdoors/exposed/town/rmh
	name = "Rivermist Hollow"
	first_time_text = "RIVERMIST HOLLOW"
	icon_state = "town"
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'

/area/rogue/outdoors/town/rmh/roofs
	name = "Rivermist Hollow Rooftops"
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

/area/rogue/indoors/shelter/town/rmh/roofs
	name = "Rivermist Hollow Rooftops"
	icon_state = "roofs"
	droning_sound = 'sound/music/area/field.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'

/area/rogue/under/town/rmh/basement
	name = "basement"
	icon_state = "basement"
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	spookysounds = SPOOKY_DUNGEON
	spookynight = SPOOKY_DUNGEON
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	soundenv = 5
	town_area = TRUE
	converted_type = /area/rogue/outdoors/exposed/rmh/under/basement
	ceiling_protected = TRUE

/area/rogue/outdoors/exposed/rmh/under/basement
	icon_state = "basement"
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/under/town/rmh/treasury
	name = "treasury"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "treasury"
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	spookysounds = SPOOKY_DUNGEON
	spookynight = SPOOKY_DUNGEON
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	soundenv = 5
	town_area = TRUE
	converted_type = /area/rogue/outdoors/exposed/rmh/under/basement
	ceiling_protected = TRUE

/area/rogue/under/town/rmh/bank
	name = "bank vault"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "bank"
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	spookysounds = SPOOKY_DUNGEON
	spookynight = SPOOKY_DUNGEON
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	soundenv = 5
	town_area = TRUE
	converted_type = /area/rogue/outdoors/exposed/rmh/under/basement
	ceiling_protected = TRUE

/area/rogue/indoors/town/rmh/garrison
	name = "Town Guardhouse"
	first_time_text = "TOWN GUARDHOUSE"
	icon_state = "garrison"
	droning_sound = 'sound/music/area/manorgarri.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/town/rmh

/area/rogue/indoors/town/rmh/garrison/wall
	name = "Town Wall"
	first_time_text = "TOWN WALL"

/area/rogue/indoors/town/rmh/cell
	name = "Town Dungeon"
	first_time_text = "TOWN DUNGEON"
	icon_state = "cell"
	spookysounds = SPOOKY_DUNGEON
	spookynight = SPOOKY_DUNGEON
	droning_sound = 'sound/music/area/manorgarri.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/town/rmh
	cell_area = TRUE

/area/rogue/under/town/rmh/sewer
	name = "Rivermist Hollow Sewers"
	first_time_text = "RIVERMIST HOLLOW SEWERS"
	icon_state = "sewer"
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_RATS
	spookynight = SPOOKY_RATS
	droning_sound = 'sound/music/area/sewers.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambientrain = RAIN_SEWER
	soundenv = 21
	converted_type = /area/rogue/outdoors/exposed/under/rmh/sewer
	ceiling_protected = TRUE

/area/rogue/outdoors/exposed/under/rmh/sewer
	name = "Rivermist Hollow Sewers"
	first_time_text = "RIVERMIST HOLLOW SEWERS"
	icon_state = "sewer"
	droning_sound = 'sound/music/area/sewers.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/rmh/magician
	name = "Wizard's Tower"
	first_time_text = "WIZARD'S TOWER"
	icon_state = "magician"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/magiciantower.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/magiciantower

/area/rogue/outdoors/exposed/magiciantower
	name = "Wizard's Tower"
	first_time_text = "WIZARD'S TOWER"
	icon_state = "magiciantower"
	droning_sound = 'sound/music/area/magiciantower.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/rmh/magician/pass
	name = "Secret Pass"
	first_time_text = "SECRET PASS"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/magiciantower.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ceiling_protected = TRUE

/area/rogue/indoors/town/rmh/barber
	name = "Town Barber"
	first_time_text = "TOWN BARBER"

/area/rogue/indoors/town/rmh/farm
	name = "Town Farm"
	first_time_text = "TOWN FARM"

/area/rogue/outdoors/exposed/town/rmh/farm
	name = "Town Farm"
	first_time_text = "TOWN FARM"
	icon_state = "outdoors"

/area/rogue/indoors/town/rmh/bank
	name = "Town Bank"
	first_time_text = "TOWN BANK"

/area/rogue/indoors/town/rmh/sawmill
	name = "Town Sawmill"
	first_time_text = "TOWN SAWMILL"

/area/rogue/indoors/town/rmh/library
	name = "Town Library"
	first_time_text = "TOWN LIBRARY"

/area/rogue/indoors/town/rmh/bath
	name = "Town Baths"
	first_time_text = "TOWN BATHS"
	icon_state = "bath"
	droning_sound = 'sound/music/area/bath.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/rmh/bath

/area/rogue/outdoors/exposed/rmh/bath
	name = "Town Baths"
	droning_sound = 'sound/music/area/bath.ogg'

/area/rogue/indoors/town/rmh/crafters_guild
	name = "Crafters Guild"
	first_time_text = "CRAFTERS GUILD"

/area/rogue/indoors/town/rmh/crafters_guild/under
	name = "Crafters Guild"
	first_time_text = "CRAFTERS GUILD"
	icon_state = "dwarfin"
	droning_sound = 'sound/music/area/dwarf.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/rmh/crafters

/area/rogue/outdoors/exposed/rmh/crafters
	name = "Crafters Guild"
	first_time_text = "CRAFTERS GUILD"
	icon_state = "dwarf"
	droning_sound = 'sound/music/area/dwarf.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/rmh/merchant
	name = "Merchants Guild"
	first_time_text = "MERCHANTS GUILD"
	icon_state = "shop"
	droning_sound = 'sound/music/area/shop.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/rmh/merchant

/area/rogue/outdoors/exposed/rmh/merchant
	name = "Merchants Guild"
	first_time_text = "MERCHANTS GUILD"
	icon_state = "shop"
	droning_sound = 'sound/music/area/shop.ogg'

/area/rogue/indoors/town/rmh/tavern
	name = "Drunk Dwarf Tavern"
	first_time_text = "DRUNK DWARF TAVERN"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "tavern"
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	droning_sound = 'sound/silence.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/rmh/tavern
	tavern_area = TRUE

/area/rogue/outdoors/exposed/rmh/tavern
	name = "Drunk Dwarf Tavern"
	first_time_text = "DRUNK DWARF TAVERN"
	droning_sound = 'sound/silence.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	tavern_area = TRUE

/area/rogue/indoors/town/rmh/town_hall
	name = "Town Hall"
	first_time_text = "TOWN HALL"

/area/rogue/indoors/town/rmh/chapel
	name = "The Town Chapel"
	first_time_text = "THE TOWN CHAPEL"
	icon_state = "church"
	droning_sound = 'sound/music/area/church.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	holy_area = TRUE
	droning_sound_dawn = 'sound/music/area/churchdawn.ogg'
	converted_type = /area/rogue/outdoors/exposed/church
	deathsight_message = "a chapel"

/area/rogue/outdoors/exposed/rmh/chapel
	name = "The Town Chapel"
	first_time_text = "THE TOWN CHAPEL"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "outdoors"
	droning_sound = 'sound/music/area/church.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	droning_sound_dawn = 'sound/music/area/churchdawn.ogg'
	deathsight_message = "a chapel"

/area/rogue/indoors/town/rmh/chapel/basement
	icon_state = "The Ancient Crypt"
	first_time_text = "THE ANCIENT CRYPT"
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "THE ANCIENT CRYPT"

//HERMITS
/area/rogue/indoors/town/rmh/miner
	name = "Miner's Hut"
	first_time_text = "MINER'S HUT"

/area/rogue/indoors/town/rmh/witch
	name = "Witch's Hut"
	first_time_text = "WITCH'S HUT"

//BEDROCK AND BORDERS
/area/rogue/under/rmh_bedrock
	name = "Bedrock Border"
	first_time_text = "BEDROCK BORDER"
	icon_state = "unknown"
	ceiling_protected = TRUE
	deathsight_message = "out of bounds"

/area/rogue/outdoors/rmh_air
	name = "In Air"
	icon = 'modular_rmh/icons/turf/areas.dmi'
	icon_state = "air"
	deathsight_message = "open air"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
