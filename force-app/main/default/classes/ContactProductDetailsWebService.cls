@RestResource(urlMapping='/Contact/ProductDetails/*')
global without sharing class ContactProductDetailsWebService {

    /*
    * Function: getProductDetails
    * Purpose:  This function parses the UUID parameters and finds the Product Details related
    * to the Contact
    */
    @HttpGet
    global static void getProductDetails(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String requestBody = req.requestBody.toString();
        String contactQuery = 'SELECT Id, Product__c, Home_Country__c FROM Contact';
        String productDetailsQuery = 'SELECT Id, N26_Product__c, N26_Product__r.Name, Country__c, Cost_per_Calendar_Month__c, Card_Replacement_Cost__c, ATM_Fee_in_other_currencies__c FROM N26_Product_Detail__c';

        try {
            String uuidParam = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            
            if(String.isNotBlank(uuidParam)){
                contactQuery += ' WHERE UUID__c=\'' + uuidParam + '\' LIMIT 1';
            } else {
                throw new CustomInvalidException('Invalid Request - UUID was not Provided in the Parameters');
            }

            List<Contact> contactRecordResults = Database.Query(contactQuery);
            if(contactRecordResults.size() == 0){
                throw new CustomNotFoundException('No Contact Record was Found');
            }

            Contact contactRecord = contactRecordResults[0];

            // Query to find the product details
            if(String.isNotBlank(contactRecord.Product__c) && String.isNotBlank(contactRecord.Home_Country__c)){
                productDetailsQuery += ' WHERE N26_Product__c=\'' + contactRecord.Product__c + '\'' + ' AND Country__c=\'' + contactRecord.Home_Country__c + '\' LIMIT 1';
            } else {
                throw new CustomNotFoundException('Unable to Find Product Details - Both Product and Home Country fields must be populated on the Contact');
            }

            List<N26_Product_Detail__c> productDetailsResults = Database.Query(productDetailsQuery);
            if(productDetailsResults.size() == 0){
                throw new CustomNotFoundException('No Product Details Record was Found for this Product and Home Country');
            }

            ContactProductDetailsResponseWrapper.ProductDetail responseBody = new ContactProductDetailsResponseWrapper.ProductDetail();
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(buildProductDetailsResponse(responseBody, productDetailsResults[0]));
        } catch(CustomNotFoundException e){
            res.statusCode = 404;
            ContactProductDetailsUtil.buildErrorResponse(e, res, 'Not Found');
        } catch(CustomInvalidException e){
            res.statusCode = 400;
            ContactProductDetailsUtil.buildErrorResponse(e, res, 'Invalid Request');
        } catch(Exception e){
            ContactProductDetailsUtil.buildErrorResponse(e, res, 'Exception');
        }
    }

    /*
    * Function: buildProductDetailsResponse
    * Purpose:  This Helper function builds up the 200 OK JSON Response for the Product Details HttpGet Method
    */
    public static String buildProductDetailsResponse(ContactProductDetailsResponseWrapper.ProductDetail responseBody, N26_Product_Detail__c productDetailsResults){        
        responseBody.homeCountry = productDetailsResults.Country__c;
        responseBody.productName = productDetailsResults.N26_Product__r.Name;
        responseBody.atmFee = productDetailsResults.ATM_Fee_in_other_currencies__c;
        responseBody.cardReplacementCost = productDetailsResults.Card_Replacement_Cost__c;
        responseBody.costPerCalendarMonth = productDetailsResults.Cost_per_Calendar_Month__c;

        return JSON.serialize(responseBody);
    }

    public class CustomInvalidException extends Exception {}
    public class CustomNotFoundException extends Exception {}

}