import vibe.vibe;
import vibe.data.json;
import jsonld :jsonContext;
import model : Actor, getActorById;

URL appendUrl(URL url, string extra) @safe {
    URL newUrl = url;
    newUrl.pathString = url.pathString ~ extra;
    return newUrl;
}

void getActor(HTTPServerRequest req, HTTPServerResponse res) @safe {
    string actorid = req.params["actorid"];
    auto actor = getActorById(actorid);
	res.writeJsonBody(
        Json([
            "@context": jsonContext(),
            "id": actor.id.serializeToJson(),
            "type": actor.type.serializeToJson(),
            "name": actor.name.serializeToJson(),
            "preferredUsername": actor.preferredUsername.serializeToJson(),
            "inbox": appendUrl(req.fullURL, "inbox/").serializeToJson(),
            "sharedInbox": appendUrl(req.fullURL, "sharedinbox/").serializeToJson(),
            "outbox": appendUrl(req.fullURL, "outbox/").serializeToJson(),
            "following": appendUrl(req.fullURL, "following/").serializeToJson(),
            "followers": appendUrl(req.fullURL, "followers/").serializeToJson()
        ])
    );
}

void getActorInbox(HTTPServerRequest req, HTTPServerResponse res) @safe {
    auto actor = getActorById(req.params["actorid"]);
    res.writeJsonBody(
        Json([
            "@context": jsonContext(),
            "type": Json("OrderedCollection"),
            "summary": Json("Actor's Inbox"),
            "orderedItems": actor.inbox.serializeToJson()
        ])
    );
}

void postActorSharedInbox(HTTPServerRequest req, HTTPServerResponse res) @safe {
    auto actor = getActorById(req.params["actorid"]);
}

void getActorOutbox(HTTPServerRequest req, HTTPServerResponse res) @safe {
    auto actor = getActorById(req.params["actorid"]);
    res.writeJsonBody(
        Json([
            "@context": jsonContext(),
            "type": Json("OrderedCollection"),
            "summary": Json("Actor's Outbox"),
            "orderedItems": actor.outbox.serializeToJson()
        ])
    );
}

void getActorFollowers(HTTPServerRequest req, HTTPServerResponse res) @safe {
    auto actor = getActorById(req.params["actorid"]);
    res.writeJsonBody(
        Json([
            "@context": jsonContext(),
            "type": Json("OrderedCollection"),
            "summary": Json("Actor's Followers"),
            "orderedItems": actor.followers.serializeToJson()
        ])
    );
}

void getActorFollowing(HTTPServerRequest req, HTTPServerResponse res) @safe {
    auto actor = getActorById(req.params["actorid"]);
    res.writeJsonBody(
        Json([
            "@context": jsonContext(),
            "type": Json("OrderedCollection"),
            "summary": Json("Actor's Following"),
            "orderedItems": actor.following.serializeToJson()
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
