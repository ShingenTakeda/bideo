extends CharacterBody3D

@export var raycast: RayCast3D

func _ready():
	raycast = $RayCast3D

func _process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("Player"):
			print("Player detected!")
