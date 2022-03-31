/**
 * Utility class that provides the ability to generate Ids for given SObject types in tests
 *
 * @group Utils
 */
@isTest
public inherited sharing class TestIdUtils
{
	private static Integer highestGeneratedId = 0;
	private static Map<SobjectType,String> objectPrefixesBySobjectType = new Map<SobjectType,String>();

	/**
	 * Generate a valid Id for the given SObjectType.
     * Ensures that it is 1 higher than the previously generated (or returned) Id.
     *
     * @param   SobjectType	The SObjectType for which the Id should be created
     * @return  Id			The generated Id
     */
   	public static Id generateId( SobjectType objectType )
	{
		return generateId( objectType, highestGeneratedId + 1 );
	}

	/**
	 * Generate a valid Id for the given SObjectType, using the passed in idSequence number
     * to derive it.
	 *
     * @param   SobjectType The SObjectType for which the Id should be created
     * @param	Integer		The sequence number of the Id.
     * @return  Id			The generated Id
     */
	public static Id generateId( SobjectType objectType, Integer idSequence )
	{
		String prefix     = getObjectPrefix( objectType );
		String uniquePart = String.valueOf( idSequence );
		String newId      = prefix.rightPad( 18 - uniquePart.length(), '0' ) + uniquePart;

		if ( idSequence > highestGeneratedId ) {
			highestGeneratedId = idSequence;
		}

		return newId;
	}

	/**
	 * Get the Id prefix for the given object type.
     *
     * Caches the values to reduce calls to describes.
	 *
     * @param   SobjectType	The SObjectType for which the object prefix should be returned
     * @return  Id			The Id prefix for the passed objectType
     */
	private static String getObjectPrefix( SobjectType objectType )
	{
		if ( ! objectPrefixesBySobjectType.containsKey( objectType ) )
		{
            objectPrefixesBySobjectType.put( objectType, objectType.getDescribe().getKeyPrefix() );
		}
        return objectPrefixesBySobjectType.get( objectType );
	}
}