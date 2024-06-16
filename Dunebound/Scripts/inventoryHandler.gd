extends Node2D
var closeButton:Button
var tilePerRow
var scrollbar:VScrollBar
const TILE_MARGIN:float = 10
const TILE_CONTAINER_MARGIN:float = 20
var items_node:Array= []
var total_tiles_per_scrollpos
func newInfoGhost(source:Object):
	var ghost = source.duplicate()
	#for some dumbass reason duplicate is getting the variable itself but not its value
	ghost.foodTypeA = source.foodTypeA
	ghost.visible = false
	ghost.get_node("hitbox").set_deferred("disabled",false)
	ghost.position = Global.Player.position+Vector2(0,100)
	Global.camera.get_parent().add_child(ghost)
	items_node.append(ghost)
@onready var rawr = get_node("rawr~")
@onready var templateTile = get_node("itemTileContainer").get_node("itemTileTemplate")
func _ready():
	Global.inventory = self
	#i hate math
	scrollbar = get_node("VScrollBar")
	tilePerRow = floor((rawr.size.x-TILE_CONTAINER_MARGIN*2)/(templateTile.size.x+TILE_MARGIN))
	self.visible = false
	total_tiles_per_scrollpos = tilePerRow*floor(rawr.size.y/templateTile.size.y+TILE_MARGIN)
	closeButton = get_node("closeButton")
	closeButton.connect("pressed",invClose)
	get_node("TextEdit").connect("text_changed",search)
	closeButton.disabled = true
func invClose():
	self.visible = false
	closeButton.disabled = true
func invToggle():
	self.visible = !self.visible
	#get_parent().get_node("PauseScreen").visible=!get_parent().get_node("PauseScreen").visibl
	closeButton.disabled = !closeButton.disabled

func _process(_delta):
	if(Input.is_action_just_pressed("inventory_toggle")):
		invToggle()

func search():
	var query:String = get_node("TextEdit").text
	var itemFound:bool
	var itemPos:Array = []
	for x in items_node.size():
		if(items_node[x].foodTypeA==query):
			itemFound = true
			itemPos.push_back(x)
			#il make the search work with non-food items later
	var currentTileAmountOnPage:int = 0
	var currentTileAMountOnRow:int = 0
	var lastSpawnedTilePosition:Vector2 = get_node("itemTileContainer/itemTileTemplate").size
	scrollbar.max_value = ceil(itemPos.size()/total_tiles_per_scrollpos)
	for y in itemPos.size():
		currentTileAmountOnPage+=1
		var newTile = templateTile.duplicate(15)
		
		add_child(newTile)
		newTile.get_node("Sprite2D").texture = items_node[itemPos[y]].get_node("Sprite2D").texture
		newTile.get_node("Sprite2D").scale = Vector2(templateTile.size.x-1/newTile.get_node("Sprite2D").texture.get_size().x,templateTile.size.y-1/newTile.get_node("Sprite2D").texture.get_size().y)
		if(currentTileAMountOnRow+1>tilePerRow):
			newTile.position = templateTile.position+Vector2(0,TILE_MARGIN)
			currentTileAMountOnRow = 0
		else:
			newTile.position = lastSpawnedTilePosition+Vector2(templateTile.size.x+TILE_MARGIN,0)
		lastSpawnedTilePosition = position
