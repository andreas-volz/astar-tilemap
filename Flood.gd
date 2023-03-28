extends Node2D

onready var sprite: Sprite = $Sprite

func set_color(color : Color):
	sprite.modulate = color
