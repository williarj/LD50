extends Node
class_name hectic

var hectic_level : int = 0
var panic_speed_mult : float = 1.0
var perm_speed_mult : float = 1.0

func total_speed_mult() -> float:
	return panic_speed_mult * perm_speed_mult
