import { LightningElement, api } from 'lwc';
import configureElementIdGenerator from 'c/elementIdGenerator';

import CANCEL_LABEL from '@salesforce/label/c.ortoo_core_cancel';
import SAVE_LABEL from '@salesforce/label/c.ortoo_core_save';

/**
 * Provides a standard format for save and cancel buttons, as well as the ability to add additional ones into it.
 *
 * If the 'additional-buttons' slot is used, it should be used with:
 *      * <span slot="additional-buttons">
 *      * Buttons that have class="slds-p-around_xxx-small"
 */
export default class SaveButtons extends LightningElement {

    @api cancelLabel = CANCEL_LABEL;
    @api saveLabel   = SAVE_LABEL;

    @api disableSave;

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