public with sharing class CarHandlerDataFactory {

    private static String OFFICE_NAME = 'TestOffice';
    private static String GARAGE_NAME = 'TestGarage';


    public static Car__c getCarByName(String name) {
        return new Car__c(Name = name, Brand__c = 'Mercedes-Benz', Price__c = 100000);
    }

    public static List<Car__c> getCars(Integer countOfCarsNeed) {
        Car_Rental_Office__c office = new Car_Rental_Office__c(Name = OFFICE_NAME);
        insert office;
        Id officeId = [SELECT Id FROM Car_Rental_Office__c].Id;

        Car_Rental_Garage__c garage = new Car_Rental_Garage__c(Name = GARAGE_NAME, Car_Rental_Office__c = officeId, Phone__c = '+30011111111', Email__c = 'mail@office.com');
        insert garage;
        Id garageId = [SELECT Id FROM Car_Rental_Garage__c].Id;

        List<Car__c> cars = new List<Car__c>();
        for (Integer i = 0; i < countOfCarsNeed; i++) {
            cars.add(new Car__c(Name = 'Test_' + i, Brand__c = 'Volkswagen', Car_Rental_Garage__c = garageId, Price__c = i * 1000));
        }

        return cars;
    }

    public static String getOfficeName() {
        return OFFICE_NAME;
    }

    public static String getGarageName() {
        return GARAGE_NAME;
    }
}