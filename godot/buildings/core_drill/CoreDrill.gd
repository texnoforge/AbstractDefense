extends StaticBody2D


var rotation_speed = -4


func _physics_process(delta):
	self.rotate(rotation_speed * delta)
