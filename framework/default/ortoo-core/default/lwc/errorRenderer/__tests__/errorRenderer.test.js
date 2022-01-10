import displayError from 'c/errorRenderer';

let showToastEvent = function ShowToastEvent( details ) {
    this.detail = details
};

jest.mock('lightning/platformShowToastEvent', () => ({
    ShowToastEvent: showToastEvent
}));

describe('c-error-renderer', () => {
    afterEach(() => {
    });

    it( 'When the passed error is a string, will raise a toast with the message as the given text', () => {

        console.error = jest.fn();

        let objectToRunAgainst = {
            dispatchEvent: jest.fn()
        };

        let error = 'An error string';

        displayError.call( objectToRunAgainst, error );

        expect( objectToRunAgainst.dispatchEvent ).toBeCalled();

        let dispatchedEvent = objectToRunAgainst.dispatchEvent.mock.calls[0][0];

        expect( dispatchedEvent.detail.title ).toBe( 'c.ortoo_core_error_title' );
        expect( dispatchedEvent.detail.message ).toBe( error );
        expect( dispatchedEvent.detail.variant ).toBe( 'error' );

        expect( console.error ).toHaveBeenCalledTimes( 1 );
        let reportedError = console.error.mock.calls[0][0];

        expect( reportedError ).toBe( error );
    });

    it( 'When the passed javascript error is a string, will raise a toast with the message as the error message', () => {

        console.error = jest.fn();

        let objectToRunAgainst = {
            dispatchEvent: jest.fn()
        };

        let error = {
            message: 'javascript error format'
        };

        displayError.call( objectToRunAgainst, error );

        expect( objectToRunAgainst.dispatchEvent ).toBeCalled();

        let dispatchedEvent = objectToRunAgainst.dispatchEvent.mock.calls[0][0];

        expect( dispatchedEvent.detail.title ).toBe( 'c.ortoo_core_error_title' );
        expect( dispatchedEvent.detail.message ).toBe( 'javascript error format' );
        expect( dispatchedEvent.detail.variant ).toBe( 'error' );

        expect( console.error ).toHaveBeenCalledTimes( 1 );
        let reportedError = console.error.mock.calls[0][0];

        expect( reportedError ).toBe( error );
    });

    it( 'When the passed error is an Apex exception object, will raise a toast with the message as the given text', () => {

        console.error = jest.fn();

        let objectToRunAgainst = {
            dispatchEvent: jest.fn()
        };

        let error = {
            body: {
                message: 'An error message in the body'
            }
        }

        displayError.call( objectToRunAgainst, error );

        expect( objectToRunAgainst.dispatchEvent ).toBeCalled();

        let dispatchedEvent = objectToRunAgainst.dispatchEvent.mock.calls[0][0];

        expect( dispatchedEvent.detail.title ).toBe( 'c.ortoo_core_error_title' );
        expect( dispatchedEvent.detail.message ).toBe( 'An error message in the body' );
        expect( dispatchedEvent.detail.variant ).toBe( 'error' );

        expect( console.error ).toHaveBeenCalledTimes( 1 );
        let reportedError = console.error.mock.calls[0][0];

        expect( reportedError ).toBe( error );
    });
});