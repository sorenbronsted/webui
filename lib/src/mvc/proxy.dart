part of webui;

class Proxy extends Subject {

	Map<int, DataClass> _objects;

	Proxy() {
		_objects = {};
	}

	String get cls => runtimeType.toString();
	String get eventCreateOk => '${cls}/CreateOk';
	String get eventCreateFail => '${cls}/CreateFail';
	String get eventReadOk => '${cls}/ReadOk';
	String get eventReadFail => '${cls}/ReadFail';
	String get eventUpdateOk => '${cls}/UpdateOk';
	String get eventUpdateFail => '${cls}/UpdateFail';
	String get eventDeleteOk => '${cls}/DeleteOk';
	String get eventDeleteFail => '${cls}/DeleteFail';

	void addData(DataClass data) => _objects[data.uid] = data;

	void addDataList(List<Map> rows) {
		_objects.clear();
		rows.forEach((Map object) {
			addData(new DataClass(object['${cls}']));
		});
	}

	void removeData(int uid) => _objects.remove(uid);

	DataClass getData(int uid) => _objects[uid];

	Iterable<DataClass> getDataList() => _objects.values;

	void setProperty(ElementValue element) {
		_objects[element.uid].set(element.property, element.value);
	}

	void create() {
		log.fine('create');
		var data = new DataClass({'uid':0});
		_objects[data.uid] = data;
		fire(eventCreateOk, _objects[data.uid]);
	}

	void read([int uid]) {
		log.fine('read uid:${uid}');
		if (uid != null) {
			if (_objects[uid] != null) {
				fire(eventReadOk, getData(uid));
			}
			else {
				fire(eventReadFail, '${runtimeType} not found, uid: ${uid}');
			}
		}
		else {
			String params = getReadByParameters();
			log.fine('read: params: ${params}');
			Rest.instance.get('/rest/${cls}${params}').then((List rows) {
				addDataList(rows);
				fire(eventReadOk, getDataList());
			}).catchError((error) {
				fire(eventReadFail, error);
			});
		}
	}

	void delete(int uid) {
		log.fine('delete uid:${uid}');
		Rest.instance.delete('/rest/${cls}/${uid}').then((_) {
			fire(eventDeleteOk);
		}).catchError((error) {
			fire(eventDeleteFail, error);
		});
	}

	void update(int uid) {
		log.fine('update uid:${uid}');
		Rest.instance.post('/rest/${cls}/${uid}', _objects[uid].asMap()).then((_) {
			fire(eventUpdateOk);
		}).catchError((error) {
			fire(eventUpdateFail, error);
		});
	}

  String getReadByParameters() => '';
}
