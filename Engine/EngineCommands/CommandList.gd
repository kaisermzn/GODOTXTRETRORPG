class_name CommandList extends ICommand

func execute(state:GameState.State, args:String) -> CommandResponse:
	var result := GameEngine._lista_comandos()
	var commandResponse = CommandResponse.new()
	commandResponse.State = state
	commandResponse.Response = result
	return commandResponse
