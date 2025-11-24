class_name ICommandMainMenu extends Node

func executeCommand(state:GameState.State, args:Array) -> CommandResponse:
	var commandResponse = CommandResponse.new()
	commandResponse.Response = ""
	var cmd = args.get(0)
	match cmd:
		"1":
			GameEngine._clear_screen()
			GameEngine._start_new()
			commandResponse.State = GameState.State.CREATE_GAME
		
		"2":
			GameEngine._clear_screen()
			GameEngine._start_load()
			commandResponse.State = GameState.State.LOAD_GAME
		"3":
			GameEngine.get_tree().quit()
	return commandResponse
