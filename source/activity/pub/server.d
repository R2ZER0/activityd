module activity.pub.server;

import activity.db;
import vibe.data.json;

struct ActivityServer {
    ActivityDB db;
}

struct User {
    string name;
    // TODO add some kind of auth

    static User publicUser = User("public");
}

void postInbox(ActivityServer server, string inboxId, Json data) {
    // TODO
}

auto getInbox(ActivityServer server, string inboxId, User user) {
    // TODO 
}

void postToOutbox(ActivityServer server, string outboxId, Json data) {
    // TODO
}

auto getOutbox(ActivityServer server, string outboxId, User user) {
    // TODO
}
