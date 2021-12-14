import { LightningElement, api } from 'lwc';

import SAVE_LABEL from '@salesforce/label/c.ortoo_core_save';
import CANCEL_LABEL from '@salesforce/label/c.ortoo_core_cancel';
import EDIT_LABEL from '@salesforce/label/c.ortoo_core_edit';

/**
 * Provides a standard format for a dual mode, view and edit form, including the rendering of edit / save and cancel buttons
 */
export default class ViewAndEditForm extends LightningElement {

    @api inEditMode = false;

    @api editButtonLabel   = EDIT_LABEL;
    @api cancelButtonLabel = CANCEL_LABEL;
    @api saveButtonLabel   = SAVE_LABEL;

    @api displayDensity;

    handleSaveClick( event ) {
        const newEvent = new CustomEvent( 'save' );
        this.dispatchEvent( newEvent );
    }

    handleEditClick( event ) {
        const newEvent = new CustomEvent( 'edit' );
        this.dispatchEvent( newEvent );
    }

    handleCancelClick( event ) {
        const newEvent = new CustomEvent( 'cancel' );
        this.dispatchEvent( newEvent );
    }
}