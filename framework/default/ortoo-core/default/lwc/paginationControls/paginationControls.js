import { LightningElement, api } from 'lwc';
import configureElementIdGenerator from 'c/elementIdGenerator';

import FIRST_LABEL from '@salesforce/label/c.ortoo_core_first_page';
import PREVIOUS_LABEL from '@salesforce/label/c.ortoo_core_previous_page';
import NEXT_LABEL from '@salesforce/label/c.ortoo_core_next_page';
import LAST_LABEL from '@salesforce/label/c.ortoo_core_last_page';
import TOTAL_RECORDS_LABEL from '@salesforce/label/c.ortoo_core_total_records';
import PAGE_SIZE_LABEL from '@salesforce/label/c.ortoo_core_page_size';
import PAGE_DESCRIPTION from '@salesforce/label/c.ortoo_core_page_number_description';

export default class PaginationControls extends LightningElement {

    @api numberOfRecords;

    _recordsPerPage = 0;
    @api get recordsPerPage() {
        return this._recordsPerPage;
    }
    set recordsPerPage( value ) {
        const previousOffset = this.offset;

        this._recordsPerPage = isNaN( value ) ? this._recordsPerPage : parseInt( value );
        this.offset = previousOffset;
    }

    _currentPage = 1;
    @api get currentPage() {
        return this._currentPage;
    }
    set currentPage( value ) {
        this._currentPage = ( value < 1 || isNaN( value ) ) ? 1 : value;
        this.dispatchNavigateEvent();
    }

    @api
    get offset() {
        return ( this.currentPage - 1 ) * this.recordsPerPage;
    }
    set offset( value ) {
        if ( ! isNaN( value ) && this.recordsPerPage ) {
            this.currentPage = Math.floor( value / this.recordsPerPage ) + 1;
        }
    };

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
        informationMessageId: 'info',
    }

    // Could potentially be loaded from the DB, but I'm not sure why you need to
    pageSizeOptions = [
        { label: '20', value: 20 },
        { label: '50', value: 50 },
        { label: '100', value: 100 },
        { label: '200', value: 200 },
    ];

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

    get initialised() {
        return ! isNaN( this.numberOfRecords ) && ! isNaN( this.recordsPerPage ) && ! isNaN( this.currentPage );
    }

    get disableFirstButton() {
        return !this.initialised || this.onFirstPage;
    }

    get disablePreviousButton() {
        return !this.initialised || this.onFirstPage;
    }

    get disableNextButton() {
        return !this.initialised || this.onLastPage;
    }

    get disableLastButton() {
        return !this.initialised || this.onLastPage;
    }

    handleFirstClick( event ) {
        this.currentPage = 1;
    }

    handlePreviousClick( event ) {
        this.currentPage--;
    }

    handleNextClick( event ) {
        this.currentPage++;
    }

    handleLastClick( event ) {
        this.currentPage = this.numberOfPages;
    }

    handleChangePageSize( event ) {
        this.recordsPerPage = event.detail.value;
    }

    dispatchNavigateEvent() {

        const detail = {
                            page: this.currentPage,
                            offset: this.offset,
                            window: this.recordsPerPage
                        };
        const newEvent = new CustomEvent( 'navigate', { detail: detail } );
        this.dispatchEvent( newEvent );
    }
}