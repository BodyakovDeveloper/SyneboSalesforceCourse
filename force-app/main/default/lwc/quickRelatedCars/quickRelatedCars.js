import { LightningElement, api, wire } from 'lwc';
import getRelatedCars from '@salesforce/apex/GarageRelatedLwc.getRelatedCars';

export default class QuickRelatedCars extends LightningElement {
    @api recordId;
    data = [];

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Brand', fieldName: 'Brand__c', type: 'text' },
        { label: 'Horse power', fieldName: 'Horse_Power__c', type: 'text' },
        { label: 'Price', fieldName: 'Price__c', type: 'text' },
    ];


    @wire (getRelatedCars) wiredAccounts({data,error}){
        if (data) {
            this.data = data;
            console.log(data); 
        } else if (error) {
            console.log(error);
        }
   }
}