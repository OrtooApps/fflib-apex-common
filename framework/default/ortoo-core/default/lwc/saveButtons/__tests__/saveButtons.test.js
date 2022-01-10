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

        let cancelHandler = jest.fn();
        element.addEventListener( 'cancel', cancelHandler );

        let saveHandler = jest.fn();
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

        let cancelHandler = jest.fn();
        element.addEventListener( 'cancel', cancelHandler );

        let saveHandler = jest.fn();
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

    /*
    it( 'Will use the passed prefix to define the element ids', () => {

        const element = createElement('c-modal', {
            is: Modal
        });
        element.visible = true;
        element.ortooElemIdPrefix = 'definedmodel'

        document.body.appendChild( element );

        return Promise.resolve()
            .then( () => {
                const clickEvent = new CustomEvent( 'click', {} );
                expect( element.shadowRoot.querySelector( '[data-ortoo-elem-id="definedmodel-closecross"]' ) ).not.toBe( null );
            })
    });
*/
    it( 'have moved other things over to these save buttons', () => {
        expect( false ).toBe( true );
    });
});