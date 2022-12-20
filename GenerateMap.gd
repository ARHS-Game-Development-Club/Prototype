extends TileMap


const DIRECTION = {
	"up"    : [0, -1],
	"right" : [1, 0],
	"down"  : [0, 1],
	"left"  : [-1, 0]
}


class RoomDoor:
	var x: int
	var y: int
	var width: int
	var direction_out: Array
	func _init(_x, _y, _width, _direction_out):
		self.x = _x
		self.y = _y
		self.width = _width
		self.direction_out = _direction_out


class RoomLayout:
	var room_grid: Array
	var doors: Array
	func _init(_room_grid, _doors):
		self.room_grid = _room_grid
		self.doors = _doors

	func clone():
		return get_script().new(self.room_grid.duplicate(true), self.doors)


var room_variant_1 = RoomLayout.new([
			[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
			[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
			[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
		], [
			RoomDoor.new(13, 0,  4, DIRECTION.get("up")),
			RoomDoor.new(29, 7,  3, DIRECTION.get("right")),
			RoomDoor.new(13, 16, 4, DIRECTION.get("down")),
			RoomDoor.new(0,  7,  3, DIRECTION.get("left"))
		]
)
var room_variants = [room_variant_1]


# At least for now, all rooms should fit inside a 30x17 2D array.
const ROOM_WIDTH = 30
const ROOM_HEIGHT = 17
# Both room map constants should preferably be odd ints so that th estarter 
# room is right in the middle.
const ROOM_MAP_WIDTH = 9
const ROOM_MAP_HEIGHT = 9


func new_grid(grid_width, grid_height):
	var grid = []
	grid.resize(grid_height)
	for i in range(grid.size()):
		grid[i] = []
		grid[i].resize(grid_width)

	return grid


# Top-left of the starter room is (0,0) on the TileMap grid.
func add_starter_room(room_map):
	var x = floor(ROOM_MAP_WIDTH / 2.0)
	var y = floor(ROOM_MAP_HEIGHT / 2.0)
	room_map[y][x] = room_variant_1.clone()

	return [room_map, x * ROOM_WIDTH, y * ROOM_HEIGHT]


func get_neighbor_room_position(room_x, room_y, door):
	return [door.direction_out[0] + room_x, door.direction_out[1] + room_y]


func is_in_bounds(neighbor_x, neighbor_y):
	if 0 <= neighbor_x \
			and neighbor_x < ROOM_MAP_WIDTH \
			and 0 <= neighbor_y \
			and neighbor_y < ROOM_MAP_HEIGHT:
		return true

	return false


func is_vacant(room_map, neighbor_x, neighbor_y):
	if room_map[neighbor_y][neighbor_x] == null:
		return true

	return false


# Randomly select a room variant to be added to a cell.
func add_room(room_map, neighbor_x, neighbor_y):
	var new_room = room_variants[randi() % room_variants.size()].clone()
	room_map[neighbor_y][neighbor_x] = new_room

	return room_map


func get_direction_key(door):
	var direction_keys = DIRECTION.keys()
	match door.direction_out:
		[0, -1]: return direction_keys[0]
		[1, 0]: return direction_keys[1]
		[0, 1]: return direction_keys[2]
		[-1, 0]: return direction_keys[3]


func generate_door(room, door_x, door_y, door_width, direction_key):
	if direction_key == "right" or direction_key == "left":
		for row in range(door_y, door_y + door_width):
			room.room_grid[row][door_x] = 0
	else:
		for col in range(door_x, door_x + door_width):
			room.room_grid[door_y][col] = 0

	return room


# Uses the position and width of the door defined in the room variant
func add_door(room_map, door, room_x, room_y):
	# Add a door to current room...
	var curr_room = room_map[room_y][room_x]
	var direction_key = get_direction_key(door)
	room_map[room_y][room_x] = generate_door(curr_room, door.x, door.y, 
			door.width, direction_key)

	# ...and the neighboring room we want to connect.
	var neighbor_room = room_map[room_y + door.direction_out[1]] \
			[room_x + door.direction_out[0]]
	for neighbor_door in neighbor_room.doors:
		if neighbor_door.direction_out[0] + door.direction_out[0] == 0 \
				and neighbor_door.direction_out[1] \
				+ door.direction_out[1] == 0:
			direction_key = get_direction_key(neighbor_door)
			room_map[room_y + door.direction_out[1]] \
					[room_x + door.direction_out[0]] = generate_door(
						neighbor_room, neighbor_door.x, neighbor_door.y,
						neighbor_door.width, direction_key
			)

	return room_map


# This is a recursive function. Create a github issue ticket if 
# this causes problems with performance.
func generate_neighbors(room_map, room_x, room_y, threshold):
	var curr_room = room_map[room_y][room_x]
	# TODO: Randomize order of doors to check
	for i in range(curr_room.doors.size()):
		if threshold <= 0:
			break
		elif randf() > threshold:
			threshold -= 0.1
		else:
			threshold -= 0.1

			var door = curr_room.doors[i]

			var neighbor_pos = get_neighbor_room_position(room_x, room_y, door)
			var neighbor_x = neighbor_pos[0]
			var neighbor_y = neighbor_pos[1]

			if is_in_bounds(neighbor_x, neighbor_y):
				if is_vacant(room_map, neighbor_x, neighbor_y):
					room_map = add_room(room_map, neighbor_x, neighbor_y)

				room_map = add_door(room_map, door, room_x, room_y)
				room_map = generate_neighbors(room_map, neighbor_x, neighbor_y,
						threshold)

	return room_map


func create_tile_grid(room_map, grid):
	for tile_row in range(grid.size()):
		var room_row = floor(float(tile_row) / ROOM_HEIGHT)
		for tile_col in range(grid[tile_row].size()):
			var room_col = floor(float(tile_col) / ROOM_WIDTH)
			if room_map[room_row][room_col]:
				grid[tile_row][tile_col] = room_map[room_row][room_col] \
						.room_grid[tile_row % ROOM_HEIGHT] \
								[tile_col % ROOM_WIDTH]

	return grid


func draw_tile_grid(grid, origin_x, origin_y):
	for row in range(grid.size()):
		for col in range(grid[row].size()):
			if grid[row][col] != null:
				set_cell(col - origin_x, row - origin_y, grid[row][col])


# Use for debugging
func print_room_map(room_map):
	for i in range(room_map.size()):
		print(room_map[i])


# Called when the node enters the scene tree for the first time.
func _ready():
	# Randomize the seed
	randomize()

	# Holds RoomLayout types
	var room_map = new_grid(ROOM_MAP_WIDTH, ROOM_MAP_HEIGHT)
	# Holds actual grid of tiles
	var grid = new_grid(ROOM_MAP_WIDTH * ROOM_WIDTH, 
			ROOM_MAP_HEIGHT * ROOM_HEIGHT)

	var starter_room_result = add_starter_room(room_map)
	room_map = starter_room_result[0]
	var grid_origin_x = starter_room_result[1]
	var grid_origin_y = starter_room_result[2]
	room_map = generate_neighbors(
			room_map,
			floor(ROOM_MAP_WIDTH / 2.0),
			floor(ROOM_MAP_HEIGHT / 2.0),
			1
	)
	print_room_map(room_map)

	# Holds actual grid of tiles
	grid = create_tile_grid(room_map, grid)
	draw_tile_grid(grid, grid_origin_x, grid_origin_y)
