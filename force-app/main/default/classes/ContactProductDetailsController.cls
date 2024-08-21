public without sharing class ContactProductDetailsController {

    /* Function: getProductDetails
    *  Purpose: This function is to get the product details depending on the Product and Home Country
    *  of the Contact record related to the current Case.
    */
    @AuraEnabled(cacheable=true)
    public static N26_Product_Detail__c getProductDetails(Id caseRecordId){
        System.debug('caseRecordId >> ' + caseRecordId);
        if(caseRecordId != null){
            Case caseRecord = [SELECT Id, ContactId, Contact.Name, Contact.Product__c, Contact.Home_Country__c FROM Case WHERE Id = :caseRecordId LIMIT 1];
            Id productId = caseRecord.Contact.Product__c;
            String homeCountry = caseRecord.Contact.Home_Country__c;
            System.debug('productId >> ' + productId);

            N26_Product_Detail__c productDetails = [SELECT Id, ATM_Fee_in_other_currencies__c, Card_Replacement_Cost__c, Cost_per_Calendar_Month__c, N26_Product__c, N26_Product__r.Name, Country__c FROM N26_Product_Detail__c WHERE Country__c =: homeCountry AND N26_Product__c =: productId LIMIT 1];
            if(productDetails != null){
                return productDetails;
            } else {
                return null;
            }
        } else {
            return null;
        }
    }

    // on the case record
    // will have the contact id
    // get the Product__ and Home_Country__c from the contact record
    // then query the N26_Product_Detail__c table for the key pair value
    // use try catch methods
}