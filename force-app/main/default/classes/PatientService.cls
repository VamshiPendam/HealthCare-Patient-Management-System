public with sharing class PatientService {

    @AuraEnabled(cacheable=true)
    public static List<Patient__c> getPatients() {

        return [
            SELECT Id,
                   Name,
                   Date_of_Birth__c,
                   Gender__c,
                   Phone__c,
                   Email__c,
                   Blood_Group__c
            FROM Patient__c
            ORDER BY CreatedDate DESC
            LIMIT 50
        ];
    }
}