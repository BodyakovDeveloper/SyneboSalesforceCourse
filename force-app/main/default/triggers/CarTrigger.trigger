trigger CarTrigger on Car__c (before insert) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            CarHandler.skipHorsePowerValidation(Trigger.new);
        }
    }
}