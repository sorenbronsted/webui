part of webui;

class DataClass {
	Map _properties = {};

	DataClass([this._properties]);

	int get uid => _properties['uid'];

	String get(String property) {
		if (property == 'uid') {
			throw "Use the uid property directly";
		}
		return _properties[property];
	}

	void set(String property, String value) {
		_properties[property] = value;
	}

	Map asMap() => _properties;
}