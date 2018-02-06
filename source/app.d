import vibe.vibe;
import vibe.data.json;
import std.typecons;
import jsonld :jsonContext;
import model;
import activity;
import sampledata : loadSampleData;

void getObject(HTTPServerRequest req, HTTPServerResponse res) @safe {
    string objid = req.fullURL.toString;
    Json obj = getObjectById(objid);

    if(obj.type == Json.Type.object) {
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
}

void main() {
	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "127.0.0.1"];

    logInfo("Loading data.json");
    loadSampleData("data.json");
    logInfo("Loaded " ~ objectCache.length.to!string ~ " objects");

	auto router = new URLRouter;
	router.get("/hello", &hello);

	router.get("*", &getObject);
    router.post("*", &postObject);

	listenHTTP(settings, router);

	logInfo("Ready");
	runApplication();
}
