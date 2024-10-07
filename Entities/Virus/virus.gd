extends CharacterBody3D

@export var raycast: RayCast3D

var lua_vm: LuaAPI = LuaAPI.new()
var lua_script : String = ""
var was_modified : bool = false

func l_print(message: String):
	print(message)

func _ready():
	raycast = $RayCast3D
	lua_vm.bind_libraries(["base", "table", "string"])

	lua_vm.push_variant("print", l_print)

	var file = FileAccess.open("res://lua_scripts/test_enemy.lua", FileAccess.READ)
	lua_script = file.get_as_text()
	var err : LuaError = lua_vm.do_string(lua_script)

	if err is LuaError:
		return

	var ret = lua_vm.call_function("test_enemy.exec", [])
	if ret is LuaError:
		print("ERROR %d: %s" % [ret.type, ret.message])
		return

func _process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("Player"):
			print("Player detected!")
