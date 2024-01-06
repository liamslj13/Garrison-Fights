extends Node2D


func _on_wait_timeout():
	$AnimatedSprite2D.play("default")
	$WaitAgain.start()
	
func _on_wait_again_timeout():
	get_tree().change_scene_to_file("res://gameover.tscn")
