import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ERROR_TITLE from '@salesforce/label/c.ortoo_core_error_title';
import VALIDATION_MESSAGE from '@salesforce/label/c.ortoo_core_validation_errors_occurred';

/**
 * When bound to a Lightning Web Component, will retrieve all validateable elements
 * and ask them to report their validity (via the method 'reportValidity').
 *
 * If any fail, will report that an error has occurred and then return false.
 * Otherwise, returns true.
 *
 * Assumes that components will render validation errors themselves as per the standard components.
 *
 * @returns Boolean States if the bound LWC is regarded as valid.
 */
const reportValidity = function( options ) {

    !options && ( options = {} );

    !options.hasOwnProperty( 'showToast' ) && ( options.showToast = true );
    !options.hasOwnProperty( 'toastVariant' ) && ( options.toastVariant = 'error' );

    !options.validationErrorTitle && ( options.validationErrorTitle = ERROR_TITLE );
    !options.validationErrorMessage && ( options.validationErrorMessage = VALIDATION_MESSAGE );

    const validateableElements = this.template.querySelectorAll( '[data-validateable]' );

    if ( !validateableElements ) {
        return true;
    }

    let hasValidationError = false;
    validateableElements.forEach( thisElement => {
        if ( ! thisElement.reportValidity() ) {
            hasValidationError = true;
        }
    });

    if ( hasValidationError && options.showToast ) {
        const toastEvent = new ShowToastEvent({
            title: options.validationErrorTitle,
            message: options.validationErrorMessage,
            variant: options.toastVariant,
        });
        this.dispatchEvent( toastEvent );
    }
    return ! hasValidationError;
}

export default reportValidity;