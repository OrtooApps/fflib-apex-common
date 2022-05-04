/**
 * Library functions that provide the ability to set properties onto and get properties off the URI Fragment
 *
 * Be aware that anything put onto the URI Fragment is public, editable and can no longer be trusted.
 * Only allow user editable data to be up onto the URI.
 *
 * Under no circumstances should sensitive information or security related entities (such as feature flags)
 * be placed on the URI.
 *
 * Warning: Whilst it will encode Date and DateTime properties it may not do what you expect (due to timezones).
 * 			It is advised that you explicitly format the dates prior to using them in these functions.
 */

const addFragmentToUri = ( uri, object ) => {
	const fragment = buildUriFragment( object );
	return fragment
			? ( uri.includes( '#' ) )
				? uri + '&' + fragment
				: uri + '#' + fragment
			: uri;
}

const setUriFragmentObject = object => {
	location.hash = buildUriFragment( object );
}

const getUriFragmentAsObject = () => {
	return interpretUriFragment( location.hash );
}

const registerUriFragmentListener = handler => {
	window.addEventListener( 'hashchange', handler );
}

const buildUriFragment = objectToHash => {

	const hashes = [];
	if ( !isObject( objectToHash ) ) {
		return objectToHash;
	}
	const flattenedObject = flatten( objectToHash );

	for ( const propertyName in flattenedObject ) {
		if ( flattenedObject[ propertyName ] !== undefined && flattenedObject[ propertyName ] !== '' ) {
			hashes.push( encodeURIComponent( propertyName ) + '=' + encodeURIComponent( JSON.stringify( flattenedObject[ propertyName ] ) ) );
		}
 	}
	return hashes.join( '&' );
}

const interpretUriFragment = hashToInterpret => {

	if ( !hashToInterpret ) {
		return {};
	}

	if ( hashToInterpret.includes( '#' ) ) {
		hashToInterpret = hashToInterpret.substring( hashToInterpret.indexOf( '#' ) + 1 );
	}

	if ( ! hashToInterpret.includes( '=' ) ) {
		return decodeURIComponent( hashToInterpret );
	}

	const flatObject = {};

	hashToInterpret
		.split( '&' )
		.forEach( thisParameterPairString => {
			if ( thisParameterPairString.includes( '=' ) ) {
				const [rawParameterName,rawParameterValue] = thisParameterPairString.split( '=' );

				let parameterValue = '';
				try {
					parameterValue = JSON.parse( decodeURIComponent( rawParameterValue ) );
					flatObject[ decodeURIComponent( rawParameterName ) ] = parameterValue;
				} catch ( e ) {
					console.error( 'Invalid parameter value in URI fragment' );
				}
			}
		});

	return expand( flatObject );
}

const flatten = objectToFlatten => {

	const result = {};

	for ( const propertyName in objectToFlatten ) {
		if ( isObject( objectToFlatten[ propertyName ] ) ) {
			const flattenedChild = flatten( objectToFlatten[ propertyName ] );
			for ( const childPropertyName in flattenedChild ) {

				result[ propertyName + '.' +  childPropertyName ] = flattenedChild[ childPropertyName ];
			}
		} else {
			result[ propertyName ] = objectToFlatten[ propertyName ];
		}
	}
	return result;
};

const expand = ( objectToExpand, objectToAssignTo ) => {

	! objectToAssignTo && ( objectToAssignTo = {} );

	for ( const propertyName in objectToExpand ) {

		if ( propertyName.includes( '.' ) ) {

			const parentPropertyName = propertyName.substring( 0, propertyName.indexOf( '.' ) );
			const childPropertyName = propertyName.substring( propertyName.indexOf( '.' ) + 1 );

			const child = [];
			child[ childPropertyName ] = objectToExpand[ propertyName ];
			!objectToAssignTo[ parentPropertyName ] && ( objectToAssignTo[ parentPropertyName ] = {} );

			expand( child, objectToAssignTo[ parentPropertyName ] );

		} else {
			objectToAssignTo[ propertyName ] = objectToExpand[ propertyName ];
		}
	}
	return objectToAssignTo;
}

const isObject = potentialObject => typeof potentialObject === 'object' && !Array.isArray( potentialObject );

export default {
	addFragmentToUri : addFragmentToUri,
	setUriFragmentObject : setUriFragmentObject,
	getUriFragmentAsObject : getUriFragmentAsObject,
	registerUriFragmentListener : registerUriFragmentListener,
};