import { createElement } from 'lwc';
import FilterAndResults from 'c/filterAndResults';

jest.mock('@salesforce/label/c.ortoo_core_loading', () => { return { default: "Loading" } }, { virtual: true } );

const CARD_SELECTOR = '[data-ortoo-elem-id="filterandresults-card"]';
const SEARCH_BUTTON_SELECTOR = '[data-ortoo-elem-id="filterandresults-search"]';
const TOP_PAGE_NAVIGATION_SELECTOR = '[data-ortoo-elem-id="filterandresults-pageselectortop"]';
const BOTTOM_PAGE_NAVIGATION_SELECTOR = '[data-ortoo-elem-id="filterandresults-pageselectorbottom"]';

describe( 'c-filter-and-results', () => {

    beforeEach( () => {
        const element = createElement('c-filter-and-result', {
            is: FilterAndResults
        });

        document.body.appendChild( element );
    });

    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it( 'when rendered, includes slots for the info, form, action buttons and the data', () => {

        const element = document.body.querySelector( 'c-filter-and-result' );

        return Promise.resolve()
        .then( () => {
            expect( element.shadowRoot.querySelector( 'slot[name="info"]' ) ).not.toBeNull();
            expect( element.shadowRoot.querySelector( 'slot[name="form"]' ) ).not.toBeNull();
            expect( element.shadowRoot.querySelector( 'slot[name="action-buttons-top"]' ) ).not.toBeNull();
            expect( element.shadowRoot.querySelector( 'slot[name="action-buttons-bottom"]' ) ).not.toBeNull();
            expect( element.shadowRoot.querySelector( 'slot[name="data"]' ) ).not.toBeNull();
        })
    });

    it( 'when loaded is set to true, will show a loading spinner', () => {

        const element = document.body.querySelector( 'c-filter-and-result' );

        element.loading = true;

        return Promise.resolve()
        .then( () => {
            expect( element.shadowRoot.querySelector( 'lightning-spinner' ) ).not.toBeNull();
        })
    });

    it( 'when loaded is set to false, will not show a loading spinner', () => {

        const element = document.body.querySelector( 'c-filter-and-result' );

        element.loading = false;

        return Promise.resolve()
        .then( () => {
            expect( element.shadowRoot.querySelector( 'lightning-spinner' ) ).toBeNull();
        })
    });

    it( 'when disableSearchButton is set to true, will disable the search button', () => {

        const element = document.body.querySelector( 'c-filter-and-result' );

        element.disableSearchButton = true;

        return Promise.resolve()
        .then( () => {
            expect( element.shadowRoot.querySelector( SEARCH_BUTTON_SELECTOR ).disabled ).toBe( true );
        });
    });

    it( 'when disableSearchButton is set to false, will enable the search button', () => {

        const element = document.body.querySelector( 'c-filter-and-result' );

        element.disableSearchButton = false;

        return Promise.resolve()
        .then( () => {
            expect( element.shadowRoot.querySelector( SEARCH_BUTTON_SELECTOR ).disabled ).toBe( false );
        });
    });

    it( 'when showPaginationControls flag is set to true will show pagination controls above and below the data', () => {

        const element = document.body.querySelector( 'c-filter-and-result' );

        element.showPaginationControls = true;

        return Promise.resolve()
        .then( () => {
            expect( element.shadowRoot.querySelector( TOP_PAGE_NAVIGATION_SELECTOR ) ).not.toBeNull();
            expect( element.shadowRoot.querySelector( BOTTOM_PAGE_NAVIGATION_SELECTOR ) ).not.toBeNull();
        })
    });

    it( 'when showPaginationControls flag is set to true will configure the pagination controls with record information', () => {

        const NUMBER_OF_RECORDS = 100;
        const WINDOW_SIZE = 20;
        const OFFSET = 40;

        const element = document.body.querySelector( 'c-filter-and-result' );

        element.showPaginationControls = true;
        element.numberOfRecords = NUMBER_OF_RECORDS;
        element.recordsWindowSize = WINDOW_SIZE;
        element.offset = OFFSET;

        return Promise.resolve()
        .then( () => {
            const topNavigator = element.shadowRoot.querySelector( TOP_PAGE_NAVIGATION_SELECTOR );
            const bottomNavigator = element.shadowRoot.querySelector( BOTTOM_PAGE_NAVIGATION_SELECTOR );

            expect( topNavigator.numberOfRecords ).toBe( NUMBER_OF_RECORDS );
            expect( bottomNavigator.numberOfRecords ).toBe( NUMBER_OF_RECORDS );
            expect( topNavigator.recordsPerPage ).toBe( WINDOW_SIZE );
            expect( bottomNavigator.recordsPerPage ).toBe( WINDOW_SIZE );
            expect( topNavigator.offset ).toBe( OFFSET );
            expect( bottomNavigator.offset ).toBe( OFFSET );
        })
    });

    it( 'when showPaginationControls flag is set to false will not show pagination controls', () => {

        const element = document.body.querySelector( 'c-filter-and-result' );

        element.showPaginationControls = false;

        return Promise.resolve()
        .then( () => {
            expect( element.shadowRoot.querySelector( TOP_PAGE_NAVIGATION_SELECTOR ) ).toBeNull();
            expect( element.shadowRoot.querySelector( BOTTOM_PAGE_NAVIGATION_SELECTOR ) ).toBeNull();
        })
    });

    it( 'when the title is set, will set the card title to the passed value', () => {

        const element = document.body.querySelector( 'c-filter-and-result' );

        element.title = 'The title';

        return Promise.resolve()
        .then( () => {
            expect( element.shadowRoot.querySelector( CARD_SELECTOR ).title ).toBe( 'The title' );
        })
    });

    it( 'when the the search button is clicked, will issue a search event', () => {

        const element = document.body.querySelector( 'c-filter-and-result' );

        const eventHandler = jest.fn();
        element.addEventListener( 'search', eventHandler );

        return Promise.resolve()
        .then( () => {
            element.shadowRoot.querySelector( SEARCH_BUTTON_SELECTOR ).click();
        })
        .then( () => {
            expect( eventHandler ).toHaveBeenCalledTimes( 1 );
        })
    });

    it( 'when the top pagination control issues a navigation event, will forward the detail as a new navigation event', () => {

        const element = document.body.querySelector( 'c-filter-and-result' );
        element.showPaginationControls = true;

        const eventHandler = jest.fn();
        element.addEventListener( 'navigate', eventHandler );

        const eventPayload = {
            detail: 'the original detail'
        }

        return Promise.resolve()
        .then( () => {
            const navigateEvent = new CustomEvent( 'navigate', eventPayload );
            element.shadowRoot.querySelector( TOP_PAGE_NAVIGATION_SELECTOR ).dispatchEvent( navigateEvent );
        })
        .then( () => {
            expect( eventHandler ).toHaveBeenCalledTimes( 1 );
            const receivedEventPayload = eventHandler.mock.calls[0][0];

            expect( receivedEventPayload.detail ).toEqual( eventPayload.detail );
            expect( receivedEventPayload ).not.toBe( eventPayload );
        })
    });
    it( 'when the bottom pagination control issues a navigation event, will forward the detail as a new navigation event', () => {

        const element = document.body.querySelector( 'c-filter-and-result' );
        element.showPaginationControls = true;

        const eventHandler = jest.fn();
        element.addEventListener( 'navigate', eventHandler );

        const eventPayload = {
            detail: 'the original detail'
        }

        return Promise.resolve()
        .then( () => {
            const navigateEvent = new CustomEvent( 'navigate', eventPayload );
            element.shadowRoot.querySelector( BOTTOM_PAGE_NAVIGATION_SELECTOR ).dispatchEvent( navigateEvent );
        })
        .then( () => {
            expect( eventHandler ).toHaveBeenCalledTimes( 1 );
            const receivedEventPayload = eventHandler.mock.calls[0][0];

            expect( receivedEventPayload.detail ).toEqual( eventPayload.detail );
            expect( receivedEventPayload ).not.toBe( eventPayload );
        })
    });
});