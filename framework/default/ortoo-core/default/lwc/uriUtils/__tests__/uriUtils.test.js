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
    it( 'will decode %20 as space in property names', () => {

        location.hash = 'property%201=%22value%22';

        const expected = {};
        expected[ 'property 1' ] = 'value';
        const got = UriUtils.getUriFragmentAsObject();

        expect( got ).toEqual( expected );
    })

    it( 'will skip strings with no equals in them', () => {

        location.hash = 'property1=%22value1%22&ignorethisbit&property2=%22value2%22';

        const expected = {
            property1: 'value1',
            property2: 'value2'
        };
        const got = UriUtils.getUriFragmentAsObject();

        expect( got ).toEqual( expected );
    })
    it( 'will skip values that do not decode properly', () => {

        location.hash = 'property1=%22value1%22&invalid=%22incompleteJson&property2=%22value2%22';

        const expected = {
            property1: 'value1',
            property2: 'value2'
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

describe( 'addFragmentToUri', () => {

    it( 'when given a uri with no fragment and an object, will encode the object and add it as the fragment', () => {

        const uri = 'theBaseUri';
        const fragmentObject = { param: 'value' };

        const got = UriUtils.addFragmentToUri( uri, fragmentObject );

        expect( got ).toBe( 'theBaseUri#param=%22value%22' );
    });

    it( 'when given a uri with a fragment and an object, will encode the object and add to the end of the fragment', () => {

        const uri = 'theBaseUri#originalfragment';
        const fragmentObject = { param: 'value' };

        const got = UriUtils.addFragmentToUri( uri, fragmentObject );

        expect( got ).toBe( 'theBaseUri#originalfragment&param=%22value%22' );
    });

    it( 'when given a uri without a fragment and an empty object, will return the uri untouched', () => {

        const uri = 'theBaseUri';
        const fragmentObject = {};

        const got = UriUtils.addFragmentToUri( uri, fragmentObject );

        expect( got ).toBe( 'theBaseUri' );
    });
    it( 'when given a uri without a fragment and undefined, will return the uri untouched', () => {

        const uri = 'theBaseUri';

        const got = UriUtils.addFragmentToUri( uri );

        expect( got ).toBe( 'theBaseUri' );
    });

    it( 'when given a uri without a fragment and an empty object, will return the uri untouched', () => {

        const uri = 'theBaseUri';
        const fragmentObject = {};

        const got = UriUtils.addFragmentToUri( uri, fragmentObject );

        expect( got ).toBe( 'theBaseUri' );
    });

    it( 'when given a uri with a fragment and an empty object, will return the uri untouched', () => {

        const uri = 'theBaseUri#originalfragment';
        const fragmentObject = {};

        const got = UriUtils.addFragmentToUri( uri, fragmentObject );

        expect( got ).toBe( 'theBaseUri#originalfragment' );
    });

    it( 'when given a uri and a string fragment, will return the uri with the string fragment added', () => {

        const uri = 'theBaseUri';
        const fragment = 'astring';

        const got = UriUtils.addFragmentToUri( uri, fragment );

        expect( got ).toBe( 'theBaseUri#astring' );
    });

    it( 'when given a uri with a fragment and a string fragment, will return the uri with the string fragment added', () => {

        const uri = 'theBaseUri#existingFragment';
        const fragment = 'astring';

        const got = UriUtils.addFragmentToUri( uri, fragment );

        expect( got ).toBe( 'theBaseUri#existingFragment&astring' );
    });
});