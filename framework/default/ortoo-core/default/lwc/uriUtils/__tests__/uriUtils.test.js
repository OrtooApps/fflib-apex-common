import UriUtils from 'c/uriUtils';

describe( 'setUriFragmentObject', () => {

    beforeEach( () => {
    })

    it( 'when given simple object properties will write a set of property value pairs with the values JSON stringified', () => {

        const objectToSet = {
            property1: 'value1',
            property2: 'value2'
        };

        UriUtils.setUriFragmentObject( objectToSet );

        expect( location.hash ).toBe( '#property1=%22value1%22&property2=%22value2%22' );
    });

    it( 'when given an object with an empty string, will not add the empty one', () => {

        const objectToSet = {
            property1: 'value1',
            emptyProperty: '',
            property2: 'value2'
        };

        UriUtils.setUriFragmentObject( objectToSet );

        expect( location.hash ).toBe( '#property1=%22value1%22&property2=%22value2%22' );
    });

    it( 'when given simple object properties with &, ?, = and spaces in the values will write a set of property value pairs encoded', () => {

        const objectToSet = {
            property1: 'value 1 & 2 = 3',
            property2: 'value 2 & 3 = 4'
        };

        UriUtils.setUriFragmentObject( objectToSet );

        expect( location.hash ).toBe( '#property1=%22value%201%20%26%202%20%3D%203%22&property2=%22value%202%20%26%203%20%3D%204%22' );
    });

    it( 'when given simple object properties with &, ?, = and spaces in the property names will write a set of property value pairs encoded', () => {

        const objectToSet = {}
        objectToSet[ 'property 1 & 2 = 3' ] = 'value1';
        objectToSet[ 'property 2 & 3 = 4' ] = 'value1';

        UriUtils.setUriFragmentObject( objectToSet );

        expect( location.hash ).toBe( '#property%201%20%26%202%20%3D%203=%22value1%22&property%202%20%26%203%20%3D%204=%22value1%22' );
    });

    it( 'when given layered objects, will flatten the object into property value pairs', () => {

        const objectToSet = {
            simpleProperty: 'simpleValue',
            objectProperty: {
                childProperty: 'childValue',
                childProperty2: 'childValue2'
            },
        };
        UriUtils.setUriFragmentObject( objectToSet );

        expect( location.hash ).toBe( '#simpleProperty=%22simpleValue%22&objectProperty.childProperty=%22childValue%22&objectProperty.childProperty2=%22childValue2%22' );
    });

    it( 'when given deeply layered objects, will flatten the object into property value pairs', () => {

        const objectToSet = {
            simpleProperty: 'simpleValue',
            objectProperty: {
                childProperty: 'childValue',
                childProperty2: 'childValue2',
                childProperty3: {
                    grandchildProperty: 'grandchildValue'
                }
            },
        };
        UriUtils.setUriFragmentObject( objectToSet );

        expect( location.hash ).toBe( '#simpleProperty=%22simpleValue%22&objectProperty.childProperty=%22childValue%22&objectProperty.childProperty2=%22childValue2%22&objectProperty.childProperty3.grandchildProperty=%22grandchildValue%22' );
    });

    it( 'when given different datatypes, will format them as JSON', () => {

        const objectToSet = {
            stringProperty  : 'string',
            integerProperty : 1,
            decimalProperty : 1.2,
            booleanProperty : true,
        };
        UriUtils.setUriFragmentObject( objectToSet );

        expect( location.hash ).toBe( '#stringProperty=%22string%22&integerProperty=1&decimalProperty=1.2&booleanProperty=true' );
    });

    it( 'when given an array element, will render it', () => {

        const objectToSet = {
            arrayProperty: [ 'value1', 'value2', 'value3' ]
        };
        UriUtils.setUriFragmentObject( objectToSet );

        expect( location.hash ).toBe( '#arrayProperty=%5B%22value1%22%2C%22value2%22%2C%22value3%22%5D' );
    });

    it( 'when given an empty object, will set it to empty', () => {

        const objectToSet = {};

        location.hash = 'previouslySet';
        UriUtils.setUriFragmentObject( objectToSet );

        expect( location.hash ).toBe( '' );
    });

    it( 'when given a string, will set it to that string', () => {

        UriUtils.setUriFragmentObject( 'not an object' );

        expect( location.hash ).toBe( '#not%20an%20object' );
    });

});

describe( 'getUriFragmentAsObject', () => {
    it( 'will decode %20 as space in property values', () => {

        location.hash = 'property1=%22value%201%20%26%202%20%3D%203%22';

        const expected = {
            property1: 'value 1 & 2 = 3'
        };

        const got = UriUtils.getUriFragmentAsObject();

        expect( got ).toEqual( expected );
    })
});

describe( 'setUriFragmentObject / getUriFragmentAsObject', () => {
    it( 'when given complex objects, will serialise and deserialise them so they match', () => {

        const objectToSet = {
            simpleProperty: 'value1',
            arrayProperty: [ 'arrayvalue1', 'arrayvalue2' ],
            booleanProperty: true,
            numberProperty: 5,
            objectProperty: {
                simpleProperty: 'childvalue1',
                arrayProperty: ['childarrayvalue1', 'childarrayvalue2' ],
                objectProperty: {
                    simpleProperty: 'grandchildvalue1',
                }
            }
        };

        UriUtils.setUriFragmentObject( objectToSet );

        const got = UriUtils.getUriFragmentAsObject();

        expect( got ).toEqual( objectToSet );
    });

    it( 'when given string, will serialise and deserialise them so they match', () => {

        const stringToSet = 'a string';

        UriUtils.setUriFragmentObject( stringToSet );

        const got = UriUtils.getUriFragmentAsObject();

        expect( got ).toEqual( stringToSet );
    });
});

describe( 'registerUriFragmentListener', () => {

    beforeAll(() => {
        window.addEventListener = jest.fn();
    })

    it( 'will register the given function as an event listener for hashchanges on the window', () => {

        const handler = jest.fn();

        const got = UriUtils.registerUriFragmentListener( handler );

        expect( window.addEventListener ).toHaveBeenCalledTimes( 1 );
        expect( window.addEventListener ).toHaveBeenCalledWith( 'hashchange', handler );
    });
});