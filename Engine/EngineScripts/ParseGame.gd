class_name ParseGame
extends Object

func parse(input: String) -> Dictionary:
	var result = {
		"verb": "",
		"args": ""
	}

	var words = input.strip_edges().to_lower().split(" ", false)
	if words.size() == 0:
		return result
	
	result["verb"] = words[0]
	result["args"] = input.substr(result["verb"].length()).strip_edges()

	return result
