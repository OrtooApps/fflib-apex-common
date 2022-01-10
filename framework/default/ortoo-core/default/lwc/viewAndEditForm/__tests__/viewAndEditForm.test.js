import { createElement } from 'lwc';
import ViewAndEditForm from 'c/viewAndEditForm';

describe('c-view-and-edit-form', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('When visible card and inEditMode, has a save and cancel button, but no edit', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.visible = true;
        element.inEditMode = true;
        document.body.appendChild(element);

        const saveButtons = element.shadowRoot.querySelector( 'c-save-buttons' );
        expect( saveButtons ).not.toBe( null );

        const editButton = element.shadowRoot.querySelector( '[data-name="edit"]' );
        expect( editButton ).toBe( null );

        const additionalViewButtons = element.shadowRoot.querySelector( 'slot[name="additional-view-buttons"' );
        expect( additionalViewButtons ).toBe( null );
    });

    it('When visible card and not inEditMode, has an edit button, but no  save or cancel', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.visible = true;
        element.inEditMode = false;
        document.body.appendChild(element);

        const saveButtons = element.shadowRoot.querySelector( 'c-save-buttons' );
        expect( saveButtons ).toBe( null );

        const editButton = element.shadowRoot.querySelector( '[data-name="edit"]' );
        expect( editButton ).not.toBe( null );

        const additionalViewButtons = element.shadowRoot.querySelector( 'slot[name="additional-view-buttons"' );
        expect( additionalViewButtons ).not.toBe( null );
    });

    it('When visible card and inEditMode, has an editForm slot but no viewForm slot', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.visible = true;
        element.inEditMode = true;
        document.body.appendChild(element);

        const viewForm = element.shadowRoot.querySelector( 'slot[name="view-form"]' );
        expect( viewForm ).toBe( null );

        const editForm = element.shadowRoot.querySelector( 'slot[name="edit-form"]' );
        expect( editForm ).not.toBe( null );
    });

    it('When visible card and not inEditMode, has a viewForm slot but no editForm slot', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.visible = true;
        element.inEditMode = false;
        document.body.appendChild(element);

        const viewForm = element.shadowRoot.querySelector( 'slot[name="view-form"]' );
        expect( viewForm ).not.toBe( null );

        const editForm = element.shadowRoot.querySelector( 'slot[name="edit-form"]' );
        expect( editForm ).toBe( null );
    });

    it('When visible card, and inEditMode, clicking save will issue a save event', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.visible = true;
        element.inEditMode = true;
        document.body.appendChild(element);

        let eventHandler = jest.fn();
        element.addEventListener( 'save', eventHandler );

        return Promise.resolve()
            .then( () => {
                const saveEvent = new CustomEvent( 'save', {} );
                return element.shadowRoot.querySelector( 'c-save-buttons' ).dispatchEvent( saveEvent );
            })
            .then( () => {
                expect( eventHandler ).toBeCalled();
            })
    });

    it('When visible card, and inEditMode, clicking cancel will issue a cancel event', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.visible = true;
        element.inEditMode = true;
        document.body.appendChild(element);

        let eventHandler = jest.fn();
        element.addEventListener( 'cancel', eventHandler );

        return Promise.resolve()
            .then( () => {
                const cancelEvent = new CustomEvent( 'cancel', {} );
                return element.shadowRoot.querySelector( 'c-save-buttons' ).dispatchEvent( cancelEvent );
            })
            .then( () => {
                expect( eventHandler ).toBeCalled();
            })
    });

    it('When visible card, and not inEditMode, clicking edit will issue a edit event', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.visible = true;
        element.inEditMode = false;
        document.body.appendChild(element);

        let eventHandler = jest.fn();
        element.addEventListener( 'edit', eventHandler );

        return Promise.resolve()
            .then( () => {
                const clickEvent = new CustomEvent( 'click', {} );
                return element.shadowRoot.querySelector( '[data-name="edit"]' ).click();
            })
            .then( () => {
                expect( eventHandler ).toBeCalled();
            })
    });

    it('When visible modal and inEditMode, has a save and cancel button, but no edit', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.visible = true;
        element.inEditMode = true;
        element.mode = 'modal';
        document.body.appendChild(element);

        const saveButtons = element.shadowRoot.querySelector( 'c-save-buttons' );
        expect( saveButtons ).not.toBe( null );

        const editButton = element.shadowRoot.querySelector( '[data-name="edit"]' );
        expect( editButton ).toBe( null );

        const additionalViewButtons = element.shadowRoot.querySelector( 'slot[name="additional-view-buttons"' );
        expect( additionalViewButtons ).toBe( null );
    });

    it('When visible modal and not inEditMode, has an edit button, but no save or cancel', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.visible = true;
        element.inEditMode = false;
        element.mode = 'modal';
        document.body.appendChild(element);

        const saveButtons = element.shadowRoot.querySelector( 'c-save-buttons' );
        expect( saveButtons ).toBe( null );

        const editButton = element.shadowRoot.querySelector( '[data-name="edit"]' );
        expect( editButton ).not.toBe( null );

        const additionalViewButtons = element.shadowRoot.querySelector( 'slot[name="additional-view-buttons"' );
        expect( additionalViewButtons ).not.toBe( null );
    });

    it('When visible modal and inEditMode, has an editForm slot but no viewForm slot', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.visible = true;
        element.inEditMode = true;
        element.mode = 'modal';
        document.body.appendChild(element);

        const viewForm = element.shadowRoot.querySelector( 'slot[name="view-form"]' );
        expect( viewForm ).toBe( null );

        const editForm = element.shadowRoot.querySelector( 'slot[name="edit-form"]' );
        expect( editForm ).not.toBe( null );
    });

    it('When visible modal and not inEditMode, has a viewForm slot but no editForm slot', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.visible = true;
        element.inEditMode = false;
        element.mode = 'modal';
        document.body.appendChild(element);

        const viewForm = element.shadowRoot.querySelector( 'slot[name="view-form"]' );
        expect( viewForm ).not.toBe( null );

        const editForm = element.shadowRoot.querySelector( 'slot[name="edit-form"]' );
        expect( editForm ).toBe( null );
    });

    it('When visible modal, and inEditMode, clicking save will issue a save event', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.mode = 'modal';
        element.visible = true;
        element.inEditMode = true;
        document.body.appendChild(element);

        let eventHandler = jest.fn();
        element.addEventListener( 'save', eventHandler );

        return Promise.resolve()
            .then( () => {
                const saveEvent = new CustomEvent( 'save', {} );
                return element.shadowRoot.querySelector( 'c-save-buttons' ).dispatchEvent( saveEvent );
            })
            .then( () => {
                expect( eventHandler ).toBeCalled();
            })
    });

    it('When visible modal, and inEditMode, clicking cancel will issue a cancel event', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.mode = 'modal';
        element.visible = true;
        element.inEditMode = true;
        document.body.appendChild(element);

        let eventHandler = jest.fn();
        element.addEventListener( 'cancel', eventHandler );

        return Promise.resolve()
            .then( () => {
                const cancelEvent = new CustomEvent( 'cancel', {} );
                return element.shadowRoot.querySelector( 'c-save-buttons' ).dispatchEvent( cancelEvent );
            })
            .then( () => {
                expect( eventHandler ).toBeCalled();
            })
    });

    it('When visible modal, and not inEditMode, clicking edit will issue a edit event', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.mode = 'modal';
        element.visible = true;
        element.inEditMode = false;
        document.body.appendChild(element);

        let eventHandler = jest.fn();
        element.addEventListener( 'edit', eventHandler );

        return Promise.resolve()
            .then( () => {
                const clickEvent = new CustomEvent( 'click', {} );
                return element.shadowRoot.querySelector( '[data-name="edit"]' ).click();
            })
            .then( () => {
                expect( eventHandler ).toBeCalled();
            })
    });

    it('When configured with an invalid mode, will throw an error', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });

        expect( () => element.mode = 'invalid' ).toThrowError( 'Invalid mode specified, should be one of card, modal' );
    });
});