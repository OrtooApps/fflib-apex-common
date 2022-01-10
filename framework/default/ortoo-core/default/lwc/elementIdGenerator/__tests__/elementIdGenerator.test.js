import configureElementIdGenerator from 'c/elementIdGenerator';

let showToastEvent = function ShowToastEvent( details ) {
    this.detail = details
};

jest.mock('lightning/platformShowToastEvent', () => ({
    ShowToastEvent: showToastEvent
}));

describe('c-element-id-generator', () => {
    afterEach(() => {
    });

    it( 'is tested', () => {
        expect( false ).toBe( true );
    });
});