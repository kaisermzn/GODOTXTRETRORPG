class_name HolaMundo extends ICommand

func execute(state:GameState.State, args:String) -> CommandResponse:
	var result := "Hola mundo"+ "\n"
	var commandResponse = CommandResponse.new()
	commandResponse.State = state
	commandResponse.Response = result
	return commandResponse
