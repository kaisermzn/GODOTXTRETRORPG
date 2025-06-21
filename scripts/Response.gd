extends RichTextLabel
func set_InputResponsetext(input_text: String, response_text: String) -> void:	
	self.bbcode_enabled = false
	self.newline()
	self.append_text("[b] > " + input_text + "[/b]")
	
	if (response_text):			 	
		self.newline()
		self.push_indent(1)
		self.append_text(response_text)
		self.pop()
