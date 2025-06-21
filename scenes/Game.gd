extends Control


@onready var response = $Background/MarginContainer/InteriorBackGround/Rows/GameInfo/ScrollContainer/HistoryRows/Response
@onready var history_rows = $Background/MarginContainer/InteriorBackGround/Rows/GameInfo/ScrollContainer/HistoryRows

func _ready() -> void:
	fill_input_response("Menú inicial", true)

func _on_input_text_submitted(new_text: String) -> void:	
	if new_text == "fora":
		get_tree().quit()
	else :
		fill_input_response(new_text, false) 

func fill_input_response(input_text: String, initial: bool) -> void:
	
	if initial == false:
		response.set_InputResponsetext(input_text, "Hola Mundo")
#	history_rows.add_child(input_response)
	await get_tree().process_frame
	var sc := history_rows.get_parent() as ScrollContainer
#	# Llama a get_v_scroll_bar() y usa su max_value
	sc.scroll_vertical = sc.get_v_scroll_bar().max_value
	
