public class GetPlaceholderCommentsQueueable implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext context) {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint('callout:Json_Placeholder_Named_Credential/comments');
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
       
        // If the request is successful, parse the JSON response
        if (response.getStatusCode() == 200) {
            List<Placeholder_Comment__c> commentsToUpsert = new List<Placeholder_Comment__c>();
            List<CommentWrapper> commetsFromWrapper = CommentWrapper.parse(response.getBody());
           
            Set<String> postIdSet = new Set<String>();
            for (CommentWrapper comment : commetsFromWrapper) {
                postIdSet.add(comment.postId);
            }

            List<Placeholder_Post__c> posts = [SELECT Placeholder_Post__c.Post_Id__c, Id FROM Placeholder_Post__c WHERE Post_Id__c IN: postIdSet];
            Map<String, Id> postIdMap = new Map<String, Id>();

            for (Placeholder_Post__c post : posts) {
                postIdMap.put(post.Post_Id__c, post.Id);
            }
            for (CommentWrapper cfw : commetsFromWrapper) {
                Placeholder_Comment__c comment = new Placeholder_Comment__c();

                comment.Placeholder_Post__c = postIdMap.get(cfw.postId);
                comment.Comment_Id__c = cfw.id;
                comment.Name__c = cfw.name;
                comment.Email__c = cfw.email;
                comment.Body__c = cfw.body;

                commentsToUpsert.add(comment);
            }
            upsert commentsToUpsert Comment_Id__c;
        }
        System.enqueueJob(new PostJsonPlaceholderPostQueueable());
    }
}
