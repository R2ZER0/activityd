module model;

import vibe.data.json;
import activity;

Json[string] objectCache;

Json getObjectById(string id) @safe {
    return objectCache[id];
}

bool putObject(Json obj) @safe {
    objectCache[obj.id.get] = obj;
    return true;
}
