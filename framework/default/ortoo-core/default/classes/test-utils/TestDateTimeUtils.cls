/**
 * Utility class that provides the ability to generate Ids for given SObject types in tests
 *
 * @group Utils
 */
@isTest
public inherited sharing class TestDateTimeUtils
{
	public static void setCurrentDate( Date currentDate )
	{
		ortoo_DateLiterals.today = currentDate;
	}

	public static void setCurrentDateTime( DateTime currentDateTime )
	{
		ortoo_DateLiterals.now = currentDateTime;
	}

	public static void setCurrentDateTime( Long epochInSeconds )
	{
		ortoo_DateLiterals.now = DateTimeUtils.convertToDateTime( epochInSeconds );
	}

	public static void addToCurrentTime( Integer numberOfSeconds )
	{
		ortoo_DateLiterals.now = DateTimeUtils.convertToDateTime( ortoo_DateLiterals.epochTime + numberOfSeconds );
	}
}