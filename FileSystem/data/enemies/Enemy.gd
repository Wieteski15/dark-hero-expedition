extends Resource
class_name Enemy

@export var name: String = "Enemy"

@export var max_hp: int = 80
@export var hp: int = 80

@export var attack: int = 16
@export var speed: float = 1.0

@export var behavior: String = "focus_weak"

@export var is_alive: bool = true

@export var action_timer: float = 0.0
