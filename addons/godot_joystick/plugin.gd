@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Joystick", "PanelContainer", preload("res://addons/godot_joystick/godot_joystick.gd"), preload("res://addons/godot_joystick/icon-16.png"))


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_custom_type("Joystick")
