public class CarHandler {

    public static void changeHorsePowerToZeroOnUnsuitableValue(List<Car__c> cars) {
        for (Car__c car_i : cars) {
            if (car_i.Horse_Power__c < 0) {
                car_i.Horse_Power__c = 0;
            }
        }
    }

    public static void changeCarsCountRelatedToOffice(List<Car__c> carList) {
        Set<Id> garagesId = new Set<Id>();
        for(Car__c car_i : carList) {
            garagesId.add(car_i.Car_Rental_Garage__c);
        }
        Map<Id, Car_Rental_Garage__c> garageRecordsMap = new Map<Id, Car_Rental_Garage__c>([SELECT Car_Rental_Office__c FROM Car_Rental_Garage__c WHERE Id IN :garagesId]);
        Set<Id> officesIdSet = new Set<Id>();
        
        for (Car_Rental_Garage__c garage_i : garageRecordsMap.values()) {
            officesIdSet.add(garage_i.Car_Rental_Office__c);
        }
        
        Map<Id, Car_Rental_Office__c> officeRecordsMap = new Map<Id, Car_Rental_Office__c>([SELECT Id, Number_Of_Related_Cars__c FROM Car_Rental_Office__c WHERE Id IN : officesIdSet]);
        Set<Car_Rental_Office__c> officeSet = new Set<Car_Rental_Office__c>();

        for(Car_Rental_Office__c office_i : officeRecordsMap.values()) {
            officeSet.add(office_i);
        }

        List<AggregateResult> aggrs = [SELECT Car_Rental_Garage__r.Car_Rental_Office__c, count(Id) carNum
                                       FROM Car__c
                                       WHERE Active__c = true AND Car_Rental_Garage__r.Car_Rental_Office__c IN: officesIdSet
                                       GROUP BY Car_Rental_Garage__r.Car_Rental_Office__c];

                                       for (AggregateResult aggr : aggrs) {
            Id officeId = (id) aggr.get('Car_Rental_Office__c');
            Car_Rental_Office__c office = officeRecordsMap.get(officeId);
            if (officeSet.contains(office)) {
                officeSet.remove(office);
            }
            Decimal newValue = (Decimal) aggr.get('carNum');
            if (office.Number_Of_Related_Cars__c != newValue) {
                officeRecordsMap.get(officeId).Number_Of_Related_Cars__c = newValue;
            }
        }
        
        for (Car_Rental_Office__c office_i : officeSet) {
            office_i.Number_Of_Related_Cars__c = 0;
        }

        update new List<Car_Rental_Office__c>(officeSet);
        update officeRecordsMap.values();
    }
}