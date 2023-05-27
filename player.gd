extends Area2D
signal hit

@export var speed = 200 #export vars allows us to se its value in the inspector ; handy for values i want to be able to adjust like a node's built in property.
var screen_size 
var velocity

func _ready(): #Called when the node enters the scene tree for the first time.
	screen_size = get_viewport_rect().size #finds the size of the game window
	$sprite.animation = "up"
	#hide() #hides the node, pretty obvious

func _process(delta): #basically the "forever" loop of godot; runs every frame.
	if Input.is_action_pressed("move_right"):
		rotation_degrees += 3
	if Input.is_action_pressed("move_left"):
		rotation_degrees -= 3
	if Input.is_action_pressed("move_down"):
		velocity += 1
	if Input.is_action_pressed("move_up"):
		velocity -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
			
		$sprite.play() # "$" is get node func; returns the node at relative path from current node, returns null if node wanted is not found.
	else:
		$sprite.stop()
		
	position += velocity * delta 
	position.x = clamp(position.x, 0 , screen_size.x) #clamp restricts a value to a given reange.
	position.y = clamp(position.y, 0 , screen_size.y)
	

func _on_body_entered(body): #basically the "when i recieve" broadcasts of godot
	hide()
	hit.emit()
	$collision_shape.set_deferred("disabled", true) #We need to disable the player's collision so that we don't trigger the hit signal more than once.

func reset(pos):
	position = pos
	show()
	$collision_shape.disabled = false #sets it to true so that ti can work again
