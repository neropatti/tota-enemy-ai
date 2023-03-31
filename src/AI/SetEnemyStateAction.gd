extends ActionLeaf

export(
	String,
	"idle",
	"walk",
	"graze",
	"spotted_player",
	"precharge",
	"ready_to_charge",
	"charge",
	"charging",
	"attack",
	"attacked",
	"die",
	"hurt",
	"predatory"
) var state_to_change_to


func tick(_actor, blackboard):
	# print(get_path())
	blackboard.set("state", state_to_change_to)
	return SUCCESS
