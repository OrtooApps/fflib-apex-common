import DatatableHelper from 'c/datatableHelper';
import displayError from 'c/errorRenderer';

jest.mock( 'c/errorRenderer' );

jest.mock('@salesforce/label/c.ortoo_core_datatable_sorting_disabled_title', () => { return { default: "Sorting configuration error" } }, { virtual: true } );

describe( 'refreshConfiguration', () => {

    beforeEach( () => {
        displayError.mockClear();
    })

    it( 'when executed against an object with the specified field as an array of objects, will clone it (shallow clone the objects in the array)', () => {

        const propertyToClone = [
            { property: 'value0', property1: 'value1', objectProperty: { property: 'subProperty' } },
            { property: 'value2', property1: 'value3' },
        ];

        const objectToRunAgainst = {
            columnsProperty: propertyToClone
        };

        DatatableHelper.refreshConfiguration.call( objectToRunAgainst, 'columnsProperty' );

        expect( objectToRunAgainst.columnsProperty ).toEqual( propertyToClone );
        expect( objectToRunAgainst.columnsProperty ).not.toBe( propertyToClone );

        expect( objectToRunAgainst.columnsProperty[0] ).toEqual( propertyToClone[0] );
        expect( objectToRunAgainst.columnsProperty[0] ).not.toBe( propertyToClone[0] );

        expect( objectToRunAgainst.columnsProperty[1] ).toEqual( propertyToClone[1] );
        expect( objectToRunAgainst.columnsProperty[1] ).not.toBe( propertyToClone[1] );

        expect( objectToRunAgainst.columnsProperty[0].objectProperty ).toBe( propertyToClone[0].objectProperty ); // at this level we no longer clone
    });

    it( 'when executed against an object with the specified field not an array, will throw', () => {

        const propertyToClone = 'not an array';

        const objectToRunAgainst = {
            columnsProperty: propertyToClone
        };

        const call = () => DatatableHelper.refreshConfiguration.call( objectToRunAgainst, 'columnsProperty' );

        expect( call ).toThrow( 'refreshConfiguration called with a property (columnsProperty) that is not an Array' );
    });

    it( 'when executed against an object with the specified field not an array of objects, will throw', () => {

        const propertyToClone = ['not an array of objects'];

        const objectToRunAgainst = {
            columnsProperty: propertyToClone
        };

        const call = () => DatatableHelper.refreshConfiguration.call( objectToRunAgainst, 'columnsProperty' );

        expect( call ).toThrow( 'refreshConfiguration called with a property (columnsProperty) that is not an Array of Objects.' );
    });
});

describe( 'configureSortableFields', () => {

    beforeEach( () => {
        displayError.mockClear();
    })

    it( 'when bound to an object with a columns definition, the name of the right property and list of columns that are sortable, will set the sortable property on the appropriate columns', () => {

        const columns = [
            { fieldName: 'field0' },
            { fieldName: 'field1' },
            { fieldName: 'field2' },
            { fieldName: 'field3' },
            { fieldName: 'field4' },
        ];

        const objectToRunAgainst = {
            columnsProperty: columns
        };

        const sortableColumns = [ 'field0', 'field2', 'field4' ];

        DatatableHelper.configureSortableFields.call( objectToRunAgainst, 'columnsProperty', sortableColumns, null );

        expect( objectToRunAgainst.columnsProperty[0].sortable ).toBe( true );
        expect( objectToRunAgainst.columnsProperty[1].sortable ).toBeUndefined();
        expect( objectToRunAgainst.columnsProperty[2].sortable ).toBe( true );
        expect( objectToRunAgainst.columnsProperty[3].sortable ).toBeUndefined();
        expect( objectToRunAgainst.columnsProperty[4].sortable ).toBe( true );
    });

    it( 'when told a column that does not exist is sortable, will skip it', () => {

        const columns = [
            { fieldName: 'field0' },
            { fieldName: 'field1' },
            { fieldName: 'field2' }
        ];

        const objectToRunAgainst = {
            columnsProperty: columns
        };

        const sortableColumns = [ 'field0', 'someOtherField', 'field2' ];

        DatatableHelper.configureSortableFields.call( objectToRunAgainst, 'columnsProperty', sortableColumns, null );

        expect( objectToRunAgainst.columnsProperty[0].sortable ).toBe( true );
        expect( objectToRunAgainst.columnsProperty[1].sortable ).toBeUndefined();
        expect( objectToRunAgainst.columnsProperty[2].sortable ).toBe( true );
    });

    it( 'when given an empty list of columns, will not set any as sortable', () => {

        const columns = [
            { fieldName: 'field0' },
            { fieldName: 'field1' },
            { fieldName: 'field2' }
        ];

        const objectToRunAgainst = {
            columnsProperty: columns
        };

        const sortableColumns = [];

        DatatableHelper.configureSortableFields.call( objectToRunAgainst, 'columnsProperty', sortableColumns, null );

        expect( objectToRunAgainst.columnsProperty[0].sortable ).toBeUndefined();
        expect( objectToRunAgainst.columnsProperty[1].sortable ).toBeUndefined();
        expect( objectToRunAgainst.columnsProperty[2].sortable ).toBeUndefined();
    });

    it( 'when the column definition includes an object that does not have a fieldName, will skip it', () => {

        const columns = [
            { fieldName: 'field0' },
            { fieldName: 'field1' },
            {},
            { fieldName: 'field2' }
        ];

        const objectToRunAgainst = {
            columnsProperty: columns
        };

        const sortableColumns = [ 'field1', 'field2' ];

        DatatableHelper.configureSortableFields.call( objectToRunAgainst, 'columnsProperty', sortableColumns, null );

        expect( objectToRunAgainst.columnsProperty[0].sortable ).toBeUndefined();
        expect( objectToRunAgainst.columnsProperty[1].sortable ).toBe( true );
        expect( objectToRunAgainst.columnsProperty[2].sortable ).toBeUndefined();
        expect( objectToRunAgainst.columnsProperty[3].sortable ).toBe( true );
    });

    it( 'when the column property is empty, will not throw', () => {

        const columns = [
        ];

        const objectToRunAgainst = {
            columnsProperty: columns
        };

        const sortableColumns = [ 'field1', 'field2' ];

        DatatableHelper.configureSortableFields.call( objectToRunAgainst, 'columnsProperty', sortableColumns, null );

        expect( objectToRunAgainst.columnsProperty.length ).toBe( 0 );
    });

    it( 'when called without being bound to an object, will throw', () => {

        const sortableColumns = [ 'field1', 'field2' ];

        const call = () => DatatableHelper.configureSortableFields( 'columnsProperty', sortableColumns, null );

        expect( call ).toThrow( 'configureSortableFields called with a property (columnsProperty) that does not exist.  Have you bound your instance by using "bind" or "call"?' );
    });

    it( 'when the passed column property does not exist on the bound object, will throw', () => {

        const objectToRunAgainst = {};

        const sortableColumns = [ 'field1', 'field2' ];

        const call = () => DatatableHelper.configureSortableFields.call( objectToRunAgainst, 'columnsProperty', sortableColumns, null );

        expect( call ).toThrow( 'configureSortableFields called with a property (columnsProperty) that does not exist.' );
    });

    it( 'when the passed column property is not an array, will throw', () => {

        const columns = 'this is not an array';

        const objectToRunAgainst = {
            columnsProperty: columns
        };
        const sortableColumns = [ 'field1', 'field2' ];

        const call = () => DatatableHelper.configureSortableFields.call( objectToRunAgainst, 'columnsProperty', sortableColumns, null );

        expect( call ).toThrow( 'configureSortableFields called with a property (columnsProperty) that is not an Array.' );
    });

    it( 'when the passed column property is not an array of objects, will throw', () => {

        const columns = [
            {},
            'this is not an object',
            {}
        ];

        const objectToRunAgainst = {
            columnsProperty: columns
        };
        const sortableColumns = [ 'field1', 'field2' ];

        const call = () => DatatableHelper.configureSortableFields.call( objectToRunAgainst, 'columnsProperty', sortableColumns, null );

        expect( call ).toThrow( 'configureSortableFields called with a property (columnsProperty) that is not an Array of Objects.' );
    });

    it( 'when given an error, will report that error and return', () => {

        const columns = [
            {}
        ];

        const objectToRunAgainst = {
            columnsProperty: columns
        };
        const sortableColumns = [ 'field1', 'field2' ];

        const error = 'This is an error';

        DatatableHelper.configureSortableFields.call( objectToRunAgainst, 'columnsProperty', sortableColumns, error );

        expect( displayError.mock.calls[0][0] ).toBe( 'This is an error' );
        expect( displayError.mock.calls[0][1]?.title ).toBe( 'Sorting configuration error' );
    });
});

describe( 'configureLabelsBasedOnSobjectDefinition', () => {

    it( 'when bound to an object with a columns definition, the name of the right property and a definition with some fields that have labels', () => {

        const columns = [
            { label: 'original', fieldName: 'contact-firstname', labelSobject: 'Contact', labelSobjectField: 'FirstName' },
            { label: 'original', fieldName: 'contact-lastname', labelSobject: 'Contact', labelSobjectField: 'LastName' },
            { label: 'original', fieldName: 'account-name', labelSobject: 'Account', labelSobjectField: 'Name' },
            { label: 'original', fieldName: 'contact-name', labelSobject: 'Contact', labelSobjectField: 'Name' },
        ];

        const objectToRunAgainst = {
            columnsProperty: columns
        };

        const sobjectDefinition = {
			apiName: 'Contact',
			fields: {
				FirstName: {
					label: 'First Name Label'
				},
				LastName: {
					label: 'Last Name Label'
				},
				Name: {
					label: 'Name Label'
				},
			}
		}

        DatatableHelper.configureLabelsBasedOnSobjectDefinition.call( objectToRunAgainst, 'columnsProperty', sobjectDefinition );

        expect( objectToRunAgainst.columnsProperty[0].label ).toBe( 'First Name Label' );
        expect( objectToRunAgainst.columnsProperty[1].label ).toBe( 'Last Name Label' );
        expect( objectToRunAgainst.columnsProperty[2].label ).toBe( 'original' );
        expect( objectToRunAgainst.columnsProperty[3].label ).toBe( 'Name Label' );
    });

	it( 'when columns include labelSobject and labelSobjectField combinations that do not exist, will ignore them', () => {

        const columns = [
            { label: 'original', fieldName: 'contact-firstname', labelSobject: 'Contact', labelSobjectField: 'FirstName' },
            { label: 'original', fieldName: 'contact-lastname', labelSobject: 'Contact', labelSobjectField: 'LastName' },
            { label: 'original', fieldName: 'account-name', labelSobject: 'Account', labelSobjectField: 'Name' },
            { label: 'original', fieldName: 'contact-name', labelSobject: 'Contact', labelSobjectField: 'Name' },
        ];

        const objectToRunAgainst = {
            columnsProperty: columns
        };

        const sobjectDefinition = {
			apiName: 'Contact',
			fields: {
				LastName: {
					label: 'Last Name Label'
				},
			}
		}

        DatatableHelper.configureLabelsBasedOnSobjectDefinition.call( objectToRunAgainst, 'columnsProperty', sobjectDefinition );

        expect( objectToRunAgainst.columnsProperty[0].label ).toBe( 'original' );
        expect( objectToRunAgainst.columnsProperty[1].label ).toBe( 'Last Name Label' );
        expect( objectToRunAgainst.columnsProperty[2].label ).toBe( 'original' );
        expect( objectToRunAgainst.columnsProperty[3].label ).toBe( 'original' );
    });

	it( 'when columns include entries with no labelSobject or labelSobjectField, will ignore them', () => {

        const columns = [
            { label: 'original', fieldName: 'ignore-no-properties' },
            { label: 'original', fieldName: 'ignore-noobject',labelSobjectField: 'LastName' },
            { label: 'original', fieldName: 'ignore-nofield', labelSobject: 'Contact' },
            { label: 'original', fieldName: 'contact-name', labelSobject: 'Contact', labelSobjectField: 'Name' },
        ];

        const objectToRunAgainst = {
            columnsProperty: columns
        };

        const sobjectDefinition = {
			apiName: 'Contact',
			fields: {
				Name: {
					label: 'Name Label'
				},
			}
		}

        DatatableHelper.configureLabelsBasedOnSobjectDefinition.call( objectToRunAgainst, 'columnsProperty', sobjectDefinition );

        expect( objectToRunAgainst.columnsProperty[0].label ).toBe( 'original' );
        expect( objectToRunAgainst.columnsProperty[1].label ).toBe( 'original' );
        expect( objectToRunAgainst.columnsProperty[2].label ).toBe( 'original' );
        expect( objectToRunAgainst.columnsProperty[3].label ).toBe( 'Name Label' );
    });

    it( 'when the sobjectDefinition is null', () => {

        const columns = [
            { label: 'alabel', fieldName: 'afield' },
        ];

        const objectToRunAgainst = {
            columnsProperty: columns
        };

        DatatableHelper.configureLabelsBasedOnSobjectDefinition.call( objectToRunAgainst, 'columnsProperty', null );

        expect( objectToRunAgainst.columnsProperty.length ).toBe( 1 );
    });

    it( 'when the column property is empty, will not throw', () => {

        const columns = [
        ];

        const objectToRunAgainst = {
            columnsProperty: columns
        };

        const sobjectDefinition = {
			apiName: 'Contact',
			fields: {
				Name: {
					label: 'Name Label'
				},
			}
		}

        DatatableHelper.configureLabelsBasedOnSobjectDefinition.call( objectToRunAgainst, 'columnsProperty', sobjectDefinition );

        expect( objectToRunAgainst.columnsProperty.length ).toBe( 0 );
    });

	it( 'when called without being bound to an object, will throw', () => {

        const sobjectDefinition = {
			apiName: 'Contact',
			fields: {
				Name: {
					label: 'Name Label'
				},
			}
		}

        const call = () => DatatableHelper.configureLabelsBasedOnSobjectDefinition( 'columnsProperty', sobjectDefinition );

        expect( call ).toThrow( 'configureLabelsBasedOnSobjectDefinition called with a property (columnsProperty) that does not exist.  Have you bound your instance by using "bind" or "call"?' );
    });

    it( 'when the passed column property does not exist on the bound object, will throw', () => {

        const objectToRunAgainst = {};

        const sobjectDefinition = {
			apiName: 'Contact',
			fields: {
				Name: {
					label: 'Name Label'
				},
			}
		}

        const call = () => DatatableHelper.configureLabelsBasedOnSobjectDefinition.call( objectToRunAgainst, 'columnsProperty', sobjectDefinition );

        expect( call ).toThrow( 'configureLabelsBasedOnSobjectDefinition called with a property (columnsProperty) that does not exist.' );
    });

    it( 'when the passed column property is not an array, will throw', () => {

        const columns = 'this is not an array';

        const objectToRunAgainst = {
            columnsProperty: columns
        };

		const sobjectDefinition = {
			apiName: 'Contact',
			fields: {
				Name: {
					label: 'Name Label'
				},
			}
		}

        const call = () => DatatableHelper.configureLabelsBasedOnSobjectDefinition.call( objectToRunAgainst, 'columnsProperty', sobjectDefinition );

        expect( call ).toThrow( 'configureLabelsBasedOnSobjectDefinition called with a property (columnsProperty) that is not an Array.' );
    });

    it( 'when the passed column property is not an array of objects, will throw', () => {

        const columns = [
            {},
            'this is not an object',
            {}
        ];

        const objectToRunAgainst = {
            columnsProperty: columns
        };

		const sobjectDefinition = {
			apiName: 'Contact',
			fields: {
				Name: {
					label: 'Name Label'
				},
			}
		}

        const call = () => DatatableHelper.configureLabelsBasedOnSobjectDefinition.call( objectToRunAgainst, 'columnsProperty', sobjectDefinition );

        expect( call ).toThrow( 'configureLabelsBasedOnSobjectDefinition called with a property (columnsProperty) that is not an Array of Objects.' );
    });

});
