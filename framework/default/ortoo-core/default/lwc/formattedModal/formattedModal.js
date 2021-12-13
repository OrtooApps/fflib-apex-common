import { LightningElement, api } from 'lwc';

export default class FormattedModal extends LightningElement {
    @api visible;

    handleCancel() {
        this.dispatchCancel();
    }

    dispatchCancel() {
        const event = new CustomEvent( 'cancel' );
        this.dispatchEvent( event );
    }
}