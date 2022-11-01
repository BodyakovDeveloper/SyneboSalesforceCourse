public class GetPlaceholderCommentsQueueable implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext context) {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint('https://jsonplaceholder.typicode.com/comments');
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        System.debug(response.getStatusCode());
        // If the request is successful, parse the JSON response
        if (response.getStatusCode() == 200) {
            List<Placeholder_Comment__c> commentsToUpsert = new List<Placeholder_Comment__c>();
            List<CommentWrapper> commetsFromWrapper = CommentWrapper.parse(response.getBody());

            Set<Id> postIdSet = new Set<Id>();

            for (Placeholder_Comment__c comment : commetsFromWrapper) {
                postIdSet.add();
            }

            List<Placeholder_Post__c> postMap = [SELECT Placeholder_Post__c.Post_Id__c, Id FROM Placeholder_Post__c WHERE Post_Id__c IN: postIdSet];
            System.debug(postMap);
        
            for (CommentWrapper cfw : commetsFromWrapper) {
                Placeholder_Comment__c comment = new Placeholder_Comment__c();
                System.debug(postMap.get(cfw.postId));
                System.debug(postMap.get(cfw.postId).Id);

                comment.Placeholder_Post__c = postMap.get(cfw.postId).Id;
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