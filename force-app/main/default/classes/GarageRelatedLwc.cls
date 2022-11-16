public with sharing class GarageRelatedLwc {
    @AuraEnabled
    public static List<Car__c> getRelatedCars(Id garageId) {
        try {
            return [SELECT Id, Name, Price__c, Brand__c, Horse_Power__c FROM Car__c WHERE Id =: garageId];    
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}