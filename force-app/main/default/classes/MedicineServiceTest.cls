@IsTest
private class MedicineServiceTest {

    @TestSetup
    static void createTestData() {

        Medicine__c medicine = new Medicine__c(
            Name = 'Test Medicine',
            Medicine_Type__c = 'Tablet',
            Manufacturer__c = 'Test Pharma',
            Unit_Price__c = 50,
            Stock_Quantity__c = 100,
            Expiry_Date__c = Date.today().addMonths(12),
            Medicine_Status__c = 'Available'
        );

        insert medicine;
    }

    @IsTest
    static void testGetMedicines() {

        Test.startTest();

        List<Medicine__c> medicines =
            MedicineService.getMedicines();

        Test.stopTest();

        System.assertEquals(1, medicines.size());
        System.assertEquals(
            'Test Medicine',
            medicines[0].Name
        );
    }
}