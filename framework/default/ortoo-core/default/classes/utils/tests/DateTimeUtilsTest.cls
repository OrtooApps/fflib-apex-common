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
	private static void convertToDate_whenGivenADateTime_returnsTheDateFromIt() // NOPMD: Test method name format
	{
		DateTime timeToConvert = DateTime.newInstance( 2020, 5, 1, 13, 45, 0 );
		Date expected = Date.newInstance( 2020, 5, 1 );

		Test.startTest();
			Date got = DateTimeUtils.convertToDate( timeToConvert );
		Test.stopTest();

		System.assertEquals( expected, got, 'convertToDate, when given a date time, will return the date from it' );
	}

	@isTest
	private static void convertToDate_whenPassedANullTimeToConvert_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				DateTimeUtils.convertToDate( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'convertToDate called with a null timeToConvert', exceptionMessage, 'convertToDate, when passed a null timeToConvert, will throw an exception' );
	}

	@isTest
	private static void shiftToDate_whenGivenADateTimeAndDate_returnsANewDateTimeForTheNewDate() // NOPMD: Test method name format
	{
		DateTime timeToShift = DateTime.newInstance( 2020, 5, 1, 13, 45, 0 );
		Date newDate = Date.newInstance( 2021, 7, 11 );

		DateTime expected = DateTime.newInstance( 2021, 7, 11, 13, 45, 0 );

		Test.startTest();
			DateTime got = DateTimeUtils.shiftToDate( timeToShift, newDate );
		Test.stopTest();

		System.assertEquals( expected, got, 'shiftToDate, when given a DateTime and a Date, will return a new DateTime on the given date, with the original DateTime time' );
	}

	@isTest
	private static void shiftToDate_whenPassedANullTimeToShift_throwsAnException() // NOPMD: Test method name format
	{
		Date newDate = Date.newInstance( 2021, 7, 11 );

		Test.startTest();
			String exceptionMessage;
			try
			{
				DateTimeUtils.shiftToDate( null, newDate );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'shiftToDate called with a null timeToShift', exceptionMessage, 'shiftToDate, when passed a null timeToShift, will throw an exception' );
	}

	@isTest
	private static void shiftToDate_whenPassedANullNewDate_throwsAnException() // NOPMD: Test method name format
	{
		DateTime timeToShift = DateTime.newInstance( 2020, 5, 1, 13, 45, 0 );

		Test.startTest();
			String exceptionMessage;
			try
			{
				DateTimeUtils.shiftToDate( timeToShift, null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'shiftToDate called with a null newDate', exceptionMessage, 'shiftToDate, when passed a null newDate, will throw an exception' );
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