extends Node

# Emitted when the player's health changes
signal player_health_changed

# Emitted when the player presses the input for toggling the parasol
signal player_toggle_parasol(state: bool)

# Emitted when the parasol is finished either opening or closing
signal player_parasol_state_changed

const MAX_HEALTH: float = 100
const SUNLIGHT_DAMAGE_PER_SECOND: float = 10
const PASSIVE_HEALING_PER_SECOND: float = 5

var health: float

# Used to determine the animation state of the parasol
var parasol_opening: bool = false

# The current open or closed state of the parasol, used for direct sunlight checks
var parasol_open: bool = false

func _ready():
	self.connect("player_parasol_state_changed", _on_player_parasol_state_changed)
	health = MAX_HEALTH

func _process(delta):
	if DirectSunlightManager.is_processing():
		if DirectSunlightManager.player_in_sunlight and not parasol_open:
			health = clampf(health - (SUNLIGHT_DAMAGE_PER_SECOND * delta), 0.0, MAX_HEALTH)
			emit_signal("player_health_changed")
		elif health < MAX_HEALTH:
			health = clampf(health + (PASSIVE_HEALING_PER_SECOND * delta), 0.0, MAX_HEALTH)
			emit_signal("player_health_changed")
	
	if Input.is_action_just_pressed("toggle_parasol"):
		parasol_opening = not parasol_opening
		emit_signal("player_toggle_parasol", parasol_opening)

func _on_player_parasol_state_changed():
	parasol_open = parasol_opening
