extends Control

var health_bar_panel: Panel
var health_label: Label

func _ready():
	health_bar_panel = get_node_or_null("HealthBar")
	health_label = get_node_or_null("HealthLabel")
	
	update_health_information()
	
	PlayerStatManager.connect("player_health_changed", _on_player_health_changed)

func _on_player_health_changed():
	update_health_information()

func update_health_information():
	health_bar_panel.scale.x = PlayerStatManager.health / PlayerStatManager.MAX_HEALTH
	health_label.text = str(roundf(PlayerStatManager.health))
