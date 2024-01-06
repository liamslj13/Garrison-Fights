extends Node2D

func _on_back_2_thelobby_timeout():
	get_tree().change_scene_to_file("res://TitleScreen/title_screen.tscn")
