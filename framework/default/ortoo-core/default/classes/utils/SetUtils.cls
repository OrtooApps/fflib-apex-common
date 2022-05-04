/**
 * Utility class that provides extra capabilities related to Sets
 *
 * @group Utils
 */
public inherited sharing class SetUtils
{
	/**
     * Given a Set of Ids, will convert it into a Set of String
     * @param	Set<Id>	The Set of Ids to convert
     * @return	Set<String>The resulting Set of Strings
     */
	public static Set<String> convertToSetOfStrings( Set<Id> setOfIds )
	{
		if ( setOfIds == null )
		{
			return new Set<String>();
		}
		Set<String> returnSet = new Set<String>( (List<String>)new List<Id>( setOfIds ) );

		Contract.ensures( returnSet != null, 'convertToSetOfStrings returned with a null returnSet' );
		return returnSet;
	}

	/**
     * Given a Set of Strings, will convert it into a Set of Ids
     * @param	List<Id>	The Set of Strings to convert
     * @return	Set<Id>		The resulting Set of Ids
     */
	public static Set<Id> convertToSetOfIds( List<Id> listOfIds )
	{
		if ( listOfIds == null )
		{
			return new Set<Id>();
		}
		Set<Id> returnSet = new Set<Id>( listOfIds );

		Contract.ensures( returnSet != null, 'convertToSetOfIds returned with a null returnSet' );
		return returnSet;
	}

	/**
     * Given a Set of Strings, will convert it into a Set of Ids
     * @param	Set<String>	The Set of Strings to convert
     * @return	Set<Id>		The resulting Set of Ids
     */
	public static Set<Id> convertToSetOfIds( Set<String> setOfStrings )
	{
		if ( setOfStrings == null )
		{
			return new Set<Id>();
		}
		Set<Id> returnSet = new Set<Id>( (List<Id>)new List<String>( setOfStrings ) );

		Contract.ensures( returnSet != null, 'convertToSetOfIds returned with a null returnSet' );
		return returnSet;
	}

	/**
     * Given a List of SObjects, will convert it into a Set of the Ids of those SObjects
     * @param	List<Sobject>	The List of SObjects to convert
     * @return	Set<Id>			The resulting Set of Ids
     */
	public static Set<Id> convertToSetOfIds( List<Sobject> listOfSobjects )
	{
		if ( listOfSobjects == null )
		{
			return new Set<Id>();
		}

		List<Sobject> convertableList = new List<Sobject>();
		for ( Sobject thisSobject : listOfSobjects )
		{
			if ( thisSobject.Id != null )
			{
				convertableList.add( thisSobject );
			}
		}
		Set<Id> returnSet = ( new Map<Id,Sobject>( convertableList ) ).keySet();

		Contract.ensures( returnSet != null, 'convertToSetOfIds returned with a null returnSet' );
		return returnSet;
	}

	/**
     * Given a List of SObjects and an SObjectField reference will convert it into a Set of the Ids held in the given field
     * @param	List<Sobject>	The List of SObjects to convert
	 * @param	SObjectField	The field to get the Ids from
     * @return	Set<Id>			The resulting Set of Ids
     */
	public static Set<Id> convertToSetOfIds( List<Sobject> listOfSobjects, SObjectField idField )
	{
		if ( listOfSobjects == null || idField == null )
		{
			return new Set<Id>();
		}

		Set<Id> returnSet = new Set<Id>();
		for ( Sobject thisSobject : listOfSobjects )
		{
			if ( thisSobject.get( idField ) != null ) {
				returnSet.add( (Id)thisSobject.get( idField ) );
			}
		}

		Contract.ensures( returnSet != null, 'convertToSetOfIds returned with a null returnSet' );
		return returnSet;
	}
}