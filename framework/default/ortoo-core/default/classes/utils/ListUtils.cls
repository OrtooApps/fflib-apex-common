/**
 * Utility class that provides extra capabilities related to Lists
 *
 * @group Utils
 */
public inherited sharing class ListUtils
{
	/**
     * Given a List, and the specification of the indexes of the startElement and endElement elements to retrieve,
	 * will return a new list that contains the sub-set of the original list defined by those boundaries.
	 *
	 * Will include the 'startElement' element, but not the 'endElement'
	 *
	 * Both startElement and endElement can be specified as negative numbers in order to count back from the endElement of the list
	 *
	 * Is built to be generally in line with the Javascript implementation of slice as defined here:
	 * 		https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/slice
	 *
	 * // TODO: the URL is not included in the generated docs
	 * // TODO: the paragraphs are not included in the generated docs
	 *
     * @param	List<Object>	The List to take the slice from
     * @param	Integer			The index of the first element to include
     * @param	Integer			The index of the endElement element (not included in the return)
     * @return	The resulting sliced List
     */
	public static List<Object> slice( List<Object> input, Integer startElement, Integer endElement )
	{
		Contract.requires( input != null, 'slice called with a null list' );
		Contract.requires( startElement != null, 'slice called with a null startElement' );
		Contract.requires( endElement != null, 'slice called with a null endElement' );

		if ( endElement < 0 )
		{
			endElement += input.size();
		}

		if ( startElement < 0 )
		{
			if ( startElement < input.size() * -1 )
			{
				startElement = 0;
			} else {
				startElement += input.size();
			}
		}
		List<Object> output = input.clone();

		if ( endElement < startElement || startElement > input.size() )
		{
			output.clear();
		}
		else
		{
			for ( Integer i = 0; i < startElement; i++ )
			{
				output.remove( 0 );
			}

			Integer length = endElement - startElement;

			while ( output.size() > length )
			{
				output.remove( length );
			}
		}

		Contract.ensures( output != null, 'slice returned with a null list' );
		return output;
	}

	/**
     * Given a List and a length, returns a copy of the original list with only the first 'length' number of elements.
	 *
	 * Length can be specified as negative, returning last 'length' number of elements rather than the first.
	 *
     * @param	List<Object>	The List from which to take the slice
     * @param	Integer			The number of elements to include in the trimmed list
     * @return	The resulting trimmed List
     */
	public static List<Object> trim( List<Object> input, Integer length )
	{
		Contract.requires( input != null, 'trim called with a null list' );
		Contract.requires( length != null, 'trim called with a null length' );

		Integer startElement = 0;
		Integer endElement   = length;

		// If the length is less than zero, we're counting back from the end, so we need to calculate the start
		if ( length < 0 )
		{
			startElement = Math.abs( length ) <= input.size() ? input.size() + length : 0;
			endElement   = input.size();
		}

		List<Object> output = slice( input, startElement, endElement );

		Contract.ensures( output != null, 'trim returned with a null list' );
		return output;
	}

	/**
     * Given a List of SObjects and a reference to an Id field, returns the count of the number of unique Ids in that list.
	 *
     * @param	List<Sobject>	The List of SObjects to examine
     * @param	SObjectField	The field to examine
     * @return	The number of unique Ids
     */
	public static Integer getNumberOfUniqueIds( List<Sobject> listOfSobjects, SObjectField idField )
	{
		Contract.requires( listOfSobjects != null, 'getNumberOfUniqueIds called with a null listOfSobjects' );
		Contract.requires( idField != null, 'getNumberOfUniqueIds called with a null idField' );

		Integer numberOfUniqueIds = SetUtils.convertToSetOfIds( listOfSobjects, idField ).size();

		Contract.ensures( numberOfUniqueIds != null, 'trim returned with a null list' );
		return numberOfUniqueIds;
	}

	/**
	 * Given a List of any type, will return a List created by calling toString against each of the elements
	 *
	 * @param	List<Object>	The list of objects to convert
	 * @return	List<String>	The converted list
	 */
	public static List<String> convertToListOfStrings( List<Object> listOfObjects )
	{
		if ( listOfObjects == null )
		{
			return new List<String>();
		}

		List<String> returnList = new List<String>();
		for ( Object thisObject : listOfObjects )
		{
			returnList.add( thisObject.toString() );
		}
		return returnList;
	}

	/**
	 * Given a Set of Objects, will return a List of those Strings
	 *
	 * Note this will only work for sets defined as Set<Object>
	 *
	 * @param	Set<Object>		The set of Obejcts to convert
	 * @return	List<String>	The converted list
	 */
	public static List<String> convertToListOfStrings( Set<Object> setOfObjects )
	{
		if ( setOfObjects == null )
		{
			return new List<String>();
		}

		List<String> returnList = new List<String>();
		for ( Object thisObject : setOfObjects )
		{
			returnList.add( thisObject.toString() );
		}

		return returnList;
	}

	/**
	 * Given a Set of any Strings, will return a List of those Strings
	 *
	 * @param	Set<String>		The set of strings to convert
	 * @return	List<String>	The converted list
	 */
	public static List<String> convertToListOfStrings( Set<String> setOfStrings )
	{
		if ( setOfStrings == null )
		{
			return new List<String>();
		}
		return new List<String>( setOfStrings );
	}
}