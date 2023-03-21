extends Node2D

# 0000 = UP|DOWN|LEFT|RIGHT

var cliff_mappings = {
	"0000": "Closed",
	"1111": "Open",
	"0001": "OpenRight",
	"0010": "OpenLeft",
	"0100": "OpenDown",
	"1000": "OpenUp",
	"1100": "OpenUpDown",
	"0011": "OpenLeftRight",
	"1010": "OpenUpLeft",
	"1001": "OpenUpRight",
	"0110": "OpenDownLeft",
	"0101": "OpenDownRight",
	"1110": "OpenUpDownLeft",
	"1011": "OpenUpLeftRight",
	"0111": "OpenDownLeftRight",
	"1101": "OpenUpDownRight"
}


func set_border_openings(openings: Array) -> void:
	var id: String = ""
	for i in range(openings.size()):
		var opening: String = str(openings[i])
		id += opening

	# Linear world is manually amended
	if id == "":
		return

	assert(cliff_mappings[id] != null)

	var a: TileMap

	var cliff_openings = get_children()
	for cliff_opening in cliff_openings:
		if cliff_opening.name != cliff_mappings[id]:
			cliff_opening.visible = false
			cliff_opening.collision_layer = 0
			cliff_opening.collision_mask = 0
		else:
			cliff_opening.visible = true
			cliff_opening.collision_layer = 1
			cliff_opening.collision_mask = 1
