@IsTest
private class BillingServiceTest {

    @TestSetup
    static void createTestData() {

        Patient__c patient = new Patient__c(
            Name = 'Test Patient',
            Date_of_Birth__c = Date.newInstance(1995, 5, 15),
            Gender__c = 'Male',
            Phone__c = '9876543210',
            Email__c = 'testpatient@example.com',
            Blood_Group__c = 'O+'
        );

        insert patient;

        Doctor__c doctor = new Doctor__c(
            Name = 'Test Doctor',
            Specialization__c = 'Cardiologist',
            Phone__c = '9876543211',
            Email__c = 'testdoctor@example.com',
            Experience__c = 5,
            Consultation_Fee__c = 500,
            Availability__c = 'Available',
            License_Number__c = 'LIC12345'
        );

        insert doctor;

        Appointment__c appointment = new Appointment__c(
            Patient__c = patient.Id,
            Doctor__c = doctor.Id,
            Appointment_Date__c = Date.today(),
            Appointment_Time__c = '10:00 AM',
            Status__c = 'Scheduled',
            Appointment_Type__c = 'Consultation',
            Reason__c = 'Regular checkup'
        );

        insert appointment;

        Billing__c bill = new Billing__c(
            Patient__c = patient.Id,
            Appointment__c = appointment.Id,
            Consultation_Fee__c = 500,
            Medicine_Charges__c = 200,
            Other_Charges__c = 100,
            Payment_Status__c = 'Pending'
        );

        insert bill;
    }

    @IsTest
    static void testGetBills() {

        Test.startTest();

        List<Billing__c> bills =
            BillingService.getBills();

        Test.stopTest();

        System.assertEquals(1, bills.size());
        System.assertEquals(
            'Pending',
            bills[0].Payment_Status__c
        );
    }
}
