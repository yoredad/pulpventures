extends Node

## Global message bus. Register objects that implement
## notify(topic: String, message: String), then broadcast messages to every
## object registered for a topic.

var _listeners: Dictionary = {}


func register(topic: String, reference: Object) -> void:
	if not is_instance_valid(reference):
		push_warning("MessageBus: cannot register an invalid reference for topic '%s'." % topic)
		return
	if not _implements_notify(reference):
		push_warning("MessageBus: %s does not implement notify(topic: String, message: String); not registered for '%s'." % [reference, topic])
		return
	if not _listeners.has(topic):
		_listeners[topic] = []
	var references: Array = _listeners[topic]
	if not references.has(reference):
		references.append(reference)


func unregister(topic: String, reference: Object) -> void:
	if not _listeners.has(topic):
		return
	var references: Array = _listeners[topic]
	var idx := references.find(reference)
	if idx != -1:
		references.remove_at(idx)
	if references.is_empty():
		_listeners.erase(topic)


func notify(topic: String, message: String) -> void:
	if not _listeners.has(topic):
		return
	var references: Array = _listeners[topic]
	# Iterate over a copy, but check validity of each listener
	var i = 0
	while i < references.size():
		var listener: Object = references[i]
		if is_instance_valid(listener):
			listener.call("notify", topic, message)
			i += 1
		else:
			references.remove_at(i)
	if references.is_empty():
		_listeners.erase(topic)


func _implements_notify(reference: Object) -> bool:
	if not reference.has_method("notify"):
		return false
	for info: Dictionary in reference.get_method_list():
		if info.get("name") != "notify":
			continue
		var args: Array = info.get("args", [])
		if args.size() != 2:
			return false
		for arg: Dictionary in args:
			var arg_type: int = arg.get("type", TYPE_NIL)
			if arg_type != TYPE_STRING and arg_type != TYPE_NIL:
				return false
		return true
	return false
