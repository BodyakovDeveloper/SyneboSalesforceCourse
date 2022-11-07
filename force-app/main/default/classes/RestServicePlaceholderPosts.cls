@RestResource(urlMapping='/post/*')
global with sharing class RestServicePlaceholderPosts {

    // [GET]
    // /services/apexrest/post/a0E7S000000bcVX
    @HttpGet
    global static void getPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try {
            String postId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
            Placeholder_Post__c result = [SELECT Id, Post_Id__c, Title__c, Body__c, User_Id__c 
                                          FROM Placeholder_Post__c 
                                          WHERE Id = :postId];
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(JSON.serialize(result));
            res.statusCode = 200;
        } catch (Exception e) {
            setExceptionResponse(e);
        }
    }
    
    // [POST]
    // /services/apexrest/post
    //{
    //  "User_Id__c": 222,
    //  "Post_Id__c": 222,
    //  "Title__c": "post test",
    //  "Body__c": "post test"
    //}
    @HttpPost
    global static void savePost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try {
            Placeholder_Post__c jsonCalloutObject = (Placeholder_Post__c) JSON.deserialize(req.requestBody.toString(), Placeholder_Post__c.class);
            if (jsonCalloutObject.Post_Id__c == null) {
                throw new ExternalObjectException('Post Id cannot be null');
            }
            insert jsonCalloutObject;
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(JSON.serialize(jsonCalloutObject));
            res.statusCode = 201;
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
        }
    }

     // [PUT]
    // /services/apexrest/post/a0E7S000000bcVX
    //{
    //  "User_Id__c": 99999,
    //  "Post_Id__c": 999999,
    //  "Title__c": "updated",
    //  "Body__c": "updated"
    //}
    @HttpPut
    global static void updatePost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try {
            String objId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
            Placeholder_Post__c objToUpdate = [SELECT Id FROM Placeholder_Post__c WHERE Id = :objId];

            Placeholder_Post__c jsonCalloutObject = (Placeholder_Post__c) JSON.deserialize(req.requestBody.toString(), Placeholder_Post__c.class);
            objToUpdate.Body__c = jsonCalloutObject.Body__c;
            objToUpdate.Post_Id__c = jsonCalloutObject.Post_Id__c;
            objToUpdate.Title__c = jsonCalloutObject.Title__c;
            objToUpdate.User_Id__c = jsonCalloutObject.User_Id__c;
            
            update objToUpdate;

            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(JSON.serialize(objToUpdate));
            res.statusCode = 202;
        } catch (Exception e) {
            setExceptionResponse(e);
        }
    }

    // [DELETE]
    // /services/apexrest/post/a0E7S000000bcVX
    @HttpDelete
    global static void deletePost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try {
            String objId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
            Placeholder_Post__c objToDelete = [SELECT Id FROM Placeholder_Post__c WHERE Id = :objId];
            
            delete objToDelete;

            RestContext.response.responseBody = Blob.valueOf('{ "message" : "' + 'post with id: ' + objId + ' was successfully deleted.' + '"}');
            res.statusCode = 202;
        } catch (Exception e) {
            setExceptionResponse(e); 
        }
       
    }

    private static void setExceptionResponse(Exception e) {
        RestContext.response.responseBody = Blob.valueOf('{ "message" : "' + e + '"}');
        RestContext.response.statusCode = 404;
    }
}