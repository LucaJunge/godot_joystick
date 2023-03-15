# Godot Joystick (4.0)

![](./addons/godot_joystick/media/logo.png)

This repository contains the source code for my Joystick Plugin for the Godot Engine 4.0

## Installation

Copy the `addons/godot_joystick` folder to the addons folder of your project.

Add the `Joystick` node via `CTRL+A` and add it to your scene.

## Configuration

You can set some settings for your joystick. Take a look at the inspector to see all available settings.

![](./addons/godot_joystick/media/inspector.png)

## Usage

In your \_process() function get the joystick input axes:

```
func _process(delta) -> void:
		var x : float = Input.get_action_strength("move_x")
		var y : float = Input.get_action_strength("move_y")

    # Use the input axes
		bug.position += Vector2(x,y) * speed * delta
```

## Test scene

The repository contains a test scene under `addons/godot_joystick/Test.tscn`:

<img src="addons/godot_joystick/media/showcase.png" width="300">
