List<AggregateResult>  aggrs = [SELECT Car_Rental_Garage__r.Car_Rental_Office__c, count(Id)carNum
FROM Car__c 
WHERE Active__c = true AND Car_Rental_Garage__r.Car_Rental_Office__c IN: officeIdSet
GROUP BY Car_Rental_Garage__r.Car_Rental_Office__c];

System.debug(aggrs);