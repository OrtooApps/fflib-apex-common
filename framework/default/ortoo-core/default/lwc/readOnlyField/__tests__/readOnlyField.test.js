import { createElement } from 'lwc';
import ReadOnlyField from 'c/readOnlyField';

describe('c-read-only-field', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('When name is set, will create a span with that name', () => {
        const element = createElement('c-read-only-field', {
            is: ReadOnlyField
        });
        element.name = 'the-name';
        document.body.appendChild(element);

        const expectedElement = element.shadowRoot.querySelector( 'span[name="the-name"]' );
        expect( expectedElement ).not.toBe( null );
    });

    it('When value is set, will populate the value element with that value', () => {
        const element = createElement('c-read-only-field', {
            is: ReadOnlyField
        });
        element.value = 'a value';
        document.body.appendChild(element);

        const expectedElement = element.shadowRoot.querySelector( '[name="value"]' );
        expect( expectedElement ).not.toBe( null );
        expect( expectedElement.textContent ).toBe( 'a value' );
    });

    it('When value is not set, will populate the value element with an empty string', () => {
        const element = createElement('c-read-only-field', {
            is: ReadOnlyField
        });
        document.body.appendChild(element);

        const expectedElement = element.shadowRoot.querySelector( '[name="value"]' );
        expect( expectedElement ).not.toBe( null );
        expect( expectedElement.textContent ).toBe( '' );
    });

    it('When label is set, will populate a label element with that value, assigning a generated name to it based on the top level name', () => {
        const element = createElement('c-read-only-field', {
            is: ReadOnlyField
        });
        element.name  = 'the-name';
        element.label = 'The Label';

        document.body.appendChild(element);

        const expectedElement = element.shadowRoot.querySelector( '[name="the-name-label"]' );
        expect( expectedElement ).not.toBe( null );
        expect( expectedElement.textContent ).toBe( 'The Label' );
    });

    it('When label is not set, will populate the value element with an empty string', () => {
        const element = createElement('c-read-only-field', {
            is: ReadOnlyField
        });
        element.name  = 'the-name';

        document.body.appendChild(element);

        const expectedElement = element.shadowRoot.querySelector( '[name="the-name-label"]' );
        expect( expectedElement ).not.toBe( null );
        expect( expectedElement.textContent ).toBe( '' );
    });

    it('When fieldLevelHelp is set, will create a help text element with that content', () => {
        const element = createElement('c-read-only-field', {
            is: ReadOnlyField
        });
        element.fieldLevelHelp = 'this is help text';
        document.body.appendChild(element);

        const expectedElement = element.shadowRoot.querySelector( 'lightning-helptext' );
        expect( expectedElement ).not.toBe( null );
        expect( expectedElement.content ).toBe( 'this is help text' );
    });

    it('When fieldLevelHelp is not set, will not create a help text element', () => {
        const element = createElement('c-read-only-field', {
            is: ReadOnlyField
        });
        document.body.appendChild(element);

        const expectedElement = element.shadowRoot.querySelector( 'lightning-helptext' );
        expect( expectedElement ).toBe( null );
    });

    it('When displayDensity is set to comfy, will render the label as stacked', () => {
        const element = createElement('c-read-only-field', {
            is: ReadOnlyField
        });
        element.name = 'the-name';
        element.displayDensity = 'comfy';
        document.body.appendChild(element);

        const expectedElement = element.shadowRoot.querySelector( 'span[name="the-name"]' );
        expect( expectedElement ).not.toBe( null );
        expect( expectedElement.classList ).toContain( 'slds-form-element_stacked' );
    });

    it('When displayDensity is set to compact, will render the label as inline', () => {
        const element = createElement('c-read-only-field', {
            is: ReadOnlyField
        });
        element.name = 'the-name';
        element.displayDensity = 'compact';
        document.body.appendChild(element);

        const expectedElement = element.shadowRoot.querySelector( 'span[name="the-name"]' );
        expect( expectedElement ).not.toBe( null );
        expect( expectedElement.classList ).toContain( 'slds-form-element_horizontal' );
    });
});