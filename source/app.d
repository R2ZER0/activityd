import vibe.vibe;
import vibe.data.json;
import std.typecons;
import std.process : environment;
import jsonld :jsonContext;
import model;
import activity;
import activity.db : ActivityDB;
import sampledata : loadSampleData;
import activity.postman.client;
import activity.pub.server;

ActivityDB adb;

void getObject(HTTPServerRequest req, HTTPServerResponse res) @safe {
    string objid = req.fullURL.toString;
    if(adb.has(objid)) {
        Json obj = adb.get(objid);
        res.writeJsonBody(obj);

    } else {
        res.statusCode = 404;
    }
}

void postObject(HTTPServerRequest req, HTTPServerResponse res) @safe {
    string objid = req.fullURL.toString;
    Json obj = getObjectById(objid);
    
    // is this a real object?
    if(!obj.isObject) {
        res.statusCode = 404;
        return;
    }

    // Can we post to this object?
    string actorid;
    if(isActorAttr("inbox", obj, actorid)) { 
        // Attempted post to inbox for actor actorid
        // TODO
    }

    if(isActorAttr("outbox", obj, actorid)) { 
        // Attempted post to outbox for actor actorid
        // TODO
    }

    // Otherwise...
    res.statusCode = 405;
}

void hello(HTTPServerRequest req, HTTPServerResponse res) {
	res.writeBody("Hello, ActivityPub world!");
    auto client = new PostmanClient(environment["POSTMAN_POSTQUEUE"]);
    client.queueForDelivery(
        Json([
            "id": Json("http://localhost:8080/test"),
            "type": Json("Create"),
            "object": Json([
                "type": Json("Note"),
                "content": Json("Hi!")
            ]),
            "to": Json([Json("http://localhost:8080/actor/")]),
            "cc": Json("http://localhost:8080/actor2/")
        ])
    );
}

void main() {
    adb = new ActivityDB();

    logInfo("Loading data.json");
    loadSampleData("data.json", adb);
    logInfo("Loaded " ~ adb.objects.length.to!string ~ " objects");

	auto router = new URLRouter;
	router.get("/hello", &hello);

	router.get("*", &getObject);
    router.post("*", &postObject);

	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "0.0.0.0"];
    listenHTTP(settings, router);

	logInfo("Ready");
	runApplication();
}
