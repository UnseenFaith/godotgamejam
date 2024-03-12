extends Control

enum Towers {
	NONE,
	BASIC,
	SLOW
}

signal tower_selected(tower: Towers)


func _ready() -> void:
	GuiTransitions.show("ShopClosed")

func _on_button_pressed() -> void:
	GuiTransitions.hide("ShopOpened")
	GuiTransitions.show("ShopClosed")

func _on_open_button_pressed() -> void:
	GuiTransitions.hide("ShopClosed")
	GuiTransitions.show("ShopOpened")


func _on_basic_tower_pressed() -> void:
	GuiTransitions.hide("ShopOpened")
	GuiTransitions.show("ShopClosed")
	emit_signal("tower_selected", Towers.BASIC) # Replace with function body.
