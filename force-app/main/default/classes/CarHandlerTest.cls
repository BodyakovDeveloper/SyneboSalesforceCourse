@isTest
public with sharing class CarHandlerTest {
    
    private static Integer COUNT_OF_CARS_TO_CREATE = 4;

    @testSetup
    public static void setup() {
        insert CarHandlerDataFactory.getCars(COUNT_OF_CARS_TO_CREATE);
    }

    @isTest
    public static void changeCountOfRelatedCarsOnInsertTest() {
        String carName = 'TestName';

        String officeName = CarHandlerDataFactory.getOfficeName();
        String garageName = CarHandlerDataFactory.getGarageName();

        Car_Rental_Garage__c testGarage = [SELECT Id, Name FROM Car_Rental_Garage__c WHERE Name =: garageName];
        Car__c newCar = CarHandlerDataFactory.getCarByName(carName);
        newCar.Car_Rental_Garage__c = testGarage.Id;

        Test.startTest();
        
        insert newCar;

        Test.stopTest();

        Car__c carFromDb = [SELECT Id FROM Car__c WHERE Name =: carName LIMIT 1].get(0);
        Car_Rental_Office__c office = [SELECT Id, Name, Number_Of_Related_Cars__c FROM Car_Rental_Office__c WHERE Name =: officeName];

        System.assertEquals(newCar.Id, carFromDb.Id, 'Car did not created');
        System.assertEquals(COUNT_OF_CARS_TO_CREATE + 1, office.Number_Of_Related_Cars__c, 'Wrong count of cars on office record');
    }

    @isTest
    public static void changeCountOfRelatedCarsUpdateTest() {

        String officeName = CarHandlerDataFactory.getOfficeName();

        Test.startTest();

        Car__c carToUpdate = [SELECT Id, Name, Active__c FROM Car__c].get(0);
        carToUpdate.Active__c = false;
        update carToUpdate;

        Test.stopTest();

        Car__c carFromDb = [SELECT Id, Active__c FROM Car__c WHERE Id =: carToUpdate.Id].get(0);
        Car_Rental_Office__c office = [SELECT Id, Name, Number_Of_Related_Cars__c FROM Car_Rental_Office__c WHERE Name =: officeName];

        System.assertEquals(carToUpdate.Active__c, carFromDb.Active__c, 'Car did not updated');
        System.assertEquals(COUNT_OF_CARS_TO_CREATE - 1, office.Number_Of_Related_Cars__c, 'Wrong count of cars on office record');
    }

    @isTest
    public static void changeCountOfRelatedCarsDeleteTest() {

        String officeName = CarHandlerDataFactory.getOfficeName();

        Test.startTest();

        Car__c carToUpdate = [SELECT Id, Name, Active__c FROM Car__c].get(0);
        delete carToUpdate;

        Test.stopTest();

        Car_Rental_Office__c office = [SELECT Id, Name, Number_Of_Related_Cars__c FROM Car_Rental_Office__c WHERE Name =: officeName];
        System.assertEquals(COUNT_OF_CARS_TO_CREATE - 1, office.Number_Of_Related_Cars__c, 'Wrong count of cars on office record');
    }

    @isTest    
    public static void changeHorsePowerToZeroOnUnsuitableValueTest() {
        Car_Rental_Garage__c garage = [SELECT Id, Car_Rental_Office__c FROM Car_Rental_Garage__c WHERE Name =: CarHandlerDataFactory.getGarageName()];
        List<Car__c> cars = new List<Car__c>();
        for (Integer i = 0; i < 3; i++) {
            Car__c car = new Car__c(Name = 'CarName' + i, Brand__c = 'Mercedes-Benz', Price__c = i, Car_Rental_Garage__c = garage.Id);
            cars.add(car);
        }

        cars.get(0).Horse_Power__c = -200;
        cars.get(1).Horse_Power__c = 0;
        cars.get(2).Horse_Power__c = 200;

        CarHandler.changeHorsePowerToZeroOnUnsuitableValue(cars);

        System.assertEquals(0, cars.get(0).Horse_Power__c, 'The value did not change or changed with an error');
        System.assertEquals(0, cars.get(1).Horse_Power__c, 'the value has changed even though it shouldn\'t have');
        System.assertEquals(200, cars.get(2).Horse_Power__c, 'the value has changed even though it shouldn\'t have');
    }
}