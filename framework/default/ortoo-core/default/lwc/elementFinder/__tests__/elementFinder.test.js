import configureFindElement from 'c/elementFinder';

describe( 'configureFindElement', () => {
    it( 'will add a "findElement" function against the passed object', () => {

        const objectToRunAgainst = {};

        configureFindElement( objectToRunAgainst );

        expect( objectToRunAgainst.findElement ).toBeDefined();
    });
});

describe( 'findElement', () => {
    it( 'will ask the bound object for the element with the specified data-ortoo-elem-id', () => {

        const mockQuerySelector = jest.fn();

        const objectToRunAgainst = {
            template: {
                querySelector: mockQuerySelector
            }
        };
        mockQuerySelector.mockReturnValueOnce( 'the element' );

        configureFindElement( objectToRunAgainst );

        const response = objectToRunAgainst.findElement( 'test-element' );

        expect( response ).toBe( 'the element' );
        expect( mockQuerySelector ).toBeCalledWith( '[data-ortoo-elem-id="test-element"]' );
    });
});