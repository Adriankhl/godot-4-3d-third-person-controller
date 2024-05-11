extends GDLlava

signal llava_visiable
signal llava_invisible

var _original_mouse_mode: Input.MouseMode = Input.MOUSE_MODE_CAPTURED

func _physics_process(_delta):
	if (!$LlavaUI.visible and Input.is_action_just_pressed("open_llm")):
		$LlavaUI.visible = true
		_original_mouse_mode = Input.mouse_mode
		emit_signal("llava_visiable")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if($LlavaUI.visible and Input.is_action_just_pressed("pause")):
		$LlavaUI.visible = false
		emit_signal("llava_invisible")
		Input.mouse_mode = _original_mouse_mode
