/**
 * Utility class that provides the ability to generate Ids for given SObject types in tests
 *
 * @group Utils
 */
@isTest
public inherited sharing class TestDateTimeUtils
{
	/**
	 * Sets the current Date as returned by ortoo_DateLiterals.today
	 * Does not change the return of ortoo_DateLiterals.now
	 */
	public static void setCurrentDate( Date currentDate )
	{
		ortoo_DateLiterals.today = currentDate;
		ortoo_DateLiterals.now = DateTimeUtils.shiftToDate( ortoo_DateLiterals.now, currentDate );
	}

	/**
	 * Sets the current DateTime as returned by ortoo_DateLiterals.now
	 * Also sets ortoo_DateLiterals.today to be for the same date
	 */
	public static void setCurrentDateTime( DateTime currentDateTime )
	{
		ortoo_DateLiterals.now = currentDateTime;
		ortoo_DateLiterals.today = DateTimeUtils.convertToDate( currentDateTime );
	}

	/**
	 * Sets the current DateTime as returned by ortoo_DateLiterals.now to the time represented by the given epoch
	 * Also sets ortoo_DateLiterals.today to be for the same date
	 */
	public static void setCurrentDateTime( Long epochInSeconds )
	{
		setCurrentDateTime( DateTimeUtils.convertToDateTime( epochInSeconds ) );
	}

	/**
	 * Adds the given number of seconds to ortoo_DateLiterals.now
	 * Also sets ortoo_DateLiterals.today to be for the same date
	 */
	public static void addToCurrentTime( Integer numberOfSeconds )
	{
		setCurrentDateTime( ortoo_DateLiterals.epochTime + numberOfSeconds );
	}
}