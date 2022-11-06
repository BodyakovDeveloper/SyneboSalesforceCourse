public class GetJsonPlaceholderPostsQueueable implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext context) {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint('callout:Json_Placeholder_Named_Credential/posts');
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        System.debug(response.getStatusCode());
        // If the request is successful, parse the JSON response
        if (response.getStatusCode() == 200) {
            List<Placeholder_Post__c> calloutObjects = new List<Placeholder_Post__c>();
            List<PostWrapper> posts = PostWrapper.parse(response.getBody());
            for (PostWrapper post : posts) {
                Placeholder_Post__c calloutObj = new Placeholder_Post__c();
                calloutObj.Body__c = post.body;
                calloutObj.Post_Id__c = post.id;
                calloutObj.Title__c = post.title;
                calloutObj.User_Id__c = post.userId;
                calloutObjects.add(calloutObj);
            }
            upsert calloutObjects Post_Id__c;
        }
        System.enqueueJob(new GetPlaceholderCommentsQueueable());
    }
}