import { createElement } from 'lwc';
import SaveButtons from 'c/saveButtons';

describe('c-save-buttons', () => {
    afterEach(() => {
    });

    it( 'Will issue a cancel event when cancel button is pressed', () => {

        const element = createElement('c-save-buttons', {
            is: SaveButtons
        });

        document.body.appendChild( element );

        const cancelHandler = jest.fn();
        element.addEventListener( 'cancel', cancelHandler );

        const saveHandler = jest.fn();
        element.addEventListener( 'save', saveHandler );

        return Promise.resolve()
            .then( () => {
                const clickEvent = new CustomEvent( 'click', {} );
                return element.shadowRoot.querySelector( '[data-ortoo-elem-id="savebuttons-cancel"]' ).dispatchEvent( clickEvent );
            })
            .then( () => {
                expect( saveHandler ).not.toHaveBeenCalled();
                expect( cancelHandler ).toHaveBeenCalled();
            });
    });

    it( 'Will issue a save event when save button is pressed', () => {

        const element = createElement('c-save-buttons', {
            is: SaveButtons
        });

        document.body.appendChild( element );

        const cancelHandler = jest.fn();
        element.addEventListener( 'cancel', cancelHandler );

        const saveHandler = jest.fn();
        element.addEventListener( 'save', saveHandler );

        return Promise.resolve()
            .then( () => {
                const clickEvent = new CustomEvent( 'click', {} );
                return element.shadowRoot.querySelector( '[data-ortoo-elem-id="savebuttons-save"]' ).dispatchEvent( clickEvent );
            })
            .then( () => {
                expect( saveHandler ).toHaveBeenCalled();
                expect( cancelHandler ).not.toHaveBeenCalled();
            });
    });

    it( 'Will use the passed prefix to define the element ids', () => {

        const element = createElement('c-modal', {
            is: SaveButtons
        });
        element.visible = true;
        element.ortooElemIdPrefix = 'definedsavebuttons'

        document.body.appendChild( element );

        return Promise.resolve()
            .then( () => {
                expect( element.shadowRoot.querySelector( '[data-ortoo-elem-id="definedsavebuttons-save"]' ) ).not.toBe( null );
                expect( element.shadowRoot.querySelector( '[data-ortoo-elem-id="definedsavebuttons-cancel"]' ) ).not.toBe( null );
            })
    });
});