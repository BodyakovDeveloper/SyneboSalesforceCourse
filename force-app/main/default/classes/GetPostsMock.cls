global with sharing class GetPostsMock implements HttpCalloutMock {
    
    global static HttpResponse respond(HttpRequest req) {
        System.assertEquals('callout:Json_Placeholder_Named_Credential/posts', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
    }
}