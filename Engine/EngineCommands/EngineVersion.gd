class_name EngineVersion extends ICommand

func execute(state:GameState.State, args:String) -> CommandResponse:
	var result := GameEngine._engine_version() + "\n"
	var commandResponse = CommandResponse.new()
	commandResponse.State = state
	commandResponse.Response = result
	return commandResponse
