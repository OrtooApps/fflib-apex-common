import { createElement } from 'lwc';
import Message from 'c/message';

const MESSAGE_SELECTOR = '[data-ortoo-elem-id="messagebox-message"]';
const ICON_SELECTOR = '[data-ortoo-elem-id="messagebox-icon"]';
const CONTAINER_SELECTOR = '[data-ortoo-elem-id="messagebox-container"]';

describe('c-message', () => {

    beforeEach(() => {
        const element = createElement('c-message', {
            is: Message
        });
        document.body.appendChild( element );
    });

    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it( 'Will render the message given', () => {

        const element = document.body.querySelector( 'c-message' );
        element.message = 'the message';

        return Promise.resolve()
        .then( () =>
            expect( element.shadowRoot.querySelector( MESSAGE_SELECTOR ).innerHTML ).toBe( 'the message' )
        );
    });

    it( 'When no message is set, will not render anything', () => {

        const element = document.body.querySelector( 'c-message' );

        return Promise.resolve()
        .then( () =>
            expect( element.shadowRoot.querySelector( MESSAGE_SELECTOR ) ).toBe( null )
        );
    });

    it( 'When message is set to an empty string, will not render anything', () => {

        const element = document.body.querySelector( 'c-message' );
        element.message = '';

        return Promise.resolve()
        .then( () =>
            expect( element.shadowRoot.querySelector( MESSAGE_SELECTOR ) ).toBe( null )
        );
    });

    it( 'When message is set to a blank string, will not render anything', () => {

        const element = document.body.querySelector( 'c-message' );
        element.message = '       ';

        return Promise.resolve()
        .then( () =>
            expect( element.shadowRoot.querySelector( MESSAGE_SELECTOR ) ).toBe( null )
        );
    });

    it( 'When message is set to a 0 string, will render it', () => {

        const element = document.body.querySelector( 'c-message' );
        element.message = '0';

        return Promise.resolve()
        .then( () =>
            expect( element.shadowRoot.querySelector( MESSAGE_SELECTOR ).innerHTML ).toBe( '0' )
        );
    });

    it( 'When variant is set to error, will set up an error message', () => {

        const element = document.body.querySelector( 'c-message' );
        element.message = 'unimportant';
        element.variant = 'error';

        return Promise.resolve()
        .then( () => {
            expect( element.shadowRoot.querySelector( ICON_SELECTOR ).iconName ).toBe( 'utility:error' )
            expect( element.shadowRoot.querySelector( CONTAINER_SELECTOR ).className ).toContain( 'slds-theme--error' )
        });
    });

    it( 'When variant is set to info, will set up an info message', () => {

        const element = document.body.querySelector( 'c-message' );
        element.message = 'unimportant';
        element.variant = 'info';

        return Promise.resolve()
        .then( () => {
            expect( element.shadowRoot.querySelector( ICON_SELECTOR ).iconName ).toBe( 'utility:info' )
            expect( element.shadowRoot.querySelector( CONTAINER_SELECTOR ).className ).toContain( 'slds-theme--info' )
        });
    });

    it( 'When variant is set to warning, will set up an warning message', () => {

        const element = document.body.querySelector( 'c-message' );
        element.message = 'unimportant';
        element.variant = 'warning';

        return Promise.resolve()
        .then( () => {
            expect( element.shadowRoot.querySelector( ICON_SELECTOR ).iconName ).toBe( 'utility:warning' )
            expect( element.shadowRoot.querySelector( CONTAINER_SELECTOR ).className ).toContain( 'slds-theme--warning' )
        });
    });

    it( 'When variant is set to success, will set up an success message', () => {

        const element = document.body.querySelector( 'c-message' );
        element.message = 'unimportant';
        element.variant = 'success';

        return Promise.resolve()
        .then( () => {
            expect( element.shadowRoot.querySelector( ICON_SELECTOR ).iconName ).toBe( 'utility:success' )
            expect( element.shadowRoot.querySelector( CONTAINER_SELECTOR ).className ).toContain( 'slds-theme--success' )
        });
    });
});