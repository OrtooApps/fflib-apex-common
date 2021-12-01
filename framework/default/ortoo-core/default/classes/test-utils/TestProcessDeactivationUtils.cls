/**
 * Utility class that provides the ability to disable process types in tests
 *
 * @group TestUtils
 */
@isTest
public with sharing class TestProcessDeactivationUtils
{
	/**
	 * Deactivate all processes in this app.
	 */
	public static void deactivateAll()
	{
		store( getDeactivateAll() );
	}

	/**
	 * Deactivate the trigger in the app that are served by the passed domain classes
	 */
	public static void deactivateTriggerByDomain( Type domain )
	{
		store( getDeactivateTriggersByDomain( new List<Type>{ domain } ) );
	}

	/**
	 * Deactivate the triggers in the app that are served by the passed domain classes
	 */
	public static void deactivateTriggersByDomain( List<Type> domains )
	{
		store( getDeactivateTriggersByDomain( domains ) );
	}

	/**
	 * Builds a Process Deactivation record for the current organisation, that states all processes should be deactivated.
	 *
	 * @return	Process_Deactivation__c	A Process Deactivation record that states all processes should be deactivated
	 */
	public static Process_Deactivation__c getDeactivateAll()
	{
		return build( true );
	}

	/**
	 * Builds a Process Deactivation record for the current organisation, that states all processes should be activated, other than the stated triggers.
	 *
	 * @return	Process_Deactivation__c	A Process Deactivation record that states the given domain triggers should be deactivated
	 */
	public static Process_Deactivation__c getDeactivateTriggersByDomain( List<Type> domains )
	{
		Contract.requires( domains != null, 'getDeactivateTriggersByDomain called with a null domains' );

		Process_Deactivation__c returnRecord = build( false );
		returnRecord.Disable_Triggers_By_Domain__c	= StringUtils.convertListToDelimitedString( domains );

		return returnRecord;
	}

	/**
	 * Stores the give process deactivation record, ensuing that any cached versions of them are cleared.
	 *
	 * @param	Process_Deactivation__c	The setting record to store
	 */
	public static void store( Process_Deactivation__c processDeactivationSetting )
	{
		insert processDeactivationSetting;
		ProcessDeactivation.clearSetting();
	}

	private static Process_Deactivation__c build( Boolean defaultValue )
	{
		return new Process_Deactivation__c
			(
				SetupOwnerId					= UserInfo.getOrganizationId(),
				Disable_Validation_Rules__c		= defaultValue,
				Disable_Triggers__c     		= defaultValue,
				Disable_Flows__c           		= defaultValue,
				Disable_Processes__c       		= defaultValue,
				Disable_Workflows__c       		= defaultValue
			);
	}
}