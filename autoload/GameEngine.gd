extends Node
signal entry_added(input_text: String, response_text: String)
signal clear_screen()

enum State {
	MAIN_MENU,
	PLAYING
}
var state = State.MAIN_MENU

func _ready() -> void:
	_show_menu()

func _show_menu() -> void:
	var menu_text = "
	============ MENÚ PRINCIPAL ===========
	1. nueva partida – crear partida nueva
	2. salir – cerrar juego
	=======================================
	"
	emit_signal("entry_added", "", menu_text)

func process_input(text: String) -> void:
	text = text.strip_edges().to_lower()
	match state:
		State.MAIN_MENU:
			_handle_menu(text)
		State.PLAYING:
			if text == "salir":
				state = State.MAIN_MENU
				_show_menu()
			else:
				_handle_game(text)

func _handle_menu(cmd: String) -> void:
	match cmd:
		"1":
			_start_new()
		#"continuar":
		#    if _has_save():
		#        _load()
		#    else:
		#        emit_signal("entry_added", cmd, "No hay partida guardada.")
		"2":
			get_tree().quit()
		#_:
		#	emit_signal("entry_added", cmd, "Opción inválida.")

func _start_new() -> void:
	# Inicializa tu mundo/jugador aquí
	state = State.PLAYING
	emit_signal("entry_added", "Nueva Partida", "")

func _handle_game(cmd: String) -> void:
	# Aquí despacharías al Parser / Game logic
	# Por ahora devolvemos un eco:
	if (cmd):
		
		if (cmd == "fora"):
			get_tree().quit()
		
		var response = "Eco: %s" % cmd
		emit_signal("entry_added", cmd, response)
