module activity.type;

import std.typecons : nullable, Nullable;
import vibe.data.json;
import activity.object;

///////////////////////////////////////////////////////////////////////////////
// Type Checking
///////////////////////////////////////////////////////////////////////////////

bool isa(string typec, string type) pure @safe {
    if(typec == "Object") {
        return (type != "Link");

    } else if(typec == "Actor") {
        return (
            type == "Application" ||
            type == "Group" ||
            type == "Organisation" ||
            type == "Person" ||
            type == "Service"
        );

    } else if(typec == "Collection") {
        return (
            type == "Collection" ||
            type == "OrderedCollection"
        );    

    } else {
        return (typec == type);
    }
}

bool isa(string typec, Json obj) @safe {
    if(obj.isJsonObject) {
        return isa(typec, obj.objType);
    }
    return false;
}

bool isa(T)(string typec, Nullable!T type) @safe {
    if(type.isNull) {
        return false;
    } else {
        return isa(typec, type.get);
    }
}

bool isObject(T)(T x) @safe { return isa("Object", x); }
bool isLink(T)(T x) @safe { return isa("Link", x); }
bool isObjectOrLink(T)(T x) @safe { return isObject(x) || isLink(x); }
bool isActor(T)(T x) @safe { return isa("Actor", x); }
bool isCollection(T)(T x) @safe { return isa("Collection", x); }

