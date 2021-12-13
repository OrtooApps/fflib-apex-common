import { createElement } from 'lwc';
import FormattedModal from 'c/formattedModal';

describe('c-formatted-modal', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });
    it('Will use a c-modal to render the modal', () => {
        const element = createElement('c-formatted-modal', {
            is: FormattedModal
        });
        document.body.appendChild(element);
        element.visible = true;

        return Promise.resolve()
            .then( () => {
                const modal = element.shadowRoot.querySelector( 'c-modal' );
                expect( modal ).not.toBe( null );
            });
    });

    it('Will create a contents slot in the c-modal', () => {
        const element = createElement('c-formatted-modal', {
            is: FormattedModal
        });
        document.body.appendChild(element);
        element.visible = true;

        return Promise.resolve() // we need this because we set the element to visible *after* adding it to the dom.
                                 // this means we need to wait for a render cycle to complete.
            .then( () => {
                const modalContentsSlot = element.shadowRoot.querySelector( 'c-modal [slot="contents"]' );
                expect( modalContentsSlot ).not.toBe( null );
            });
    });

    it('Will populate the contents of the c-modal with slots that are exposed externally', () => {
        const element = createElement('c-formatted-modal', {
            is: FormattedModal
        });
        document.body.appendChild(element);
        element.visible = true;

        return Promise.resolve()
            .then( () => {
                const titleSlot    = element.shadowRoot.querySelector( 'c-modal [slot="contents"] slot[name="title"]' )
                const contentsSlot = element.shadowRoot.querySelector( 'c-modal [slot="contents"] slot[name="contents"]' )
                const footerSlot   = element.shadowRoot.querySelector( 'c-modal [slot="contents"] slot[name="footer"]' )
                expect( titleSlot ).not.toBe( null );
                expect( contentsSlot ).not.toBe( null );
                expect( footerSlot ).not.toBe( null );
            });
    });

    it('When the modal is set to be not visible, will not render the slots', () => {
        const element = createElement('c-formatted-modal', {
            is: FormattedModal
        });
        document.body.appendChild(element);
        element.visible = false;

        return Promise.resolve()
            .then( () => {
                const titleSlot    = element.shadowRoot.querySelector( 'c-modal [slot="contents"] slot[name="title"]' )
                const contentsSlot = element.shadowRoot.querySelector( 'c-modal [slot="contents"] slot[name="contents"]' )
                const footerSlot   = element.shadowRoot.querySelector( 'c-modal [slot="contents"] slot[name="footer"]' )
                expect( titleSlot ).toBe( null );
                expect( contentsSlot ).toBe( null );
                expect( footerSlot ).toBe( null );
            });
    });

    it('will default the modal to be non visible', () => {
        const element = createElement('c-formatted-modal', {
            is: FormattedModal
        });
        document.body.appendChild(element);

        return Promise.resolve()
            .then( () => {
                const titleSlot    = element.shadowRoot.querySelector( 'c-modal [slot="contents"] slot[name="title"]' )
                const contentsSlot = element.shadowRoot.querySelector( 'c-modal [slot="contents"] slot[name="contents"]' )
                const footerSlot   = element.shadowRoot.querySelector( 'c-modal [slot="contents"] slot[name="footer"]' )
                expect( titleSlot ).toBe( null );
                expect( contentsSlot ).toBe( null );
                expect( footerSlot ).toBe( null );
            });
    });

    it('will forward the cancel event on the c-modal, if one it issued', () => {
        const element = createElement('c-formatted-modal', {
            is: FormattedModal
        });
        element.visible = true;
        document.body.appendChild(element);

        let cancelHandler = jest.fn();
        element.addEventListener( 'cancel', cancelHandler );

        return Promise.resolve()
            .then( () => {
                const modal = element.shadowRoot.querySelector( 'c-modal' );
                modal.dispatchEvent( new CustomEvent( 'cancel' ) );
            })
            .then( () => {
                expect( cancelHandler ).toHaveBeenCalled();
            })
    });
});