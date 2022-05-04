@isTest
private without sharing class NullActionTest
{
	@isTest
	private static void doNothing_whenCalled_willDoNothing() // NOPMD: Test method name format
	{
		NullAction.doNothing();
		System.assert( true, 'doNothing, when called, will do nothing' );
	}
}