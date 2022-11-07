@isTest
public with sharing class RestServicePlaceholderPostsTest {
    
    @testSetup
    static void makeData() {
        Placeholder_Post__c post = new Placeholder_Post__c(Title__c = 'TestTitle', Post_Id__c = 'testId', User_Id__c = 1, Body__c = 'TestBody');
        insert post;
    }

    @isTest
    static void testGetPositive() {
        Placeholder_Post__c post = [SELECT Id, Name, Body__c, Title__c, User_Id__c, Post_Id__c FROM Placeholder_Post__c LIMIT 1];

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/post/' + post.Id;
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        RestServicePlaceholderPosts.getPost();
        Test.stopTest(); 

        Placeholder_Post__c responseBody = (Placeholder_Post__c) JSON.deserialize(res.responseBody.toString(), Placeholder_Post__c.class);

        System.assertNotEquals(null, responseBody, 'Response object is null');
        System.assertEquals(post.Id, responseBody.Id, 'The Id is not as expected');
        System.assertEquals(post.Post_Id__c, responseBody.Post_Id__c, 'The post_id is not as expected');
        System.assertEquals(post.Title__c, responseBody.Title__c, 'The title is not as expected');
        System.assertEquals(200, res.statusCode, 'The status code is not as expected');
    }

    @isTest
    static void testGetNegative() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/post/234576dsgfh36';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        RestServicePlaceholderPosts.getPost();
        Test.stopTest(); 
        
        String responseBody = res.responseBody.toString();
        System.assertEquals('{ "message" : "System.QueryException: List has no rows for assignment to SObject"}', responseBody);
        System.assertEquals(404, res.statusCode, 'The status code is not as expected');
    }

    @isTest //positive unit test for the REST API POST call
    static void testPostPositive() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String externalPostId = 'postTestId';
        Placeholder_Post__c post = new Placeholder_Post__c(Title__c = 'postTestTitle', Post_Id__c = externalPostId, User_Id__c = 1, Body__c = 'postTestBody');
        
        req.requestURI = '/services/apexrest/post/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serializePretty(post));
        
        RestContext.request = req;
   	    RestContext.response= res;
        
        Test.startTest();
        RestServicePlaceholderPosts.savePost();
        Test.stopTest();
        
        Placeholder_Post__c newPostCreated = [SELECT Id, Title__c, Post_Id__c FROM Placeholder_Post__c WHERE Post_Id__c =: externalPostId];
        
        Placeholder_Post__c responseBody = (Placeholder_Post__c) JSON.deserialize(res.responseBody.toString(), Placeholder_Post__c.class);
        System.assertEquals(newPostCreated.Id, responseBody.Id, 'The Id is not as expected');
        System.assertEquals(newPostCreated.Post_Id__c, responseBody.Post_Id__c,'The post Id is not as expected');
        System.assertEquals(201, res.statusCode, 'The status code is not as expected');
    }

    @isTest //negative unit test for the REST API POST call
    static void testPostNegative() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        Placeholder_Post__c post = new Placeholder_Post__c();
        
        req.requestURI = '/services/apexrest/post/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serializePretty(post));
        
        RestContext.request = req;
   	    RestContext.response= res;
        
        Test.startTest();
        RestServicePlaceholderPosts.savePost();
        Test.stopTest();
        
        System.assertEquals(500, res.statusCode, 'The status code is not as expected');
    }

    @isTest //negative unit test for the REST API POST call
    static void testUpdatePositive() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        String updatedTitle = 'updatedTitle';

        Placeholder_Post__c post = [SELECT Id, Title__c, Post_Id__c FROM Placeholder_Post__c LIMIT 1];
        post.Title__c = updatedTitle;

        req.requestURI = '/services/apexrest/post/' + post.Id;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serializePretty(post));
        
        RestContext.request = req;
   	    RestContext.response= res;
        
        Test.startTest();
        RestServicePlaceholderPosts.updatePost();
        Test.stopTest();

        Placeholder_Post__c updatedPost = [SELECT Id, Title__c, Post_Id__c FROM Placeholder_Post__c WHERE Id =: post.Id];

        
        System.assertEquals(post.Id, updatedPost.Id, 'The Id is not as expected');
        System.assertEquals(202, res.statusCode, 'The status code is not as expected');
    }

    @isTest //negative unit test for the REST API POST call
    static void testUpdateNegative() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        String updatedTitle = 'updatedTitle';

        Placeholder_Post__c post = [SELECT Id, Title__c, Post_Id__c FROM Placeholder_Post__c LIMIT 1];

        String oldPostId = post.Post_Id__c;

        String postJson = JSON.serialize(post);
        postJson = postJson.replace(oldPostId, '');

        req.requestURI = '/services/apexrest/post/' + post.Id;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(postJson);
        
        RestContext.request = req;
   	    RestContext.response= res;
        
        Test.startTest();
        RestServicePlaceholderPosts.updatePost();
        Test.stopTest();

        System.assertEquals(404, res.statusCode, 'The status code is not as expected');
    }

    @isTest //negative unit test for the REST API POST call
    static void testDeletePositive() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        Placeholder_Post__c post = [SELECT Id, Title__c, Post_Id__c FROM Placeholder_Post__c LIMIT 1];

        req.requestURI = '/services/apexrest/post/' + post.Id;
        req.httpMethod = 'DELETE';
        
        RestContext.request = req;
   	    RestContext.response = res;
        
        Test.startTest();
        RestServicePlaceholderPosts.deletePost();
        Test.stopTest();

        List<AggregateResult> aggrs = [SELECT COUNT(Post_Id__c) FROM Placeholder_Post__c WHERE Id =: post.Id];

        System.assertEquals(0, aggrs.get(0).get('expr0'), 'The count of records after delete is not as expected');
        System.assertEquals(202, res.statusCode, 'The status code is not as expected');
    }

    
    @isTest //negative unit test for the REST API POST call
    static void testDeleteNegative() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();


        req.requestURI = '/services/apexrest/post/' + 'ASwdeew12312wdwQUAQ';
        req.httpMethod = 'DELETE';
        
        RestContext.request = req;
   	    RestContext.response = res;

        Test.startTest();
        RestServicePlaceholderPosts.deletePost();
        Test.stopTest();

        List<AggregateResult> aggrs = [SELECT COUNT(Post_Id__c) FROM Placeholder_Post__c];

        System.assertEquals(1, aggrs.get(0).get('expr0'), 'The count of records after delete is not as expected');
        System.assertEquals(404, res.statusCode, 'The status code is not as expected');
    }
}