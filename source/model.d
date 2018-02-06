module model;

import vibe.data.json;
import std.typecons;
import activity;

Json[string] objectCache;


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

    } else if(obj.type == Json.Type.object) {
        objId = obj.objId;

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
    auto objId = obj.objId;

    if(objId.isNull) {
        return false;
    } else {
        objectCache[objId.get] = obj;
        return true;
    }
}
