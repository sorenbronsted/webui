part of webui;

class Repo {
	static Repo _instance;

	Map<String, Object> _objects = {};

	static Repo get instance {
		if (_instance == null) {
			_instance = new Repo();
		}
		return _instance;
	}

	void add(Object object) => _objects[object.runtimeType.toString()] = object;

	Object getByType(Type type) => _objects[type.toString()];

	Object getByName(String name) => _objects[name];

}