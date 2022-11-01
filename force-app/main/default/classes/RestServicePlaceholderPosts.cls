@RestResource(urlMapping='/post/*')
global with sharing class RestServicePlaceholderPosts {

    // [GET]
    // /services/apexrest/post/a0E7S000000bcVX
    @HttpGet
    global static Json_Callout_Object__c getPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String postId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        Json_Callout_Object__c result = [SELECT Id, Post_Id__c, Title__c, Body__c, User_Id__c 
                                         FROM Json_Callout_Object__c 
                                         WHERE Id = :postId];
        return result;
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
    global static Id savePost() {
        RestRequest req = RestContext.request;
        Json_Callout_Object__c jsonCalloutObject = (Json_Callout_Object__c) JSON.deserialize(req.requestBody.toString(), Json_Callout_Object__c.class);
        if (jsonCalloutObject != null) {
            insert jsonCalloutObject;
        }
        return jsonCalloutObject.Id;
    }

    // [DELETE]
    // /services/apexrest/post/a0E7S000000bcVX
    @HttpDelete
    global static void deletePost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String objId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        Json_Callout_Object__c objToDelete = [SELECT Id FROM Json_Callout_Object__c WHERE Id = :objId];
       
        if (objToDelete != null) {
            delete objToDelete;
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
        String objId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        Json_Callout_Object__c objToUpdate = [SELECT Id FROM Json_Callout_Object__c WHERE Id = :objId];
        if (objToUpdate != null) {
            Json_Callout_Object__c jsonCalloutObject = (Json_Callout_Object__c) JSON.deserialize(req.requestBody.toString(), Json_Callout_Object__c.class);
            objToUpdate.Body__c = jsonCalloutObject.Body__c;
            objToUpdate.Post_Id__c = jsonCalloutObject.Post_Id__c;
            objToUpdate.Title__c = jsonCalloutObject.Title__c;
            objToUpdate.User_Id__c = jsonCalloutObject.User_Id__c;
            
            update objToUpdate;
        }
    }
}