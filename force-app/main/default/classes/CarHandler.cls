public with sharing class CarHandler {

    public static void skipHorsePowerValidation(List<Car__c> cars) {
        for (Car__c car_i : cars) {
            if (car_i.Horse_Power__c < 0) {
                car_i.Horse_Power__c = 0;
            }
        }
    }

    public static void changeCarsCountRelatedToOffice(List<Car__c> carList){
        Set<Id> garageIdSet = new Set<Id>();
        Set<Id> officeIdSet = new Set<Id>();
        List<Car_Rental_Office__c> offToUpdate = new List<Car_Rental_Office__c>();
        for (Car__c car_i: carList){
            garageIdSet.add(car_i.Car_Rental_Garage__c);
        }
        for (Car_Rental_Garage__c garage : [SELECT Id, Car_Rental_Office__c 
                                           FROM Car_Rental_Garage__c 
                                           WHERE Id IN: garageIdSet]) {
            officeIdSet.add(garage.Car_Rental_Office__c);
        }
        List<AggregateResult> aggrs = [SELECT Car_Rental_Garage__r.Car_Rental_Office__c, count(Id)carNum 
                                       FROM Car__c 
                                       WHERE Car_Rental_Garage__r.Car_Rental_Office__c IN:officeIdSet 
                                       GROUP BY Car_Rental_Garage__r.Car_Rental_Office__c] ;
        if (aggrs.size() > 0){
            for (AggregateResult aggr : aggrs){
                Car_Rental_Office__c office = new Car_Rental_Office__c();
                office.Id = (id)aggr.get('Car_Rental_Office__c');
                office.Number_Of_Related_Cars__c =(decimal)aggr.get('carNum') ;
                offToUpdate.add(office);
            }
                update offToUpdate;
        }
    }
}
