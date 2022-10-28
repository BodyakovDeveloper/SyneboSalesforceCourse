public class PostJsonPlaceholderPostQueueable implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext context) {

        Http http = new Http();
        HttpRequest request = new HttpRequest();
       
        request.setEndpoint('https://jsonplaceholder.typicode.com/posts');
        request.setMethod('POST');
       
        String title = 'test title';
        String body = 'test body';
        Integer userId = 1;

        request.setBody('title=' + EncodingUtil.urlEncode(title, 'UTF-8')
                      + '&body=' + EncodingUtil.urlEncode(body, 'UTF-8')
                      + '&userId=' + userId);

        HttpResponse response = http.send(request);
        System.debug(response);
    }
}