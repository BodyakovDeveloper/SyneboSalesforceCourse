@isTest
public with sharing class CommentWrapperTest {
    @isTest 
    public static void testCommentWrapper() {
        String postId = '1';
        String id = '1';
        String jsonToParse = '[{"postId":' + postId + ' , "id": ' + id + '}]';
        Test.startTest();
        List<CommentWrapper> commentWrapperList = (List<CommentWrapper>) CommentWrapper.parse(jsonToParse);
        CommentWrapper commentWrapper = commentWrapperList.get(0);

        Test.stopTest();

        System.assertEquals(postId, commentWrapper.postId, 'UserId is wrong');
        System.assertEquals(id, commentWrapper.id, 'Id is wrong');
    }
}
