extends RichTextLabel

var ending_survived_text = "And thus, the Challenger fell to the horde.\n
The dark powers that had latched onto her from the very first trial dissipated and diffused back into the land, awaiting the next Challenger to come, seeking their strength.\n
The town’s denizens succumbed to the madness of the elder eldritch horror and perished to infighting and ritualistic slaughter, but it was contained to the city alone.\n
With no survivors to tell the tale, it was only a matter of time before new wanderers emerged, stumbling across the ruins before taking up residence. As the population grew, the otherworldly entity returned with alluring calls to adventure and promises of power. Over time, his religion was founded anew… and a new Challenger approaches.
"

var ending_died_text = "And thus, the Challenger conquered the horde.\n
As the horde of underdwellers witnessed the might of the Challenger and the dark powers she wielded, they knew their master had finally emerged. They bowed their heads as one, and the Challenger took on her mantle as the Harbinger.\n
A twisted and unrelenting voice booms through your head:\n
[i]“You have nurtured and mastered the gifts I have granted and, in so doing, have given yourself to me utterly. Now go. Take the horde and bring the reaping to ALL.”[/i]\n
At her master’s orders, the Harbinger swept across the land. Bringing indiscriminate and wanton destruction to all he came across. The myriad armies, nations and countries that stood were cut down and washed away by a seemingly limitless deluge of horrific beasts from beneath.\n
When no other creatures remained, the beasts turned on themselves, tearing each other apart before eviscerating their own bodies. When the Harbinger stood alone in a world burned and devoid of life, the Horror finally released his grasp and drifted back to its own realm to sleep in peace. Leaving the Challenger to look out on all she had wrought and felt the total weight of her crimes, but nobody left to make her pay for them.\n
"

func _ready() -> void:
	if Global.level_5_survived_passed_time:
		scroll_text(ending_survived_text)
	else:
		scroll_text(ending_died_text)

func scroll_text(input_text : String) -> void:
	visible_characters = 0
	text = input_text
	
	for i in get_parsed_text():
		visible_characters += 1
		await  get_tree().create_timer(0.1).timeout
