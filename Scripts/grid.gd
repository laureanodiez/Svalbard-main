extends Node3D
class_name MyGrid

var sceneArray : Dictionary = {}
var preloadScenes : Array[PackedScene]

func _ready():
	pass

func translateCoordinates(pos : Vector3) -> Vector3i:
	return Vector3i(floor(pos.x/10)*10 + 5, 0, floor(pos.z/10)*10 + 5)

func find(pos : Vector3i):
	var keyArray = sceneArray.keys()
	return keyArray.find(pos)

func get_used_cells():
	return sceneArray.keys()

func getScene(scene_id : int):
	if scene_id == 0:
		return preload("res://Scenes/Generation/escenario chaletspasillo.tscn")
	if scene_id == 1:
		return preload("res://Scenes/Generation/escena 1.tscn")
	if scene_id == 2:
		return preload("res://Scenes/Generation/escenario midchalet.tscn")
	if scene_id == 3:
		return preload("res://Scenes/Generation/escenario limpia.tscn")
	if scene_id == 4:
		return preload("res://Scenes/Generation/escenario midbalcon.tscn")
	if scene_id == 5:
		return preload("res://Scenes/Generation/escenario pueblo.tscn")	
	if scene_id == 6:
		return preload("res://Scenes/Generation/escenario iglesia + chalet.tscn")
	if scene_id == 7:
		return preload("res://Scenes/Generation/escena 1.tscn")
#	preloadScenes[0] = preload("res://Textures/chalet_azul.glb")
#	preloadScenes[1] = preload("res://Textures/senalcol.glb")

func set_cell_item(pos : Vector3i, scene_id : int):
	var scene : PackedScene = getScene(scene_id)
	var newInstance = scene.instantiate()

	newInstance.position = pos
	sceneArray[pos] = scene

	return newInstance
