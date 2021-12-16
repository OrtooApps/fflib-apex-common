import { LightningElement, api } from 'lwc';

import LAYOUT_CONSTANTS from 'c/layoutConstants';

export default class ReadOnlyField extends LightningElement {

    @api name;
    @api label;
    @api value;
    @api fieldLevelHelp;
    @api displayDensity = LAYOUT_CONSTANTS.DISPLAY_DENSITY.DEFAULT;

    get labelClasses() {
        return LAYOUT_CONSTANTS.getLabelClasses( this.displayDensity );
    }

    get labelName() {
        return this.name + '-label';
    }
}