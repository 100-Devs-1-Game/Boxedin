extends Node3D

@export var red := true:
	set(value):
		red = value
		%Red.visible = value
@export var green := false:
	set(value):
		green = value
		%Green.visible = value
@export var is_blinking := false:
	set(value):
		is_blinking = value
		_blinking(value)
		
var blink_tween : Tween
var blink_time : float
		
func _ready() -> void:
	blink_time = randf_range(0.98,1.02)
	if is_blinking:
		_blinking(is_blinking)
	_reset()

func _reset() -> void:
	%Green.visible = green
	%Red.visible = red


func _blinking(value: bool) -> void:
	if !value:
		#stop it
		blink_tween.kill()
		_reset()
		%TrafficLight.show()
		return
	blink_tween = create_tween().set_loops(-1)
	blink_tween.tween_interval(0.00001)
	blink_tween.tween_property(%TrafficLight,"visible",true,blink_time)
	blink_tween.tween_property(%TrafficLight,"visible",false,blink_time)
