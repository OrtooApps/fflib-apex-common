@isTest
public inherited sharing class SearchResultsTest
{
	@isTest
	private static void constructor_whenPassedANumberOfRecordsAndSomeRecords_setsTheMemberVariables() // NOPMD: Test method name format
	{
		Integer totalNumberOfRecords = 10;
		List<Object> records = new List<Object>{ 1, 2, 3 };

		Test.startTest();
			SearchResults results = new SearchResults( totalNumberOfRecords, records );
		Test.stopTest();

		System.assertEquals( totalNumberOfRecords, results.totalNumberOfRecords, 'constructor, when passed a number of records and some records, will set the totalNumberOfRecords' );
		System.assertEquals( records, results.records, 'constructor, when passed a number of records and some records, will set the records' );
	}

	@isTest
	private static void constructor_whenPassedZeroAndEmpty_setsTheMemberVariables() // NOPMD: Test method name format
	{
		Integer totalNumberOfRecords = 0;
		List<Object> records = new List<Object>();

		Test.startTest();
			SearchResults results = new SearchResults( totalNumberOfRecords, records );
		Test.stopTest();

		System.assertEquals( totalNumberOfRecords, results.totalNumberOfRecords, 'constructor, when passed a zero number of records and no records, will set the totalNumberOfRecords to zero' );
		System.assertEquals( records, results.records, 'constructor, when passed a zero number of records and no records, will set the records to empty' );
	}

	@isTest
	private static void constructor_whenPassedANullNumberOfRecords_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchResults( null, new List<Object>() );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'constructor called with a null totalNumberOfRecords', exceptionMessage, 'constructor, when passed a null totalNumberOfRecords, will throw an exception' );
	}

	@isTest
	private static void constructor_whenPassedANegativeNumberOfRecords_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchResults( -1, new List<Object>() );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'constructor called with a negative totalNumberOfRecords', exceptionMessage, 'constructor, when passed a negative totalNumberOfRecords, will throw an exception' );
	}

	@isTest
	private static void constructor_whenPassedANullRecords_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchResults( 10, null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'constructor called with a null records', exceptionMessage, 'constructor, when passed a null records, will throw an exception' );
	}

	@isTest
	private static void constructor_whenPassedATotalNumberLowerThanPassedRecords_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchResults( 2, new List<Object>{ 1, 2, 3, 4 } );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'constructor called with a totalNumberOfRecords that is lower than the size of records', exceptionMessage, 'constructor, when passed a total number of records that is lower than the number of records, will throw an exception' );
	}
}