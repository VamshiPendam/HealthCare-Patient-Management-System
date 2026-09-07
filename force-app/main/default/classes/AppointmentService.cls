public with sharing class AppointmentService {

    @AuraEnabled(cacheable=true)
    public static List<Appointment__c> getAppointments() {

        return [
            SELECT Id,
                   Name,
                   Patient__c,
                   Patient__r.Name,
                   Doctor__c,
                   Doctor__r.Name,
                   Appointment_Date__c,
                   Appointment_Time__c,
                   Status__c,
                   Appointment_Type__c,
                   Reason__c
            FROM Appointment__c
            ORDER BY Appointment_Date__c DESC
            LIMIT 50
        ];
    }
}