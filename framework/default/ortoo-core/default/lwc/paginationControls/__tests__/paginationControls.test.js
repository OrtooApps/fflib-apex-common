import { createElement } from 'lwc';
import PaginationControls from 'c/paginationControls';

jest.mock('@salesforce/label/c.ortoo_core_total_records', () => { return { default: "Total Records" } }, { virtual: true } );
jest.mock('@salesforce/label/c.ortoo_core_page_size', () => { return { default: "Page Size" } }, { virtual: true } );
jest.mock('@salesforce/label/c.ortoo_core_page_number_description', () => { return { default: "{0} of {1}" } }, { virtual: true } );

const FIRST_SELECTOR = '[data-ortoo-elem-id="pageselector-first"]';
const PREVIOUS_SELECTOR = '[data-ortoo-elem-id="pageselector-previous"]';
const NEXT_SELECTOR = '[data-ortoo-elem-id="pageselector-next"]';
const LAST_SELECTOR = '[data-ortoo-elem-id="pageselector-last"]';
const PAGE_SIZE_SELECTOR = '[data-ortoo-elem-id="pageselector-pagesize"]';
const INFO_SELECTOR = '[data-ortoo-elem-id="pageselector-info"]';

describe( 'c-pagination-controls', () => {

    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it( 'when no record properties are set, will leave all buttons as disabled', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });

        document.body.appendChild( element );

        return Promise.resolve()
        .then( () => {

            const firstButton = element.shadowRoot.querySelector( FIRST_SELECTOR );
            expect( firstButton.disabled ).toBe( true );

            const previousButton = element.shadowRoot.querySelector( PREVIOUS_SELECTOR );
            expect( previousButton.disabled ).toBe( true );

            const nextButton = element.shadowRoot.querySelector( NEXT_SELECTOR );
            expect( nextButton.disabled ).toBe( true );

            const lastButton = element.shadowRoot.querySelector( LAST_SELECTOR );
            expect( lastButton.disabled ).toBe( true );
        })
    });

    it( 'when in a middle page, defined by the currentPage, will enable all the buttons', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 10;
        element.currentPage     = 5;

        document.body.appendChild( element );

        return Promise.resolve()
        .then( () => {

            const firstButton = element.shadowRoot.querySelector( FIRST_SELECTOR );
            expect( firstButton.disabled ).toBe( false );

            const previousButton = element.shadowRoot.querySelector( PREVIOUS_SELECTOR );
            expect( previousButton.disabled ).toBe( false );

            const nextButton = element.shadowRoot.querySelector( NEXT_SELECTOR );
            expect( nextButton.disabled ).toBe( false );

            const lastButton = element.shadowRoot.querySelector( LAST_SELECTOR );
            expect( lastButton.disabled ).toBe( false );
        })
    });

    it( 'when the first button is pressed, will set the current page to 1 and issue an event', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 10;
        element.currentPage     = 5;

        document.body.appendChild( element );

        const navigateHandler = jest.fn();
        element.addEventListener( 'navigate', navigateHandler );

        return Promise.resolve()
        .then( () => {

            element.shadowRoot.querySelector( FIRST_SELECTOR ).click();

            expect( element.currentPage ).toBe( 1 );

            expect( navigateHandler ).toHaveBeenCalledTimes( 1 );

            expect( navigateHandler.mock.calls[0][0].detail.pageToNavigateTo ).toBe( 1 );
            expect( navigateHandler.mock.calls[0][0].detail.offset ).toBe( 0 );
            expect( navigateHandler.mock.calls[0][0].detail.window ).toBe( 10 );
        })
    });

    it( 'when the previous button is pressed, will reduce the current page by 1 and issue an event', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 10;
        element.currentPage     = 5;

        document.body.appendChild( element );

        const navigateHandler = jest.fn();
        element.addEventListener( 'navigate', navigateHandler );

        return Promise.resolve()
        .then( () => {

            element.shadowRoot.querySelector( PREVIOUS_SELECTOR ).click()

            expect( element.currentPage ).toBe( 4 );

            expect( navigateHandler ).toHaveBeenCalledTimes( 1 );

            expect( navigateHandler.mock.calls[0][0].detail.pageToNavigateTo ).toBe( 4 );
            expect( navigateHandler.mock.calls[0][0].detail.offset ).toBe( 30 );
            expect( navigateHandler.mock.calls[0][0].detail.window ).toBe( 10 );
        })
    });

    it( 'when the next button is pressed, will increase the current page by 1 and issue an event', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 10;
        element.currentPage     = 5;

        document.body.appendChild( element );

        const navigateHandler = jest.fn();
        element.addEventListener( 'navigate', navigateHandler );

        return Promise.resolve()
        .then( () => {

            element.shadowRoot.querySelector( NEXT_SELECTOR ).click()

            expect( element.currentPage ).toBe( 6 );

            expect( navigateHandler ).toHaveBeenCalledTimes( 1 );

            expect( navigateHandler.mock.calls[0][0].detail.pageToNavigateTo ).toBe( 6 );
            expect( navigateHandler.mock.calls[0][0].detail.offset ).toBe( 50 );
            expect( navigateHandler.mock.calls[0][0].detail.window ).toBe( 10 );
        })
    });

    it( 'when the last button is pressed, will set the current page to the last and issue an event', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 10;
        element.currentPage     = 5;

        document.body.appendChild( element );

        const navigateHandler = jest.fn();
        element.addEventListener( 'navigate', navigateHandler );

        return Promise.resolve()
        .then( () => {

            element.shadowRoot.querySelector( LAST_SELECTOR ).click()

            expect( element.currentPage ).toBe( 10 );

            expect( navigateHandler ).toHaveBeenCalledTimes( 1 );

            expect( navigateHandler.mock.calls[0][0].detail.pageToNavigateTo ).toBe( 10 );
            expect( navigateHandler.mock.calls[0][0].detail.offset ).toBe( 90 );
            expect( navigateHandler.mock.calls[0][0].detail.window ).toBe( 10 );
        })
    });

    it( 'when the number of records per page is changed, will issue a navigation event and set the current page so the previous first record is still shown - checking first page', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 10;
        element.currentPage     = 1;

        document.body.appendChild( element );

        const navigateHandler = jest.fn();
        element.addEventListener( 'navigate', navigateHandler );

        return Promise.resolve()
        .then( () => {

            const pageSizeElement = element.shadowRoot.querySelector( PAGE_SIZE_SELECTOR );
            return pageSizeElement.dispatchEvent( new CustomEvent( 'change', { detail: { value: 25 } } ) );
        })
        .then( () => {

            expect( element.currentPage ).toBe( 1 ); // will reduce the page size so that the previous starting offset is displayed

            expect( navigateHandler ).toHaveBeenCalledTimes( 1 );

            expect( navigateHandler.mock.calls[0][0].detail.pageToNavigateTo ).toBe( 1 );
            expect( navigateHandler.mock.calls[0][0].detail.offset ).toBe( 0 );
            expect( navigateHandler.mock.calls[0][0].detail.window ).toBe( 25 );
        })
    });

    it( 'when the number of records per page is changed, will issue a navigation event and set the current page so the previous first record is still shown - checking last page', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 10;
        element.currentPage     = 10;

        document.body.appendChild( element );

        const navigateHandler = jest.fn();
        element.addEventListener( 'navigate', navigateHandler );

        return Promise.resolve()
        .then( () => {

            const pageSizeElement = element.shadowRoot.querySelector( PAGE_SIZE_SELECTOR );
            return pageSizeElement.dispatchEvent( new CustomEvent( 'change', { detail: { value: 25 } } ) );
        })
        .then( () => {

            expect( element.currentPage ).toBe( 4 );

            expect( navigateHandler ).toHaveBeenCalledTimes( 1 );

            expect( navigateHandler.mock.calls[0][0].detail.pageToNavigateTo ).toBe( 4 );
            expect( navigateHandler.mock.calls[0][0].detail.offset ).toBe( 75 );
            expect( navigateHandler.mock.calls[0][0].detail.window ).toBe( 25 );
        })
    });

    it( 'when the number of records per page is changed, will issue a navigation event and set the current page so the previous first record is still shown - checking in the middle', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 10;
        element.currentPage     = 7;

        document.body.appendChild( element );

        const navigateHandler = jest.fn();
        element.addEventListener( 'navigate', navigateHandler );

        return Promise.resolve()
        .then( () => {

            const pageSizeElement = element.shadowRoot.querySelector( PAGE_SIZE_SELECTOR );
            return pageSizeElement.dispatchEvent( new CustomEvent( 'change', { detail: { value: 25 } } ) );
        })
        .then( () => {

            expect( element.currentPage ).toBe( 3 ); // will reduce the page size so that the previous starting offset is displayed

            expect( navigateHandler ).toHaveBeenCalledTimes( 1 );

            expect( navigateHandler.mock.calls[0][0].detail.pageToNavigateTo ).toBe( 3 );
            expect( navigateHandler.mock.calls[0][0].detail.offset ).toBe( 50 );
            expect( navigateHandler.mock.calls[0][0].detail.window ).toBe( 25 );
        })
    });

    it( 'when on the first page, defined by the currentPage, but more records exist, will enable the next buttons, but not the previous ones', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 10;
        element.currentPage     = 1;

        document.body.appendChild( element );

        return Promise.resolve()
        .then( () => {

            const firstButton = element.shadowRoot.querySelector( FIRST_SELECTOR );
            expect( firstButton.disabled ).toBe( true );

            const previousButton = element.shadowRoot.querySelector( PREVIOUS_SELECTOR );
            expect( previousButton.disabled ).toBe( true );

            const nextButton = element.shadowRoot.querySelector( NEXT_SELECTOR );
            expect( nextButton.disabled ).toBe( false );

            const lastButton = element.shadowRoot.querySelector( LAST_SELECTOR );
            expect( lastButton.disabled ).toBe( false );
        })
    });

    it( 'when on the first page, defined by the offset, but more records exist, will enable the next buttons, but not the previous ones', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 10;
        element.offset          = 0;

        document.body.appendChild( element );

        return Promise.resolve()
        .then( () => {

            const firstButton = element.shadowRoot.querySelector( FIRST_SELECTOR );
            expect( firstButton.disabled ).toBe( true );

            const previousButton = element.shadowRoot.querySelector( PREVIOUS_SELECTOR );
            expect( previousButton.disabled ).toBe( true );

            const nextButton = element.shadowRoot.querySelector( NEXT_SELECTOR );
            expect( nextButton.disabled ).toBe( false );

            const lastButton = element.shadowRoot.querySelector( LAST_SELECTOR );
            expect( lastButton.disabled ).toBe( false );
        })
    });

    it( 'when on the last page, defined by the currentPage, but more records exist, will enable the previous buttons, but not the next ones', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 10;
        element.currentPage     = 10;

        document.body.appendChild( element );

        return Promise.resolve()
        .then( () => {

            const firstButton = element.shadowRoot.querySelector( FIRST_SELECTOR );
            expect( firstButton.disabled ).toBe( false );

            const previousButton = element.shadowRoot.querySelector( PREVIOUS_SELECTOR );
            expect( previousButton.disabled ).toBe( false );

            const nextButton = element.shadowRoot.querySelector( NEXT_SELECTOR );
            expect( nextButton.disabled ).toBe( true );

            const lastButton = element.shadowRoot.querySelector( LAST_SELECTOR );
            expect( lastButton.disabled ).toBe( true );
        })
    });

    it( 'when on the last page, defined by the offset, but more records exist, will enable the previous buttons, but not the next ones', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 10;
        element.offset          = 90;

        document.body.appendChild( element );

        return Promise.resolve()
        .then( () => {

            const firstButton = element.shadowRoot.querySelector( FIRST_SELECTOR );
            expect( firstButton.disabled ).toBe( false );

            const previousButton = element.shadowRoot.querySelector( PREVIOUS_SELECTOR );
            expect( previousButton.disabled ).toBe( false );

            const nextButton = element.shadowRoot.querySelector( NEXT_SELECTOR );
            expect( nextButton.disabled ).toBe( true );

            const lastButton = element.shadowRoot.querySelector( LAST_SELECTOR );
            expect( lastButton.disabled ).toBe( true );
        })
    });

    it( 'when in a middle page, defined by the offset, will enable all the buttons', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 10;
        element.offset          = 50;

        document.body.appendChild( element );

        return Promise.resolve()
        .then( () => {

            const firstButton = element.shadowRoot.querySelector( FIRST_SELECTOR );
            expect( firstButton.disabled ).toBe( false );

            const previousButton = element.shadowRoot.querySelector( PREVIOUS_SELECTOR );
            expect( previousButton.disabled ).toBe( false );

            const nextButton = element.shadowRoot.querySelector( NEXT_SELECTOR );
            expect( nextButton.disabled ).toBe( false );

            const lastButton = element.shadowRoot.querySelector( LAST_SELECTOR );
            expect( lastButton.disabled ).toBe( false );
        })
    });

    it( 'when the page size is bigger than the number of records, will disable all the buttons', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 10;
        element.recordsPerPage  = 20;
        element.offset          = 0;

        document.body.appendChild( element );

        return Promise.resolve()
        .then( () => {

            const firstButton = element.shadowRoot.querySelector( FIRST_SELECTOR );
            expect( firstButton.disabled ).toBe( true );

            const previousButton = element.shadowRoot.querySelector( PREVIOUS_SELECTOR );
            expect( previousButton.disabled ).toBe( true );

            const nextButton = element.shadowRoot.querySelector( NEXT_SELECTOR );
            expect( nextButton.disabled ).toBe( true );

            const lastButton = element.shadowRoot.querySelector( LAST_SELECTOR );
            expect( lastButton.disabled ).toBe( true );
        })
    });

    it( 'when the current page is set, the offset will be set', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 20;
        element.currentPage     = 3;

        expect( element.offset ).toBe( 40 ); // the first record on page 3
    });

    it( 'when the offset is set, the current page will be set', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 20;
        element.offset          = 40;

        expect( element.currentPage ).toBe( 3 );
    });

    it( 'when the offset is set so it is not on a page boundary, it will be rounded down to a page boundary', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 20;
        element.offset          = 45;

        expect( element.offset ).toBe( 40 );
        expect( element.currentPage ).toBe( 3 );
    });

    it( 'when the offset is set to a negative number, it will be set to zero', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 20;
        element.offset          = -45;

        expect( element.offset ).toBe( 0 );
        expect( element.currentPage ).toBe( 1 );
    });

    it( 'when the currentPage is set to a negative number, it will be set to 1', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 20;
        element.currentPage     = -45;

        expect( element.offset ).toBe( 0 );
        expect( element.currentPage ).toBe( 1 );
    });

    it( 'when the current page is set beyond the number of records, it will still render in that position', () => {
        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 10;
        element.currentPage     = 15; // beyond the end

        expect( element.currentPage ).toBe( 15 );

        document.body.appendChild( element );

        return Promise.resolve()
        .then( () => {

            const firstButton = element.shadowRoot.querySelector( FIRST_SELECTOR );
            expect( firstButton.disabled ).toBe( false );

            const previousButton = element.shadowRoot.querySelector( PREVIOUS_SELECTOR );
            expect( previousButton.disabled ).toBe( false );

            const nextButton = element.shadowRoot.querySelector( NEXT_SELECTOR );
            expect( nextButton.disabled ).toBe( true );

            const lastButton = element.shadowRoot.querySelector( LAST_SELECTOR );
            expect( lastButton.disabled ).toBe( true );
        })
    });

    it( 'will show a message containing details on the current page and the label for the page size selector, built up by labels', () => {

        const element = createElement('c-pagination-controls', {
            is: PaginationControls
        });
        element.numberOfRecords = 100;
        element.recordsPerPage  = 10;
        element.currentPage     = 5;

        document.body.appendChild( element );

        return Promise.resolve()
        .then( () => {
            const info = element.shadowRoot.querySelector( INFO_SELECTOR );

            expect( info.textContent ).toBe( 'Total Records: 100 • 5 of 10 • Page Size' );
        })
    });
});