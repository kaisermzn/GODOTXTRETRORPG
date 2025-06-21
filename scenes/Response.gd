extends RichTextLabel
func set_InputResponsetext(input_text: String, response_text: String) -> void:	
	self.bbcode_enabled = false
		
	self.append_text("\n[b] > " + input_text + "[/b]")
	
	if (response_text):		
		self.append_text("\n    " +response_text)
	else:		
		self.append_text("No se reconoce el comando")
