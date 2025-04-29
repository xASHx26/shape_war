extends Node

var json=JSON.new()
var path="user://data.json"
var data ={}
func Write_save(contant):
	var file=FileAccess.open(path,FileAccess.WRITE)
	file.store_string(json.stringify(contant))
	file.close()
	file=null
	
func read_save():
	if FileAccess.file_exists(path):  # Check if the file exists
		var file = FileAccess.open(path, FileAccess.READ)
		if file:  # Ensure file was opened successfully
			var content = file.get_as_text()
			var parsed_data = json.parse_string(content)
			file.close()
			return parsed_data
		else:
			print("Failed to open file:", path)
	else:
		print("File does not exist:", path)
	return null  # Return null if the file couldn't be read

func create_new_save():
	var file = FileAccess.open("res://scripts/default_save.json", FileAccess.READ)
	if file: 
		var contant = json.parse_string(file.get_as_text())
		data = contant
		Write_save(contant)
		file.close()
	else:
		print("Failed to open default_save.json")

func _ready():
	if not FileAccess.file_exists(path):  # Check if save file already exists
		print("Save file not found. Creating new save...")
		create_new_save()
	else:
		print("Save file found. Loading existing save...")
		data = read_save()  # Load existing save data

	
