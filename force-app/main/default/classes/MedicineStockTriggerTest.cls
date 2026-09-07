@IsTest
private class MedicineStockTriggerTest {

    @IsTest
    static void testAvailableMedicine() {

        Medicine__c medicine = new Medicine__c(
            Name = 'Test Available Medicine',
            Medicine_Type__c = 'Tablet',
            Manufacturer__c = 'Test Pharma',
            Unit_Price__c = 50,
            Stock_Quantity__c = 50,
            Expiry_Date__c = Date.today().addMonths(12)
        );

        Test.startTest();
        insert medicine;
        Test.stopTest();

        Medicine__c result = [
            SELECT Medicine_Status__c
            FROM Medicine__c
            WHERE Id = :medicine.Id
        ];

        System.assertEquals(
            'Available',
            result.Medicine_Status__c
        );
    }


    @IsTest
    static void testLowStockMedicine() {

        Medicine__c medicine = new Medicine__c(
            Name = 'Test Low Stock Medicine',
            Medicine_Type__c = 'Tablet',
            Manufacturer__c = 'Test Pharma',
            Unit_Price__c = 50,
            Stock_Quantity__c = 5,
            Expiry_Date__c = Date.today().addMonths(12)
        );

        Test.startTest();
        insert medicine;
        Test.stopTest();

        Medicine__c result = [
            SELECT Medicine_Status__c
            FROM Medicine__c
            WHERE Id = :medicine.Id
        ];

        System.assertEquals(
            'Low Stock',
            result.Medicine_Status__c
        );
    }


    @IsTest
    static void testOutOfStockMedicine() {

        Medicine__c medicine = new Medicine__c(
            Name = 'Test Out Of Stock Medicine',
            Medicine_Type__c = 'Tablet',
            Manufacturer__c = 'Test Pharma',
            Unit_Price__c = 50,
            Stock_Quantity__c = 0,
            Expiry_Date__c = Date.today().addMonths(12)
        );

        Test.startTest();
        insert medicine;
        Test.stopTest();

        Medicine__c result = [
            SELECT Medicine_Status__c
            FROM Medicine__c
            WHERE Id = :medicine.Id
        ];

        System.assertEquals(
            'Out of Stock',
            result.Medicine_Status__c
        );
    }
}