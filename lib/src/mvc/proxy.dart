part of webui;

abstract class Proxy extends Subject {

	String get cls => runtimeType.toString();
	String get eventReadOk => '${cls}/ReadOk';
	String get eventReadFail => '${cls}/ReadFail';

	void read(int uid);
	void setProperty(ElementValue value);
}

abstract class CrudProxy extends Proxy {
	Map<int, Map> _objects;

	CrudProxy() {
		_objects = {};
	}

	String get eventCreateOk => '${cls}/CreateOk';
	String get eventCreateFail => '${cls}/CreateFail';
	String get eventUpdateOk => '${cls}/UpdateOk';
	String get eventUpdateFail => '${cls}/UpdateFail';
	String get eventDeleteOk => '${cls}/DeleteOk';
	String get eventDeleteFail => '${cls}/DeleteFail';

	@override
	void setProperty(ElementValue element) {
		_objects[element.uid][element.property] = element.value;
	}

	void create() {
		log.fine('create');
		var uid = 0;
		_objects[uid] = {'uid':uid};
		fire(eventCreateOk, _objects[uid]);
	}

	@override
	void read(int uid) {
		log.fine('read uid:${uid}');
		if (_objects[uid] != null) {
			fire(eventReadOk, _objects[uid]);
		}
		else {
			fire(eventReadFail, '${runtimeType} not found, uid: ${uid}');
		}
	}

	void readBy() {
		log.fine('readby');
		Rest.instance.get('/rest/${runtimeType}').then((List objects) {
			_objects.clear();
			objects.forEach((Map object) {
				_objects[object['${runtimeType}']['uid']] = object['${runtimeType}'];
			});
			fire(eventReadOk, _objects.values);
		}).catchError((error) {
			fire(eventReadFail, error);
		});
	}

	void delete(int uid) {
		log.fine('delete uid:${uid}');
		Rest.instance.delete('/rest/${runtimeType}/${uid}').then((_) {
			fire(eventDeleteOk);
		}).catchError((error) {
			fire(eventDeleteFail, error);
		});
	}

	void update(int uid) {
		log.fine('update uid:${uid}');
		Rest.instance.post('/rest/${runtimeType}/${uid}', _objects[uid]).then((_) {
			fire(eventUpdateOk);
		}).catchError((error) {
			fire(eventUpdateFail, error);
		});
	}
}
