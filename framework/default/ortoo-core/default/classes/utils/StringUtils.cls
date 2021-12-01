/**
 * Utility class that provides extra capabilities related to Strings
 *
 * @group Utils
 */
public inherited sharing class StringUtils
{
	/**
	 * Performs a String.format against a label, escaping any single apostrophes (').
	 * Reduces the chances of an invalidly formatted label breaking the generation of the text.
	 */
	public static String formatLabel( String label, List<String> replacements )
	{
		String returnLabel = ( label == null ) ? '' : label;

		if ( replacements != null )
		{
			returnLabel = String.format( returnLabel.replace( '\'', '\'\'' ), replacements );
		}

		Contract.ensures( returnLabel != null, 'formatLabel returned with a null returnLabel' );
		return returnLabel;
	}

	/**
	 * Given a String that contains values that are semi-colon delimited, will split it,
	 * trimming each entry and returning a list of strings.
	 *
	 * @param	String			A semi-colon delimited list as a single string
	 * @return	List<String>	The original string, split and trimmed on semi-colon
	 */
	public static List<String> convertDelimitedStringToList( String inputString )
	{
		return convertDelimitedStringToList( inputString, ';' );
	}

	/**
	 * Given a String that contains values that are delimited by the passed delimiter, will split it,
	 * trimming each entry and returning a list of strings.
	 *
	 * @param	String			A list as a single string
	 * @param	String			The delimiter used in the passed String
	 * @return	List<String>	The original string, split and trimmed on the passed delimiter
	 */
	public static List<String> convertDelimitedStringToList( String inputString, String delimiter )
	{
		Contract.requires( String.isNotEmpty( delimiter ), 'convertDelimitedStringToList called with an empty delimiter' );

		List<String> result = new List<String>();

		if ( String.isNotBlank( inputString ) )
		{
			for( String thisItem : inputString.split( delimiter ) )
			{
				result.add( thisItem.trim() );
			}
		}

		Contract.ensures( result != null, 'convertDelimitedStringToList returned with a null result' );
		return result;
	}

	/**
	 * Given a list of strings, will join them with the default delimiter (a semi-colon).
	 *
	 * @param	List<String>	The list of strings to join
	 * @return	String			The joined string
	 */
	public static String convertListToDelimitedString( List<String> listOfStrings )
	{
		Contract.requires( listOfStrings != null, 'convertListToDelimitedString called with a null listOfStrings' );

		return String.join( listOfStrings, ';' );
	}

	/**
	 * Given a list of objects, will covert them to Strings and then join them with the default delimiter (a semi-colon).
	 *
	 * @param	List<Object>	The list of strings to join
	 * @return	String			The joined string
	 */
	public static String convertListToDelimitedString( List<Object> listOfObjects )
	{
		return convertListToDelimitedString( listOfObjects, ';' );
	}

	/**
	 * Given a list of objects, will covert them to Strings and then join them with the specified delimiter
	 *
	 * @param	List<Object>	The list of strings to join
	 * @param	String			Delimiter
	 * @return	String			The joined string
	 */
	public static String convertListToDelimitedString( List<Object> listOfObjects, String delimiter )
	{
		Contract.requires( listOfObjects != null, 'convertListToDelimitedString called with a null listOfObjects' );
		Contract.requires( String.isNotEmpty( delimiter ), 'convertListToDelimitedString called with an empty delimiter' );

		return String.join( ListUtils.convertToListOfStrings( listOfObjects ), delimiter );
	}
}