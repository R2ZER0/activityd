module model;

import vibe.data.json;
import std.typecons;
import activity;

Json[string] objectCache;

Nullable!string getObjectId(Json obj) @safe {
    if(obj.type == Json.Type.string) {
        return nullable(obj.get!string);

    } else if(obj.type == Json.Type.object) {

        if("id" in obj) {
            return nullable(obj["id"].get!string);
        } else if("@id" in obj) {
            return nullable(obj["@id"].get!string);
        } else {
            return Nullable!string();
        }

    } else {
        return Nullable!string();
    }
}

Nullable!string getObjectType(Json obj) @safe {
    if("type" in obj) {
        return nullable(obj["type"].get!string);
    } else if("@type" in obj) {
        return nullable(obj["@type"].get!string);
    } else {
        return Nullable!string();
    }
}

Json getObjectById(string id) @safe {
    if(id in objectCache) {
        return objectCache[id];
    } else {
        return Json(null);
    }
}

Json getObjectById(Json obj) @safe {
    Nullable!string objId;

    if(obj.type == Json.Type.null_) {
        return Json(null);

    if(obj.type == Json.Type.object) {
        objId = getObjectId(obj);

    } else if(obj.type == Json.Type.string) {
        objId = nullable(obj.get!string);
    }

    if(!objId.isNull) {
        return getObjectById(objId.get);
    } else {
        return Json(null);
    }    
}

bool putObject(Json obj) @safe {
    auto objId = getObjectId(obj);

    if(objId.isNull) {
        return false;
    } else {
        objectCache[objId.get] = obj;
        return true;
    }
}
