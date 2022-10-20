public with sharing class CarHandler {

    public static void skipHorsePowerValidation(List<Car__c> cars) {
        for(Car__c car_i : cars) {
            if (car_i.Horse_Power__c < 0) {
                car_i.Horse_Power__c = 0;
            }
        }
    }
}