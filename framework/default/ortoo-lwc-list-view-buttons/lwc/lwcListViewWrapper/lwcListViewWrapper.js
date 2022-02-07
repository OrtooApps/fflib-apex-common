import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import displayError from 'c/errorRenderer';
import getEpochTime from '@salesforce/apex/TimeController.getEpochTime';

const LOAD_LEEWAY = 60; // number of seconds leeway between the redirection to the page and the load of it.

// TODO: clarify the error message when using an old link
// TODO: standards to always say how many records will be updated on the included LWC
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
				displayError.call( this, 'It appears the page was loaded from an old link, and this is dangerous so it is not allowed' );
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