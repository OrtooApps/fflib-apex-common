import { LightningElement, api, wire } from 'lwc';
import configureElementIdGenerator from 'c/elementIdGenerator';

import pageSizeOptions from '@salesforce/apex/UsersComponentController.pageSizeOptions';

//import XXX_LABEL from '@salesforce/label/c.ortoo_core_xxxx';

const FIRST_LABEL = 'First Page'; // labels, as per above
const PREVIOUS_LABEL = 'Previous';
const NEXT_LABEL = 'Next';
const LAST_LABEL = 'Last Page';
const TOTAL_RECORDS_LABEL = 'Total records';
const PAGE_DESCRIPTION = 'Page {0} of {1}';
const PAGE_SIZE_LABEL = 'Page Size';

export default class PaginationControls extends LightningElement {

    @api numberOfRecords;
    @api recordsPerPage;
    @api currentPage;

    labels = {
        first: FIRST_LABEL,
        previous: PREVIOUS_LABEL,
        next: NEXT_LABEL,
        last: LAST_LABEL,
        totalRecords: TOTAL_RECORDS_LABEL,
        pageSize: PAGE_SIZE_LABEL,
    };

    @api ortooElemIdPrefix = 'pageselector';

    ortooIdConfiguration = {
        firstButtonId: 'first',
        previousButtonId: 'previous',
        nextButtonId: 'next',
        lastButtonId: 'last',
        pageSizeId: 'pagesize',
    }

    @wire(pageSizeOptions, {}) pageSizeOptions;

    connectedCallback() {
        configureElementIdGenerator( this );
    }

    get pageDescription() {
        return PAGE_DESCRIPTION
                    .replace( '{0}', this.currentPage )
                    .replace( '{1}', this.numberOfPages );
    }

    get numberOfPages() {
        return Math.ceil( this.numberOfRecords / this.recordsPerPage );
    }

    get onFirstPage() {
        return this.currentPage == 1;
    }

    get onLastPage() {
        return this.currentPage >= this.numberOfPages;
    }

    get disableFirstButton() {
        return this.onFirstPage;
    }

    get disablePreviousButton() {
        return this.onFirstPage;
    }

    get disableNextButton() {
        return this.onLastPage;
    }

    get disableLastButton() {
        return this.onLastPage;
    }

    handleFirstClick( event ) {
        this.dispatchNavigateToPageEvent( 0 );
    }

    handlePreviousClick( event ) {
        this.dispatchNavigateToPageEvent( this.currentPage - 1 );
    }

    handleNextClick( event ) {
        this.dispatchNavigateToPageEvent( this.currentPage + 1 );
    }

    handleLastClick( event ) {
        this.dispatchNavigateToPageEvent( this.numberOfPages );
    }

    handleChangePageSize( event ) {
        this.recordsPerPage = event.detail.value;
        this.dispatchNavigateToPageEvent( Math.min( this.currentPage, this.numberOfPages ) );
    }

    dispatchNavigateToPageEvent( pageToNavigateTo ) {
        const detail = {
                            pageToNavigateTo: pageToNavigateTo,
                            recordsPerPage  : this.recordsPerPage
                        };
        const newEvent = new CustomEvent( 'navigatetopage', { detail: detail } );
        this.dispatchEvent( newEvent );
    }
}