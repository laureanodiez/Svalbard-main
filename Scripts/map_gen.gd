extends Node3D

@onready var grid : MyGrid
@onready var renderDistance = 2
@onready var playerPos : Vector3

signal targetPosition(pos : Vector3)

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = MyGrid.new()
	var numArray = [-15, -5, 5, 15, 25]

	for x in numArray:
		for z in numArray:
			var newInstance = grid.set_cell_item(Vector3i(x, 0, z), 0)
			add_child(newInstance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_player_grid_position_changed(old_pos, new_pos):
	if new_pos != old_pos:
		changeGridMap(grid.translateCoordinates(old_pos), grid.translateCoordinates(new_pos))

func changeGridMap(old_pos : Vector3i, new_pos : Vector3i):
	var sceneArray = grid.get_used_cells()

	var direction : Vector3i = new_pos - old_pos
	direction *= renderDistance

	var firstChunk : Vector3i = new_pos + direction

	var perpendicularDirection = Vector3i.ZERO
	direction /= renderDistance
	perpendicularDirection.x = -direction.z
	perpendicularDirection.z = direction.x
	perpendicularDirection.y = direction.y

	var array : Array = [firstChunk, firstChunk+(1*perpendicularDirection), firstChunk+(2*perpendicularDirection), firstChunk+(-1*perpendicularDirection), firstChunk+(-2*perpendicularDirection)]
	var rng = RandomNumberGenerator.new()
	var bloque = rng.randi_range(0, 7)
	
	for pos in array:
		if sceneArray.find(pos) == -1:
			var newInstance = grid.set_cell_item(pos, bloque)
			add_child(newInstance)
			spawnEnemy(pos)
			
func spawnEnemy(pos : Vector3i):
	var bear = preload("res://Scenes/bear.tscn")
	
	var rng = RandomNumberGenerator.new()
	
	if rng.randi_range(0, 100)<20:
		var newBear = bear.instantiate()
		newBear.position = pos
		newBear.position.y = 1
		
		add_child(newBear)


func _on_player_global_position_changed(pos):
	playerPos = pos
	targetPosition.emit(pos)
