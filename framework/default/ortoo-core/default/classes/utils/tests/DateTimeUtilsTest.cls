@isTest
public with sharing class DateTimeUtilsTest
{
	@isTest
	private static void convertToEpochTime_whenGivenADateTime_convertsItToEpochInSeconds() // NOPMD: Test method name format
	{
		DateTime timeToConvert = DateTime.newInstanceGmt( 2020, 5, 1, 13, 45, 0 );
		Long expected = 1588340700;

		Test.startTest();
			Long got = DateTimeUtils.convertToEpochTime( timeToConvert );
		Test.stopTest();

		System.assertEquals( expected, got, 'convertToEpochTime, when given a date time, will convert it to epoch in seconds' );
	}

	@isTest
	private static void convertToEpochTime_whenPassedANullTimeToConvert_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				DateTimeUtils.convertToEpochTime( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'convertToEpochTime called with a null timeToConvert', exceptionMessage, 'convertToEpochTime, when passed a null timeToConvert, will throw an exception' );
	}

	@isTest
	private static void convertToDateTime_whenGivenAEpochInSeconds_convertsItToDateTime() // NOPMD: Test method name format
	{
		Long epochInSeconds = 1588340700;
		DateTime expected = DateTime.newInstanceGmt( 2020, 5, 1, 13, 45, 0 );

		Test.startTest();
			DateTime got = DateTimeUtils.convertToDateTime( epochInSeconds );
		Test.stopTest();

		System.assertEquals( expected, got, 'convertToDateTime, when given an epoch time in seconds, will convert it to DateTime' );
	}

	@isTest
	private static void convertToDateTime_whenPassedANullEpochInSeconds_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				DateTimeUtils.convertToDateTime( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'convertToDateTime called with a null epochInSeconds', exceptionMessage, 'convertToDateTime, when passed a null epochInSeconds, will throw an exception' );
	}
}