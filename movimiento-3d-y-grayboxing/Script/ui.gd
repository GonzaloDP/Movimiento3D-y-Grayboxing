extends Node

@onready var player = $"../CSGCombiner3D/Player"
@onready var label = $CanvasLayer/Label

func _ready() -> void:
	player.monedas_cambiaron.connect(actualizar_contador)

func actualizar_contador(cantidad):
	label.text = "MONEDAS: " + str(cantidad)
