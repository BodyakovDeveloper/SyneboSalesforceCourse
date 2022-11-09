public with sharing class CreatePost {
    @AuraEnabled
    public static Placeholder_Post__c createPost(Placeholder_Post__c post){
        try {
                insert post;
                return post;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}