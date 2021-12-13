import { createElement } from 'lwc';
import Modal from 'c/modal';

describe('c-modal', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    // TODO: test the cancel event

    it( 'Component is set to visible, the contents slot is shown', () => {
        const element = createElement('c-modal', {
            is: Modal
        });
        element.visible = true;

        document.body.appendChild( element );

        const div = element.shadowRoot.querySelector( 'slot[name="contents"]' );
        expect( div ).not.toBe( null );
    });

    it( 'Component is set to not visible, the contents slot is not shown', () => {
        const element = createElement('c-modal', {
            is: Modal
        });
        element.visible = false;

        document.body.appendChild( element );

        const div = element.shadowRoot.querySelector( 'slot[name="contents"]' );
        expect( div ).toBe( null );
    });

    it( 'Component visibility is not set, the contents slot is not shown', () => {
        const element = createElement('c-modal', {
            is: Modal
        });

        document.body.appendChild( element );

        const div = element.shadowRoot.querySelector( 'slot[name="contents"]' );
        expect( div ).toBe( null );
    });
});