import { createElement, api } from 'lwc';
import SelfConfiguredCombobox from 'c/selfConfiguredCombobox';
import LAYOUT_CONSTANTS from 'c/layoutConstants';

const OPTIONS = [
    { value: '0', label: 'Zero' },
    { value: '1', label: 'One' },
    { value: '2', label: 'Two' },
    { value: '3', label: 'Three' },
    { value: '' , label: 'None'},
];

const ALTERNATIVE_OPTIONS = [
    { value: 'A', label: 'ay' },
    { value: 'B', label: 'be' },
];

const INVALID_VALUE = '99';
const VALID_VALUE   = OPTIONS[1].value;

const NAME            = 'the-name';
const PLACEHOLDER     = 'The placeholder text';
const LABEL           = 'The label';
const HELP_TEXT       = 'Help text that is helpful';
const DISPLAY_DENSITY = LAYOUT_CONSTANTS.DISPLAY_DENSITY.COMPACT;

const SYSTEM_DEFAULT_DISPLAY_DENSITY = LAYOUT_CONSTANTS.DISPLAY_DENSITY.DEFAULT;

const READ_ONLY_FIELD_TYPE = 'c-read-only-field';
const EDITABLE_FIELD_TYPE  = 'lightning-combobox';

// This exists so we can expose the protected property 'options' and make it settable via the API
// The property should be overridden in any use of SelfConfiguredCombobox
class TestableSelfConfiguredCombobox extends SelfConfiguredCombobox {
    @api
    set settableOptions( values ) {
        this.options = values;
    };
    get settableOptions() {
        return this.options;
    }
    @api
    set settableNoOptionsErrorMessage( value ) {
        this.noOptionsErrorMessage = value;
    }
    get settableNoOptionsErrorMessage() {
        return this.noOptionsErrorMessage;
    }
}

console.error = jest.fn();

describe('c-self-configured-combobox', () => {
    beforeEach( () => {
        console.error.mockClear();
    })

    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('when readonly, will not show the editable field', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.readOnly = true;

        document.body.appendChild(element);

        const editableField = element.shadowRoot.querySelector( EDITABLE_FIELD_TYPE );
        expect( editableField ).toBe( null );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when editable, will not show the readOnly field', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.readOnly = false;

        document.body.appendChild(element);

        const readOnlyField = element.shadowRoot.querySelector( READ_ONLY_FIELD_TYPE );
        expect( readOnlyField ).toBe( null );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when readonly, will pass the label, help text and display density into the readonlyfield', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.readOnly       = true;
        element.label          = LABEL;
        element.fieldLevelHelp       = HELP_TEXT;
        element.displayDensity = DISPLAY_DENSITY;

        document.body.appendChild(element);

        const readOnlyField = element.shadowRoot.querySelector( READ_ONLY_FIELD_TYPE );
        expect( readOnlyField.label ).toBe( LABEL );
        expect( readOnlyField.fieldLevelHelp ).toBe( HELP_TEXT );
        expect( readOnlyField.displayDensity ).toBe( DISPLAY_DENSITY );

        const editableField = element.shadowRoot.querySelector( EDITABLE_FIELD_TYPE );
        expect( editableField ).toBe( null );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when readonly, will show the label associated with the value', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.settableOptions = OPTIONS;
        element.value           = '1';
        element.readOnly        = true;

        document.body.appendChild(element);

        const readOnlyField = element.shadowRoot.querySelector( READ_ONLY_FIELD_TYPE );
        expect( readOnlyField.value ).toBe( 'One' );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when readonly, and the value is empty, will show the label associated with the empty thing', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.settableOptions = OPTIONS;
        element.value           = '';
        element.readOnly        = true;

        document.body.appendChild(element);

        const readOnlyField = element.shadowRoot.querySelector( READ_ONLY_FIELD_TYPE );
        expect( readOnlyField.value ).toBe( 'None' );
        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when readonly, the value is not empty and the options are, will show an empty value', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.value    = 'Not empty';
        element.readOnly = true;

        document.body.appendChild(element);

        const readOnlyField = element.shadowRoot.querySelector( READ_ONLY_FIELD_TYPE );
        expect( readOnlyField.value ).toBe( '' );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when editable, will pass many properties to the rendered editable field', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.readOnly    = false;
        element.name        = NAME;
        element.label       = LABEL;
        element.placeholder = PLACEHOLDER;
        element.fieldLevelHelp    = HELP_TEXT;
        element.required    = true;

        document.body.appendChild(element);

        const editableField = element.shadowRoot.querySelector( EDITABLE_FIELD_TYPE );

        expect( editableField.readOnly       ).toBe( undefined );
        expect( editableField.name           ).toBe( NAME );
        expect( editableField.label          ).toBe( LABEL );
        expect( editableField.placeholder    ).toBe( PLACEHOLDER );
        expect( editableField.fieldLevelHelp ).toBe( HELP_TEXT );
        expect( editableField.required       ).toBe( true );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when editable, and the selected value is changed, will dispatch a change event with the new value', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.settableOptions = OPTIONS;

        const changeHandler = jest.fn();
        element.addEventListener( 'change', changeHandler ) ;

        document.body.appendChild(element);

        const NEW_VALUE = '2';

        const editableField = element.shadowRoot.querySelector( EDITABLE_FIELD_TYPE );
        editableField.value = NEW_VALUE;
        editableField.dispatchEvent( new CustomEvent( 'change' ) );

        expect( changeHandler ).toHaveBeenCalled();
        expect( changeHandler.mock.calls[0][0].detail ).toBe( NEW_VALUE );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('displayDensity will default to the standard default', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });

        document.body.appendChild(element);

        expect( element.displayDensity ).toBe( SYSTEM_DEFAULT_DISPLAY_DENSITY );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when display density is comfy and the label is set, will set the combobox label variant to the comfy version', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.label          = 'A label';
        element.displayDensity = LAYOUT_CONSTANTS.DISPLAY_DENSITY.COMFY;

        document.body.appendChild(element);

        const editableField = element.shadowRoot.querySelector( EDITABLE_FIELD_TYPE );

        expect( editableField.variant ).toBe( LAYOUT_CONSTANTS.LABEL_PROPERTIES.COMFY.VARIANT );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when display density is comfy and the label is not set, will set the combobox label variant to hidden', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.displayDensity = LAYOUT_CONSTANTS.DISPLAY_DENSITY.COMFY;

        document.body.appendChild(element);

        const editableField = element.shadowRoot.querySelector( EDITABLE_FIELD_TYPE );

        expect( editableField.variant ).toBe( LAYOUT_CONSTANTS.LABEL_PROPERTIES.HIDDEN.VARIANT );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when display density is compact and the label is set, will set the combobox label variant to the compact version', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.label          = 'A label';
        element.displayDensity = LAYOUT_CONSTANTS.DISPLAY_DENSITY.COMPACT;

        document.body.appendChild(element);

        const editableField = element.shadowRoot.querySelector( EDITABLE_FIELD_TYPE );

        expect( editableField.variant ).toBe( LAYOUT_CONSTANTS.LABEL_PROPERTIES.COMPACT.VARIANT );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when display density is compact and the label is not set, will set the combobox label variant to hidden', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.displayDensity = LAYOUT_CONSTANTS.DISPLAY_DENSITY.COMPACT;

        document.body.appendChild(element);

        const editableField = element.shadowRoot.querySelector( EDITABLE_FIELD_TYPE );

        expect( editableField.variant ).toBe( LAYOUT_CONSTANTS.LABEL_PROPERTIES.HIDDEN.VARIANT );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when required is set and no value is set, reportValidity returns false', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.required = true;

        document.body.appendChild(element);

        expect( element.reportValidity() ).toBe( false );
        expect( element.checkValidity() ).toBe( false );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when required is set and a valid value is set, reportValidity returns true', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.required = true;
        element.settableOptions  = OPTIONS;
        element.value    = VALID_VALUE;

        document.body.appendChild(element);

        expect( element.reportValidity() ).toBe( true );
        expect( element.checkValidity() ).toBe( true );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when required is set and a valid falsy value is set, reportValidity returns true', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.required        = true;
        element.settableOptions = OPTIONS;
        element.value           = '0';

        document.body.appendChild(element);

        expect( element.reportValidity() ).toBe( true );
        expect( element.checkValidity() ).toBe( true );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when required is set and no value is set, reportValidity returns false', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.required        = true;
        element.settableOptions = OPTIONS;
        element.value           = INVALID_VALUE;

        document.body.appendChild(element);

        expect( element.reportValidity() ).toBe( false );
        expect( element.checkValidity() ).toBe( false );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when required is not set and no value is set, reportValidity returns true', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });

        document.body.appendChild(element);

        expect( element.reportValidity() ).toBe( true );
        expect( element.checkValidity() ).toBe( true );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when required is not set and a valid value is set, reportValidity returns true', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.settableOptions = OPTIONS;
        element.value           = VALID_VALUE;

        document.body.appendChild(element);

        expect( element.reportValidity() ).toBe( true );
        expect( element.checkValidity() ).toBe( true );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when required is not set and no value is set, reportValidity returns false', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.settableOptions = OPTIONS;
        element.value           = INVALID_VALUE;

        document.body.appendChild(element);

        expect( element.reportValidity() ).toBe( false );
        expect( element.checkValidity() ).toBe( false );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when the options change and the existing value is still valid, will keep that value and describe itself as valid', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.settableOptions  = ALTERNATIVE_OPTIONS;
        element.value            = VALID_VALUE;

        const changeHandler = jest.fn();
        element.addEventListener( 'change', changeHandler );

        element.settableOptions  = OPTIONS;

        document.body.appendChild(element);

        expect( element.value ).toBe( VALID_VALUE );

        expect( changeHandler ).not.toHaveBeenCalled();

        expect( element.reportValidity() ).toBe( true );
        expect( element.checkValidity() ).toBe( true );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('when the options change and the existing value is no longer valid, will change the value to empty and issue a change event', () => {
        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        element.settableOptions = ALTERNATIVE_OPTIONS;
        element.value           = INVALID_VALUE;

        const changeHandler = jest.fn();
        element.addEventListener( 'change', changeHandler );

        element.settableOptions = OPTIONS;

        document.body.appendChild(element);

        expect( element.value ).toBe( '' );
        expect( changeHandler ).toHaveBeenCalled();
        expect( changeHandler.mock.calls[0][0].detail ).toBe( '' );

        expect( element.reportValidity() ).toBe( true );
        expect( element.checkValidity() ).toBe( true );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('can call showHelpMessageIfInvalid', () => {

        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        document.body.appendChild(element);

        element.showHelpMessageIfInvalid();

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('reportValidity against an element with no value and undefined options and it will return true', () => {

        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        document.body.appendChild(element);

        const validity = element.reportValidity();

        expect( validity ).toBe( true );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('configure an element with no defined options and it will report itself as invalid', () => {

        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        document.body.appendChild(element);

        element.settableNoOptionsErrorMessage = 'no options';
        element.settableOptions = [];

        expect( element.checkValidity() ).toBe( false );

        expect( console.error ).toHaveBeenCalled();
        expect( console.error.mock.calls[0][0] ).toBe( 'no options' );
    });

    it('reportValidity against an element with no defined options and it will return false', () => {

        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        document.body.appendChild(element);

        element.settableNoOptionsErrorMessage = 'no options';
        element.settableOptions = [];
        console.error.mockClear();

        const validity = element.reportValidity();

        expect( element.reportValidity() ).toBe( false );
        expect( element.checkValidity() ).toBe( false );

        expect( console.error ).toHaveBeenCalled();
        expect( console.error.mock.calls[0][0] ).toBe( 'no options' );
    });

    it('reportValidity against an element with a value that matches a current option and it will return true', () => {

        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        document.body.appendChild(element);

        element.settableOptions = OPTIONS;
        element.value           = VALID_VALUE;

        const validity = element.reportValidity();

        expect( validity ).toBe( true );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('reportValidity against an element with a value that does not match a current options and it will return false', () => {

        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        document.body.appendChild(element);

        element.settableOptions = OPTIONS;
        element.value           = INVALID_VALUE;

        const validity = element.reportValidity();

        expect( validity ).toBe( false );

        expect( console.error ).not.toHaveBeenCalled();
    });

    it('can call setCustomValidity and it will change the validity', () => {

        const element = createElement('c-self-configured-combobox', {
            is: TestableSelfConfiguredCombobox
        });
        document.body.appendChild(element);

        element.setCustomValidity( 'this is invalid' );

        expect( element.checkValidity() ).toBe( false );

        expect( console.error ).not.toHaveBeenCalled();
    });
});