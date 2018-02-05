module activity;
import std.typecons : Nullable;

alias asdatetime = string;

union ASObjectOrLink {
    ASObject object;
    ASLink link;
}

struct ASObject {
    Nullable!string         id;
    Nullable!string         type;
    Nullable!ASObjectOrLink attachment;
    Nullable!ASObjectOrLink attributedTo;
    Nullable!ASObjectOrLink audience;
    Nullable!string         content;
    Nullable!ASObjectOrLink context;
    Nullable!string         name;
    Nullable!asdatetime     endTime;
    Nullable!ASObjectOrLink generator;
    Nullable!ASObjectOrLink icon;
    Nullable!ASObjectOrLink image;
    Nullable!ASObjectOrLink inReplyTo;
    
}

struct ASLink {

}

