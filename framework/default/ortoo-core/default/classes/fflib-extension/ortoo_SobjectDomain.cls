/**
 * Is an extension of the provided fflib version of SobjectDomain in order to add the ability to generically load
 * a new version of the existing records
 *
 * @group fflib Extension
 */
public virtual inherited sharing class ortoo_SobjectDomain extends fflib_SobjectDomain // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
	public static fflib_SobjectDomain.TestFactory Test = fflib_SobjectDomain.Test;

	/**
	 * Constructor.
	 */
	public ortoo_SobjectDomain( List<Sobject> sObjectList )
	{
		super( sObjectList );
	}

	/**
	 * Load a new version of the current records from the database and return them.
	 *
	 * @return	List<Sobject>	The re-loaded version of the current records
	 */
	@testVisible
	protected List<Sobject> loadCurrentRecordsFromDatabase()
	{
		return Application.SELECTOR.newInstance( getSobjectType() ).selectSObjectsById( getRecordIds() );
	}

	/**
	 * Perform the trigger functionality for the given Domain class type.
	 * Allows for the deactivation of the trigger via Custom Settings
	 */
	public static void triggerHandler( Type domainClass )
	{
		Contract.requires( domainClass != null, 'triggerHandler called with a null domainClass' );

		if ( ProcessDeactivation.triggersDeactivated( domainClass ) )
		{
			return;
		}
		fflib_SobjectDomain.triggerHandler( domainClass );
	}
}