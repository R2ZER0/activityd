module activity;

import vibe.data.json : Json, serializeToJson;
 import vibe.inet.url : URL;
import std.typecons;
import utils : appendUrl;
import jsonld : jsonContext;

// Easy access
template InjAccessFn(string name, T) {
   mixin("
        T " ~ name ~ "(Json obj) @safe {
            return obj[\"" ~ name ~ "\"].get!T;
        }
    ");
}


string genAccessFn(string name, string type) pure @safe {
    return  "
        Nullable!"~type~" "~name~"(Json obj) @safe {
            if(\""~name~"\" in obj) {
                return obj[\""~name~"\"].get!"~type~"().nullable;
            } else {
                return Nullable!"~type~"();
            }
        }
    ";
}

string genAccessFns(string[string] params) {
    string fns = "";
    foreach(paramname; params.keys) {
        fns = fns ~ genAccessFn(paramname, params[paramname]);        
    }
    return fns;
}

template ObjectDefinition(string objtype, string[string] params) {
    //pragma(msg, "Generated: ", genAccessFns(params);
    mixin(genAccessFns(params));
}

mixin ObjectDefinition!("Actor", [
    "inbox": "string",
    "outbox": "string",
    "followers": "string",
    "following": "string"
]);

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

bool isActor(Json obj) @safe {
    if("type" in obj) {
        return isActor(obj["type"].get!string);
    } else {
        return false;
    }
}
        

// Object generation
Json generateActorObject(URL baseUrl,
                         Nullable!string name = Nullable!string(),
                         Nullable!string preferredUsername = Nullable!string()
) @safe {
    return Json([
        "@context": jsonContext(),
        "id": baseUrl.toString.serializeToJson,
        "type": "Person".serializeToJson,
        "name": name.serializeToJson(),
        "preferredUsername": preferredUsername.serializeToJson(),
        "inbox": appendUrl(baseUrl, "inbox/").serializeToJson(),
        "sharedInbox": appendUrl(baseUrl, "sharedinbox/").serializeToJson(),
        "outbox": appendUrl(baseUrl, "outbox/").serializeToJson(),
        "following": appendUrl(baseUrl, "following/").serializeToJson(),
        "followers": appendUrl(baseUrl, "followers/").serializeToJson()
    ]);
}

