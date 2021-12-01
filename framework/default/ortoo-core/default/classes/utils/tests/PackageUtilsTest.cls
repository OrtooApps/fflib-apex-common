@isTest
private without sharing class PackageUtilsTest
{
	@isTest
	private static void getNamespace_whenCalledWithASystemClassFullyDescribed_willReturnSystem() // NOPMD: Test method name format
	{
		String packageUtilsNamespace = PackageUtils.getNamespace( System.Test.class );

		System.assertEquals( 'System', packageUtilsNamespace, 'getNamespace, when called with a System class, will return System' );
	}

	@isTest
	private static void getNamespace_whenCalledWithASystemClass_willReturnSystem() // NOPMD: Test method name format
	{
		String packageUtilsNamespace = PackageUtils.getNamespace( Test.class );

		System.assertEquals( 'System', packageUtilsNamespace, 'getNamespace, when called with a System class, will return System' );
	}

	@isTest
	private static void getNamespace_whenCalledWithAnCustomClass_willReturnAString() // NOPMD: Test method name format
	{
		String packageUtilsNamespace = PackageUtils.getNamespace( PackageUtils.class );
		// we can't test more than this because we don't know what namespace we will be installed in
		System.assertNotEquals( null, packageUtilsNamespace, 'getNamespace, when called with a custom class, will return the namespace it is in - cal only test it is a string though' );
	}

	@isTest
	private static void getNamespace_whenCalledWithAnInnerClass_willReturnTheSameAsTheContainingClass() // NOPMD: Test method name format
	{
		String packageUtilsNamespace = PackageUtils.getNamespace( PackageUtils.class );
		String innerClassNamespace = PackageUtils.getNamespace( InnerClass.class );
		// we can't test more than this because we don't know what namespace we will be installed in
		System.assertEquals( packageUtilsNamespace, innerClassNamespace, 'getNamespace, when called with an inner class, will return the same as the containing class' );
	}

	@isTest
	private static void getNamespace_whenCalledWithANullClassType_willThrowAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				PackageUtils.getNamespace( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'getNamespace was called with a null classType', exceptionMessage, 'getNamespace, when called with a null object, will throw an exception' );
	}

	@isTest
	private static void namespacePrefix_whenReferenced_willBeSetToAString() // NOPMD: Test method name format
	{
		// we can't test more than this because we don't know what namespace we will be installed in
		System.assertNotEquals( null, PackageUtils.NAMESPACE_PREFIX, 'NAMESPACE_PREFIX, when referenced, will be set to a String' );
	}

	public class InnerClass {}
}