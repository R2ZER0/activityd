import vibe.vibe;
import vibe.data.json;
import std.typecons;
import jsonld :jsonContext;
import model;
import activity;
import sampledata : generateSampleData;

void getActor(HTTPServerRequest req, HTTPServerResponse res) @safe {
    //string actorid = req.params["actorid"];
    string actorid = req.fullURL.toString;
//	res.writeJsonBody(
//      getObjectById(actorid)
//  );
    res.writeBody( getSObjectById(actorid) );
}

void getActorInbox(HTTPServerRequest req, HTTPServerResponse res) @safe {
    auto actor = getObjectById(req.params["actorid"]);
    res.writeJsonBody(
        Json([
            "@context": jsonContext(),
            "type": Json("OrderedCollection"),
            "summary": Json("Actor's Inbox"),
            "orderedItems": actor["inbox"]
        ])
    );
}

void postActorSharedInbox(HTTPServerRequest req, HTTPServerResponse res) @safe {
    auto actor = getObjectById(req.params["actorid"]);
}

void getActorOutbox(HTTPServerRequest req, HTTPServerResponse res) @safe {
    auto actor = getObjectById(req.params["actorid"]);
    res.writeJsonBody(
        Json([
            "@context": jsonContext(),
            "type": Json("OrderedCollection"),
            "summary": Json("Actor's Outbox"),
            "orderedItems": actor["outbox"]
        ])
    );
}

void getActorFollowers(HTTPServerRequest req, HTTPServerResponse res) @safe {
    auto actor = getObjectById(req.params["actorid"]);

    if(actor.has("followers")) {
        auto followers = getObjectById(actor["followers"]);
    
        res.writeJsonBody(
            Json([
                "@context": jsonContext(),
                "type": Json("OrderedCollection"),
                "summary": Json("Actor's Followers"),
                "orderedItems": followers
            ])
        );
    }
}

void getActorFollowing(HTTPServerRequest req, HTTPServerResponse res) @safe {
    auto actor = getObjectById(req.params["actorid"]);
    res.writeJsonBody(
        Json([
            "@context": jsonContext(),
            "type": Json("OrderedCollection"),
            "summary": Json("Actor's Following"),
            "orderedItems": actor["following"]
        ])
    );
}

void postActor(Json activity) @safe {
	
}

void hello(HTTPServerRequest req, HTTPServerResponse res) {
	res.writeBody("Hello, ActivityPub world!");
}

void main() {
	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "127.0.0.1"];

    generateSampleData();

	auto router = new URLRouter;
	router.get("/hello", &hello);
	router.get("/:actorid/", &getActor);
    router.get("/:actorid/inbox/", &getActorInbox);
    router.get("/:actorid/outbox/", &getActorOutbox);
    router.get("/:actorid/followers/", &getActorFollowers);
    router.get("/:actorid/following/", &getActorFollowing);

    router.post("/:actorid/sharedinbox/", &postActorSharedInbox);

	router.get("*", serveStaticFiles("public/"));

	listenHTTP(settings, router);

	logInfo("Please open http://127.0.0.1:8080/ in your browser.");
	runApplication();
}
