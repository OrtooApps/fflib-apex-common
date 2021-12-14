import { createElement } from 'lwc';
import ViewAndEditForm from 'c/viewAndEditForm';

describe('c-view-and-edit-form', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('When inEditMode, has a save and cancel button, but no edit', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.inEditMode = true;
        document.body.appendChild(element);

        const saveButton = element.shadowRoot.querySelector( '[data-name="save"]' );
        expect( saveButton ).not.toBe( null );

        const cancelButton = element.shadowRoot.querySelector( '[data-name="cancel"]' );
        expect( cancelButton ).not.toBe( null );

        const editButton = element.shadowRoot.querySelector( '[data-name="edit"]' );
        expect( editButton ).toBe( null );
    });

    it('When not inEditMode, has an edit button, but no  save or cancel', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.inEditMode = false;
        document.body.appendChild(element);

        const saveButton = element.shadowRoot.querySelector( '[data-name="save"]' );
        expect( saveButton ).toBe( null );

        const cancelButton = element.shadowRoot.querySelector( '[data-name="cancel"]' );
        expect( cancelButton ).toBe( null );

        const editButton = element.shadowRoot.querySelector( '[data-name="edit"]' );
        expect( editButton ).not.toBe( null );
    });

    it('When inEditMode, has an editForm slot but no viewForm slot', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.inEditMode = true;
        document.body.appendChild(element);

        const viewForm = element.shadowRoot.querySelector( 'slot[name="viewForm"]' );
        expect( viewForm ).toBe( null );

        const editForm = element.shadowRoot.querySelector( 'slot[name="editForm"]' );
        expect( editForm ).not.toBe( null );
    });

    it('When not inEditMode, has a viewForm slot but no editForm slot', () => {
        const element = createElement('c-view-and-edit-form', {
            is: ViewAndEditForm
        });
        element.inEditMode = false;
        document.body.appendChild(element);

        const viewForm = element.shadowRoot.querySelector( 'slot[name="viewForm"]' );
        expect( viewForm ).not.toBe( null );

        const editForm = element.shadowRoot.querySelector( 'slot[name="editForm"]' );
        expect( editForm ).toBe( null );
    });
});