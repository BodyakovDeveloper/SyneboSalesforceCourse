import { LightningElement,track} from 'lwc';
import POST_OBJECT from '@salesforce/schema/Placeholder_Post__c';
import NAME_FIELD from '@salesforce/schema/Placeholder_Post__c.Name';
import POST_ID_FIELD from '@salesforce/schema/Placeholder_Post__c.Post_Id__c';
import USER_ID_FIELD from '@salesforce/schema/Placeholder_Post__c.User_Id__c';
import TITLE_FIELD from '@salesforce/schema/Placeholder_Post__c.Title__c';
import BODY_FIELD from '@salesforce/schema/Placeholder_Post__c.Body__c';

import createPost from '@salesforce/apex/CreatePost.createPost';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreatePost extends LightningElement {
    @track customFormModal = false; 
    
    @track name = NAME_FIELD;
    @track postId = POST_ID_FIELD;
    @track userId = USER_ID_FIELD;
    @track title = TITLE_FIELD;
    @track body = BODY_FIELD;

    rec = {
        Name : this.name,
        Post_Id__c : this.postId,
        User_Id__c : this.userId,
        Title__c : this.title,
        Body__c : this.body
    }

    customShowModalPopup() {            
        this.customFormModal = true;
    }
 
    customHideModalPopup() {    
        this.customFormModal = false;
    }
 
    handleName(event) {
        this.rec.Name = event.target.value;
    }

    handleUserId(event) {
        this.rec.User_Id__c = event.target.value;
    }

    handlePostId(event) {
        this.rec.Post_Id__c = event.target.value;
    }

    handleTitle(event) {
        this.rec.Title__c = event.target.value;
    }

    handleBody(event) {
        this.rec.Body__c = event.target.value;
    }

    handleClick() {
        createPost({ post : this.rec })
            .then(result => {
                this.message = result;
                this.error = undefined;
                if(this.message !== undefined) {
                    this.rec.Name = '';
                    this.rec.Post_Id__c = '';
                    this.rec.User_Id__c = '';
                    this.rec.Title__c = '';
                    this.rec.Body__c = '';

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Account created Succesfully',
                            variant: 'success',
                        }),
                    );
                }
                this.customFormModal = false;
                console.log(JSON.stringify(result));
                console.log("result", this.message);

            })
            .catch(error => {
                this.message = undefined;
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Failed to Insert record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
                console.log("error", JSON.stringify(this.error));
            });
    }
}