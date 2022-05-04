/**
 * Utility class that provides extra capabilities related to building URIs
 *
 * @group Utils
 */
public inherited sharing class UriUtils
{
	/**
	 * Given a Map of property name to value pairs, will output them in a format that uriUtils.js can interpret.
	 *
	 * Supports each element being one of:
	 *		* Primitive (e.g. String / Boolean / Integer)
	 *		* List of primitives
	 *		* Map<String,Object>
	 *
	 * Warning: Whilst it will encode Date and DateTime properties it may not do what you expect (due to timezones).
	 * 			It is advised that you explicitly format the dates prior to passing them into this method.
	 *
	 *	@param	Map<String,Object>	The properties to generate the URI fragment for
	 *	@return	String				The resulting URI fragment that represents the properties
	 */
	public static String buildUriFragment( Map<String,Object> properties )
	{
		Contract.requires( properties != null, 'buildUriFragment called with a null properties' );
		return String.join( encodeProperties( '', properties ), '&' );
	}

	/**
	 * Given a PageReference and Map of property name to value pairs, will add the properties to the PageReference
	 * as an anchor.
	 *
	 * Supports the structures described against buildUriFragment
	 *
	 * Warning: Whilst it will encode Date and DateTime properties it may not do what you expect (due to timezones).
	 * 			It is advised that you explicitly format the dates prior to passing them into this method.
	 *
	 *	@param	PageReference		The PageReference to add the URI fragment to
	 *	@param	Map<String,Object>	The properties to generate the URI fragment for
	 */
	public static void addUriFragment( PageReference pageReference, Map<String,Object> properties )
	{
		Contract.requires( pageReference != null, 'addUriFragment called with a null pageReference' );
		Contract.requires( properties != null, 'addUriFragment called with a null properties' );

		pageReference.setAnchor( buildUriFragment( properties ) );
	}

	private static List<String> encodeProperties( String parentPropertyName, Map<String,Object> propertyValues )
	{
		List<String> encodedProperties = new List<String>();
		for( String thisPropertyName : propertyValues.keySet() )
		{
			String fullPropertyName = String.isBlank( parentPropertyName ) ? thisPropertyName : parentPropertyName + '.' + thisPropertyName;

			encodedProperties.addAll(
				encodeProperty( fullPropertyName, propertyValues.get( thisPropertyName ) )
			);
		}
		return encodedProperties;
	}

	private static List<String> encodeProperty( String propertyName, Object propertyValue )
	{
		try
		{
			return encodeProperties( propertyName, (Map<String,Object>)propertyValue );
		}
		catch ( Exception e )
		{} // NOPMD: intentionally left blank as this is the simplest way to check if propertyValue is a Map

		if ( String.isEmpty( String.valueOf( propertyValue ) ) ) {
			return new List<String>();
		}

		return new List<String>
		{
			urlEncode( propertyName ) + '=' + urlEncode( JSON.serialize( propertyValue ) )
		};
	}

	// Private version of urlEncode that ensures that spaces are encoded with %20 instead of +
	// since this is how they should be represented in the fragment
	private static String urlEncode( String value )
	{
		return EncodingUtil.urlEncode( value, 'UTF-8' ).replaceAll( '\\+', '%20' );
	}
}