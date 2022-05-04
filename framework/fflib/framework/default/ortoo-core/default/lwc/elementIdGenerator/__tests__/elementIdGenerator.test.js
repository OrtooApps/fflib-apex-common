import configureElementIdGenerator from 'c/elementIdGenerator';

describe('configureElementIdGenerator', () => {
    afterEach(() => {
    });

    it( 'will add properties to the passed object based on the ortooIdConfiguration property names with values built from the combination of the ortooIdConfiguration property values and the ortooElemIdPrefix', () => {

        const objectToRunAgainst = {
            ortooElemIdPrefix: 'theprefix',
            ortooIdConfiguration: {
                field1: 'thefield1',
                field2: 'thefield2'
            }
        };

        configureElementIdGenerator( objectToRunAgainst );

        expect( objectToRunAgainst.field1 ).toBe( 'theprefix-thefield1' );
        expect( objectToRunAgainst.field2 ).toBe( 'theprefix-thefield2' );
    });

    it( 'will skip the value if it is not specified', () => {

        const objectToRunAgainst = {
            ortooElemIdPrefix: 'theprefix',
            ortooIdConfiguration: {
                field1: '',
                field2: 'thefield2'
            }
        };

        configureElementIdGenerator( objectToRunAgainst );

        expect( objectToRunAgainst.field1 ).toBe( 'theprefix' );
        expect( objectToRunAgainst.field2 ).toBe( 'theprefix-thefield2' );
    });

    it( 'will throw an error if given an object with no ortooElemIdPrefix property', () => {

        const objectToRunAgainst = {
            ortooIdConfiguration: {
                field1: '',
                field2: 'thefield2'
            }
        };

        expect( () => configureElementIdGenerator( objectToRunAgainst ) ).toThrow();
    });
    it( 'will throw an error if given an object with an empty ortooElemIdPrefix property', () => {

        const objectToRunAgainst = {
            ortooElemIdPrefix: '',
            ortooIdConfiguration: {
                field1: '',
                field2: 'thefield2'
            }
        };

        expect( () => configureElementIdGenerator( objectToRunAgainst ) ).toThrow();
    });
    it( 'will throw an error if given an object with a null ortooElemIdPrefix property', () => {

        const objectToRunAgainst = {
            ortooElemIdPrefix: null,
            ortooIdConfiguration: {
                field1: '',
                field2: 'thefield2'
            }
        };

        expect( () => configureElementIdGenerator( objectToRunAgainst ) ).toThrow();
    });

    it( 'will throw an error if given an object with no ortooIdConfiguration property', () => {

        const objectToRunAgainst = {
            ortooElemIdPrefix: 'theprefix'
        };

        expect( () => configureElementIdGenerator( objectToRunAgainst ) ).toThrow();
    });

    it( 'will not throw an error if given an object with an empty object for the ortooIdConfiguration property', () => {

        const objectToRunAgainst = {
            ortooElemIdPrefix: 'theprefix',
            ortooIdConfiguration: {}
        };

        expect( () => configureElementIdGenerator( objectToRunAgainst ) ).not.toThrow();
    });
});