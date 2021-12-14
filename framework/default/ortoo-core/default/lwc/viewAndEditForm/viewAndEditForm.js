import { LightningElement, api } from 'lwc';

export default class ViewAndEditForm extends LightningElement {

    @api inEditMode = false;

    // TODO: labels
    @api editButtonLabel   = 'Edit';
    @api cancelButtonLabel = 'Cancel';
    @api saveButtonLabel   = 'Save';

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