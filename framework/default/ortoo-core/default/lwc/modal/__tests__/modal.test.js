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

    it( 'Component is set to visible, the title, contents and footer slots are shown', () => {
        const element = createElement('c-modal', {
            is: Modal
        });
        element.visible = true;

        document.body.appendChild( element );

        const titleDiv = element.shadowRoot.querySelector( 'slot[name="title"]' );
        expect( titleDiv ).not.toBe( null );

        const contentsDiv = element.shadowRoot.querySelector( 'slot[name="contents"]' );
        expect( contentsDiv ).not.toBe( null );

        const footerDiv = element.shadowRoot.querySelector( 'slot[name="footer"]' );
        expect( footerDiv ).not.toBe( null );
    });

    it( 'Component is set to not visible, the title, contents and footer slots slots are not shown', () => {
        const element = createElement('c-modal', {
            is: Modal
        });
        element.visible = false;

        document.body.appendChild( element );

        const titleDiv = element.shadowRoot.querySelector( 'slot[name="title"]' );
        expect( titleDiv ).toBe( null );

        const contentsDiv = element.shadowRoot.querySelector( 'slot[name="contents"]' );
        expect( contentsDiv ).toBe( null );

        const footerDiv = element.shadowRoot.querySelector( 'slot[name="footer"]' );
        expect( footerDiv ).toBe( null );
    });

    it( 'Component visibility is not set, the title, contents and footer slots slots are not shown', () => {
        const element = createElement('c-modal', {
            is: Modal
        });

        document.body.appendChild( element );

        const titleDiv = element.shadowRoot.querySelector( 'slot[name="title"]' );
        expect( titleDiv ).toBe( null );

        const contentsDiv = element.shadowRoot.querySelector( 'slot[name="contents"]' );
        expect( contentsDiv ).toBe( null );

        const footerDiv = element.shadowRoot.querySelector( 'slot[name="footer"]' );
        expect( footerDiv ).toBe( null );
    });

    it( 'Will issue a cancel event when "escape" is pressed', () => {

        const element = createElement('c-modal', {
            is: Modal
        });
        element.visible = true;

        document.body.appendChild( element );

        let cancelHandler = jest.fn();
        element.addEventListener( 'cancel', cancelHandler );

        return Promise.resolve()
            .then( () => {
                const escapeKeyEvent = new KeyboardEvent( 'keydown', { code: 'Escape' } );
                return element.shadowRoot.querySelector( 'lightning-card' ).dispatchEvent( escapeKeyEvent );
            })
            .then( () => {
                expect( cancelHandler ).toHaveBeenCalled();
            });
    });
    it( 'Will issue a cancel event when "cancel cross" is pressed', () => {

        const element = createElement('c-modal', {
            is: Modal
        });
        element.visible = true;

        document.body.appendChild( element );

        let cancelHandler = jest.fn();
        element.addEventListener( 'cancel', cancelHandler );

        return Promise.resolve()
            .then( () => {
                const clickEvent = new CustomEvent( 'click', {} );
                return element.shadowRoot.querySelector( 'button[aria-id="cancel-cross"]' ).dispatchEvent( clickEvent );
            })
            .then( () => {
                expect( cancelHandler ).toHaveBeenCalled();
            });
    });


});