module model;
import vibe.data.json;
import jsonld : jsonContext;

struct Actor {
	string id;
	string type = "Person";
    string name;
    string preferredUsername;
	Json[] inbox = [];
	Json[] outbox = [];
	string[] following = [];
	string[] followers = [];
}

Actor[string] actors;

static this() {
	actors = [
		"rikki": Actor("https://rikkiguy.me.uk/", "Person", "Rikki", "R2ZER0")
	];
}

public Actor getActorById(string actorId) @safe {
    return actors[actorId];
}

public size_t putInOutbox(string actorId, Json activity) @safe {
    auto outbox = actors[actorId].outbox;
	outbox ~= activity;
	return outbox.length - 1;
}

