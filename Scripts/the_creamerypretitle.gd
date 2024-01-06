extends Control

func _on_animated_sprite_2d_animation_finished():
	get_tree().change_scene_to_file("res://TitleScreen/title_screen.tscn")
