/**
 * Utility class that provides extra capabilities related to SObjects
 *
 * @group Utils
 */
public inherited sharing class SobjectUtils
{
	/**
	 * Provides cached access to the Global Describe.  Is used to help manage the performance of accessing it (takes time to initially generate)
	 * In most cases, direct access to DESCRIBE is not required and methods on this class should be called instead.
	 */
	public static Map<String,Schema.SobjectType> DESCRIBE // NOPMD: whilst not being final, want to give the impression that it is - is lazy loaded so cannot be
	{
		get
		{
			if ( DESCRIBE == null )
			{
				DESCRIBE = Schema.getGlobalDescribe();
			}
			return DESCRIBE;
		}
		private set;
	}

	/**
	 * Given a string that represents an SObject, will return the Schema.SobjectType that represents it
	 *
	 * @param	String		The Name of the SObject to return the Type for
	 * @return	SobjectType	The SObjectType that represents that SObject
	 */
	public static Schema.SobjectType getSobjectType( String sobjectName )
	{
		Contract.requires( sobjectName != null, 'Attempted to get the type for a null sobjectName' );

		// Note that this will resolve the sobject based on the standard rules for reference resolution
		// I.E. current namespace, custom defined in the org, standard
		// This means that an SObject in the current namespace can be referenced by a string that does not include the namespace
		// If this is replaced (e.g. for performance), then that functionality must be preserved
		return ((SObject)Type.forName( sobjectName )?.newInstance())?.getSObjectType();
	}

	/**
	 * Given an instance of an SObject, will return the developer / API name of the SObject (e.g. Contact)
	 *
	 * @param	Sobject		The SObject to return the Name for
	 * @return	String		The API Name of the SObject
	 */
	public static String getSobjectName( Sobject record )
	{
		Contract.requires( record != null, 'Attempted to get the name of a null SObject' );

		String sobjectName = getSobjectName( record.getSObjectType() );

		Contract.ensures( sobjectName != null, 'getSobjectName returned with a null sobjectName' );
		return sObjectName;
	}

	/**
	 * Given an SObjectType, will return the developer / API name of the SObject (e.g. Contact)
	 *
	 * @param	SobjectType	The SObjectType to return the Name for
	 * @return	String		The API Name of the SObjectType
	 */
	public static String getSobjectName( SobjectType sobjectType )
	{
		Contract.requires( sobjectType != null, 'Attempted to get the name of a null SObjectType' );

		String sobjectName = sobjectType.getDescribe().getName();

		Contract.ensures( sobjectName != null, 'getSobjectName returned with a null sobjectName' );
		return sobjectName;
	}
}