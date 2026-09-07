public with sharing class BillingService {

    @AuraEnabled(cacheable=true)
    public static List<Billing__c> getBills() {

        return [
            SELECT Id,
                   Name,
                   Patient__c,
                   Patient__r.Name,
                   Appointment__c,
                   Visit__c,
                   Consultation_Fee__c,
                   Medicine_Charges__c,
                   Other_Charges__c,
                   Total_Amount__c,
                   Payment_Status__c,
                     Payment_Method__c
            FROM Billing__c
                 ORDER BY CreatedDate DESC
            LIMIT 50
        ];
    }
}