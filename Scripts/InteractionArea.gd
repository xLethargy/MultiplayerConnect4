extends Area3D
class_name InteractionArea

@export var action_name : String = "interact"
@export var message : String = "enter message"

var interact : Callable = func():
	pass

var interact_released : Callable = func():
	pass


func call_register_area():
	InteractionManager.register_area(self)
	if get_parent().has_method("show_label"):
		get_parent().show_label()


func call_unregister_area():
	InteractionManager.unregister_area()
	if get_parent().has_method("hide_label"):
		get_parent().hide_label()
