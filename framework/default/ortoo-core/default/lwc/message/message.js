import { LightningElement, api } from 'lwc';
import configureElementIdGenerator from 'c/elementIdGenerator';

export default class Message extends LightningElement {

	@api message;
	@api variant;

    @api ortooElemIdPrefix = 'messagebox';

    ortooIdConfiguration = {
        messageId: 'message',
		iconId: 'icon',
		containerId: 'container',
    }

    connectedCallback() {
        configureElementIdGenerator( this );
    }

	variantToClassMapping = {
		error: 'slds-theme--error',
		warning: 'slds-theme--warning',
		info: 'slds-theme--info',
		success: 'slds-theme--success',
	}

	variantToIconMapping = {
		error: 'utility:error',
		warning: 'utility:warning',
		info: 'utility:info',
		success: 'utility:success',
	}

	get messagePopulated() {
		return ( this.message && !/^\s*$/.test( this.message ) );
	}

	get themeClass() {
		return this.variantToClassMapping[ this.variant ];
	}

	get topLevelClasses() {
		return this.themeClass+' slds-notify--toast slds-notify slds-notify--toast forceToastMessage';
	}

    get iconName() {
        return this.variantToIconMapping[ this.variant ];
    }
}