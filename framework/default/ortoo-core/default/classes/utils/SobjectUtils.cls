/**
 * Utility class that provides extra capabilities related to SObjects.
 *
 * Many of the methods provide shortcuts to pre-existing Salesforce methods.
 * For example: record.getSObjectType().getDescribe().isCreateable();
 * These methods exist in order to:
 * 		1 - Make the code in the app that performs these checks simpler and easier to read.
 * 		2 - Provide the ability to make performance improvements as and when the
 * 			relative performance of different methods change.
 * 			This may include the ability to cache certain results.
 *
 * These methods should always be used to ask questions of SObjects.
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
	 * Given an instance of an SObject, will return its SobjectType
	 *
	 * @param	Sobject		The SObject for which to return the SobjectType
	 * @return	SobjectType	The SobjectType of the SObject
	 */
	public static SobjectType getSobjectType( Sobject record )
	{
		Contract.requires( record != null, 'getSobjectType called with a null record' );

		return record.getSObjectType();
	}

	// TODO: use the describe on the object?
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

	/**
	 * Given an SObjectType, will return the Local version of the developer / API name of the SObject (e.g. Contact)
	 *
	 * @param	SobjectType	The SObjectType to return the Name for
	 * @return	String		The Local API Name of the SObjectType
	 */
	public static String getSobjectLocalName( SobjectType sobjectType )
	{
		Contract.requires( sobjectType != null, 'Attempted to get the local name of a null SObjectType' );

		String sobjectName = sobjectType.getDescribe().getLocalName();

		Contract.ensures( sobjectName != null, 'getSobjectLocalName returned with a null sobjectName' );
		return sobjectName;
	}

	/**
	 * States if the given SObject is of a type that the current user is allowed to insert
	 *
	 * @param	SObject	The SObject to check 'isCreatable' of
	 * @return	Boolean	States if the user can insert records of this type
	 */
	public static Boolean isCreateable( Sobject record )
	{
		Contract.requires( record != null, 'isCreateable called with a null record' );

		return getSObjectDescribeResult( record ).isCreateable();
	}

	/**
	 * States if the given SObject is of a type that the current user is allowed to update
	 *
	 * @param	SObject	The SObject to check 'isUpdateable' of
	 * @return	Boolean	States if the user can update records of this type
	 */
	public static Boolean isUpdateable( Sobject record )
	{
		Contract.requires( record != null, 'isUpdateable called with a null record' );

		return getSObjectDescribeResult( record ).isUpdateable();
	}

	/**
	 * States if the given SObject is of a type that the current user is allowed to delete
	 *
	 * @param	SObject	The SObject to check 'isDeletable' of
	 * @return	Boolean	States if the user can delete records of this type
	 */
	public static Boolean isDeletable( Sobject record )
	{
		Contract.requires( record != null, 'isDeletable called with a null record' );

		return getSObjectDescribeResult( record ).isDeletable();
	}

	/**
	 * States if the given SObjectType is one that the current user is allowed to insert
	 *
	 * @param	SobjectType	The SObject to check 'isCreateable' of
	 * @return	Boolean	States if the user can insert records of this type
	 */
	public static Boolean isCreateable( SobjectType type )
	{
		Contract.requires( type != null, 'isCreateable called with a null type' );

		return getSObjectDescribeResult( type ).isCreateable();
	}

	/**
	 * States if the given SObjectType is one that the current user is allowed to update
	 *
	 * @param	SobjectType	The SObject to check 'isUpdateable' of
	 * @return	Boolean	States if the user can update records of this type
	 */
	public static Boolean isUpdateable( SobjectType type )
	{
		Contract.requires( type != null, 'isUpdateable called with a null type' );

		return getSObjectDescribeResult( type ).isUpdateable();
	}

	/**
	 * States if the given SObjectType is one that the current user is allowed to delete
	 *
	 * @param	SobjectType	The SObject to check 'isDeletable' of
	 * @return	Boolean	States if the user can delete records of this type
	 */
	public static Boolean isDeletable( SobjectType type )
	{
		Contract.requires( type != null, 'isDeletable called with a null type' );

		return getSObjectDescribeResult( type ).isDeletable();
	}

	/**
	 * States if the given SObjectType is one that the current user is allowed to access
	 *
	 * @param	SobjectType	The SObject to check 'isAccessible' of
	 * @return	Boolean	States if the user can delete records of this type
	 */
	public static Boolean isAccessible( SobjectType type )
	{
		Contract.requires( type != null, 'isAccessible called with a null type' );

		return getSObjectDescribeResult( type ).isAccessible();
	}

	/**
	 * Given an SObject record, will return the DescrideSObjectResult for it.
	 *
	 * Generally shouldn't be used by external methods.  Instead the question of the
	 * describe result should be asked of SobjectUtils.
	 *
	 * For example, see 'isCreateable'.
	 *
	 * @param	SObject					The SObject to get the describe for
	 * @return	DescribeSObjectResult	The passed SObject's describe
	 */
	private static DescribeSObjectResult getSobjectDescribeResult( Sobject record )
	{
		Contract.requires( record != null, 'getSobjectDescribeResult called with a null record' );

		return getSobjectDescribeResult( record.getSObjectType() );
	}

	/**
	 * Given an SObject Type record, will return the DescrideSObjectResult for it.
	 *
	 * Generally shouldn't be used by external methods.  Instead the question of the
	 * describe result should be asked of SobjectUtils.
	 *
	 * For example, see 'isCreateable'.
	 *
	 * @param	SObjectType				The SObjectType to get the describe for
	 * @return	DescribeSObjectResult	The passed SObject's describe
	 */
	private static DescribeSObjectResult getSobjectDescribeResult( SobjectType type )
	{
		Contract.requires( type != null, 'getSobjectDescribeResult called with a null type' );

		return type.getDescribe();
	}
}