extends Control

@onready var output_label: RichTextLabel = $VBoxContainer/Output
@onready var input_edit: LineEdit = $VBoxContainer/Input

func _ready() -> void:
    input_edit.text_submitted.connect(_on_input_submitted)
    input_edit.grab_focus()

func _on_input_submitted(text: String) -> void:
    input_edit.text = ""
    match text.strip_edges().to_lower():
        "hola":
            output_label.add_text("hola mundo\n")
        "fuera":
            get_tree().quit()
        _:
            output_label.add_text("No conozco ese comando\n")
    output_label.scroll_to_line(output_label.get_line_count() - 1)
