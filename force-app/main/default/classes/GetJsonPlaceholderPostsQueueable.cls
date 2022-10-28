public class GetJsonPlaceholderPostsQueueable implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext context) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint('https://jsonplaceholder.typicode.com/posts');
        request.setMethod('GET');
            
        HttpResponse response = http.send(request);
     
        // If the request is successful, parse the JSON response
        if (response.getStatusCode() == 200) {
            
            String responseBody = response.getBody();
            responseBody = responseBody.replaceAll('id', 'Post_Id__c');
            responseBody = responseBody.replaceAll('userId', 'User_Id__c');
            responseBody = responseBody.replaceAll('title', 'Title__c');
            responseBody = responseBody.replaceAll('body', 'Body__c');
            System.debug(responseBody);

            List<Json_Callout_Object__c> calloutObjects = (List<Json_Callout_Object__c>) JSON.deserialize(responseBody, List<Json_Callout_Object__c>.class);
            System.debug(calloutObjects);

            for (Json_Callout_Object__c obj : calloutObjects) {
                Json_Callout_Object__c objWithId = new Json_Callout_Object__c();
                objWithId.Post_Id__c = obj.Post_Id__c;
                objWithId.User_Id__c = obj.User_Id__c;
                objWithId.Title__c = obj.Title__c;
                objWithId.Body__c = obj.Body__c;
                obj = objWithId;
            }

            upsert calloutObjects;
        }

        System.enqueueJob(new PostJsonPlaceholderPostQueueable());
    }
}