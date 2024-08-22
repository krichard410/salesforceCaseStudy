@isTest
private class ContactProductDetailsWebServiceTest {

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
        testContactRecord.UUID__c = '650e8400-e29b-41d4-a716-446655440000';
        Database.insert(testContactRecord);
    }

    /*
    * Function: getContactProductDetailsByUUID
    * Purpose:  This test method tests getting product details by using a contact UUID
    */
    @isTest
    static void getContactProductDetailsByUUID() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Contact/ProductDetails/650e8400-e29b-41d4-a716-446655440000';
        req.httpMethod = 'GET';
        req.requestBody = Blob.valueOf('');

        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();

        ContactProductDetailsWebService.getProductDetails();

        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(res.responseBody.toString());

        Assert.areEqual(200, res.statusCode, 'The Response Status Code should be 200.');

        // Asserting each value from the JSON response matches what is on the Product Details Record
        Assert.areEqual('Black - Apex Testing Only', responseMap.get('productName'), 'The Product Name in the JSON response should match the Product Name SF value.');
        Assert.areEqual('DE', responseMap.get('homeCountry'), 'The Home Country in the JSON response should match the Home Country SF value.');
        Assert.areEqual('€ 9,90', responseMap.get('costPerCalendarMonth'), 'The Cost per Calendar Month in the JSON response should match the Cost per Calendar Month SF value.');
        Assert.areEqual('€ 6', responseMap.get('cardReplacementCost'), 'The Card Replacement Cost in the JSON response should match the Card Replacement Cost SF value.');
        Assert.areEqual('Free', responseMap.get('atmFee'), 'The ATM Fee in the JSON response should match the ATM Fee SF value.');

        Test.stopTest();
    }

    /*
    * Function: getContactProductDetailsByUUID
    * Purpose:  This test method tests getting a 400 error for not passing in any UUID
    */
    @isTest
    static void getContactProductDetailsNoUUID() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Contact/ProductDetails/';
        req.httpMethod = 'GET';
        req.requestBody = Blob.valueOf('');

        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();

        ContactProductDetailsWebService.getProductDetails();

        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(res.responseBody.toString());

        Assert.areEqual(400, res.statusCode, 'The Response Status Code should be 400.');
        Assert.areNotEqual(null, responseMap, 'There should have been an error response sent back.');

        Test.stopTest();
    }

    /*
    * Function: getContactProductDetailsNoMatchingUUID
    * Purpose:  This test method tests getting a 404 error by passing in a UUID that doesn't match to any SF Contact
    */
    @isTest
    static void getContactProductDetailsNoMatchingUUID() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Contact/ProductDetails/880e8400-e29b-41d4-a716-446655440000';
        req.httpMethod = 'GET';
        req.requestBody = Blob.valueOf('');

        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();

        ContactProductDetailsWebService.getProductDetails();

        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(res.responseBody.toString());

        Assert.areEqual(404, res.statusCode, 'The Response Status Code should be 404.');
        Assert.areNotEqual(null, responseMap, 'There should have been an error response sent back.');

        Test.stopTest();
    }

    /*
    * Function: getContactProductDetailsNoHomeCountryContact
    * Purpose:  This test method tests getting a 404 exception error due to missing Home Country on the Contact
    */
    @isTest
    static void getContactProductDetailsNoHomeCountryContact() {

        Contact testContactRecord = [SELECT Id FROM Contact WHERE FirstName = 'Ms. Testing Apex' LIMIT 1];
        testContactRecord.Home_Country__c = '';
        Database.update(testContactRecord);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Contact/ProductDetails/650e8400-e29b-41d4-a716-446655440000';
        req.httpMethod = 'GET';
        req.requestBody = Blob.valueOf('');

        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();

        ContactProductDetailsWebService.getProductDetails();

        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(res.responseBody.toString());

        Assert.areEqual(404, res.statusCode, 'The Response Status Code should be 404 (Missing Contact Home Country value).');

        Test.stopTest();
    }

    /*
    * Function: getContactProductDetailsNoProductDetails
    * Purpose:  This test method tests getting a 404 exception error due to missing Product Details record
    */
    @isTest
    static void getContactProductDetailsNoProductDetails() {

        N26_Product__c testProduct = [SELECT Id FROM N26_Product__c WHERE Name = 'Black - Apex Testing Only' LIMIT 1];
        N26_Product_Detail__c testProductDetailRecord = [SELECT Id FROM N26_Product_Detail__c WHERE Country__c = 'DE' AND N26_Product__c =: testProduct.Id LIMIT 1];
        Database.delete(testProductDetailRecord);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Contact/ProductDetails/650e8400-e29b-41d4-a716-446655440000';
        req.httpMethod = 'GET';
        req.requestBody = Blob.valueOf('');

        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();

        ContactProductDetailsWebService.getProductDetails();

        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(res.responseBody.toString());

        Assert.areEqual(404, res.statusCode, 'The Response Status Code should be 404 (No Product Detail Record found).');

        Test.stopTest();
    }
}