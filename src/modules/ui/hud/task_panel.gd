extends PanelContainer
class_name TaskPanel
@export var title := "":
	set(value):
		title = value;
		%Title.text = value
		if value == "":
			self.hide()
		else:
			self.show()
@export var tasks := "Task":
	set(value):
		tasks = value
		%Tasks.text = "[ul]"+value+"[/ul]"
