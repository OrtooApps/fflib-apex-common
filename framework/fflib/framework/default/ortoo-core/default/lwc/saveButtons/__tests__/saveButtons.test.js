import { createElement } from 'lwc';
import SaveButtons from 'c/saveButtons';

const SAVE_BUTTON_SELECTOR = '[data-ortoo-elem-id="savebuttons-save"]';
const CANCEL_BUTTON_SELECTOR = '[data-ortoo-elem-id="savebuttons-cancel"]';

describe('c-save-buttons', () => {

    beforeEach(() => {
        const element = createElement('c-save-buttons', {
            is: SaveButtons
        });
        document.body.appendChild( element );
    });

    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it( 'Will issue a cancel event when cancel button is pressed', () => {

        const element = document.body.querySelector( 'c-save-buttons' );

        const cancelHandler = jest.fn();
        element.addEventListener( 'cancel', cancelHandler );

        const saveHandler = jest.fn();
        element.addEventListener( 'save', saveHandler );

        return Promise.resolve()
            .then( () => {
                const clickEvent = new CustomEvent( 'click', {} );
                return element.shadowRoot.querySelector( CANCEL_BUTTON_SELECTOR ).dispatchEvent( clickEvent );
            })
            .then( () => {
                expect( saveHandler ).not.toHaveBeenCalled();
                expect( cancelHandler ).toHaveBeenCalled();
            });
    });

    it( 'Will issue a save event when save button is pressed', () => {

        const element = document.body.querySelector( 'c-save-buttons' );

        const cancelHandler = jest.fn();
        element.addEventListener( 'cancel', cancelHandler );

        const saveHandler = jest.fn();
        element.addEventListener( 'save', saveHandler );

        return Promise.resolve()
            .then( () => {
                const clickEvent = new CustomEvent( 'click', {} );
                return element.shadowRoot.querySelector( SAVE_BUTTON_SELECTOR ).dispatchEvent( clickEvent );
            })
            .then( () => {
                expect( saveHandler ).toHaveBeenCalled();
                expect( cancelHandler ).not.toHaveBeenCalled();
            });
    });

    it( 'Has an additional-buttons slot', () => {

        const element = document.body.querySelector( 'c-save-buttons' );

        return Promise.resolve()
            .then( () => {
                const additionalButtonsSlot = element.shadowRoot.querySelector( 'slot[name="additional-buttons"]');
                expect( additionalButtonsSlot ).not.toBeNull();
            });
    })

    it( 'Will use the passed prefix to define the element ids', () => {

        const element = document.body.querySelector( 'c-save-buttons' );

        element.visible = true;
        element.ortooElemIdPrefix = 'definedsavebuttons'

        return Promise.resolve()
            .then( () => {
                expect( element.shadowRoot.querySelector( '[data-ortoo-elem-id="definedsavebuttons-save"]' ) ).not.toBe( null );
                expect( element.shadowRoot.querySelector( '[data-ortoo-elem-id="definedsavebuttons-cancel"]' ) ).not.toBe( null );
            })
    });

    it( 'When given a saveLabel, will use it for the save button', () => {

        const element = document.body.querySelector( 'c-save-buttons' );

        element.visible = true;
        element.saveLabel = 'Save it!';

        return Promise.resolve()
            .then( () => {
                expect( element.shadowRoot.querySelector( SAVE_BUTTON_SELECTOR ).label ).toBe( 'Save it!' );
                expect( element.shadowRoot.querySelector( CANCEL_BUTTON_SELECTOR ).label ).not.toBe( 'Save it!' );
            })
    });

    it( 'When given a cancelLabel, will use it for the cancel button', () => {

        const element = document.body.querySelector( 'c-save-buttons' );

        element.visible = true;
        element.cancelLabel = 'Cancel it!';

        return Promise.resolve()
            .then( () => {
                expect( element.shadowRoot.querySelector( SAVE_BUTTON_SELECTOR ).label ).not.toBe( 'Cancel it!' );
                expect( element.shadowRoot.querySelector( CANCEL_BUTTON_SELECTOR ).label ).toBe( 'Cancel it!' );
            })
    });

    it( 'When not given labels, will default them', () => {

        const element = document.body.querySelector( 'c-save-buttons' );

        element.visible = true;

        return Promise.resolve()
            .then( () => {
                expect( element.shadowRoot.querySelector( SAVE_BUTTON_SELECTOR ).label ).not.toBeFalsy();
                expect( element.shadowRoot.querySelector( CANCEL_BUTTON_SELECTOR ).label ).not.toBeFalsy();
            })
    });

    it( 'When told to disable the save button, will disable it', () => {

        const element = document.body.querySelector( 'c-save-buttons' );

        element.visible = true;
        element.disableSave = true;

        return Promise.resolve()
            .then( () => {
                expect( element.shadowRoot.querySelector( SAVE_BUTTON_SELECTOR ).disabled ).toBe( true );
                expect( element.shadowRoot.querySelector( CANCEL_BUTTON_SELECTOR ).disabled ).not.toBe( true );
            })
    });

    it( 'When told to not disable the save button, will not disable it', () => {

        const element = document.body.querySelector( 'c-save-buttons' );

        element.visible = true;
        element.disableSave = false;

        return Promise.resolve()
            .then( () => {
                expect( element.shadowRoot.querySelector( SAVE_BUTTON_SELECTOR ).disabled ).not.toBe( true );
                expect( element.shadowRoot.querySelector( CANCEL_BUTTON_SELECTOR ).disabled ).not.toBe( true );
            })
    });
});