extends Control

# Base width you designed for (desktop reference)
@export var base_screen_width : int = 1920
@export var base_font_size : int = 24

# Optional clamp for min/max font size
@export var min_font_size : int = 14
@export var max_font_size : int = 32

func _ready():
	_scale_fonts(self)

# Recursive function to scale fonts in all children
func _scale_fonts(node: Node):
	for child in node.get_children():
		if child is Label:
			var screen_width = DisplayServer.screen_get_size().x
			var scaled_font_size = int(base_font_size * (screen_width / base_screen_width))
			scaled_font_size = clamp(scaled_font_size, min_font_size, max_font_size)
			child.add_theme_font_size_override("font_size", scaled_font_size)
		elif child is Control:
			# Recursively scale labels in children
			_scale_fonts(child)
