public class JsonPlaceholderParser {

	public Integer userId {get;set;} 
	public Integer id {get;set;} 
	public String title {get;set;} 
	public String body {get;set;} 

	public JsonPlaceholderParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'userId') {
						userId = parser.getIntegerValue();
					} else if (text == 'id') {
						id = parser.getIntegerValue();
					} else if (text == 'title') {
						title = parser.getText();
					} else if (text == 'body') {
						body = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'JsonPlaceholderParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public static JsonPlaceholderParser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new JsonPlaceholderParser(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
}