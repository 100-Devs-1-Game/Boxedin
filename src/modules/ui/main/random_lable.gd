extends RichTextLabel
@export_multiline var random_text: Array[String]
@export var text_size: int = 60
@export var text_color: String = "black"

func _ready() -> void:
	self.text = "[font_size={size}][color={color}]{text}".format({"size": text_size, "color": text_color, "text":  random_text.pick_random()})


func _on_visibility_changed() -> void:
	self.text = "[font_size={size}][color={color}]{text}".format({"size": text_size, "color": text_color, "text":  random_text.pick_random()})
