module activity.object;

import std.typecons : nullable, Nullable;
import vibe.data.json;

///////////////////////////////////////////////////////////////////////////////
// Easy access
///////////////////////////////////////////////////////////////////////////////
bool isJsonNull(Json obj) @safe { return (obj.type == Json.Type.null_); }
bool isJsonObject(Json obj) @safe { return obj.type == Json.Type.object; }
bool isJsonString(Json obj) @safe { return obj.type == Json.Type.string; }
bool isJsonArray(Json obj) @safe { return obj.type == Json.Type.array; }

bool has(Json obj, string prop) @safe {
    return (obj.type == Json.Type.object && prop in obj);
}

Nullable!string objId(Json obj) @safe {
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

Nullable!string objType(Json obj) @safe {
    if("type" in obj) {
        return nullable(obj["type"].get!string);
    } else if("@type" in obj) {
        return nullable(obj["@type"].get!string);
    } else {
        return Nullable!string();
    }
}
