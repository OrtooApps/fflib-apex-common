import { LightningElement, api } from 'lwc';
import configureElementIdGenerator from 'c/elementIdGenerator';

//import CANCEL_LABEL from '@salesforce/label/c.ortoo_core_cancel';
//import SAVE_LABEL from '@salesforce/label/c.ortoo_core_save';

const CANCEL_LABEL = 'Cancel';
const SAVE_LABEL = 'Save';
export default class SaveButtons extends LightningElement {

    @api cancelLabel = CANCEL_LABEL; // should be a label (see above)
    @api saveLabel   = SAVE_LABEL; // should be a label (see above)

    @api ortooElemIdPrefix = 'savebuttons';

    ortooIdConfiguration = {
        saveButtonId: 'save',
        cancelButtonId: 'cancel',
    }

    connectedCallback() {
        configureElementIdGenerator( this );
    }

    handleSaveClick( event ) {
        const newEvent = new CustomEvent( 'save' );
        this.dispatchEvent( newEvent );
    }

    handleCancelClick( event ) {
        const newEvent = new CustomEvent( 'cancel' );
        this.dispatchEvent( newEvent );
    }
}