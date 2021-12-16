import { LightningElement, api } from 'lwc';
import CLOSE_LABEL from '@salesforce/label/c.ortoo_core_close';

export default class Modal extends LightningElement {
    @api visible;
    @api hideFooter = false;

    labels = {
        close: CLOSE_LABEL
    };

    dispatchCancel() {
        const event = new CustomEvent( 'cancel' );
        this.dispatchEvent( event );
    }

    handleCancel() {
        this.dispatchCancel();
    }

    handleKeyDown( event ) {
        if( event.code == 'Escape' ) {
            this.dispatchCancel();
            event.preventDefault();
            event.stopImmediatePropagation();
        }
      }
}