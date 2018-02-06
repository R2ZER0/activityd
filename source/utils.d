module utils;

import vibe.data.json;
import vibe.inet.url : URL;


URL appendUrl(URL url, string extra) @safe {
    URL newUrl = url;
    newUrl.pathString = url.pathString ~ extra;
    return newUrl;
}

string appendUrl(string url, string extra) @safe {
    return url ~ extra;
}

