public class PostWrapper {
	public String userId;
	public String id;
	public String title;
	public String body;	

	public static List<PostWrapper> parse(String json) {
		return (List<PostWrapper>) System.JSON.deserialize(json, List<PostWrapper>.class);
	}
}