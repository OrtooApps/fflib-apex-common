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

        const saveButton = element.shadowRoot.querySelector( '[data-name="save"]' );
        expect( saveButton ).not.toBe( null );

        const cancelButton = element.shadowRoot.querySelector( '[data-name="cancel"]' );
        expect( cancelButton ).not.toBe( null );

        const editButton = element.shadowRoot.querySelector( '[data-name="edit"]' );
        expect( editButton ).toBe( null );

        const additionalViewButtons = element.shadowRoot.querySelector( 'slot[name="additionalViewButtons"' );
        expect( additionalViewButtons ).toBe( null );

        const additionalEditButtons = element.shadowRoot.querySelector( 'slot[name="additionalEditButtons"' );
        expect( additionalEditButtons ).not.toBe( null );
    });

    it('When visible card and not inEditMode, has an edit button, but no  save or cancel', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.visible = true;
        element.inEditMode = false;
        document.body.appendChild(element);

        const saveButton = element.shadowRoot.querySelector( '[data-name="save"]' );
        expect( saveButton ).toBe( null );

        const cancelButton = element.shadowRoot.querySelector( '[data-name="cancel"]' );
        expect( cancelButton ).toBe( null );

        const editButton = element.shadowRoot.querySelector( '[data-name="edit"]' );
        expect( editButton ).not.toBe( null );

        const additionalViewButtons = element.shadowRoot.querySelector( 'slot[name="additionalViewButtons"' );
        expect( additionalViewButtons ).not.toBe( null );

        const additionalEditButtons = element.shadowRoot.querySelector( 'slot[name="additionalEditButtons"' );
        expect( additionalEditButtons ).toBe( null );
    });

    it('When visible card and inEditMode, has an editForm slot but no viewForm slot', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.visible = true;
        element.inEditMode = true;
        document.body.appendChild(element);

        const viewForm = element.shadowRoot.querySelector( 'slot[name="viewForm"]' );
        expect( viewForm ).toBe( null );

        const editForm = element.shadowRoot.querySelector( 'slot[name="editForm"]' );
        expect( editForm ).not.toBe( null );
    });

    it('When visible card and not inEditMode, has a viewForm slot but no editForm slot', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.visible = true;
        element.inEditMode = false;
        document.body.appendChild(element);

        const viewForm = element.shadowRoot.querySelector( 'slot[name="viewForm"]' );
        expect( viewForm ).not.toBe( null );

        const editForm = element.shadowRoot.querySelector( 'slot[name="editForm"]' );
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
                const clickEvent = new CustomEvent( 'click', {} );
                return element.shadowRoot.querySelector( '[data-name="save"]' ).click();
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
                const clickEvent = new CustomEvent( 'click', {} );
                return element.shadowRoot.querySelector( '[data-name="cancel"]' ).click();
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

        const saveButton = element.shadowRoot.querySelector( '[data-name="save"]' );
        expect( saveButton ).not.toBe( null );

        const cancelButton = element.shadowRoot.querySelector( '[data-name="cancel"]' );
        expect( cancelButton ).not.toBe( null );

        const editButton = element.shadowRoot.querySelector( '[data-name="edit"]' );
        expect( editButton ).toBe( null );

        const additionalViewButtons = element.shadowRoot.querySelector( 'slot[name="additionalViewButtons"' );
        expect( additionalViewButtons ).toBe( null );

        const additionalEditButtons = element.shadowRoot.querySelector( 'slot[name="additionalEditButtons"' );
        expect( additionalEditButtons ).not.toBe( null );
    });

    it('When visible modal and not inEditMode, has an edit button, but no save or cancel', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.visible = true;
        element.inEditMode = false;
        element.mode = 'modal';
        document.body.appendChild(element);

        const saveButton = element.shadowRoot.querySelector( '[data-name="save"]' );
        expect( saveButton ).toBe( null );

        const cancelButton = element.shadowRoot.querySelector( '[data-name="cancel"]' );
        expect( cancelButton ).toBe( null );

        const editButton = element.shadowRoot.querySelector( '[data-name="edit"]' );
        expect( editButton ).not.toBe( null );

        const additionalViewButtons = element.shadowRoot.querySelector( 'slot[name="additionalViewButtons"' );
        expect( additionalViewButtons ).not.toBe( null );

        const additionalEditButtons = element.shadowRoot.querySelector( 'slot[name="additionalEditButtons"' );
        expect( additionalEditButtons ).toBe( null );
    });

    it('When visible modal and inEditMode, has an editForm slot but no viewForm slot', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.visible = true;
        element.inEditMode = true;
        element.mode = 'modal';
        document.body.appendChild(element);

        const viewForm = element.shadowRoot.querySelector( 'slot[name="viewForm"]' );
        expect( viewForm ).toBe( null );

        const editForm = element.shadowRoot.querySelector( 'slot[name="editForm"]' );
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

        const viewForm = element.shadowRoot.querySelector( 'slot[name="viewForm"]' );
        expect( viewForm ).not.toBe( null );

        const editForm = element.shadowRoot.querySelector( 'slot[name="editForm"]' );
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
                const clickEvent = new CustomEvent( 'click', {} );
                return element.shadowRoot.querySelector( '[data-name="save"]' ).click();
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
                const clickEvent = new CustomEvent( 'click', {} );
                return element.shadowRoot.querySelector( '[data-name="cancel"]' ).click();
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