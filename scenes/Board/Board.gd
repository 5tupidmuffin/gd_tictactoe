class_name Board
extends Node2D

@onready var cells: Array[Cell] = get_cells()

signal display_message(message: String)

const WINNING_COMBINATIONS = [
    # horizontal lines
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    # vertical lines
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    # cross lines
    [0, 4, 8],
    [2, 4, 6],
]
const PLAYERMARK = {
    "X": "X",
    "O": "O",
}
const GREEN_COLOR = Color(.4, .97, .57, 1)

var logical_board: Array[String] = [
    '', '', '',
    '', '', '',
    '', '', '',
]
var move_count = 0
var current_player = PLAYERMARK.X
var is_winner_found = false


func get_cells() -> Array[Cell]:
    var child_count = get_child_count()
    var cells: Array[Cell] = []
    for idx in child_count:
        var node = get_child(idx)
        if node is Cell:
            cells.append(node)
    return cells

# Called when the node enters the scene tree for the first time.
func _ready():
    for cell in cells:
        cell.connect("cell_clicked", on_cell_clicked)


func change_player() -> void:
    if current_player == PLAYERMARK.X:
        current_player = PLAYERMARK.O
    else:
        current_player = PLAYERMARK.X


func color_winning_combo(combo: Array) -> void:
    for cell_idx in combo:
        var cell: Cell = cells[cell_idx]
        cell.label.label_settings.font_color = Color(0.4, 0.97, 0.57, 1)
        

func check_for_winner() -> void:
    for comb in WINNING_COMBINATIONS:
        if (
            logical_board[comb[0]] == logical_board[comb[1]] and
            logical_board[comb[1]] == logical_board[comb[2]] and
            logical_board[comb[0]] != ""
        ):
            is_winner_found = true
            color_winning_combo(comb)
            var winner_message = "%s is the winner!" % logical_board[comb[0]]
            emit_signal("display_message", winner_message)


func on_cell_clicked(cell_index: int, cell: Cell) -> void:
    if cell.label.text in PLAYERMARK.values() or is_winner_found:
        return
    # update boards
    logical_board[cell_index] = current_player
    cell.update_mark(current_player)
    move_count += 1
    if move_count >= 5:
        check_for_winner()
    if move_count >= 9 and not is_winner_found:
        emit_signal("display_message", "it's a draw")
    change_player()
    
