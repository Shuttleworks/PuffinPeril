extends Area2D #allows us to inherit all the functionality of this asset's type
signal hit

#@export allows the values to be adjusted in the IDE Inspector
@export var speed = 400 #how fast the player will move (pixels/sec) 
var screen_size #size of the game window

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		#$ is shorthand for get_node(), so code below is the same as get_node("AnimatedSprite2D").stop()
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		
		$AnimatedSprite2D.flip_h = velocity.x < 0 # shorthand boolean assignment
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body: Node2D) -> void:
	#hide() # Player disappears after being hit.
	
	
	#body.queue_free() #since the function has the reference to the body it hit, it was much easier to target it here.
	#can you emit a variable with a signal?
	
	hit.emit(body)
	# Must be deferred as we can't change physics properties on a physics callback.
	#$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
