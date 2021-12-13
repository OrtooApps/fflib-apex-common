@isTest
private without sharing class SetUtilsTest
{
	@isTest
	private static void convertToSetOfStrings_setOfIds_whenGivenSetOfIds_willConvertThatSetOfIdsToStrings() // NOPMD: Test method name format
	{
		Set<Id> setToConvert = new Set<Id>{
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() )
		};

		Set<String> convertedSet = SetUtils.convertToSetOfStrings( setToConvert );

		System.assertEquals( setToConvert.size(), convertedSet.size(), 'convertToSetOfStrings, when given a Set of Ids, will return a Set with an entry for each of the original set records' );

		for ( String originalString : setToConvert )
		{
			System.assert( convertedSet.contains( String.valueOf( originalString ) ), 'convertToSetOfStrings, when given a Set of Ids, will return a Set with an entry for each of the original set records - checking for ' + originalString );
		}
	}

	@isTest
	private static void convertToSetOfStrings_setOfIds_whenGivenSetOfIdsWithANull_willIncludeTheNull() // NOPMD: Test method name format
	{
		Set<Id> setToConvert = new Set<Id>{
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() )
		};

		Set<String> convertedSet = SetUtils.convertToSetOfStrings( setToConvert );

		System.assertEquals( setToConvert.size(), convertedSet.size(), 'convertToSetOfStrings, when given a Set of Ids with a null, will return a Set with an entry for each of the original set records' );

		for ( String originalString : setToConvert )
		{
			System.assert( convertedSet.contains( String.valueOf( originalString ) ), 'convertToSetOfStrings, when given a Set of Ids with a null, will return a Set with an entry for each of the original set records - checking for ' + originalString );
		}
	}

	@isTest
	private static void convertToSetOfStrings_setOfIds_whenGivenAnEmptySet_willReturnAnEmptySet() // NOPMD: Test method name format
	{
		Set<Id> setToConvert = new Set<Id>();

		Set<String> convertedSet = SetUtils.convertToSetOfStrings( setToConvert );

		System.assertEquals( 0, convertedSet.size(), 'convertToSetOfStrings, when given an empty set, will return an empty set' );
	}

	@isTest
	private static void convertToSetOfStrings_setOfIds_whenGivenNull_willReturnAnEmptySet() // NOPMD: Test method name format
	{
		Set<Id> setToConvert = null;

		Set<String> convertedSet = SetUtils.convertToSetOfStrings( setToConvert );

		System.assertEquals( 0, convertedSet.size(), 'convertToSetOfStrings, when given null, will return an empty set' );
	}

	@isTest
	private static void convertToSetOfIds_listOfIds_whenGivenListOfIds_willConvertThatListToASet() // NOPMD: Test method name format
	{
		List<Id> listToConvert = new List<Id>{
			TestIdUtils.generateId( Account.getSObjectType(), 1 ),
			TestIdUtils.generateId( Account.getSObjectType(), 2 ),
			TestIdUtils.generateId( Account.getSObjectType(), 3 ),
			TestIdUtils.generateId( Account.getSObjectType(), 1 ) // this is a duplicate
		};

		Set<Id> expectedSet = new Set<Id>{ listToConvert[0], listToConvert[1], listToConvert[2] };

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( listToConvert );

		System.assertEquals( expectedSet, convertedSet, 'convertToSetOfIds, when given a List of Ids, will return a List with an entry for each of the original unique list records' );
	}

	@isTest
	private static void convertToSetOfIds_listOfIds_whenGivenListOfIdsWithNull_willIncludeTheNull() // NOPMD: Test method name format
	{
		List<Id> listToConvert = new List<Id>{
			TestIdUtils.generateId( Account.getSObjectType(), 1 ),
			TestIdUtils.generateId( Account.getSObjectType(), 2 ),
			null
		};

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( listToConvert );

		System.assertEquals( 3, convertedSet.size(), 'convertToSetOfIds, when given a List of Ids with null in it, will return a List with an entry for each of the original unique list records' );
		System.assert( convertedSet.contains( listToConvert[0] ), 'convertToSetOfIds, when given a List of Ids with null in it, will return a List with an entry for each of the original unique list records - checking for ' + listToConvert[0] );
		System.assert( convertedSet.contains( listToConvert[1] ), 'convertToSetOfIds, when given a List of Ids with null in it, will return a List with an entry for each of the original unique list records - checking for ' + listToConvert[1] );
		System.assert( convertedSet.contains( null ), 'convertToSetOfIds, when given a List of Ids with null in it, will return a List with an entry for each of the original unique list records, including the null - checking for null' );
	}

	@isTest
	private static void convertToSetOfIds_listOfIds_whenGivenAnEmptyList_willReturnAnEmptyList() // NOPMD: Test method name format
	{
		List<Id> listToConvert = new List<Id>();

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( listToConvert );

		System.assertEquals( 0, convertedSet.size(), 'convertToSetOfIds, when given an empty List of Ids, will return an empty set' );
	}

	@isTest
	private static void convertToSetOfIds_listOfIds_whenGivenNull_willReturnAnEmptyList() // NOPMD: Test method name format
	{
		List<Id> listToConvert = null;

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( listToConvert );

		System.assertEquals( 0, convertedSet.size(), 'convertToSetOfIds, when given null, will return an empty set' );
	}

	@isTest
	private static void convertToSetOfIds_setOfIds_whenGivenSetOfStringsThatAreIds_willConvertThatSetOfStringsToIds() // NOPMD: Test method name format
	{
		Set<String> setToConvert = new Set<String>{
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() )
		};

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( setToConvert );

		System.assertEquals( setToConvert.size(), convertedSet.size(), 'convertToSetOfIds, when given a Set of Ids as Strings, will return a Set with an entry for each of the original set records' );

		for ( String originalString : setToConvert )
		{
			System.assert( convertedSet.contains( (Id)originalString ), 'convertToSetOfIds, when given a Set of Ids as Strings, will return a Set with an entry for each of the original set records - checking for ' + originalString );
		}
	}

	@isTest
	private static void convertToSetOfIds_setOfIds_whenGivenSetOfStringsWithANull_willIncludeTheNull() // NOPMD: Test method name format
	{
		Set<String> setToConvert = new Set<String>{
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() )
		};

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( setToConvert );

		System.assertEquals( setToConvert.size(), convertedSet.size(), 'convertToSetOfIds, when given a Set including a null, will return a Set with an entry for each of the original set records' );

		for ( String originalString : setToConvert )
		{
			System.assert( convertedSet.contains( (Id)originalString ), 'convertToSetOfIds, when given a Set including a null, will return a Set with an entry for each of the original set records - checking for ' + originalString );
		}
	}

	@isTest
	private static void convertToSetOfIds_setOfIds_whenGivenAnEmptySet_willReturnAnEmptySet() // NOPMD: Test method name format
	{
		Set<String> setToConvert = new Set<String>();

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( setToConvert );

		System.assertEquals( 0, convertedSet.size(), 'convertToSetOfIds, when given an empty set, will return an empty set' );
	}

	@isTest
	private static void convertToSetOfIds_setOfIds_whenGivenNull_willReturnAnEmptySet() // NOPMD: Test method name format
	{
		Set<String> setToConvert = null;

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( setToConvert );

		System.assertEquals( 0, convertedSet.size(), 'convertToSetOfIds, when given null, will return an empty set' );
	}

	@isTest
	private static void convertToSetOfIds_setOfIds_whenGivenSetOfStringsAndSomeAreNotIds_willThrowAnException() // NOPMD: Test method name format
	{
		Set<String> setToConvert = new Set<String>{
			TestIdUtils.generateId( Account.getSObjectType() ),
			'not an Id',
			TestIdUtils.generateId( Account.getSObjectType() )
		};

		String exceptionMessage;

		try {
			Set<Id> convertedSet = SetUtils.convertToSetOfIds( setToConvert );
		} catch ( StringException e ) {
			exceptionMessage = e.getMessage();
		}

		System.assertEquals( 'Invalid id: not an Id', exceptionMessage, 'convertToSetOfIds, when given a Set of Strings and some are not Ids, will throw an Exception' );
	}

	@isTest
	private static void convertToSetOfIds_listOfSobjects_whenGivenSetOfSobjectsWithIds_returnsSetOfIds() // NOPMD: Test method name format
	{
		List<Id> ids = new List<Id>{
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) ),
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) ),
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) )
		};

		List<Account> listToConvert = new List<Account>{
			new Account( Id = ids[0] ),
			new Account( Id = ids[1] ),
			new Account( Id = ids[2] )
		};

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( listToConvert );

		System.assertEquals( listToConvert.size(), convertedSet.size(), 'convertToSetOfIds, when given a Set of SObjects with Ids set, will return a Set with an entry for each of the original records' );
		System.assert( convertedSet.contains( ids[0] ), 'convertToSetOfIds, when given a Set of SObjects with Ids set, will return a Set with an entry for each of the original records - checking for ' + ids[0] );
		System.assert( convertedSet.contains( ids[1] ), 'convertToSetOfIds, when given a Set of SObjects with Ids set, will return a Set with an entry for each of the original records - checking for ' + ids[1] );
		System.assert( convertedSet.contains( ids[2] ), 'convertToSetOfIds, when given a Set of SObjects with Ids set, will return a Set with an entry for each of the original records - checking for ' + ids[2] );
	}

	@isTest
	private static void convertToSetOfIds_listOfSobjects_whenGivenSetOfSobjectsOneWithANull_willNotIncludeTheNull() // NOPMD: Test method name format
	{
		List<Id> ids = new List<Id>{
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) ),
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) ),
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) )
		};

		List<Account> listToConvert = new List<Account>{
			new Account( Id = ids[0] ),
			new Account(),
			new Account( Id = ids[1] ),
			new Account( Id = ids[2] )
		};

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( listToConvert );

		System.assertEquals( 3, convertedSet.size(), 'convertToSetOfIds, when given a Set of SObjects with one with the Id not set, will not include the null' );
		System.assert( convertedSet.contains( ids[0] ), 'convertToSetOfIds, when given a Set of SObjects with one with the Id not set, will return a Set with an entry for each of the original records that has an Id- checking for ' + ids[0] );
		System.assert( convertedSet.contains( ids[1] ), 'convertToSetOfIds, when given a Set of SObjects with one with the Id not set, will return a Set with an entry for each of the original records that has an Id- checking for ' + ids[1] );
		System.assert( convertedSet.contains( ids[2] ), 'convertToSetOfIds, when given a Set of SObjects with one with the Id not set, will return a Set with an entry for each of the original records that has an Id- checking for ' + ids[2] );
	}

	@isTest
	private static void convertToSetOfIds_listOfSobjects_whenGivenAnEmptySet_willReturnAnEmptySet() // NOPMD: Test method name format
	{
		List<Account> listToConvert = new List<Account>();

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( listToConvert );

		System.assertEquals( 0, convertedSet.size(), 'convertToSetOfIds, when given an empty set, will return an empty set' );
	}

	@isTest
	private static void convertToSetOfIds_listOfSobjects_whenGivenNull_willReturnAnEmptySet() // NOPMD: Test method name format
	{
		List<Account> listToConvert = null;

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( listToConvert );

		System.assertEquals( 0, convertedSet.size(), 'convertToSetOfIds, when given null, will return an empty set' );
	}

	@isTest
	private static void convertToSetOfIds_listOfSobjectsAndIdField_whenGivenSetOfSobjectsWithIds_returnsSetOfIds() // NOPMD: Test method name format
	{
		List<Id> ids = new List<Id>{
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) ),
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) ),
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) )
		};

		List<Contact> listToConvert = new List<Contact>{
			new Contact( AccountId = ids[0] ),
			new Contact( AccountId = ids[1] ),
			new Contact( AccountId = ids[2] )
		};

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( listToConvert, Contact.AccountId );

		System.assertEquals( listToConvert.size(), convertedSet.size(), 'convertToSetOfIds, when given a Set of SObjects with the specified Ids set, will return a Set with an entry for each of the original records' );
		System.assert( convertedSet.contains( ids[0] ), 'convertToSetOfIds, when given a Set of SObjects with the specified Ids set, will return a Set with an entry for each of the original records - checking for ' + ids[0] );
		System.assert( convertedSet.contains( ids[1] ), 'convertToSetOfIds, when given a Set of SObjects with the specified Ids set, will return a Set with an entry for each of the original records - checking for ' + ids[1] );
		System.assert( convertedSet.contains( ids[2] ), 'convertToSetOfIds, when given a Set of SObjects with the specified Ids set, will return a Set with an entry for each of the original records - checking for ' + ids[2] );
	}

	@isTest
	private static void convertToSetOfIds_listOfSobjectsAndIdField_whenGivenAnSobjectWithNotSetId_doesNotIncludeTheNull() // NOPMD: Test method name format
	{
		List<Id> ids = new List<Id>{
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) ),
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) ),
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) )
		};

		List<Contact> listToConvert = new List<Contact>{
			new Contact( AccountId = ids[0] ),
			new Contact(),
			new Contact( AccountId = ids[1] ),
			new Contact( AccountId = ids[2] )
		};

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( listToConvert, Contact.AccountId );

		System.assertEquals( 3, convertedSet.size(), 'convertToSetOfIds, when given a Set of SObjects and one does not have the id set, will not return the null Id' );
		System.assert( convertedSet.contains( ids[0] ), 'convertToSetOfIds, when given a Set of SObjects with the specified Ids set, will return a Set with an entry for each of the original records that have the id set- checking for ' + ids[0] );
		System.assert( convertedSet.contains( ids[1] ), 'convertToSetOfIds, when given a Set of SObjects with the specified Ids set, will return a Set with an entry for each of the original records that have the id set- checking for ' + ids[1] );
		System.assert( convertedSet.contains( ids[2] ), 'convertToSetOfIds, when given a Set of SObjects with the specified Ids set, will return a Set with an entry for each of the original records that have the id set- checking for ' + ids[2] );
	}

	@isTest
	private static void convertToSetOfIds_listOfSobjectsAndIdField_whenGivenAnEmptySet_willReturnAnEmptySet() // NOPMD: Test method name format
	{
		List<Contact> listToConvert = new List<Contact>();

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( listToConvert, Contact.AccountId );

		System.assertEquals( 0, convertedSet.size(), 'convertToSetOfIds, when given an empty set, will return an empty set' );
	}

	@isTest
	private static void convertToSetOfIds_listOfSobjectsAndIdField_whenGivenNullList_willReturnAnEmptySet() // NOPMD: Test method name format
	{
		List<Contact> listToConvert = null;

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( listToConvert, Contact.AccountId );

		System.assertEquals( 0, convertedSet.size(), 'convertToSetOfIds, when given null, will return an empty set' );
	}

	@isTest
	private static void convertToSetOfIds_listOfSobjectsAndIdField_whenGivenNullField_willReturnAnEmptySet() // NOPMD: Test method name format
	{
		List<Id> ids = new List<Id>{
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) ),
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) ),
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) )
		};

		List<Contact> listToConvert = new List<Contact>{
			new Contact( AccountId = ids[0] ),
			new Contact( AccountId = ids[1] ),
			new Contact( AccountId = ids[2] )
		};

		Set<Id> convertedSet = SetUtils.convertToSetOfIds( listToConvert, null );

		System.assertEquals( 0, convertedSet.size(), 'convertToSetOfIds, when given null, will return an empty set' );
	}

	@isTest
	private static void convertToSetOfIds_whenGivenAFieldThatDoesNotExistOnTheObject_willThrowAnException() // NOPMD: Test method name format
	{
		List<Id> ids = new List<Id>{
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) ),
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) ),
			String.valueOf( TestIdUtils.generateId( Account.getSObjectType() ) )
		};

		List<Contact> listToConvert = new List<Contact>{
			new Contact( AccountId = ids[0] ),
			new Contact( AccountId = ids[1] ),
			new Contact( AccountId = ids[2] )
		};

		String exceptionMessage;
		try {
			Set<Id> convertedSet = SetUtils.convertToSetOfIds( listToConvert, Account.NumberOfEmployees );
		} catch ( SObjectException e ) {
			exceptionMessage = e.getMessage();
		}

		System.assertEquals( 'Account.NumberOfEmployees does not belong to SObject type Contact', exceptionMessage, 'convertToSetOfIds, when given a field that does not exist on the object, will throw an exception' );
	}
}