import { LightningElement, api } from 'lwc';
import configureElementIdGenerator from 'c/elementIdGenerator';

import CONFIRM_LABEL from '@salesforce/label/c.ortoo_core_confirm';
import CANCEL_LABEL from '@salesforce/label/c.ortoo_core_cancel';
import YES_LABEL from '@salesforce/label/c.ortoo_core_yes';
import NO_LABEL from '@salesforce/label/c.ortoo_core_no';
import SAVE_LABEL from '@salesforce/label/c.ortoo_core_save';

const type = {
    confirm: 'confirm',
    yesNo  : 'yesNo',
    save   : 'save'
};

const buttonLabels = {
    confirm: {
        confirm: CONFIRM_LABEL,
        cancel : CANCEL_LABEL
    },
    yesNo: {
        confirm: YES_LABEL,
        cancel : NO_LABEL
    },
    save: {
        confirm: SAVE_LABEL,
        cancel : CANCEL_LABEL
    }
};
export default class ConfirmationDialog extends LightningElement {

    _type
    @api
    get type() {
        return this._type ? this._type : type.confirm;
    };
    set type( value ) {
        if ( ! type.hasOwnProperty( value ) ) {
            let typeList = [];
            for ( let thisType in type ) {
                typeList.push( type[ thisType ] );
            }
            throw 'Invalid type specified, should be one of ' + typeList.join( ', ' );
        }
        this._type = value;
    }

    _confirmLabel
    @api
    get confirmLabel() {
        return this._confirmLabel ? this._confirmLabel : buttonLabels[ this.type ].confirm;
    }
    set confirmLabel( value ) {
        this._confirmLabel = value;
    }

    _cancelLabel
    @api
    get cancelLabel() {
        return this._cancelLabel ? this._cancelLabel : buttonLabels[ this.type ].cancel;
    }
    set cancelLabel( value ) {
        this._cancelLabel = value;
    }

    // The message to send back to the parent component when the confirmation button is clicked
    @api confirmEventMessage;

    // The message to send back to the parent component when the cancel button is clicked
    @api cancelEventMessage;

    @api visible;

    @api ortooElemIdPrefix = 'confirmation';

    ortooIdConfiguration = {
        modalId: '',
        cancelId: 'cancel',
        confirmId: 'confirm',
    }

    connectedCallback() {
        configureElementIdGenerator( this );
        this.confirmLabel = this.confirmLabel ? this.confirmLabel : buttonLabels[ this.type ].confirm;
        this.cancelLabel = this.cancelLabel ? this.cancelLabel : buttonLabels[ this.type ].cancel;
    }

    handleCancel( event ) {
        this.dispatchEvent( new CustomEvent( 'cancel', { detail: this.cancelEventMessage } ) );
    }

    handleConfirm( event ) {
        this.dispatchEvent( new CustomEvent( 'confirm', { detail: this.confirmEventMessage } ) );
    }
}