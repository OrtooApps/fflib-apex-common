/**
 * Utility class that provides extra capabilities related to DateTime
 *
 * @group Utils
 */
public inherited sharing class DateTimeUtils
{
	/**
	 * Given a date time, will convert it into the epoch time, in seconds
	 *
	 * @param	DateTime	The time to convert
	 * @return	Long		The epoch time, in number of seconds
	 */
	public static Long convertToEpochTime( DateTime timeToConvert )
	{
		Contract.requires( timeToConvert != null, 'convertToEpochTime called with a null timeToConvert' );

		Long milliseconds = timeToConvert.getTime();
		return milliseconds / 1000;
	}

	/**
	 * Given a DateTime, will convert it to a date
	 *
	 * @param	DateTime	The time to convert
	 * @return	Date		The resulting Date
	 */
	public static Date convertToDate( DateTime timeToConvert )
	{
		Contract.requires( timeToConvert != null, 'convertToDate called with a null timeToConvert' );

		return  Date.newInstance( timeToConvert.year(), timeToConvert.month(), timeToConvert.day() );
	}

	/**
	 * Given a DateTime, will shift it to the specified date, keeping the time the same.
	 *
	 * Note that the millisecond precision is lost
	 *
	 * @param	DateTime	The time to shift
	 * @param	Date		The new date to shift the DateTime to
	 * @return	DateTime	The resulting DateTime
	 */
	public static DateTime shiftToDate( DateTime timeToShift, Date newDate )
	{
		Contract.requires( timeToShift != null, 'shiftToDate called with a null timeToShift' );
		Contract.requires( newDate != null, 'shiftToDate called with a null newDate' );

		return DateTime.newInstance( newDate.year(), newDate.month(), newDate.day(), timeToShift.hour(), timeToShift.minute(), timeToShift.second() );
	}

	/**
	 * Given an epoch time in seconds, will convert it into a DateTime
	 *
	 * @param	Long		The epoch time, in number of seconds
	 * @return	DateTime	The resulting DateTime
	 */
	public static DateTime convertToDateTime( Long epochInSeconds )
	{
		Contract.requires( epochInSeconds != null, 'convertToDateTime called with a null epochInSeconds' );

		return DateTime.newInstance( epochInSeconds * 1000 );
	}
}