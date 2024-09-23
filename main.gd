extends Node

@export var food_scene: PackedScene
@export var enemy_scene: PackedScene

const food_type = preload("res://food.gd")
const enemy_type = preload("res://mob.gd")

var time
var eaten
var strikes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over(message = "Game Over") -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$LimitTimer.stop()
	$HUD.show_game_over(eaten, message)
	$Music.stop()
	$DeathSound.play()
	
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("foodie", "queue_free")

func new_game():
	time = $LimitTimer.wait_time # this needs to be the same value as the LimitTimer. Anyway to read from property?
	eaten = 0
	strikes = 3
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_time(time)
	$HUD.show_message("Get ready")
	$HUD.update_strikes(strikes)
	#get_tree().call_group("mobs", "queue_free")
	$Music.play()

func _on_score_timer_timeout() -> void:
	time -= 1
	$HUD.update_time(time)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	$LimitTimer.start()
	
func _on_mob_timer_timeout() -> void:
	#Create dynamic fish (food)
	generateFood()
	generateEnemies()
	
	
func generateFood() -> void:
	#Create a new instahce of the Food scene
	var food = food_scene.instantiate()
	
	#Choose a random location on Path 2D
	var food_spawn_location = $MobPath/MobSpawnLocation
	food_spawn_location.progress_ratio = randf()
	
	#Set the food's direction perpendicular to the path direction
	var direction = food_spawn_location.rotation + PI / 2
	
	#Set the food's position to a random location.
	food.position = food_spawn_location.position
	
	#Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	food.rotation = direction
	
	#Choose the velocity for the food.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	food.linear_velocity = velocity.rotated(direction)
	
	#Spawn the food by adding it to the Main scene
	add_child(food)


func generateEnemies() -> void:
	#Create a new instahce of the Enemy (Mob) scene
	var enemy = enemy_scene.instantiate()
	
	#Choose a random location on Path 2D
	var enemy_spawn_location = $MobPath/MobSpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	
	#Set the enemy's direction perpendicular to the path direction
	var direction = enemy_spawn_location.rotation + PI / 2
	
	#Set the enemy's position to a random location.
	enemy.position = enemy_spawn_location.position
	
	#Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	
	#Choose the velocity for the food.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)
	
	#Spawn the food by adding it to the Main scene
	add_child(enemy)


func _on_player_hit(body) -> void:
	eaten += 1
	$HUD.update_points(eaten)
	
	if(body is enemy_type):
		strikes -= 1
		$OuchSound.play()
		$HUD.update_strikes(strikes)
		if (strikes == 0):
			game_over("Out of lives")
		
	if(body is food_type):	
		$HappySound.play()
		body.queue_free() # remove the food
	
	
	


func _on_limit_timer_timeout() -> void:
	game_over("Time's Up")
