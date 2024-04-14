extends Node

var death_count = 0 # Keeping track of the player death count

var debug # Reference to DebugPanel for debug property assignment

# Level specifc varaiables
var level_1_survived_passed_time = false # Used for unlocking the machine gun
var level_2_survived_passed_time = false # Used for unlocking the shotgun
var level_3_survived_passed_time = false # Used for unlocking the grenade launcher
var level_4_survived_passed_time = false # Maybe used for another chance at getting a weapon unlock if died before
var level_5_survived_passed_time = false # Used for determining which ending the player gets
