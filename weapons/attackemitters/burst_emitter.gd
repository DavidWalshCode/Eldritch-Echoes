extends AttackEmitter

@export var burst_count = 5

func fire():
	for _i in range(burst_count):
		super()
