extends CanvasLayer

#Notifies 'Main' node that the button has been pressed
signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over(score, message = "Game Over"):
	show_message(message)
	#wait until the MessageTimer has counted down.
	
	await $MessageTimer.timeout
	
	$Message.text = "You scored: " + str(score)
	$Message.show()
	
	#Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_time(time):
	$CountdownLabel.text = str(time)

func update_points(points):
	$PointsLabel.text = str(points)
	
func update_strikes(strikes):
	var lifedisplay = ""
	for x in range(0, strikes):
		lifedisplay += " *"
	$LifeLabel.text = str(lifedisplay)
	
func register_mobhit(message):
	$MobLabel.text = str(message)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	update_points("0")
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()
