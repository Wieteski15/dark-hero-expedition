extends Resource
class_name Character

@export var name: String = "Unname"

@export var max_hp: int = 100
@export var hp: int = 100

@export var attak: int = 10
@export var speed: float = 1.0

@export var morale: int = 100

@export var is_live: bool = true

@export var pernament_wonds: Array[String] = []
@export var equipment: Array = []

@export var death_cause: String = ""
