/**
 * A Lightning Controlller that provides access to the Epoch Time as defined by the
 * Salesforce instance's clock
 */
public with sharing class TimeController
{
	/**
	 * Returns the current Epoch time, in seconds
	 *
	 * @return  Long	The current Epoch Time, in seconds.
	 */
	@AuraEnabled
	public static Long getEpochTime()
	{
		return ortoo_DateLiterals.epochTime;
	}
}