extends GDLlava

signal llava_visiable
signal llava_invisible

## Resume to this original mouse mode after closing the Llava UI
var _original_mouse_mode: Input.MouseMode = Input.MOUSE_MODE_CAPTURED
var image: Image = Image.new()


func _physics_process(_delta):
	if (!$InputUI.visible and Input.is_action_just_pressed("open_llm")):
		$InputUI.visible = true
		$OutputUI.visible = true
		
		## Check to see if the thread is still running
		$InputUI/GenerateButton.disabled = is_running()
		
		## Display the view as a image, which the image will be further processed by the model
		image = get_viewport().get_texture().get_image()
		var texture = ImageTexture.create_from_image(image)
		$InputUI/Screen.texture = texture
		
		_original_mouse_mode = Input.mouse_mode
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		emit_signal("llava_visiable")
		
	if($InputUI.visible and Input.is_action_just_pressed("pause")):
		$InputUI.visible = false
		$OutputUI.visible = false
		
		Input.mouse_mode = _original_mouse_mode
		
		emit_signal("llava_invisible")
	
	if (Input.is_action_just_pressed("toggle_mouse_capture")):
		if (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_generate_button_pressed():
	$OutputUI/Output.text = ""
	$InputUI/GenerateButton.disabled = true
	run_generate_text_image($InputUI/Prompt.text, image)


func _on_generate_text_finished(text):
	$InputUI/GenerateButton.disabled = false
	$OutputUI/CloseButton.disabled = false
	print("Full generated text:")
	print(text)


func _on_generate_text_updated(new_text):
	$OutputUI.visible = true
	$OutputUI/CloseButton.disabled = true
	$OutputUI/Output.text += new_text


func _on_close_button_pressed():
	$OutputUI.visible = false
