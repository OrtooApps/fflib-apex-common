import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import displayError from 'c/errorRenderer';
import getEpochTime from '@salesforce/apex/TimeController.getEpochTime';

import INVALID_LOAD_LABEL from '@salesforce/label/c.ortoo_lwc_list_view_buttons_invalid_load';

const LOAD_LEEWAY = 60; // number of seconds leeway between the redirection to the page and the load of it.

export default class LwcListViewWrapper extends NavigationMixin( LightningElement ) {

	@track currentPageReference;
    @wire( CurrentPageReference )
    setCurrentPageReference( currentPageReference ) {
        this.currentPageReference = currentPageReference;
		this.checkLoadTimeWithinLimits();
    }

	displayForm;
	launchedEpochTime;

    get recordIds() {
        return JSON.parse( this.currentPageReference?.state?.c__recordIds );
    }

	get directedEpochTime() {
		return parseInt( this.currentPageReference?.state?.c__epoch );
	}

	get returnUrl() {
		return this.currentPageReference?.state?.c__returnUrl;
	}

	checkLoadTimeWithinLimits() {

		if ( ! this.directedEpochTime ) {
			return;
		}

		getEpochTime()
		.then( launchedEpochTime => {

			this.launchedEpochTime = parseInt( launchedEpochTime );

			let timeDifference = Math.abs( this.directedEpochTime - this.launchedEpochTime );
			let withinLeeway = timeDifference < LOAD_LEEWAY;

			if ( ! withinLeeway )
			{
				displayError.call( this, INVALID_LOAD_LABEL );
			}
			this.displayForm = withinLeeway;
		});
	}

	navigateToReturnUrl() {
		const navigation = {
			type: 'standard__webPage',
			attributes: {
				url: this.returnUrl
			}
		};
		this[NavigationMixin.Navigate]( navigation );
	}

	close() {
		this.navigateToReturnUrl();
	}
}