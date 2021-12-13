import { LightningElement, api } from 'lwc';

import CONFIRM_LABEL from '@salesforce/label/c.ortoo_core_confirm';
import CANCEL_LABEL from '@salesforce/label/c.ortoo_core_cancel';

export default class ConfirmationDialog extends LightningElement {

    // TODO: consider standard variations - No / *Yes ; Cancel / *Confirm ; Cancel / *Save
        // yesNoConfirmationDialog
        // saveConfirmationDialog
    @api confirmLabel = CONFIRM_LABEL;
    @api cancelLabel  = CANCEL_LABEL;

    // The message to send back to the parent component when the confirmation button is clicked
    @api confirmEventMessage;

    // The message to send back to the parent component when the cancel button is clicked
    @api cancelEventMessage;

    @api visible;

    handleCancel( event ) {
        this.dispatchEvent( new CustomEvent( 'cancel', { detail: this.cancelEventMessage } ) );
    }

    handleConfirm( event ) {
        this.dispatchEvent( new CustomEvent( 'confirm', { detail: this.confirmEventMessage } ) );
    }
}