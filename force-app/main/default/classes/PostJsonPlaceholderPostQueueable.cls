public class PostJsonPlaceholderPostQueueable implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext context) {

        Http http = new Http();
        HttpRequest request = new HttpRequest();
       
        request.setEndpoint('callout:Json_Placeholder_Named_Credential/posts');
        request.setMethod('POST');

        PostWrapper postWrapper = new PostWrapper();
        postWrapper.id = '1';
        postWrapper.userId = 1;
        postWrapper.title = 'test title';
        postWrapper.body = 'test body';
        
        request.setBody(JSON.serialize(postWrapper));

        HttpResponse response = http.send(request);
    }
}