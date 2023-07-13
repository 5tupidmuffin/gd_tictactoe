class_name Cell
extends ColorRect

signal cell_clicked(cell_index, cell)
# signal cell_clicked(cell_index: int, cell: Cell)


@export var cell_index: int
@onready var label: Label = $Label


func update_mark(mark: String) -> void:
    label.text = mark


func _on_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.button_index == 1:
        emit_signal("cell_clicked", cell_index, self)
