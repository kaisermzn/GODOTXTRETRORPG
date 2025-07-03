extends Control


@onready var response = $Background/MarginContainer/InteriorBackGround/Rows/GameInfo/ScrollContainer/HistoryRows/Response
@onready var history_rows = $Background/MarginContainer/InteriorBackGround/Rows/GameInfo/ScrollContainer/HistoryRows

var _log_text := ""

func _ready() -> void:
	GameEngine.entry_added.connect(_on_entry_added)
	GameEngine.clear_screen.connect(_clear_screen)
	var menu_text = "
	============ MENÚ PRINCIPAL ===========
	1. nueva partida – crear partida nueva
	2. salir – cerrar juego
	=======================================
	"
	GameEngine._show_menu()

func _on_input_text_submitted(new_text: String) -> void:
	GameEngine.process_input(new_text)

func _on_entry_added(input_text: String, response_text: String, initial: bool= false) -> void:
	if (initial == false):
		response.set_InputResponsetext(input_text, response_text)
	else:
		response.set_InputResponsetext(input_text, "")
	await get_tree().process_frame
	var sc := history_rows.get_parent() as ScrollContainer
#	# Llama a get_v_scroll_bar() y usa su max_value
	sc.scroll_vertical = sc.get_v_scroll_bar().max_value
	

func _clear_screen() -> void:
	response.clear_screen()
