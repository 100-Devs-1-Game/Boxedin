extends Button

@onready var texture_rect = $Marker
@onready var anim_player = $AnimationPlayer


func _ready():
	mouse_entered.connect(_on_button_hovered)
	mouse_exited.connect(_on_button_unhovered)
	texture_rect.visible = true 

func _on_button_hovered():
	anim_player.play("main_button_reveal")

func _on_button_unhovered():
	anim_player.play("RESET")
