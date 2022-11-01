trigger CarTrigger on Car__c (before insert, after insert, after update, after delete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            CarHandler.changeHorsePowerToZeroOnUnsuitableValue(Trigger.new);  // skipHorsePowerValidation
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            CarHandler.changeCarsCountRelatedToOffice(Trigger.new);
        } else if (Trigger.isUpdate) {
            CarHandler.changeCarsCountRelatedToOffice(Trigger.new);
        } else if (Trigger.isDelete) {            
            CarHandler.changeCarsCountRelatedToOffice(Trigger.old);
        }
    }
}