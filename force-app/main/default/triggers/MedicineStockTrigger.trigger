trigger MedicineStockTrigger on Medicine__c (before insert, before update) {

    for (Medicine__c medicine : Trigger.new) {

        if (medicine.Stock_Quantity__c == null ||
            medicine.Stock_Quantity__c == 0) {

            medicine.Medicine_Status__c = 'Out of Stock';

        } else if (medicine.Stock_Quantity__c <= 10) {

            medicine.Medicine_Status__c = 'Low Stock';

        } else {

            medicine.Medicine_Status__c = 'Available';
        }
    }
}
