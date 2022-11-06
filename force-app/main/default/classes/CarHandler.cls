public with sharing class CarHandler {

    public static void changeHorsePowerToZeroOnUnsuitableValue(List<Car__c> cars) {
        for (Car__c car_i : cars) {
            if (car_i.Horse_Power__c < 0) {
                car_i.Horse_Power__c = 0;
            }
        }
    }

    public static void changeCarsCountRelatedToOffice(List<Car__c> carList) {
        System.debug(carList);
        Set<Id> carIdSet = new Set<Id>();

        for (Car__c car_i : carList) {
                carIdSet.add(car_i.Id);
        }

        System.debug(carIdSet);
       // [SELECT Id, Car_Rental_Garage__r.Car_Rental_Office__r.Number_Of_Related_Cars__c
        //FROM Car__c]

        List<AggregateResult>  aggrs =  [SELECT Car_Rental_Garage__r.Car_Rental_Office__c off, count(Id) carQuantity
                                         FROM Car__c 
                                         WHERE Id IN: carIdSet
                                         GROUP BY Car_Rental_Garage__r.Car_Rental_Office__c];

        List<Car__c> carListWithOldQuantityInOff = [SELECT Id, Car_Rental_Garage__r.Car_Rental_Office__c, Car_Rental_Garage__r.Car_Rental_Office__r.Number_Of_Related_Cars__c 
                                                    FROM Car__c 
                                                    WHERE Id IN: carList];
        
        System.debug(carListWithOldQuantityInOff);
        Map<Id, Decimal> carMapWithOldQuantityInOff = new Map<Id, Decimal>();
        Set<Id> officeIdSet = new Set<Id>();

        for (Car__c car_i : carListWithOldQuantityInOff) {
            Id officeId = car_i.Car_Rental_Garage__r.Car_Rental_Office__c;
            officeIdSet.add(officeId);
            carMapWithOldQuantityInOff.put(officeId, car_i.Car_Rental_Garage__r.Car_Rental_Office__r.Number_Of_Related_Cars__c);
        }
        List<Car_Rental_Office__c> carListToUpdate = new List<Car_Rental_Office__c>();
        System.debug(carMapWithOldQuantityInOff);
        for (AggregateResult aggr : aggrs) {
            Id officeId = (Id)aggr.get('off');
            Decimal oldQuantity = carMapWithOldQuantityInOff.get(officeId);
            Decimal newQuantity = (Decimal)aggr.get('carQuantity');
            System.debug(oldQuantity);
            System.debug(newQuantity);
            if (newQuantity != oldQuantity) {
                System.debug('not equ');
                Car_Rental_Office__c office = new Car_Rental_Office__c(Id = officeId, Number_Of_Related_Cars__c = newQuantity);
                carListToUpdate.add(office);
            }
            System.debug(aggr.Id);
            System.debug(aggr.get('carQuantity'));
        }
        System.debug(carListToUpdate);
        update carListToUpdate;
        
        System.debug(carIdSet);

       // System.enqueueJob(new GetJsonPlaceholderPostsQueueable());
    }
}