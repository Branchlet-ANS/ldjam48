
class_name Inventory

var contents = []

func add(item : Item):
	for i in contents:
		if i.get_id() == item.get_id():
			var add = min(item.get_count(), i.get_count_max() - i.get_count())
			i.add(add)
			item.remove(add)
			if item.get_count() == 0:
				return
	contents.add(item)
	
func remove(id : String, count : int):
	for item in contents:
		if item.get_id() == id:
			var remove = min(count, item.get_count())
			item.remove(remove)
			count -= remove
			if count == 0:
				break
	assert(count == 0)
