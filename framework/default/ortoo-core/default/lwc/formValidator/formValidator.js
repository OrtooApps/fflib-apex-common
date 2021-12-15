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
const reportValidity = function() {

    const validateableElements = this.template.querySelectorAll( '[data-validateable]' );

    let hasValidationError = false;
    validateableElements.forEach( thisElement => {
        if ( ! thisElement.reportValidity() ) {
            hasValidationError = true;
        }
    });

    if ( hasValidationError ) {
        const toastEvent = new ShowToastEvent({
            title: ERROR_TITLE,
            message: VALIDATION_MESSAGE,
            variant: 'error',
        });
        this.dispatchEvent( toastEvent );
    }
    return ! hasValidationError;
}

export default reportValidity;