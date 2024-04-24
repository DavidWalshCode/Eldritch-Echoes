extends Label

var ending_died_text = "And thus, Aisling the Challenger fell to the horde.\n
The dark powers that had latched onto her from the very first trial dissipated and diffused back into the land, awaiting the next Challenger to come, seeking their strength. The town’s denizens succumbed to the madness of Arakzul's elder eldritch horror and perished to infighting and ritualistic slaughter, but it was contained to the city alone.\n
With no survivors to tell the tale, it was only a matter of time before new wanderers emerged, stumbling across the ruins before taking up residence. As the population grew, the otherworldly entity returned with alluring calls to adventure and promises of power. Over time, Arakzul's religion was founded anew… and a new Challenger approaches...
"

var ending_survived_text = "And thus, Aisling the Challenger conquered the horde.\n
As the horde of underdwellers witnessed the might of the Challenger and the dark powers she wielded, they knew their master had finally emerged. They bowed their heads as one, and the Challenger took on her mantle as the Harbinger. A twisted and unrelenting voice boomed through her head: “You have nurtured and mastered the gifts I have granted and, in so doing, have given yourself to me utterly. Now go. Take the horde and bring the reaping to ALL.”\n
On her master’s orders, the Harbinger swept across the land. Bringing indiscriminate and wanton destruction to all she came across. The myriad of armies, nations and countries that stood against her were cut down and washed away by a seemingly limitless deluge of horrific beasts from beneath.\n
When no other creatures remained, the beasts turned on themselves, tearing each other apart before eviscerating their own bodies. When the Harbinger stood alone in a world burned and devoid of life, Arakzul finally released its grasp and drifted back to its own realm to sleep in peace. Leaving Aisling to look out on all she had wrought and felt the total weight of her crimes, but nobody left to make her pay for them.\n
"

@onready var died_ending_ambience = $"../../../Audio/DiedEndingAmbience"
@onready var survived_ending_ambience = $"../../../Audio/SurvivedEndingAmbience"

func _ready() -> void:
	if Global.level_5_survived_passed_time:
		survived_ending_ambience.play()
		await get_tree().create_timer(7).timeout
		scroll_text(ending_survived_text)
	else:
		died_ending_ambience.play()
		await get_tree().create_timer(7).timeout
		scroll_text(ending_died_text)

func scroll_text(input_text : String) -> void:
	visible_characters = 0
	text = input_text
	
	for i in text.length():
		visible_characters += 1
		await get_tree().create_timer(0.1).timeout
	
	await get_tree().create_timer(7).timeout
	$"../../..".queue_free()
	SceneManager.swap_scenes(SceneRegistry.main_scenes["main_menu"], get_tree().root, self, "fade_to_black")
