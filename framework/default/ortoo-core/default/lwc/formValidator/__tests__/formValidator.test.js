import reportValidity from 'c/formValidator';

let showToastEvent = function ShowToastEvent( details ) {
    this.detail = details
};

jest.mock('lightning/platformShowToastEvent', () => ({
    ShowToastEvent: showToastEvent
}));

describe('c-form-validator', () => {
    afterEach(() => {
    });

    it( 'When called against an object, will ask it for all the data-validateable elements and then call reportValidity against each one.  If all are true, returns true', () => {

        let mockQuerySelector = jest.fn();
        let mockDispatchEvent = jest.fn();

        let objectToRunAgainst = {
            dispatchEvent: mockDispatchEvent,
            template: {
                querySelectorAll: mockQuerySelector
            }
        };

        mockQuerySelector.mockReturnValueOnce(
            [
                { reportValidity: () => true },
                { reportValidity: () => true }
            ]
        );

        let response = reportValidity.call( objectToRunAgainst );

        expect( response ).toBe( true );

        expect( mockQuerySelector ).toHaveBeenCalledTimes( 1 );
        expect( mockQuerySelector.mock.calls[0][0] ).toBe( '[data-validateable]' );

        expect( mockDispatchEvent ).not.toBeCalled();
    });

    it( 'When an element reportValidity returns false, will return false and raise a toast', () => {

        let mockQuerySelector = jest.fn();
        let mockDispatchEvent = jest.fn();

        let objectToRunAgainst = {
            dispatchEvent: mockDispatchEvent,
            template: {
                querySelectorAll: mockQuerySelector
            }
        };

        mockQuerySelector.mockReturnValueOnce(
            [
                { reportValidity: () => true },
                { reportValidity: () => false }
            ]
        );

        let response = reportValidity.call( objectToRunAgainst );

        expect( response ).toBe( false );

        expect( mockDispatchEvent ).toHaveBeenCalledTimes( 1 );

        let dispatchedEvent = mockDispatchEvent.mock.calls[0][0];

        expect( dispatchedEvent.detail.title ).toBe( 'c.ortoo_core_error_title' );
        expect( dispatchedEvent.detail.message ).toBe( 'c.ortoo_core_validation_errors_occurred' );
        expect( dispatchedEvent.detail.variant ).toBe( 'error' );
    });

    it( 'When an element reportValidity returns false, will still call against all the others', () => {
        // this ensures that every object is checked - otherwise not all errors will be reported properly

        let mockQuerySelector = jest.fn();
        let mockDispatchEvent = jest.fn();

        let objectToRunAgainst = {
            dispatchEvent: mockDispatchEvent,
            template: {
                querySelectorAll: mockQuerySelector
            }
        };

        let mockSelectorReturn = [
            { reportValidity: jest.fn().mockReturnValueOnce( true ) },
            { reportValidity: jest.fn().mockReturnValueOnce( false ) },
            { reportValidity: jest.fn().mockReturnValueOnce( false ) },
            { reportValidity: jest.fn().mockReturnValueOnce( false ) },
            { reportValidity: jest.fn().mockReturnValueOnce( true ) }
        ];

        mockQuerySelector.mockReturnValueOnce( mockSelectorReturn );

        let response = reportValidity.call( objectToRunAgainst );

        expect( response ).toBe( false );
        mockSelectorReturn.forEach( thisElement  => expect( thisElement.reportValidity ).toHaveBeenCalledTimes( 1 ) );
    });

    it( 'When an element reportValidity returns false, but options say to not show a toast, will not show a toast', () => {

        let mockQuerySelector = jest.fn();
        let mockDispatchEvent = jest.fn();

        let objectToRunAgainst = {
            dispatchEvent: mockDispatchEvent,
            template: {
                querySelectorAll: mockQuerySelector
            }
        };

        mockQuerySelector.mockReturnValueOnce(
            [
                { reportValidity: () => true },
                { reportValidity: () => false }
            ]
        );

        reportValidity.call( objectToRunAgainst, { showToast: false } );
        expect( mockDispatchEvent ).toHaveBeenCalledTimes( 0 );

    });

    it( 'When an element reportValidity returns false, and options say to show a toast, will show a toast', () => {

        let mockQuerySelector = jest.fn();
        let mockDispatchEvent = jest.fn();

        let objectToRunAgainst = {
            dispatchEvent: mockDispatchEvent,
            template: {
                querySelectorAll: mockQuerySelector
            }
        };

        mockQuerySelector.mockReturnValueOnce(
            [
                { reportValidity: () => true },
                { reportValidity: () => false }
            ]
        );

        reportValidity.call( objectToRunAgainst, { showToast: true } );
        expect( mockDispatchEvent ).toHaveBeenCalledTimes( 1 );

    });
    it( 'When an element reportValidity returns false, and given alternative error title and message, will show a toast with the specified text', () => {

        let mockQuerySelector = jest.fn();
        let mockDispatchEvent = jest.fn();

        let objectToRunAgainst = {
            dispatchEvent: mockDispatchEvent,
            template: {
                querySelectorAll: mockQuerySelector
            }
        };

        mockQuerySelector.mockReturnValueOnce(
            [
                { reportValidity: () => true },
                { reportValidity: () => false }
            ]
        );

        let customTitle = 'custom title';
        let customMessage = 'custom message';
        let customVariant = 'warning';

        let response = reportValidity.call( objectToRunAgainst, { validationErrorTitle: customTitle, validationErrorMessage: customMessage, toastVariant: customVariant } );

        expect( response ).toBe( false );

        expect( mockDispatchEvent ).toHaveBeenCalledTimes( 1 );

        let dispatchedEvent = mockDispatchEvent.mock.calls[0][0];

        expect( dispatchedEvent.detail.title ).toBe( customTitle );
        expect( dispatchedEvent.detail.message ).toBe( customMessage );
        expect( dispatchedEvent.detail.variant ).toBe( customVariant );
    });
});