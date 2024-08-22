public without sharing class ContactProductDetailsUtil {
    
    /*
    * Function: buildErrorResponse
    * Purpose:  This Helper function builds up the Error JSON Responses from Exceptions
    */
    public static RestResponse buildErrorResponse(Exception e, RestResponse res, String catchExceptionError){
        
        String errorResponseBody = JSON.serialize(
            new Map<String, Object>{
                'status' => res.statusCode,
                'errors' => new List<Object>{
                    new Map<String, Object>{
                        'title' => e.getMessage(),
                        'description' => e.getStackTraceString()
                    }
                }
            }
        );

        res.responseBody = Blob.valueOf(errorResponseBody);
        return res;
    }
}