import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ERROR_TITLE from '@salesforce/label/c.ortoo_core_error_title';

/**
 * When bound to a Lightning Web Component, will render the given error object.
 */
const displayError = function( error, options ) {

    const title = options?.title ? options.title : ERROR_TITLE;
    const messagePrefix = options?.messagePrefix ? options.messagePrefix + ': ' : '';
    const mode = options?.mode ? options.mode : 'sticky';
    const variant = options?.variant ? options.variant : 'error';

    // By default we assume we have a string for the error
    let message = error;

    console.error( error );

    // Javascript Errors will have message set
    if ( error.message ) {
        message = error.message;
    }

    // Apex Exceptions will have body.message set
    if ( error.body ) {
        message = error.body.message;
    }

    if ( this?.dispatchEvent == undefined ) {
        throw 'displayError called against an object with no "dispatchEvent" function defined.  Have you bound your instance by using "bind" or "call"?\n'
            + 'Error was: ' + message;
    }

    const toastEvent = new ShowToastEvent({
        title: title,
        message: messagePrefix + message,
        variant: variant,
        mode: mode,
    });
    this.dispatchEvent( toastEvent );
}

export default displayError;
