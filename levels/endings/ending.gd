extends RichTextLabel

var ending_survived_text = "Temp\n"

var ending_died_text = "Temp\n"

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
