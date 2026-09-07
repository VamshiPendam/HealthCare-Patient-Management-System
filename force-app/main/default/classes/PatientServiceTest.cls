@IsTest
private class PatientServiceTest {

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
    }

    @IsTest
    static void testGetPatients() {

        Test.startTest();

        List<Patient__c> patients =
            PatientService.getPatients();

        Test.stopTest();

        System.assertEquals(1, patients.size());
        System.assertEquals(
            'Test Patient',
            patients[0].Name
        );
    }
}