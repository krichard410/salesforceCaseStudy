import { LightningElement, api, wire, track } from 'lwc';
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
            console.log('HEY');
            console.log(data);
        } else if(error) {
            this.error = error;
            this.productDetailInfo = undefined;
            console.log('HEY 2');
            console.log(error);
        }
    }
}