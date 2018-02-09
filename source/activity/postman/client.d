module activity.postman.client;

import std.conv;
import std.range;
import std.algorithm : sort, uniq;
import vibe.data.json;
import vibe.core.log;
import activity.object;
import vibe.db.postgresql;

class PostmanClient {
    PostgresClient pg;

    this(string pgconnstr) {
        this.pg = new PostgresClient(pgconnstr, 3);
    }

    void queueForDelivery(Json object) {
        if(object.isJsonNull) { return; }
        if(object.objId.isNull) { return; }
        
        string[] recipients = [];

        void addrs(Json r) {
            if(r.isJsonString) {
                recipients ~= r.get!string;
            } else if(r.isJsonArray) {
                foreach(rx; r) {
                    if(rx.isJsonString) {
                        recipients ~= r.get!string;
                    }
                }
            }
        }

        if(object.has("to")) { addrs(object["to"]); }
        if(object.has("cc")) { addrs(object["cc"]); }
        if(object.has("bto")) { addrs(object["bto"]); }
        if(object.has("bcc")) { addrs(object["bcc"]); }
        if(object.has("audience")) { addrs(object["audience"]); }

        this.queueForDelivery(object.objId.get, recipients); 
    }

    void queueForDelivery(string id, string[] recipients) {
        recipients.sort().uniq(); // eliminate possible duplicates // maybe FIXME?
        
        auto conn = this.pg.lockConnection();
        scope(exit) delete conn;

        foreach(recipient; recipients) {
            try {
                QueryParams p;
                p.sqlCommand = "insert into postqueue (obj_id, recipient_id) values ($1, $2)";
                p.argsFromArray = [id, recipient];
                auto result = conn.execParams(p);
                logInfo(to!string(result));

            } catch(ConnectionException e) {
                conn.resetStart();
                logWarn(e.msg);

            } catch(Exception e) {
                logWarn(e.msg);
            }
        }
    }
}
