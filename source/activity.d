module activity;

import vibe.data.json : Json, serializeToJson;
 import vibe.inet.url : URL;
import std.typecons;
import utils : appendUrl;
import jsonld : jsonContext;

// Easy access
bool has(Json obj, string prop) @safe {
    return (obj.type == Json.Type.object && prop in obj);
}

// Type checking
bool isActor(string type) pure @safe {
    return (
        type == "Application" ||
        type == "Group" ||
        type == "Organisation" ||
        type == "Person" ||
        type == "Service"
    );
}

bool isCollection(string type) pure @safe {
    return (
        type == "Collection",
        type == "OrderedCollection"
    );
}

bool isActor(Json obj) @safe {
    if("type" in obj) {
        return isActor(obj["type"].get!string);
    } else {
        return false;
    }
}
