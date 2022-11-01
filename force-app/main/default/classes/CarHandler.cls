public with sharing class CarHandler {

    public static void changeHorsePowerToZeroOnUnsuitableValue(List<Car__c> cars) {
        for (Car__c car_i : cars) {
            if (car_i.Horse_Power__c < 0) {
                car_i.Horse_Power__c = 0;
            }
        }
    }

    public static void changeCarsCountRelatedToOffice(List<Car__c> carList) {
        Set<Id> garageIdSet = new Set<Id>();
        Set<Id> officeIdSet = new Set<Id>();
    
        List<Car_Rental_Office__c> offToUpdate = new List<Car_Rental_Office__c>();

        for (Car__c car_i: carList){
            garageIdSet.add(car_i.Car_Rental_Garage__c);
        }

        for (Car_Rental_Garage__c garage_i : [SELECT Id, Car_Rental_Office__c 
                                              FROM Car_Rental_Garage__c 
                                              WHERE Id IN: garageIdSet]) {
            officeIdSet.add(garage_i.Car_Rental_Office__c);
        }

        Map<Id, Car_Rental_Office__c> officeMap = new Map<Id, Car_Rental_Office__c>
                                     ([SELECT Id, Number_Of_Related_Cars__c
                                       FROM Car_Rental_Office__c 
                                       WHERE Id IN: officeIdSet]);
                                       
        List<AggregateResult>  aggrs = [SELECT Car_Rental_Garage__r.Car_Rental_Office__c, count(Id)carNum
                                       FROM Car__c 
                                       WHERE Active__c = true AND Car_Rental_Garage__r.Car_Rental_Office__c IN: officeIdSet
                                       GROUP BY Car_Rental_Garage__r.Car_Rental_Office__c];
 
        if (aggrs.size() > 0) {
            for (AggregateResult aggr : aggrs) {
                Id officeId = (id) aggr.get('Car_Rental_Office__c');
                Car_Rental_Office__c officeWithOldValue = officeMap.get(officeId);

                Decimal oldValue = officeWithOldValue.Number_Of_Related_Cars__c;
                Decimal newValue = (Decimal) aggr.get('carNum');

                if (oldValue != newValue) {
                    Car_Rental_Office__c office = new Car_Rental_Office__c();
                    office.Id = officeId;
                    office.Number_Of_Related_Cars__c = newValue;
                    offToUpdate.add(office);
                }
            }
            if (!offToUpdate.isEmpty())
                update offToUpdate;
        } else {
             List<Car_Rental_Office__c> officesWithZeroCars = [SELECT Id, Number_Of_Related_Cars__c 
                                                               FROM Car_Rental_Office__c 
                                                               WHERE id IN: officeIdSet];

            for (Car_Rental_Office__c office_i : officesWithZeroCars) {
                office_i.Number_Of_Related_Cars__c = 0;
            }
            if (!officesWithZeroCars.isEmpty()) {
                update officesWithZeroCars;
            }   
        }

        System.enqueueJob(new GetJsonPlaceholderPostsQueueable());
    }
}