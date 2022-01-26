import displayError from 'c/errorRenderer';
import ERROR_TITLE from '@salesforce/label/c.ortoo_core_datatable_sorting_disabled_title';

const checkColumnProperty = function( functionName, object, columnsPropertyName ) {

    if ( object[columnsPropertyName] == undefined ) {
        throw functionName + ' called with a property ('+columnsPropertyName+') that does not exist.  Have you bound your instance by using "bind" or "call"?';
    }

    if ( object[columnsPropertyName].forEach == undefined ) {
        throw functionName + ' called with a property ('+columnsPropertyName+') that is not an Array.';
    }

    if ( object[columnsPropertyName].find( thisElement => typeof thisElement !== 'object' ) ) {
        throw functionName + ' called with a property ('+columnsPropertyName+') that is not an Array of Objects.';
    }
}


const refreshConfiguration = function( columnsPropertyName ) {

    checkColumnProperty( 'refreshConfiguration', this, columnsPropertyName );

    let newConfiguration = [];
    this[columnsPropertyName].forEach( thisElement => newConfiguration.push( Object.assign( {}, thisElement ) ) );
    this[columnsPropertyName] = newConfiguration;
}

const configureSortableFields = function( columnsPropertyName, fields, error ) {

    const errorTitle = ERROR_TITLE;

    if ( error ) {

        displayError.call( this, error, { title: errorTitle } );

    } else if ( fields ) {

        checkColumnProperty( 'configureSortableFields', this, columnsPropertyName );

        try {

            fields.forEach(
                thisSortableField => {
                    const referencedField = this[ columnsPropertyName ].find( thisColumn => thisColumn.fieldName == thisSortableField );
                    referencedField && ( referencedField.sortable = true );
                }
            );
            refreshConfiguration.call( this, columnsPropertyName );
        } catch ( e ) {
            displayError.call( this, e, errorTitle );
        }
    }
}

export default {
    refreshConfiguration : refreshConfiguration,
    configureSortableFields : configureSortableFields
};