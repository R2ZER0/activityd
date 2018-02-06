module activity.algorithm;

import std.typecons : nullable, Nullable;
import activity.object;
import activity.type;
import vibe.data.json;
import model : getObjectById;

///////////////////////////////////////////////////////////////////////////////
// Algorithms
///////////////////////////////////////////////////////////////////////////////

bool isActorAttr(string attrname, Json obj, out string actorid_) @safe {
    if(obj.objId.isNull) { return false; }
    if(!obj.has("attributedTo")) { return false; }
    
    auto actor = getObjectById(obj["attributedTo"]);
    if(!actor.isActor) { return false; }
    if(!actor.has(attrname)) { return false; }

    Nullable!string thingid = actor[attrname].objId;
    if(thingid.isNull) { return false; }
    if(thingid.get != obj.objId.get) { return false; }
    
    Nullable!string actorId = actor.objId;
    if(actorId.isNull) { return false; }

    actorid_ = actorId.get;
    return true;
}

