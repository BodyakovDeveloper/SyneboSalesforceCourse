trigger CarTrigger on Car__c (before insert, after insert, after delete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            CarHandler.skipHorsePowerValidation(Trigger.new);  // changeHorsePowerToZeroOnUnsuitableValue
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            CarHandler.changeCarsCountRelatedToOffice(Trigger.new);
        } else if (Trigger.isDelete) {
            CarHandler.changeCarsCountRelatedToOffice(Trigger.old);
        }
    }
}