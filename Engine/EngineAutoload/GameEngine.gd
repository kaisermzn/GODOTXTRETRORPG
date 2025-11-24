extends Node

signal entry_added(input_text: String, response_text: String)
signal clear_screen()


var engineVersion = "20251124000"
var state:GameState.State = GameState.State.MAIN_SCREEN
var main_menu_commands : Dictionary = {}
var game_commands      : Dictionary = {}


func _ready() -> void:	
	_auto_register_commands("res://Engine/EngineCommands")
	_auto_register_commands("res://Game/GameCommands")

func _engine_version() -> String:
	return engineVersion
	
func _lista_comandos() -> String:
	var lista_comandos : String = "Comandos disponibles:\n"
	var keys = game_commands.keys()
	keys.sort()  # opcional, para orden
	
	for cmd in keys:
		var command_obj = game_commands[cmd]
		var desc = ""
		if command_obj.description != "":
			desc = " - " + command_obj.description
		lista_comandos += "• %s%s\n" % [cmd, desc]
	
	lista_comandos += "• salir\n"
	
	return lista_comandos

func _show_menu() -> void:
	var menu_text = "
	============ MENÚ PRINCIPAL ===========
	1. nueva partida – crear partida nueva
	2. cargar partida – cargar partida existente
	3. salir – cerrar juego
	=======================================
	"
	emit_signal("entry_added", "", menu_text)

func _show_start_screen() -> void:
	var start_screen_text = "Escriba cualquier texto."
	emit_signal("entry_added", "", start_screen_text)
	

func _clear_screen() -> void:
	emit_signal("clear_screen")

func process_input(text: String) -> void:

	match state:
		GameState.State.MAIN_SCREEN:
			_clear_screen()
			state = GameState.State.MAIN_MENU
			_show_menu()
		GameState.State.MAIN_MENU:			
			_handle_menu(text)			
		GameState.State.PLAYING:
			match text:
				"salir", "exit:", "fora":
					state = GameState.State.MAIN_MENU
					_clear_screen()
					_show_menu()
				_:				
					_handle_game(text)
		GameState.State.CREATE_GAME:
			_handle_create_game(text)
		GameState.State.LOAD_GAME:
			_handle_load_game(text)
		

func _handle_menu(cmd: String) -> void:
	cmd = cmd.strip_edges().to_lower()	
	var iCommandMainMenu = ICommandMainMenu.new()
	var args = [cmd]
	var commandResponse = iCommandMainMenu.executeCommand(state,args)
	state = commandResponse.State
	
func _start_new() -> void:
	# Inicializa tu mundo/jugador aquí
	state = GameState.State.CREATE_GAME
	var msg = "Nueva Partida\n"
	var files = _get_save_files()
	if not files.is_empty():
		msg += "Partidas existentes:\n"
		for i in range(files.size()):
			var f = files[i]
			var display_name = f.replace("save_", "").replace(".json", "")
			msg += "%d. %s\n" % [i + 1, display_name]
		msg += "Escribe un nombre para crear/sobreescribir, 'borrar <nº>' para eliminar, o 'salir'.\n"
	else:
		msg += "Insertar nombre de la Nueva Partida o 'salir' para volver.\n"
	
	emit_signal("entry_added", "", msg)
	

func _start_load() -> void:
	state = GameState.State.LOAD_GAME
	emit_signal("entry_added", "Cargar Partida"+ "\n", "")
	var files = _get_save_files()
	if files.is_empty():
		emit_signal("entry_added", "", "No hay partidas guardadas.")
		# Volver al menú principal o quedarse ahí? 
		# Por simplicidad, nos quedamos esperando, pero el usuario podría escribir "salir" si implementamos esa lógica global
		# O forzamos volver al menú:
		state = GameState.State.MAIN_MENU
		_show_menu()
	else:
		var msg = "Partidas disponibles:\n"
		msg += "0. Salir\n"
		for i in range(files.size()):
			var f = files[i]
			var display_name = f.replace("save_", "").replace(".json", "")
			msg += "%d. %s\n" % [i + 1, display_name]
		msg += "Escribe el número o el nombre de la partida a cargar, 'borrar <nº>' para eliminar, o 'salir'."
		emit_signal("entry_added", "", msg)

func _get_save_files() -> Array:
	var files = []
	var dir = DirAccess.open("user://")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.begins_with("save_") and file_name.ends_with(".json"):
				files.append(file_name)
			file_name = dir.get_next()
	files.sort()
	return files

func _handle_game(cmd: String) -> void:
	# Aquí despacharías al Parser / Game logic
	# Por ahora devolvemos un eco:
	if (cmd):
		
		if (cmd == "fora"):
			owner.get_tree().quit()
			
		var parseGame 			= ParseGame.new()
		var commandDictionary 	= parseGame.parse(cmd)
		var verb = commandDictionary["verb"]
		var args = commandDictionary["args"]
		
		if verb == "salir" or verb == "exit":
			state = GameState.State.MAIN_MENU
			_clear_screen()
			_show_menu()
			return

		if not game_commands.has(verb):
			var msg = "No existe el comando '%s'." % verb + "\n"
			emit_signal("entry_added", cmd.strip_edges().to_upper(), msg)
			return

		var command = game_commands[verb]
		var response = command.execute(state, args)
		var msg = response.Response
		emit_signal("entry_added", cmd, msg)

func _handle_create_game(player_name: String) -> void:
	player_name = player_name.strip_edges()
	
	if player_name == "0" or player_name.to_lower() == "salir" or player_name.to_lower() == "exit":
		state = GameState.State.MAIN_MENU
		_clear_screen()
		_show_menu()
		return

	if player_name.is_empty():
		emit_signal("entry_added", "", "El nombre no puede estar vacío.")
		return

	# Logic for delete
	if player_name.begins_with("borrar ") or player_name.begins_with("delete "):
		var parts = player_name.split(" ", false, 1)
		if parts.size() > 1:
			var target = parts[1]
			var filename_to_delete = ""
			var files = _get_save_files()
			
			if target.is_valid_int():
				var idx = target.to_int()
				if idx > 0 and idx <= files.size():
					filename_to_delete = files[idx - 1]
			else:
				var potential = "save_" + target + ".json"
				if files.has(potential):
					filename_to_delete = potential
			
			if filename_to_delete != "":
				var dir = DirAccess.open("user://")
				dir.remove(filename_to_delete)
				emit_signal("entry_added", "", "Partida eliminada: " + filename_to_delete.replace("save_", "").replace(".json", ""))
				# Refresh list
				_start_new() 
				return
			else:
				emit_signal("entry_added", "", "No se encontró la partida a borrar: " + target)
				return

	_create_save_file(player_name)
	state = GameState.State.PLAYING
	_clear_screen()
	emit_signal("entry_added", player_name, "Partida creada con éxito. ¡Bienvenido, " + player_name + "!")

func _create_save_file(player_name: String) -> void:
	var save_data = {
		"player_name": player_name,
		"created_at": Time.get_datetime_string_from_system()
	}
	var file = FileAccess.open("user://save_" + player_name + ".json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
	else:
		emit_signal("entry_added", "", "Error al crear el archivo de guardado.")

func _handle_load_game(input_text: String) -> void:
	input_text = input_text.strip_edges()
	
	if input_text == "0" or input_text.to_lower() == "salir" or input_text.to_lower() == "exit":
		state = GameState.State.MAIN_MENU
		_clear_screen()
		_show_menu()
		return

	# Logic for delete
	if input_text.begins_with("borrar ") or input_text.begins_with("delete "):
		var parts = input_text.split(" ", false, 1)
		if parts.size() > 1:
			var target = parts[1]
			var filename_to_delete = ""
			var files = _get_save_files()
			
			if target.is_valid_int():
				var idx = target.to_int()
				if idx > 0 and idx <= files.size():
					filename_to_delete = files[idx - 1]
			else:
				var potential = "save_" + target + ".json"
				if files.has(potential):
					filename_to_delete = potential
			
			if filename_to_delete != "":
				var dir = DirAccess.open("user://")
				dir.remove(filename_to_delete)
				emit_signal("entry_added", "", "Partida eliminada: " + filename_to_delete.replace("save_", "").replace(".json", ""))
				# Refresh list
				_start_load() 
				return
			else:
				emit_signal("entry_added", "", "No se encontró la partida a borrar: " + target)
				return

	var files = _get_save_files()
	var filename = ""

	# Intentar por número
	if input_text.is_valid_int():
		var idx = input_text.to_int()
		if idx > 0 and idx <= files.size():
			filename = files[idx - 1]

	# Intentar por nombre si no se encontró por número
	if filename == "":
		var potential_filename = "save_" + input_text + ".json"
		if files.has(potential_filename):
			filename = potential_filename

	if filename != "" and FileAccess.file_exists("user://" + filename):
		_load_save_file(filename)
		state = GameState.State.PLAYING
		_clear_screen()
		var loaded_name = filename.replace("save_", "").replace(".json", "")
		emit_signal("entry_added", input_text, "Partida cargada. ¡Bienvenido de nuevo, " + loaded_name + "!")
	else:
		emit_signal("entry_added", input_text, "No se encontró la partida: " + input_text)

func _load_save_file(filename: String) -> void:
	var file = FileAccess.open("user://" + filename, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var data = JSON.parse_string(content)
		# Aquí cargarías el estado del juego desde 'data'
		# Por ahora solo mostramos que se cargó
		pass

func _auto_register_commands(path:String) -> void:
	var dir = DirAccess.open(path)
	if dir:
		var skip_navigational = true
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				# Subcarpeta: baja recursivamente
				_auto_register_commands("%s/%s" % [path, file_name])
			elif file_name.ends_with(".gd"):
				var script_path = "%s/%s" % [path, file_name]
				var scr = load(script_path)
				if scr:
					var inst = scr.new()
					# Comandos de menú
					if inst is ICommandMainMenu:
						var name = file_name.replace("Command.gd","").to_lower()
						main_menu_commands[name] = inst
					# Comandos de juego
					elif inst is ICommand:
						var name = file_name.trim_suffix(".gd").to_lower()
						game_commands[name] = inst
			file_name = dir.get_next()
		dir.list_dir_end()
