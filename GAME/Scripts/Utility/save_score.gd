extends Node
# Called when the node enters the scene tree for the first time.
var file_path = "res://GAME/Ressources/Score/savegame.save"
var scores : Array

func add_score(name: String, value: float)->void:
	var dic = {"name": name, "score": value}
	if scores.is_empty():
		scores.append(dic)
	else:
		for i in range(scores.size()):
			if comp_list(scores[i],dic)==1:
				scores.insert(i,dic)
				scores=scores.slice(0, 10)
				return
		if scores.size()<10:
			scores.append(dic)
func get_score()->Array:
	return scores

func save_score() -> void:
	var save_file = FileAccess.open(file_path, FileAccess.WRITE)
	var json_string = JSON.stringify(scores)
	save_file.store_line(json_string)
	
func load_score() -> void:
	if not FileAccess.file_exists(file_path):
		scores = []
	else :
		var save_file = FileAccess.open(file_path, FileAccess.READ)
		var json_string = save_file.get_line()
		var json = JSON.new()
		json.parse(json_string)
		if json.data == null:
			scores = []
		else:
			scores = json.data
		
func _ready() -> void:
	load_score()
	
	#func get_score_sort()-> Array:
		#var list = []
		#for key in scores.keys():
			#list.append({ "name": key, "score": scores[key] })
		#var size = list.size()
		#for i in range(size-1):
			#for j in range(i+1,size):
				#var res=comp_list(list[i],list[j])
				#if res==1:
					#var temp = list[i]
					#list[i] = list[j]
					#list[j] = temp
		#return list
	
func sort_score()->void:
	pass
func comp_list(a: Dictionary, b: Dictionary) -> int:
	if float(a["score"]) > float(b["score"]):
		return -1 # a doit être avant b
	elif float(a["score"]) < float(b["score"]):
		return 1 # b doit être avant a
	else:
		return 0 # a et b sont égaux
