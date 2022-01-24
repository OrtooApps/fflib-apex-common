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
			ortoo_Exception exceptionThrown;
			try
			{
				Contract.requires( false, 'will throw' );
			}
			catch ( ortoo_Exception e )
			{
				exceptionThrown = e;
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'Contract.requires failed: will throw', exceptionThrown.getMessage(), 'requires, when given a false condition, will throw an exception' );
		System.assertEquals( 'requires_whenGivenAFalseCondition_willThrowAnException', exceptionThrown.getStackTrace().getInnermostMethodName(), 'requires, when given a false condition, will throw an exception with the stack trace set to the caller' );
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
			ortoo_Exception exceptionThrown;
			try
			{
				Contract.ensures( false, 'will throw' );
			}
			catch ( ortoo_Exception e )
			{
				exceptionThrown = e;
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'Contract.ensures failed: will throw', exceptionThrown.getMessage(), 'ensures, when given a false condition, will throw an exception' );
		System.assertEquals( 'ensures_whenGivenAFalseCondition_willThrowAnException', exceptionThrown.getStackTrace().getInnermostMethodName(), 'ensures, when given a false condition, will throw an exception with the stack trace set to the caller' );
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
			ortoo_Exception exceptionThrown;
			try
			{
				Contract.assert( false, 'will throw' );
			}
			catch ( ortoo_Exception e )
			{
				exceptionThrown = e;
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'Contract.assert failed: will throw', exceptionThrown.getMessage(), 'assert, when given a false condition, will throw an exception' );
		System.assertEquals( 'ensures_whenGivenAFalseCondition_willThrowAnException', exceptionThrown.getStackTrace().getInnermostMethodName(), 'assert, when given a false condition, will throw an exception with the stack trace set to the caller' );
	}
}