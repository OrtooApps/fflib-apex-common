@isTest
private without sharing class ListUtilsTest
{
	@isTest
	private static void slice_whenGivenListAndPositiveStartAndEnd_returnsASubsetList() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, 3, 6 );

		List<Integer> expectedList = new List<Integer>{ 3, 4, 5 };

		System.assertEquals( expectedList, slicedList, 'slice, when given a list and a positive start and end, will return a subset of the original list starting at the start index and finishing on the element immediately prior to the end' );
	}

	@isTest
	private static void slice_whenGivenListAndZeroStart_willStartAtElementZero() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, 0, 6 );

		List<Integer> expectedList = new List<Integer>{ 0, 1, 2, 3, 4, 5 };

		System.assertEquals( expectedList, slicedList, 'slice, when given a start of zero, will return a subset of the original list starting at first element and finishing on the element immediately prior to the end' );
	}

	@isTest
	private static void slice_whenGivenListAndPositiveStartAndEndTheSame_returnsAnEmptyList() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, 3, 3 );

		List<Integer> expectedList = new List<Integer>();

		System.assertEquals( expectedList, slicedList, 'slice, when given a start and end the same, will return an empty list' );
	}

	@isTest
	private static void slice_whenGivenListAndNegativeStart_willStartAtElementZero() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, -4, -2 );

		List<Integer> expectedList = new List<Integer>{ 6, 7 };

		System.assertEquals( expectedList, slicedList, 'slice, when given negative start and end, will count back from the end of the list when generating the new list' );
	}

	@isTest
	private static void slice_whenGivenListAndNegativeStartAndEndTheSame_returnsAnEmptyList() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, -3, -3 );

		List<Integer> expectedList = new List<Integer>();

		System.assertEquals( expectedList, slicedList, 'slice, when given a negative start and end the same, will return an empty list' );
	}

	@isTest
	private static void slice_whenGivenListAndNegativeEnd_willStartAtElementZero() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, 0, -2 );

		List<Integer> expectedList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7 };

		System.assertEquals( expectedList, slicedList, 'slice, when given negative start and end, will cound the end back from the end of the list when generating the new list' );
	}

	@isTest
	private static void slice_whenGivenStartBeyondTheEnd_returnsAnEmptyList() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, 20, 26 );

		List<Integer> expectedList = new List<Integer>();

		System.assertEquals( expectedList, slicedList, 'slice, when given a start beyond the end of the list, will return an empty list' );
	}

	@isTest
	private static void slice_whenGivenListAEndBeyondTheEnd_returnsASubsetListToTheEnd() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, 3, 20 );

		List<Integer> expectedList = new List<Integer>{ 3, 4, 5, 6, 7, 8, 9 };

		System.assertEquals( expectedList, slicedList, 'slice, when given a list and an end beyond the end of the list, will return a subset up to the end of the list' );
	}

	@isTest
	private static void slice_whenGivenListAndNegativeStartBeyondTheStart_returnsASubsetListFromTheStart() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, -20, 3 );

		List<Integer> expectedList = new List<Integer>{ 0, 1, 2 };

		System.assertEquals( expectedList, slicedList, 'slice, when given a list and a negative start beyond the start of the list, will return a subset from the start of the list' );
	}

	@isTest
	private static void slice_whenGivenNegativeEndBeyondTheStartofTheList_returnsAnEmptyList() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, 2, -20 );

		List<Integer> expectedList = new List<Integer>();

		System.assertEquals( expectedList, slicedList, 'slice, when given a negative end beyond the start of the list, will return an empty list' );
	}

	@isTest
	private static void slice_whenGivenAPositiveEndBeforeThePositiveStart_returnsAnEmptyList() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, 5, 2 );

		List<Integer> expectedList = new List<Integer>();

		System.assertEquals( expectedList, slicedList, 'slice, when given a positive end before the positive start, will return an empty list' );
	}

	@isTest
	private static void slice_whenGivenANegativeEndBeforeThePositiveStart_returnsAnEmptyList() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, 5, -6 );

		List<Integer> expectedList = new List<Integer>();

		System.assertEquals( expectedList, slicedList, 'slice, when given a negative end before the positive start, will return an empty list' );
	}

	@isTest
	private static void slice_whenGivenAPositiveEndBeforeTheNegativeStart_returnsAnEmptyList() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, -5, 2 );

		List<Integer> expectedList = new List<Integer>();

		System.assertEquals( expectedList, slicedList, 'slice, when given a positive end before the negative start, will return an empty list' );
	}

	@isTest
	private static void slice_whenGivenANegativeEndBeforeTheNegativeStart_returnsAnEmptyList() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, -3, -6 );

		List<Integer> expectedList = new List<Integer>();

		System.assertEquals( expectedList, slicedList, 'slice, when given a negative end before the negative start, will return an empty list' );
	}

	@isTest
	private static void slice_whenANullList_willThrowAnException() // NOPMD: Test method name format
	{
		List<Integer> originalList = null;

		String exceptionMessage;
		try {
			List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, 1, 2 );
		} catch ( Contract.RequiresException e ) {
			exceptionMessage = e.getMessage();
		}

		ortoo_Asserts.assertContains( 'slice called with a null list', exceptionMessage, 'slice, when given a null list, will throw an exception' );
	}

	@isTest
	private static void slice_whenANullStart_willThrowAnException() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		String exceptionMessage;
		try {
			List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, null, 2 );
		} catch ( Contract.RequiresException e ) {
			exceptionMessage = e.getMessage();
		}

		ortoo_Asserts.assertContains( 'slice called with a null startElement', exceptionMessage, 'slice, when given a null start, will throw an exception' );
	}

	@isTest
	private static void slice_whenANullEnd_willThrowAnException() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		String exceptionMessage;
		try {
			List<Integer> slicedList = (List<Integer>)ListUtils.slice( originalList, 2, null );
		} catch ( Contract.RequiresException e ) {
			exceptionMessage = e.getMessage();
		}

		ortoo_Asserts.assertContains( 'slice called with a null endElement', exceptionMessage, 'slice, when given a null end, will throw an exception' );
	}

	@isTest
	private static void trim_whenGivenListAndPositiveLength_returnsASubsetList() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> trimmedList = (List<Integer>)ListUtils.trim( originalList, 3 );

		List<Integer> expectedList = new List<Integer>{ 0, 1, 2 };

		System.assertEquals( expectedList, trimmedList, 'trim, when given a list and a positive length, will return a subset of the original list, from the start, for the specified number of elements' );
	}

	@isTest
	private static void trim_whenGivenListAndNegativeLength_returnsASubsetList() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> trimmedList = (List<Integer>)ListUtils.trim( originalList, -3 );

		List<Integer> expectedList = new List<Integer>{ 7, 8, 9 };

		System.assertEquals( expectedList, trimmedList, 'trim, when given a list and a positive length, will return a subset of the original list, counting back from from the end, for the specified number of elements' );
	}

	@isTest
	private static void trim_whenGivenListAndPositiveLengthGreaterThanTheLength_returnsTheFullList() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> trimmedList = (List<Integer>)ListUtils.trim( originalList, 13 );

		System.assertEquals( originalList, trimmedList, 'trim, when given a list and a positive length greater than the length, will return the full original list' );
	}

	@isTest
	private static void trim_whenGivenListAndNegativeLengthGreaterThanTheLength_returnsTheFullList() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		List<Integer> trimmedList = (List<Integer>)ListUtils.trim( originalList, -13 );

		System.assertEquals( originalList, trimmedList, 'trim, when given a list and a negative length greater than the length, will return the full original list' );
	}

	@isTest
	private static void trim_whenANullList_willThrowAnException() // NOPMD: Test method name format
	{
		List<Integer> originalList = null;

		String exceptionMessage;
		try {
			List<Integer> trimmedList = (List<Integer>)ListUtils.trim( originalList, 1 );
		} catch ( Contract.RequiresException e ) {
			exceptionMessage = e.getMessage();
		}

		ortoo_Asserts.assertContains( 'trim called with a null list', exceptionMessage, 'trim, when given a null list, will throw an exception' );
	}

	@isTest
	private static void trim_whenANullLength_willThrowAnException() // NOPMD: Test method name format
	{
		List<Integer> originalList = new List<Integer>{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

		String exceptionMessage;
		try {
			List<Integer> trimmedList = (List<Integer>)ListUtils.trim( originalList, null );
		} catch ( Contract.RequiresException e ) {
			exceptionMessage = e.getMessage();
		}

		ortoo_Asserts.assertContains( 'trim called with a null length', exceptionMessage, 'trim, when given a null length, will throw an exception' );
	}

	@isTest
	private static void getNumberOfUniqueIds_whenGivenAListAndIdField_returnsACountOfTheUniqueIds() // NOPMD: Test method name format
	{
		List<Id> accountIds = new List<Id>{
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() )
		};

		List<Sobject> originalList = new List<Sobject>{
			new Contact( AccountId = accountIds[0] ),
			new Contact( AccountId = accountIds[1] ),
			new Contact( AccountId = null ),
			new Contact( AccountId = accountIds[1] ),
			new Contact( AccountId = accountIds[1] ),
			new Contact( AccountId = accountIds[2] ),
			new Contact( AccountId = null )
		};

		Integer numberOfUniqueIds = ListUtils.getNumberOfUniqueIds( originalList, Contact.AccountId );

		System.assertEquals( 3, numberOfUniqueIds, 'getNumberOfUniqueIds, when given a list and an Id field, return the number of unique ids in the specified field, in the passed objects, ignoring nulls' );
	}

	@isTest
	private static void getNumberOfUniqueIds_whenAFieldThatIsNotAnId_returnsACountOfTheUniqueIds() // NOPMD: Test method name format
	{
		List<Id> accountIds = new List<Id>{
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() )
		};

		List<Sobject> originalList = new List<Sobject>{
			new Contact( FirstName = accountIds[0] ),
			new Contact( FirstName = accountIds[1] ),
			new Contact( FirstName = null ),
			new Contact( FirstName = accountIds[1] ),
			new Contact( FirstName = accountIds[1] ),
			new Contact( FirstName = accountIds[2] ),
			new Contact( FirstName = null )
		};

		Integer numberOfUniqueIds = ListUtils.getNumberOfUniqueIds( originalList, Contact.FirstName );

		System.assertEquals( 3, numberOfUniqueIds, 'getNumberOfUniqueIds, when given a list and a non Id field that contains Id data, return the number of unique ids in the specified field, in the passed objects, ignoring nulls' );
	}

	@isTest
	private static void getNumberOfUniqueIds_whenAFieldThatIsNotAnIdAndContainsNonIdData_returnsACountOfTheUniqueIds() // NOPMD: Test method name format
	{
		List<Id> accountIds = new List<Id>{
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() )
		};

		List<Sobject> originalList = new List<Sobject>{
			new Contact( FirstName = accountIds[0] ),
			new Contact( FirstName = accountIds[1] ),
			new Contact( FirstName = 'not an Id' ),
			new Contact( FirstName = accountIds[1] ),
			new Contact( FirstName = accountIds[1] ),
			new Contact( FirstName = accountIds[2] ),
			new Contact( FirstName = 'not an Id' )
		};

		String exceptionMessage;
		try {
			Integer numberOfUniqueIds = ListUtils.getNumberOfUniqueIds( originalList, Contact.FirstName );
		} catch ( StringException e ) {
			exceptionMessage = e.getMessage();
		}

		System.assertEquals( 'Invalid id: not an Id', exceptionMessage, 'getNumberOfUniqueIds, when given a list and a non Id field that contains non id data, will throw an exception' );
	}

	@isTest
	private static void getNumberOfUniqueIds_whenGivenNullList_willThrowAnException() // NOPMD: Test method name format
	{
		List<Sobject> originalList;

		String exceptionMessage;
		try {
			Integer numberOfUniqueIds = ListUtils.getNumberOfUniqueIds( originalList, Contact.AccountId );
		} catch ( Contract.RequiresException e ) {
			exceptionMessage = e.getMessage();
		}

		ortoo_Asserts.assertContains( 'getNumberOfUniqueIds called with a null listOfSobjects', exceptionMessage, 'getNumberOfUniqueIds, when given a null list, will throw an exception' );
	}

	@isTest
	private static void getNumberOfUniqueIds_whenGivenNullIdField_willThrowAnException() // NOPMD: Test method name format
	{
		List<Sobject> originalList = new List<Sobject>{
			new Contact( AccountId = TestIdUtils.generateId( Account.getSObjectType() ) ),
			new Contact( AccountId = TestIdUtils.generateId( Account.getSObjectType() ) ),
			new Contact( AccountId = TestIdUtils.generateId( Account.getSObjectType() ) )
		};

		String exceptionMessage;
		try {
			Integer numberOfUniqueIds = ListUtils.getNumberOfUniqueIds( originalList, null );
		} catch ( Contract.RequiresException e ) {
			exceptionMessage = e.getMessage();
		}

		ortoo_Asserts.assertContains( 'getNumberOfUniqueIds called with a null idField', exceptionMessage, 'getNumberOfUniqueIds, when given a null id field, will throw an exception' );
	}

	@isTest
	private static void getNumberOfUniqueIds_whenGivenAFieldNotOnTheObject_willThrowAnException() // NOPMD: Test method name format
	{
		List<Sobject> originalList = new List<Sobject>{
			new Contact( AccountId = TestIdUtils.generateId( Account.getSObjectType() ) ),
			new Contact( AccountId = TestIdUtils.generateId( Account.getSObjectType() ) ),
			new Contact( AccountId = TestIdUtils.generateId( Account.getSObjectType() ) )
		};

		String exceptionMessage;
		try {
			Integer numberOfUniqueIds = ListUtils.getNumberOfUniqueIds( originalList, Account.NumberOfEmployees );
		} catch ( SObjectException e ) {
			exceptionMessage = e.getMessage();
		}

		System.assertEquals( 'Account.NumberOfEmployees does not belong to SObject type Contact', exceptionMessage, 'getNumberOfUniqueIds, when given a null id field, will throw an exception' );
	}

	@isTest
	private static void convertToListOfStrings_listObject_whenGivenAListOfObjects_returnsAListOfStrings() // NOPMD: Test method name format
	{
		List<Object> listOfObjects = new List<Object>{
			new StringableThing( 'one' ),
			new StringableThing( 'two' ),
			new StringableThing( 'three' )
		};

		Test.startTest();
			List<String> returnedList = ListUtils.convertToListOfStrings( listOfObjects );
		Test.stopTest();

		List<String> expectedList = new List<String>{ 'one', 'two', 'three' };

		System.assertEquals( expectedList, returnedList, 'convertToListOfStrings, when given a list of objects, will return a list with the string versions of each of them' );
	}

	@isTest
	private static void convertToListOfStrings_listObject_whenGivenAnEmptyListOfObjects_returnsAnEmptyList() // NOPMD: Test method name format
	{
		List<Object> emptyListOfObjects = new List<Object>();

		Test.startTest();
			List<String> returnedList = ListUtils.convertToListOfStrings( emptyListOfObjects );
		Test.stopTest();

		System.assertEquals( new List<String>(), returnedList, 'convertToListOfStrings, when given an empty list of objects, will return an empty list' );
	}

	@isTest
	private static void convertToListOfStrings_listObject_whenGivenNull_returnsAnEmptyList() // NOPMD: Test method name format
	{
		List<Object> nullListOfObjects = null;

		Test.startTest();
			List<String> returnedList = ListUtils.convertToListOfStrings( nullListOfObjects );
		Test.stopTest();

		System.assertEquals( new List<String>(), returnedList, 'convertToListOfStrings, when given null list of objects, will return an empty list' );
	}

	@isTest
	private static void convertToListOfStrings_setString_whenGivenASetOfStrings_returnsAListOfString() // NOPMD: Test method name format
	{
		Set<String> setOfStrings = new Set<String>{ 'one', 'two', 'three' };

		Test.startTest();
			List<String> returnedList = ListUtils.convertToListOfStrings( setOfStrings );
		Test.stopTest();

		List<String> expectedList = new List<String>{ 'one', 'two', 'three' };

		System.assertEquals( expectedList, returnedList, 'convertToListOfStrings, when given a set of strings, will return a list of the strings' );
	}

	@isTest
	private static void convertToListOfStrings_setString_whenGivenAnEmptySet_returnsAnEmptySet() // NOPMD: Test method name format
	{
		Set<String> emptySetOfStrings = new Set<String>();

		Test.startTest();
			List<String> returnedList = ListUtils.convertToListOfStrings( emptySetOfStrings );
		Test.stopTest();

		System.assertEquals( new List<String>(), returnedList, 'convertToListOfStrings, when given an empty set of strings, will return an empty list' );
	}

	@isTest
	private static void convertToListOfStrings_setString_whenGivenNull_returnsAnEmptyList() // NOPMD: Test method name format
	{
		Set<String> nullSetOfStrings = null;

		Test.startTest();
			List<String> returnedList = ListUtils.convertToListOfStrings( nullSetOfStrings );
		Test.stopTest();

		System.assertEquals( new List<String>(), returnedList, 'convertToListOfStrings, when given null set of strings, will return an empty list' );
	}

	private inherited sharing class StringableThing {
		String name;
		public StringableThing( String name )
		{
			this.name = name;
		}
		 public override String toString()
		 {
			 return this.name;
		 }
	}
}