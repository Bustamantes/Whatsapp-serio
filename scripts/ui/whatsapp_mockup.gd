extends PanelContainer

# Simulates a WhatsApp chat window

@onready var scroll: ScrollContainer = $VBoxContainer/ScrollContainer
@onready var messages_container: VBoxContainer = $VBoxContainer/ScrollContainer/MessagesContainer
@onready var header_title: Label = $VBoxContainer/Header/MarginContainer/HBoxContainer/Title

var _messages: Array = []
var _current_index: int = 0

# Path to the bubble scene
var BubbleScene = preload("res://scenes/MessageBubble.tscn")

func _ready() -> void:
	# Keep the mockup hidden until it starts
	visible = false

func start_simulation(title: String, messages: Array) -> void:
	header_title.text = title
	_messages = messages
	_current_index = 0
	
	# Clear existing messages
	for child in messages_container.get_children():
		child.queue_free()
		
	visible = true
	_schedule_next_message()

func _schedule_next_message() -> void:
	if _current_index >= _messages.size():
		return # Sim finished
		
	var msg_data: Dictionary = _messages[_current_index]
	var delay: float = msg_data.get("delay", 1.5)
	
	await get_tree().create_timer(delay).timeout
	_show_message(msg_data)
	
	_current_index += 1
	_schedule_next_message()

func _show_message(msg_data: Dictionary) -> void:
	var bubble = BubbleScene.instantiate()
	messages_container.add_child(bubble)
	
	var is_me: bool = msg_data.get("sender", "other") == "me"
	var text: String = msg_data.get("text", "")
	var time: String = msg_data.get("time", "12:00 PM")
	
	bubble.setup(text, is_me, time)
	bubble.animate_in()
	
	# Scroll to bottom smoothly
	await get_tree().process_frame
	await get_tree().process_frame # Double frame for UI to update size
	_scroll_down()

func _scroll_down() -> void:
	var max_scroll = scroll.get_v_scroll_bar().max_value
	var tween = create_tween()
	tween.tween_property(scroll, "scroll_vertical", max_scroll, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
