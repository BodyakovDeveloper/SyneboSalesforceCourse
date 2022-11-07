@isTest
public with sharing class PostWrapperTest {
    
    @isTest 
    public static void testPostWrapper() {
        Integer userId = 1;
        String id = '1';
        String jsonToParse = '[{"userId":' + userId + ' , "id": ' + id + '}]';
        Test.startTest();
        List<PostWrapper> postWrapperList = (List<PostWrapper>) PostWrapper.parse(jsonToParse);
        PostWrapper postWrapper = postWrapperList.get(0);

        Test.stopTest();

        System.assertEquals(userId, postWrapper.userId, 'UserId is wrong');
        System.assertEquals(id, postWrapper.id, 'Id is wrong');
    }
}