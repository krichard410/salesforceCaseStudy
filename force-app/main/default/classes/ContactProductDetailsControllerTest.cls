@isTest
public class ContactProductDetailsControllerTest {

    @TestSetup
    public static void createTestData(){

        N26_Product__c testProduct = new N26_Product__c();
        testProduct.Name = 'Black - Apex Testing Only';
        testProduct.N26_Product_Description__c = 'Black Product Description - Apex Testing Only';
        Database.insert(testProduct);

        N26_Product_Detail__c testProductDetails = new N26_Product_Detail__c();
        testProductDetails.N26_Product__c = testProduct.Id;
        testProductDetails.Country__c = 'DE';
        testProductDetails.Cost_per_Calendar_Month__c = '€ 9,90';
        testProductDetails.Card_Replacement_Cost__c = '€ 6';
        testProductDetails.ATM_Fee_in_other_currencies__c = 'Free';
        Database.insert(testProductDetails);

        Contact testContactRecord = new Contact();
        testContactRecord.FirstName = 'Ms. Testing Apex';
        testContactRecord.LastName = 'Contact';
        testContactRecord.Product__c = testProduct.Id;
        testContactRecord.Home_Country__c = 'DE';
        Database.insert(testContactRecord);

        Case testCaseRecord = new Case();
        testCaseRecord.Subject = 'Test Case';
        testCaseRecord.Status = 'New';
        testCaseRecord.Origin = 'Email';
        testCaseRecord.ContactId = testContactRecord.Id;
        Database.insert(testCaseRecord);
    }

    /*
    * Function: GetProductDetailsTest
    * Purpose:  This test method tests for getting the data succesfully using a proper contactId value
    */
    @isTest
    public static void GetProductDetailsTest() {
        Test.startTest();

        Contact testContactRecord = [SELECT Id FROM Contact WHERE FirstName = 'Ms. Testing Apex' LIMIT 1];
        Case testCaseRecord = [SELECT Id FROM Case WHERE ContactId =: testContactRecord.Id LIMIT 1];

        N26_Product_Detail__c returnedProductDetail = ContactProductDetailsController.getProductDetails(testCaseRecord.Id);
        
        Assert.areNotEqual(null, returnedProductDetail, 'There should have been a Product Detail record returned.');
        Assert.areEqual('DE', returnedProductDetail.Country__c, 'The Product Detail record should have DE as the Country.');

        Test.stopTest();
    }

    /*
    * Function: GetProductDetailsNoProductDetailTest
    * Purpose:  This test method tests the error handling (with no product detail record that exists)
    */
    @isTest
    public static void GetProductDetailsNoProductDetailTest() {
        Test.startTest();
 
        N26_Product__c testProduct = [SELECT Id FROM N26_Product__c WHERE Name = 'Black - Apex Testing Only' LIMIT 1];
        N26_Product_Detail__c testProductDetailRecord = [SELECT Id FROM N26_Product_Detail__c WHERE Country__c = 'DE' AND N26_Product__c =: testProduct.Id LIMIT 1];
        Database.delete(testProductDetailRecord);

        Contact testContactRecord = [SELECT Id FROM Contact WHERE FirstName = 'Ms. Testing Apex' LIMIT 1];
        Case testCaseRecord = [SELECT Id FROM Case WHERE ContactId =: testContactRecord.Id LIMIT 1];

        N26_Product_Detail__c returnedProductDetail = ContactProductDetailsController.getProductDetails(testCaseRecord.Id);
        Assert.areEqual(null, returnedProductDetail, 'There should have been no Product Detail record returned.');  

        Test.stopTest();
    }

    /*
    * Function: GetProductDetailsNoHomeCountryTest
    * Purpose:  This test method tests the error handling (by setting the Home Country on the Contact to empty)
    */
    @isTest
    public static void GetProductDetailsNoHomeCountryTest() {
        Test.startTest();

        Contact testContactRecord = [SELECT Id FROM Contact WHERE FirstName = 'Ms. Testing Apex' LIMIT 1];
        testContactRecord.Home_Country__c = '';
        Database.update(testContactRecord);

        Case testCaseRecord = [SELECT Id FROM Case WHERE ContactId =: testContactRecord.Id LIMIT 1];

        N26_Product_Detail__c returnedProductDetail = ContactProductDetailsController.getProductDetails(testCaseRecord.Id);
        
        Assert.areEqual(null, returnedProductDetail, 'There should have been no Product Detail record returned.');  

        Test.stopTest();
    }
}