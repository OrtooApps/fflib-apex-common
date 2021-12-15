import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import ERROR_TITLE from '@salesforce/label/c.ortoo_core_error_title';

/**
 * When bound to a Lightning Web Component, will render the given error object.
 */
const displayError = function( error ) {

    let title = ERROR_TITLE;
    let message = error;

    console.error( error );

    if ( error.body ) {
        message = error.body.message;
    }

    const toastEvent = new ShowToastEvent({
        title: title,
        message: message,
        variant: 'error',
    });
    this.dispatchEvent( toastEvent );
}

export default displayError;