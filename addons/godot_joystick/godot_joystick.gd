extends PanelContainer

@onready var thumbstick : Panel = preload("thumbstick.tscn").instantiate()
@onready var thumbstick_radius : Vector2 = thumbstick.size / 2.0
@onready var shader_material = preload("res://addons/godot_joystick/fade_out.tres")
## The main configuration
@export_category("Configuration")

## Which Axis should be used for the X axis
#@export var axis_x := JOY_AXIS_LEFT_X

## Which Axis should be used for the Y axis
#@export var axis_y := JOY_AXIS_LEFT_Y

## Specify the name of the Input Action for moving horizontally
## Don't forget to set them up in the project settings
@export var move_x = "move_x"

## Specify the name of the Input Action for moving vertically
## Don't forget to set them up in the project settings
@export var move_y = "move_y"

@export_group("Fade Out")

## If the joystick should fade out after some time
@export var fade_out : bool = false

## How long the fade out should last until the joystick is no longer visible
@export var fade_out_duration : float = 2.0

## After how many (milli)seconds should the button begin to fade out?
@export var fade_out_begin : float = 2.0

@export_group("Interpolation")

## Should the thumbstick ease back into the resting position?
@export var enable_interpolation : bool = false

@export var interpolation_amount : float = 0.01

@export_group("Style")

## The base color of the thumbstick
@export var base_color : Color = Color8(0, 0, 0, 100)

## The thumbstick color
@export var thumbstick_color : Color = Color8(0, 0, 0, 100)

@export var base_border_radius : int = 100

@export var thumbstick_border_radius : int = 100

@export var thumbstick_margin : float = 0.0

## Limits you can set
@export_group("Limits")

## The deadzone of the stick. Will only send events when over the threshold
@export_range(0.0, 1.0, 0.01) var DEADZONE : float = 0.2

var base_radius : Vector2 = Vector2()
var thumbstick_position : Vector2 = Vector2()
var last_position : Vector2 = Vector2()
var needs_interpolation : bool = false

func _ready():
	self.material = shader_material
	if(fade_out == true):
		self.material.set("shader_parameter/disable_fade", false)
		self.material.set("shader_parameter/fade_duration", fade_out_duration)
		self.material.set("shader_parameter/fade_delay", fade_out_begin)
	else:
		self.material.set("shader_parameter/disable_fade", true)
		
	
	self.add_child(thumbstick)
	self.custom_minimum_size = Vector2(150, 150)
	self.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	self.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	self.pivot_offset = size / 2.0
	base_radius = size / 2.0

	set_joystick_theme()
	
	gui_input.connect(on_gui_input)
	
	# If InputMap.has_action(move_x)...
	InputMap.add_action(move_x)
	InputMap.add_action(move_y)

func on_gui_input(event: InputEvent):
	
	# On first touch
	if event is InputEventScreenTouch:
		
		# If we release the button, send a "0 event" and reset the thumbstick
		if not event.is_pressed():
			set_thumbstick(base_radius)
			set_values(base_radius)
			pass
		else:
			last_position = event.position
			set_thumbstick(event.position)
			set_values(event.position)
	
	# On drag
	if event is InputEventScreenDrag:
		last_position = event.position
		set_thumbstick(event.position)
		set_values(event.position) 
	
func set_thumbstick(pos: Vector2):	
	
	var result = (pos - base_radius)
	# add the offset again and subtract the radius of the thumbstick 
	#var result = (result - base_radius) - thumbstick_radius
	thumbstick.position = (base_radius - thumbstick_radius) + result.limit_length(base_radius.x * (1 - thumbstick_margin))
	
func set_values(pos: Vector2):
	
	var normalized = (pos - base_radius) / (base_radius)
	
	# circle normalized
	normalized = normalized.limit_length(1.0)
	
	# square normalized
	var square_normalized = map_circle_to_square(normalized)
	
	last_position = normalized
	
	# Event for X axis
	Input.action_press(move_x, square_normalized.x)
	
	# Event for Y axis
	Input.action_press(move_y, square_normalized.y)

func set_joystick_theme() -> void:
	var default_stylebox: StyleBoxFlat = StyleBoxFlat.new()
	default_stylebox.set_corner_radius_all(base_border_radius)
	default_stylebox.bg_color = Color8(0, 0, 0, 100)
	self.add_theme_stylebox_override("panel", default_stylebox)
	thumbstick.get_theme_stylebox("panel").set_corner_radius_all(thumbstick_border_radius)
	
	set_base_color()
	set_thumbstick_color()

func set_base_color() -> void:
	self.get_theme_stylebox("panel").bg_color = base_color

func set_thumbstick_color() -> void:
	var style = thumbstick.get_theme_stylebox("panel")
	thumbstick.get_theme_stylebox("panel").bg_color = thumbstick_color

## This maps the values we get from the circle
## (because we limit the length to the radius)
## To a range from -1 to 1
func map_circle_to_square(circ: Vector2) -> Vector2:
	var u2 := circ.x * circ.x
	var v2 := circ.y * circ.y
	var twosqrt := 2 * sqrt(2)
	var subtermx := 2 + u2 - v2
	var subtermy := 2 - u2 + v2 
	var termx1 := subtermx + circ.x * twosqrt
	var termx2 := subtermx - circ.x * twosqrt
	var termy1 := subtermy + circ.y * twosqrt
	var termy2 := subtermy - circ.y * twosqrt
	var x = 0.5 * sqrt(termx1) - 0.5 * sqrt(termx2)
	var y = 0.5 * sqrt(termy1) - 0.5 * sqrt(termy2)
	return Vector2(x, y)
