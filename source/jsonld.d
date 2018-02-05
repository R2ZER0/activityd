module jsonld;
import vibe.data.json;

@safe
public Json jsonContext(string langcode = "en-GB")
{
	auto languageObj = Json.emptyObject;
	languageObj["@language"] = langcode;
	
	return Json([ Json("https://www.w3.org/ns/activitystreams"), languageObj ]);
}
