
class_name Inventory

var items : Array = []

func add(item : Item) -> void:
	for i in items:
		if i.get_id() == item.get_id():
			var add = min(item.get_count(), i.get_count_max() - i.get_count())
			i.add(add)
			item.remove(add)
			if item.get_count() == 0:
				return
	items.append(item)
	
func remove(id : String, count : int) -> Item:
	for item in items:
		if item.get_id() == id:
			var remove = min(count, item.get_count())
			item.remove(remove)
			count -= remove
			if count == 0:
				break
	assert(count == 0)
	return Item.new(id, count)

func to_string() -> String:
	var string : String = "{Inventory["
	for item in items:
		string += item.to_string() + ", "
	return string.rstrip(", ") + "]}"
