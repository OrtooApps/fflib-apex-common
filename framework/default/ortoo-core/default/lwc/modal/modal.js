import { LightningElement, api } from 'lwc';

export default class Modal extends LightningElement {
    @api visible;

    dispatchCancel() {
        const event = new CustomEvent( 'cancel' );
        this.dispatchEvent( event );
    }

    handleCancel() {
        this.dispatchCancel();
    }

    // Ideally the modal would auto-focus on launch
    handleKeyDown( event ) {
        if( event.code == 'Escape' ) {
            this.dispatchCancel();
            event.preventDefault();
            event.stopImmediatePropagation();
        }
      }
}