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
	 * Given an epoch time in seconds, will convert it into a DateTime
	 *
	 * @return	Long		The epoch time, in number of seconds
	 * @param	DateTime	The resulting DateTime
	 */
	public static DateTime convertToDateTime( Long epochInSeconds )
	{
		Contract.requires( epochInSeconds != null, 'convertToDateTime called with a null epochInSeconds' );

		return DateTime.newInstance( epochInSeconds * 1000 );
	}
}
