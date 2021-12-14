import { LightningElement, api } from 'lwc';

import cardTemplate from './viewAndEditForm-card.html';
import modalTemplate from './viewAndEditForm-modal.html';

import SAVE_LABEL from '@salesforce/label/c.ortoo_core_save';
import CANCEL_LABEL from '@salesforce/label/c.ortoo_core_cancel';
import EDIT_LABEL from '@salesforce/label/c.ortoo_core_edit';

const templates = {
    card: cardTemplate,
    modal: modalTemplate
};

/**
 * Provides a standard format for a dual mode, view and edit form, including the rendering of edit / save and cancel buttons
 */
export default class ViewAndEditForm extends LightningElement {

    @api inEditMode = false;
    @api visible = false;
    @api mode = 'card'; // TODO: enum-like, based on templates

    @api editButtonLabel   = EDIT_LABEL;
    @api cancelButtonLabel = CANCEL_LABEL;
    @api saveButtonLabel   = SAVE_LABEL;

    @api displayDensity;

    get hideModalFooter() {
        return ! this.inEditMode;
    }

    render() {
        return templates[ this.mode ];
    }

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

    handleCancelModalClick( event ) {
        const newEvent = new CustomEvent( 'cancelModal' );
        this.dispatchEvent( newEvent );
    }
}