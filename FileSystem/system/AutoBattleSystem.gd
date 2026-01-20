extends Node

@export var heroes: Array = []
@export var enemies: Array = []

var action_threshold: = 100.0
var battle_action: = true
var battle_time := 0.0

func _process(delta: float) -> void:
	battle_time += delta
	if battle_time > 1.0:
		for h in heroes:
			h.morale -= 5 * delta 
	if not battle_action:
		return
	_update_units(delta)
	_check_battle_end()

func _update_units(delta: float) -> void:
	for unit in heroes + enemies:
		if not unit.is_alive:
			continue
		
		unit.action_timer += unit.speed * delta * 30.0
		
		if unit.action_timer >= action_threshold:
			_resolve_action(unit)
			unit.action_timer = 0.0

func _resolve_action(unit) -> void:
	if unit in heroes:
		_hero_action(unit)
	elif unit in enemies:
		_enemy_action(unit)

func _check_panic(hero) -> bool:
	var chance := 0
	
	if hero.morale < 40:
		chance += 30
	if hero.morale < 20:
		chance += 30
	return randf() * 100 < chance

func _hero_action(hero) -> void:
	if enemies.is_empty():
		return
	
	
	if _check_panic(hero):
		print(hero.name, " panikuje i traci kolejke! ","morale = ",hero.morale)
		return
	else:
		print("nie panikuje"," morale = ",hero.morale)
	
	var target = enemies.pick_random()
	_attack(hero, target)

func _enemy_action(enemy) ->void:
	if heroes.is_empty():
		return
	var target = heroes[0]
	for h in heroes:
		if h.hp < target.hp:
			target = h
	_attack(enemy, target)
	
func _attack(attacker, target) ->void:
	var dmg : float = attacker.attack
	
	if attacker is Character:
		if attacker.morale < 70:
			dmg *= 0.8
	
	target.hp -= int(dmg)
	print(attacker.name, " hits ", target.name, " for ", int(dmg))
	
	if target.hp <= 0:
		_kill_unit(target)
	else:
		if target is Character:
			_on_big_damage(target, dmg)

func  _kill_unit(unit) -> void:
	unit.is_alive = false
	print(unit.name, " jest martwy")
	
	if unit in heroes:
		heroes.erase(unit)
		_on_ally_death(unit)
	elif unit in enemies:
		enemies.erase(unit)

func _check_battle_end() -> void:
	if heroes.is_empty():
		battle_action = false
		print("Przegrałeś")
		
	elif enemies.is_empty():
		battle_action = false
		print("Wygrałeś")

func _on_big_damage(unit, damage):
	if damage >= unit.max_hp * 0.3:
		unit.morale -= 15

func _on_ally_death(_dead_unit):
	for h in heroes:
		h.morale -= 20
		print(h.name, " -20 morale pozostało ", h.morale)
