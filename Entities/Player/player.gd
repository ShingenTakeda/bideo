extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mouse_rotation = 1
var sensibilidade = 0.005

var currentHP := 10
var maxHP := 10
var damage := 1

func _ready():
	add_to_group("Player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "foward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	#if $RayCast3D.is_colliding():
	#	print('Colidiu com: ', $RayCast3D.get_collider().name)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and event is InputEventFromWindow:
		rotate_y(-lerp(0, mouse_rotation, event.relative.x * sensibilidade))
		
func take_damage(enemy_damage): #if deve chamar a tela de game over, não reload current scene
	currentHP -= enemy_damage
	if currentHP <= 0:
		get_tree().reload_current_scene()
		
