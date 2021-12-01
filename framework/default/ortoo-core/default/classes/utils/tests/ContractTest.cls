@isTest
private without sharing class ContractTest
{
	@isTest
	private static void requires_whenGivenATrueCondition_willNotThrowAnException() // NOPMD: Test method name format
	{
		Contract.requires( true, 'will not throw an exception' );
		System.assert( true, 'requires, when given a true condition, will not thrown an exception' );
	}

	@isTest
	private static void requires_whenGivenAFalseCondition_willThrowAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				Contract.requires( false, 'will throw' );
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'Contract.requires failed: will throw', exceptionMessage, 'requires, when given a false condition, will throw an exception' );
	}

	@isTest
	private static void ensures_whenGivenATrueCondition_willNotThrowAnException() // NOPMD: Test method name format
	{
		Contract.ensures( true, 'will not throw an exception' );
		System.assert( true, 'ensures, when given a true condition, will not thrown an exception' );
	}

	@isTest
	private static void ensures_whenGivenAFalseCondition_willThrowAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				Contract.ensures( false, 'will throw' );
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'Contract.ensures failed: will throw', exceptionMessage, 'ensures, when given a false condition, will throw an exception' );
	}

	@isTest
	private static void assert_whenGivenATrueCondition_willNotThrowAnException() // NOPMD: Test method name format
	{
		Contract.ensures( true, 'will not throw an exception' );
		System.assert( true, 'assert, when given a true condition, will not thrown an exception' );
	}

	@isTest
	private static void assert_whenGivenAFalseCondition_willThrowAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				Contract.assert( false, 'will throw' );
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'Contract.assert failed: will throw', exceptionMessage, 'assert, when given a false condition, will throw an exception' );
	}
}