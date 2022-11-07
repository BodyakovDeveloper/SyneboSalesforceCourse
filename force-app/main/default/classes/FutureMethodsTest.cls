@isTest
public with sharing class FutureMethodsTest {

    private static Integer COUNT_OF_CARS_TO_CREATE = 4;

    @testSetup
    public static void setup() {
        insert CarHandlerDataFactory.getCars(COUNT_OF_CARS_TO_CREATE);
    }

    @isTest
    public static void countRelatedCarsToOfficeTest() {
        String carName = 'TestName';
        String officeName = CarHandlerDataFactory.getOfficeName();
        String garageName = CarHandlerDataFactory.getGarageName();

        Car_Rental_Garage__c testGarage = [SELECT Id, Name FROM Car_Rental_Garage__c WHERE Name =: garageName];

        Car__c newCar = CarHandlerDataFactory.getCarByName(carName);
        newCar.Car_Rental_Garage__c = testGarage.Id;

        Test.startTest();

        insert newCar;
        // get office to set wrong value and execute future method to recount related cars to the office
        Car_Rental_Office__c office = [SELECT Id, Name, Number_Of_Related_Cars__c FROM Car_Rental_Office__c WHERE Name =: officeName];
        office.Number_Of_Related_Cars__c = 0;
        update office;

        List<Car__c> cars = [SELECT Id FROM Car__c];
        List<Id> carIdList = new List<Id>();
        for (Car__c car_i : cars) {
            carIdList.add(car_i.Id);
        }
        
        FutureMethods.countRelatedCarsToOffice(carIdList);

        Test.stopTest();

        Car_Rental_Office__c officeFromDb = [SELECT Id, Name, Number_Of_Related_Cars__c FROM Car_Rental_Office__c WHERE Name =: officeName];

        System.assertEquals(COUNT_OF_CARS_TO_CREATE + 1, officeFromDb.Number_Of_Related_Cars__c, 'Wrong count of cars on office record');
    }
}
