import { LightningElement, api } from 'lwc';
import configureElementIdGenerator from 'c/elementIdGenerator';

import LAYOUT_CONSTANTS from 'c/layoutConstants';
export default class SelfConfiguredCombobox extends LightningElement {

    @api name;
    @api label;
    @api value;

    @api placeholder;

    @api disabled;
    @api readOnly;
    @api required;

    @api noPadding;

    @api fieldLevelHelp;

    // TODO: default this
    @api messageWhenValueMissing;

    @api displayDensity = LAYOUT_CONSTANTS.DISPLAY_DENSITY.DEFAULT;

    // populate these in the child implementation
    _options;
    get options() {
        return this._options;
    }
    set options( values ) {
        this._options = values;
        this.configureValue();
    }

    @api ortooElemIdPrefix = 'combobox';

    ortooIdConfiguration = {
        fieldId: ''
    }

    connectedCallback() {
        configureElementIdGenerator( this );
    }

    noOptionsErrorMessage;

    currentValueIsNotAValidOption = 'The current value is not a valid option';

    _labelVariant;
    get labelVariant() {
        if ( this._labelVariant ) {
            return this._labelVariant;
        }
        if ( ! this.label ) {
            return LAYOUT_CONSTANTS.LABEL_PROPERTIES.HIDDEN.VARIANT;
        }
        return LAYOUT_CONSTANTS.getLabelVariant( this.displayDensity );
    }
    set labelVariant( value ) {
        this._labelVariant = value;
    }

    _selector;
    get selector() {
        if ( !this._selector ) {
            this._selector = this.template.querySelector( 'lightning-combobox' );
        }
        return this._selector;
    }

    get valueLabel() {
        if ( ! this.options ) {
            return '';
        }
        const selectedOption = this.options.find( thisOption => thisOption.value == this.value );
        if ( ! selectedOption ) { // TODO: why didn't this happen in the test?
            return '';
        }
        return selectedOption.label;
    }

    get fieldPadding() {
        return this.noPadding? '' : 'slds-p-left_xx-small slds-p-bottom_x-small slds-p-right_xx-small'; // TODO; Layout Constants?
    }

    configureValue() {
        if ( this.options && ! this.currentValueIsValid() ) {
            this.resetValue();
        }

        this.reportValidity();
    }

    currentValueIsValid() {
        return this.options === undefined || this.options.some( thisOption => thisOption.value == this.value );
    }

    resetValue() {
        this.value = '';
        this.dispatchChangedEvent();
    }

    handleChange( event ) {
        event.stopPropagation();
        this.value = event.currentTarget.value;
        this.dispatchChangedEvent();
    }

    dispatchChangedEvent() {
        const event = new CustomEvent( 'change', { detail: this.value } );
        this.dispatchEvent( event );
    }

    _currentlyReportedValid;
    @api checkValidity() {
       return this._currentlyReportedValid;
    }

    @api reportValidity() {

        this._currentlyReportedValid = true;
        this.setCustomValidity( '' );

        if ( this.options !== undefined && !this.options.length ) {
            console.error( this.noOptionsErrorMessage );
            this.setCustomValidity( this.noOptionsErrorMessage );
            return false;
        }

        if ( this.required && ( this.value === '' || this.value === undefined ) ) {
            this.setCustomValidity( this.messageWhenValueMissing );
            return false;
        }

        if ( ! this.currentValueIsValid() ) {
            this.setCustomValidity( this.currentValueIsNotAValidOption );
            return false;
        }

        return true;
    }

    @api setCustomValidity( message ) {
        this._currentlyReportedValid = ( message == '' );
        if ( this.selector ) {
            return this.selector.setCustomValidity();
        }
    }

    @api showHelpMessageIfInvalid() {
        if ( this.selector ) {
            return this.selector.showHelpMessageIfInvalid();
        }
    }
}