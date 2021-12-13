import { LightningElement, api } from 'lwc';

export default class ConfirmationDialog extends LightningElement {

    @api title;
    @api name;
    // TODO: default labels
    // TODO: consider standard variations - No / *Yes ; Cancel / *Confirm ; Cancel / *Save
    @api confirmLabel;
    @api cancelLabel;

    // The message to send back to the parent component when the confirmation button is clicked
    @api confirmMessage;

    // The message to send back to the parent component when the cancel button is clicked
    @api cancelMessage;

    @api visible;

    handleCancel( event ) {
        this.dispatchEvent( new CustomEvent( 'cancel', { detail: this.cancelMessage } ) );
    }

    handleConfirm( event ) {
        this.dispatchEvent( new CustomEvent( 'confirm', { detail: this.confirmMessage } ) );
    }
}