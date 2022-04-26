/**
 * Utility class that provides extra capabilities related to DateTime
 *
 * @group Utils
 */
public inherited sharing class DateTimeUtils
{
	/**
	 * Returns the current Epoch Time, in seconds
	 *
	 * @return	Long	The current Epoch Time, in seconds
	 */
	// TODO: should this be on DateLiterals?
	public static Long getEpochTime()
	{
		return getEpochTime( ortoo_DateLiterals.now );
	}

	// TODO: test
	// TODO: document
	public static Long getEpochTime( DateTime timeToConvert )
	{
		Long milliseconds = timeToConvert.getTime();
		return milliseconds / 1000;
	}

	// TODO: test
	// TODO: document
	public static DateTime convertToDateTime( Long epochInSeconds )
	{
		return DateTime.newInstance( epochInSeconds * 1000 );
	}
}
