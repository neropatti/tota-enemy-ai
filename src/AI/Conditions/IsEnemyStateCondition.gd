extends ConditionLeaf

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
	"hurt"
) var state_to_check


func tick(actor, blackboard):
	# print(get_path())
	assert(state_to_check != null)
	var blackboard_state = blackboard.get("state")
	var is_equal_state: bool = blackboard_state == state_to_check

	print("Checking state " + blackboard_state + " is equal to " + state_to_check)

	if is_equal_state:
		return SUCCESS

	return FAILURE
