import { LightningElement, api, wire } from 'lwc';
import getProductDetails from '@salesforce/apex/ContactProductDetailsController.getProductDetails';

export default class DisplayContactProductDetails extends LightningElement {
    @api recordId;
    productDetailInfo;
    error;

    @wire(getProductDetails, { caseRecordId: '$recordId' })
    wiredRecordData({ error, data }) {
        if(data) {
            this.productDetailInfo = data;
            this.error = undefined;
        } else if(error) {
            this.error = error;
            this.productDetailInfo = undefined;
        }
    }
}