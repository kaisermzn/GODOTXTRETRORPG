extends ICommand

func _init():
	description = "Muestra esta lista de comandos."

func execute(state:GameState.State, args:String) -> CommandResponse:
	var result := GameEngine._lista_comandos()
	var commandResponse = CommandResponse.new()
	commandResponse.State = state
	commandResponse.Response = result
	return commandResponse
