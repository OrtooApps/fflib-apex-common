@isTest
private without sharing class ProcessDeactivationTest
{
	@isTest
	private static void clearSetting_whenCalled_willClearTheSettingRecord() // NOPMD: Test method name format
	{
		Process_Deactivation__c initialProcessDeactivationRecord = TestProcessDeactivationUtils.getDeactivateAll();
		ProcessDeactivation.processDeactivationSetting = initialProcessDeactivationRecord;

		Test.startTest();
			ProcessDeactivation.clearSetting();
		Test.stopTest();

		System.assertNotEquals( initialProcessDeactivationRecord, ProcessDeactivation.processDeactivationSetting, 'clearSetting, when called, will clear the setting record' );
	}

	@isTest
	private static void triggersDeactivated_whenGivenATypeThatIsListedInTheSetting_willReturnTrue() // NOPMD: Test method name format
	{
		Type otherType = ProcessDeactivationTest.class;
		Type typeToLookAt = ProcessDeactivation.class;

		TestProcessDeactivationUtils.deactivateTriggersByDomain( new List<Type>{ typeToLookAt, otherType } );

		Boolean returnedDeactivated = ProcessDeactivation.triggersDeactivated( typeToLookAt );

		System.assert( returnedDeactivated, 'triggersDeactivated, when triggers are set to active, given a type that is listed in the setting, will return true' );
	}

	@isTest
	private static void triggersDeactivated_whenGivenTriggersActiveAndATypeThatIsNotListedInTheSetting_willReturnFalse() // NOPMD: Test method name format
	{
		Type otherType = ProcessDeactivationTest.class;
		Type typeToLookAt = ProcessDeactivation.class;

		TestProcessDeactivationUtils.deactivateTriggersByDomain( new List<Type>{ otherType } );

		Boolean returnedDeactivated = ProcessDeactivation.triggersDeactivated( typeToLookAt );

		System.assert( ! returnedDeactivated, 'triggersDeactivated, when triggers are set to active, given a type that is not listed in the setting, will return false' );
	}

	@isTest
	private static void triggersDeactivated_whenGivenTriggersInactiveAnNoClassesDefined_willReturnTrue() // NOPMD: Test method name format
	{
		Type typeToLookAt = ProcessDeactivation.class;

		Process_Deactivation__c settingsRecord = TestProcessDeactivationUtils.getDeactivateTriggersByDomain( new List<Type>() );
		settingsRecord.Disable_Triggers__c = true;
		TestProcessDeactivationUtils.store( settingsRecord );

		Boolean returnedDeactivated = ProcessDeactivation.triggersDeactivated( typeToLookAt );

		System.assert( returnedDeactivated, 'triggersDeactivated, when triggers are set to inactive, will return true' );
	}

	@isTest
	private static void triggersDeactivated_whenGivenTriggersInactiveAndClassesDefined_willReturnTrue() // NOPMD: Test method name format
	{
		Type otherType = ProcessDeactivationTest.class;
		Type typeToLookAt = ProcessDeactivation.class;

		Process_Deactivation__c settingsRecord = TestProcessDeactivationUtils.getDeactivateTriggersByDomain( new List<Type>{ otherType } );
		settingsRecord.Disable_Triggers__c = true;
		TestProcessDeactivationUtils.store( settingsRecord );

		Boolean returnedDeactivated = ProcessDeactivation.triggersDeactivated( typeToLookAt );

		System.assert( returnedDeactivated, 'triggersDeactivated, when triggers are set to inactive, and classes are also defined, will still return true' );
	}

	@isTest
	private static void triggersDeactivated_whenPassedANullDomainType_willThrowAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				ProcessDeactivation.triggersDeactivated( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'triggersDeactivated called with a null domainType', exceptionMessage, 'triggersDeactivated, when passed a null domainType, will throw an exception' );
	}
}