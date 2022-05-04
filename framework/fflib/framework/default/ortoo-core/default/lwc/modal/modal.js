import { LightningElement, api } from 'lwc';
import configureElementIdGenerator from 'c/elementIdGenerator';

import CLOSE_LABEL from '@salesforce/label/c.ortoo_core_close';
export default class Modal extends LightningElement {
    @api visible;
    @api hideFooter = false;

    labels = {
        close: CLOSE_LABEL
    };

    @api ortooElemIdPrefix = 'modal';

    ortooIdConfiguration = {
        closeCrossId: 'closecross',
    }

    connectedCallback() {
        configureElementIdGenerator( this );
    }

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