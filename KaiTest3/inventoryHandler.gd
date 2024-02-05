extends Node2D
var closeButton:Button
var tilePerRow
var scrollbar:VScrollBar
const TILE_MARGIN:float = 10
const TILE_CONTAINER_MARGIN:float = 20
var items_node:Array= []
var items_type:Array= []
var total_tiles_per_scrollpos
@onready var rawr = get_node("rawr~")
@onready var templateTile = get_node("itemTileContainer").get_node("itemTileTemplate")
func _ready():
	scrollbar = get_node("VScrollBar")
	tilePerRow = floor((rawr.size.x-TILE_CONTAINER_MARGIN*2)/(templateTile.size.x+TILE_MARGIN))
	self.visible = false
	total_tiles_per_scrollpos = tilePerRow*floor(rawr.size.y/templateTile.size.y+TILE_MARGIN)
	closeButton = get_node("closeButton")
	closeButton.connect("pressed",invClose)
	closeButton.disabled = true
func invClose():
	self.visible = false
	closeButton.disabled = true
func invToggle():
	self.visible = !self.visible
	closeButton.disabled = !closeButton.disabled
func _process(delta):
	if(Input.is_action_just_pressed("inventory_toggle")):
		invToggle()
func search(query:String):
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
	
