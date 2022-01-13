import { LightningElement, api, wire } from 'lwc';
import configureElementIdGenerator from 'c/elementIdGenerator';

import SEARCH_BUTTON_LABEL from '@salesforce/label/c.ortoo_core_search_button_label';
import SEARCH_BUTTON_TITLE from '@salesforce/label/c.ortoo_core_search_button_title';
import LOADING_LABEL from '@salesforce/label/c.ortoo_core_loading';

export default class FilterAndResults extends LightningElement {

    labels = {
        searchButton: SEARCH_BUTTON_LABEL,
        searchButtonTitle: SEARCH_BUTTON_TITLE,
        loading: LOADING_LABEL,
    };

    @api ortooElemIdPrefix = 'filterandresults';

    ortooIdConfiguration = {
        searchButtonId: 'search',
        pageSelectorTopId: 'pageselectortop',
        pageSelectorBottomId: 'pageselectorbottom',
    }

    @api title;
    @api loading;
    @api numberOfRecords;
    @api recordsWindowSize;
    @api showPaginationControls;
    @api offset;
    @api searchType; // defines the type of search to load / save against

    connectedCallback() {
        configureElementIdGenerator( this );
    }

    handleSearchClicked( event ) {
        const newEvent = new CustomEvent( 'search', {} );
        this.dispatchEvent( newEvent );
    }

    handleNavigate( event ) {
        const newEvent = new CustomEvent( 'navigate', { detail: event.detail } );
        this.dispatchEvent( newEvent );
    }
}