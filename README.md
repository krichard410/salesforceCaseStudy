# Salesforce Case Study : Interview

Hello! Thanks for taking the time to view my solutions for the Salesforce Case Study :) 

## Assumptions for this Case Study
While reading the case study, I made a few assumptions on how the Salesforce solution would come together:
- A contact can only have one Product (lookup) and one Home Country (lookup)
- A product detail is a child to the Product (parent), if a Product is deleted, all Product details should be deleted as well.
- I've made the ATM Fees, Card Replacement Costs, and Cost per Calendar Month as text fields, as they seem to hold different types of data
- Assuming that Product detail records will not have any duplicates (product to country)
- For modifying existing or adding products & product details, users can do this through modifying the records directly (list views or related lists) or utilizing a data loading tool

### Screenshots from the new Salesforce App

<img width="1508" alt="Screenshot 2024-08-22 at 3 17 22 PM" src="https://github.com/user-attachments/assets/314ada1a-8ad5-410b-ba1e-eadb4c76ba9f">

## Future Enhancements for this Case Study
To improve this case study solution in the future, some things I'd love to add are:
- A way to prevent duplicate Product detail records from being created
- A way to ensure that the currency data in the ATM Fees, Card Replacement Costs, and Cost per Calendar Month match the country they are tied to (for example - if the Country is FR, I want to make sure any data in the 3 fields are using Euros)
- Perhaps making the Global Value set that holds all the countries a little nicer for a user to read (for example - 'DE' as a value would show 'Germany' as a label)

## Diagrams

### Salesforce Data Model
Below I've created a diagram of the data model that shows the new objects (and some highlighted fields) and how they interact with the standard Salesforce objects.

<img width="1011" alt="Screenshot 2024-08-22 at 2 41 54 PM" src="https://github.com/user-attachments/assets/62f31d75-350e-49a1-9184-1e4a85c43d8f">

## Question 1 - LWC
 ### Solution Breakdown
 For the first question, I decided to utilize an LWC to build out a display component to show the related Contact's product details (as I prefer LWC's). This LWC grabs the related Contact record to the Case (if one is related), and grabs the Home Country and Product fields on the Contact record to find the associated Product Details record. What is displayed to the user is the Product Name, the Home Country, and the 3 fields related to that product. Like below:

 Note: If no contact is related to the Case, then the card will completely disappear from the right pane, nothing will be shown to the case agent.
 I have also made the related Apex class 'without sharing' so that any case agent will not have to add this Apex class to their security setup.
 
<img width="1506" alt="Screenshot 2024-08-22 at 2 58 49 PM" src="https://github.com/user-attachments/assets/12eaa04d-cdda-4f7e-8328-d921d5438e70">

 ### File Breakdown
 For Question 1, the files associated with this solution are listed below:
 
<img width="827" alt="Screenshot 2024-08-22 at 3 06 51 PM" src="https://github.com/user-attachments/assets/66d7cb6f-e2de-433e-a22f-7238f9739824">

 ### Limitations
 Some limitations of this LWC component are:
 - When data is updated on the Contact or the Product Details record, the Case agent would need to refresh the page to see the most up to date changes

 ### Future Enhancements
 Some things I would love to improve on this solution would be:
 - Changing the title of the LWC card component to dynamically display the Contact's Name so it's made clearer for the Case agent
 - Adding in some editing features for the LWC, to edit the field values on the go

## Question 2 - API
 ### Solution Breakdown
  For this Question, I've built out a Web Service to handle an external system interacting with Salesforce. This Web Service is built around an HTTP GET method, which will let the external system pull data from the Salesforce platform.

  Since the external system is passing a UUID (that is mapped to every contact in Salesforce), I've built the UUID to be passed in as part of the REST Path. Once a valid UUID is passed in, it will return a single object (representing the Salesforce Product Details record) back to the external system. If an invalid UUID is passed in, a 400 error response will be sent back to the user or if no Contact was found, a 404 error response will be sent back.

<img width="731" alt="Screenshot 2024-08-22 at 2 49 55 PM" src="https://github.com/user-attachments/assets/2e7b0ab0-7d29-464d-b6a1-ca6b0b4e3ad2">

 ### File Breakdown
 For Question 2, the files associated with this solution are listed below:

 Note: I've built out a utility class to hold any functions that might be used in future enhancements of this solution. There is also one test class that covers each of the 3 Apex classes.
 There is also a folder called '' that holds a .yaml file for the API specifications I built out.
 
 <img width="839" alt="Screenshot 2024-08-22 at 3 08 36 PM" src="https://github.com/user-attachments/assets/1cb87d1d-1c7f-4d37-a199-da13f2666926">

 ### Limitations
 Some limitations with this API solution are:

 ### Future Enhancements
 With this API solution, some future enhancements that would be fun to build are:
- POST, PATCH, DELETE HTTP functions within this Apex Web Service

