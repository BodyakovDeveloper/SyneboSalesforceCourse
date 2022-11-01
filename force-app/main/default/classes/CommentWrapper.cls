public class CommentWrapper {

	public String postId;
	public String id;
	public String name;
	public String email;
	public String body;

	
	public static List<CommentWrapper> parse(String json) {
		return (List<CommentWrapper>) System.JSON.deserialize(json, List<CommentWrapper>.class);
	}
}