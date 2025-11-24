class_name Echo extends ICommand

func execute(state:GameState.State, args:String) -> CommandResponse:
	var result := args + "\n"
	var commandResponse = CommandResponse.new()
	commandResponse.State = state
	commandResponse.Response = result
	return commandResponse
