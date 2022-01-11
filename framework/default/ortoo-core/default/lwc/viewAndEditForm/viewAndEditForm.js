import { LightningElement, api } from 'lwc';
import configureElementIdGenerator from 'c/elementIdGenerator';

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

    @api editLabel   = EDIT_LABEL;
    @api cancelLabel = CANCEL_LABEL;
    @api saveLabel   = SAVE_LABEL;

    @api displayDensity;

    _mode = 'card';
    @api get mode() {
        return this._mode;
    }
    set mode( value ) {
        if ( ! templates.hasOwnProperty( value ) ) {
            let modesList = [];
            for ( let thisMode in templates ) {
                modesList.push( thisMode );
            }
            throw 'Invalid mode specified, should be one of ' + modesList.join( ', ' );
        }
        this._mode = value;
    }

    @api ortooElemIdPrefix = 'viewandeditform';

    ortooIdConfiguration = {
        modalId: '',
        editId: 'edit'
    }

    connectedCallback() {
        configureElementIdGenerator( this );
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
        const newEvent = new CustomEvent( 'cancelmodal' );
        this.dispatchEvent( newEvent );
    }
}