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
	public static Long getEpochTime()
	{
		Long millisecondsNow = Datetime.now().getTime();
		return millisecondsNow / 1000;
	}
}
