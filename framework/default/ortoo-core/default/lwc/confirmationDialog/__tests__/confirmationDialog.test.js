import { createElement } from 'lwc';
import ConfirmationDialog from 'c/confirmationDialog';

describe('c-confirmation-dialog', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('When set to visible, with a title, contains a div with the title, directing it to the title slot of the modal', () => {
        const element = createElement('c-confirmation-dialog', {
            is: ConfirmationDialog
        });
        element.visible = true;
        element.title = 'A title';
        document.body.appendChild(element);

        return Promise.resolve()
        .then( () => {
            const expectedElement = element.shadowRoot.querySelector( 'c-modal div[slot="title"]' );
            expect( expectedElement ).not.toBe( null );
        });
    });

    it('When set to visible, contains a div containing a message slot, directing it to the contents slot of the modal', () => {
        const element = createElement('c-confirmation-dialog', {
            is: ConfirmationDialog
        });
        element.visible = true;
        document.body.appendChild(element);

        const expectedElement = element.shadowRoot.querySelector( 'c-modal div[slot="contents"]' );
        expect( expectedElement ).not.toBe( null );
    });

    it('When set to visible and no button labels provided contains a div containing cancel and confirm buttons with the defaulted labels, directing them to the modal footer slot', () => {
        const element = createElement('c-confirmation-dialog', {
            is: ConfirmationDialog
        });
        element.visible = true;
        document.body.appendChild(element);

        const expectedElement = element.shadowRoot.querySelector( 'c-modal div[slot="footer"]' );
        expect( expectedElement ).not.toBe( null );

        expect( expectedElement.querySelector( '[data-name="confirm"]' ).getAttribute( 'title' ) ).not.toBe( null );
//        expect( expectedElement.querySelector( '[data-name="confirm"]' ).getAttribute( 'label' ) ).not.toBe( null );
        expect( expectedElement.querySelector( '[data-name="cancel"]' ).getAttribute( 'title' ) ).not.toBe( null );
//        expect( expectedElement.querySelector( '[data-name="cancel"]' ).getAttribute( 'label' ) ).not.toBe( null );
    });

    it('When set to visible, contains a div containing cancel and confirm buttons with the specified labels, directing them to the modal footer slot', () => {
        const element = createElement('c-confirmation-dialog', {
            is: ConfirmationDialog
        });
        element.confirmLabel = 'Confirm';
        element.cancelLabel  = 'Cancel';
        element.visible = true;
        document.body.appendChild(element);

        const expectedElement = element.shadowRoot.querySelector( 'c-modal div[slot="footer"]' );
        expect( expectedElement ).not.toBe( null );

        expect( expectedElement.querySelector( '[data-name="confirm"]' ).getAttribute( 'title' ) ).toBe( element.confirmLabel );
//        expect( expectedElement.querySelector( '[data-name="confirm"]' ).getAttribute( 'label' ) ).toBe( element.confirmLabel );
        expect( expectedElement.querySelector( '[data-name="cancel"]' ).getAttribute( 'title' ) ).toBe( element.cancelLabel );
//        expect( expectedElement.querySelector( '[data-name="cancel"]' ).getAttribute( 'label' ) ).toBe( element.cancelLabel );
    });

    it('Clicking the confirm button will issue an event containing the confirm event message', () => {

        const CONFIRM_MESSAGE = 'The confirm message';
        const CANCEL_MESSAGE  = 'The cancel message';

        const element = createElement('c-confirmation-dialog', {
            is: ConfirmationDialog
        });

        element.confirmLabel        = 'Confirm';
        element.confirmEventMessage = CONFIRM_MESSAGE;
        element.cancelLabel         = 'Cancel';
        element.cancelEventMessage  = CANCEL_MESSAGE;

        element.visible        = true;
        document.body.appendChild(element);

        const confirmHandler = jest.fn();
        element.addEventListener( 'confirm', confirmHandler ) ;

        const cancelHandler = jest.fn();
        element.addEventListener( 'cancel', cancelHandler ) ;

        element.shadowRoot.querySelector( '[title="Confirm"]' ).click();

        expect( confirmHandler ).toHaveBeenCalled();
        expect( confirmHandler.mock.calls[0][0].detail ).toBe( CONFIRM_MESSAGE );

        expect( cancelHandler ).not.toHaveBeenCalled();
    });

    it('Clicking the cancel button will issue an event containing the cancel event message', () => {

        const CONFIRM_MESSAGE = 'The confirm message';
        const CANCEL_MESSAGE  = 'The cancel message';

        const element = createElement('c-confirmation-dialog', {
            is: ConfirmationDialog
        });

        element.confirmLabel        = 'Confirm';
        element.confirmEventMessage = CONFIRM_MESSAGE;
        element.cancelLabel         = 'Cancel';
        element.cancelEventMessage  = CANCEL_MESSAGE;

        element.visible        = true;
        document.body.appendChild(element);

        const confirmHandler = jest.fn();
        element.addEventListener( 'confirm', confirmHandler ) ;

        const cancelHandler = jest.fn();
        element.addEventListener( 'cancel', cancelHandler ) ;

        element.shadowRoot.querySelector( '[title="Cancel"]' ).click();

        expect( cancelHandler ).toHaveBeenCalled();
        expect( cancelHandler.mock.calls[0][0].detail ).toBe( CANCEL_MESSAGE );

        expect( confirmHandler ).not.toHaveBeenCalled();
    });
});