@isTest
public with sharing class RestServicePlaceholderPostsTest {
    
    static void testGetPositive() {
        Account acc = [SELECT Id, Name FROM Placeholder_Post__c LIMIT 1];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();  
        
        req.requestURI = '/services/apexrest/Account/' + acc.Id;
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        SampleREST.doGet();
        Test.stopTest(); 
        
        SampleREST.AccountWrapper responseBody =(SampleREST.AccountWrapper)JSON.deserialize(res.responseBody.toString(), SampleREST.AccountWrapper.class);
        System.assertEquals(acc.Id, responseBody.accid);
        System.assertEquals(acc.Name, responseBody.accName);
        System.assertEquals(200, res.statusCode);
    }
}
