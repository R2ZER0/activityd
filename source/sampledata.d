module sampledata;

import std.file;
import std.typecons;
import model : putObject;
import vibe.data.json;
import utils;
import jsonld : jsonContext;

Json genActor(string baseUrl,
                         Nullable!string name = Nullable!string(),
                         Nullable!string preferredUsername = Nullable!string()
) @safe {
    return Json([
        "@context": jsonContext(),
        "id": baseUrl.serializeToJson,
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

void generateSampleData() @safe {
    putObject( genActor("http://localhost:8080/actor/", nullable("Test Person")) );
}

void loadSampleData(string filepath) {
    string content = readText(filepath);
    Json sampleObjects = parseJson(content);
    foreach(Json obj; sampleObjects) {
        putObject( obj );
    }
}

