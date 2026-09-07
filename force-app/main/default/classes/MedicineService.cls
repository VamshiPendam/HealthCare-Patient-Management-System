public with sharing class MedicineService {

    @AuraEnabled(cacheable=true)
    public static List<Medicine__c> getMedicines() {

        return [
            SELECT Id,
                   Name,
                   Medicine_Type__c,
                   Manufacturer__c,
                   Unit_Price__c,
                   Stock_Quantity__c,
                   Expiry_Date__c,
                   Medicine_Status__c
            FROM Medicine__c
            ORDER BY Name
            LIMIT 50
        ];
    }
}