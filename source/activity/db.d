module activity.db;

import activity.object : objId;
import vibe.data.json;

class ActivityDB {
    @safe:

    Json[string] objects;

    bool has(string id) {
        return ((id in this.objects) !is null);
    }

    Json get(string id) {
        return this.objects[id];
    }

    void put(string id, Json json) {
        this.objects[id] = json;
    }

    void put(Json json) {
        auto id = json.objId; 
        if(id.isNull) { return; }
        this.put(id.get, json);
    }
}
