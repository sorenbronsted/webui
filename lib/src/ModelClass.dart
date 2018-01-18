part of webui;

class ModelEvent {
	static const String CreateOk = 'CreateOk';
	static const String CreateFail = 'CreateFail';
	static const String ReadOk = 'ReadOk';
	static const String ReadFail = 'ReadFail';
	static const String UpdateOk = 'UpdateOk';
	static const String UpdateFail = 'UpdateFail';
	static const String DeleteOk = 'DeleteOk';
	static const String DeleteFail ='DeleteFail';

	static List allEvents = [CreateOk, CreateFail, ReadOk, ReadFail, UpdateOk, UpdateFail, DeleteOk, DeleteFail];
}

class ModelClass extends mvc.Proxy {

	ModelClass(String name) : super(name, {});

	void setProperty(String uid, String name, String value) => data[uid][name] = value;

	void create() {
		data['0'] = {'uid':0};
		sendNotification(ModelEvent.CreateOk, data['0']);
	}

	void read(String uid) {
		Map values = data[uid];
		if (values == null) {
			values = {};
		}
		sendNotification(ModelEvent.ReadOk, values);
	}

	void readBy(Map qbe) {
		var params = Rest.instance.encodeMap(qbe);
		data = {};
		Rest.instance.get('/rest/${name}?${params}').then((List rows) {
			rows.forEach((Map row) {
				data['${row[name]['uid']}'] = row[name];
			});
			sendNotification(ModelEvent.ReadOk, (data as Map).values);
		}).catchError((String error) {
			sendNotification(ModelEvent.ReadFail, error);
		});
	}

	void update(String uid) {
		Rest.instance.post('/rest/${name}', data[uid]).then((Map result) {
			sendNotification(ModelEvent.UpdateOk, data[uid]);
		}).catchError((String error) {
			sendNotification(ModelEvent.UpdateFail, error);
		});
	}

	void delete(String uid) {
		Rest.instance.delete('/rest/${name}/${uid}').then((_) {
			(data as Map).remove(uid);
			sendNotification(ModelEvent.DeleteOk, (data as Map).values);
		}).catchError((String error) {
			sendNotification(ModelEvent.DeleteFail, error);
		});
	}
}

