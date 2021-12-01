@isTest
private without sharing class PrivateObjectUtilsTest
{
	@isTest
	private static void getClassName_whenGivenAnInstanceOfAPrivateClass_willReturnItsName() // NOPMD: Test method name format
	{
		String returnedName = ObjectUtils.getClassName( new PrivateObjectUtilsTest() );
		Amoss_Asserts.assertEndsWith( 'PrivateObjectUtilsTest', returnedName, 'getClassName, when given an instance of a private class, will return its type' );
	}

	@isTest
	private static void getClassName_whenGivenAnInstanceOfAPublicInnerClassOfAPrivateClass_willReturnItsName() // NOPMD: Test method name format
	{
		String returnedName = ObjectUtils.getClassName( new PrivateObjectUtilsTest.PublicInnerClass() );
		Amoss_Asserts.assertEndsWith( 'PrivateObjectUtilsTest.PublicInnerClass', returnedName, 'getClassName, when given an instance of a public inner class of a private class, will return its type' );
	}

	@isTest
	private static void getClassName_whenGivenAnInstanceOfAPrivateInnerClassOfAPrivateClass_willReturnItsName() // NOPMD: Test method name format
	{
		String returnedName = ObjectUtils.getClassName( new PrivateObjectUtilsTest.PrivateInnerClass() );
		Amoss_Asserts.assertEndsWith( 'PrivateObjectUtilsTest.PrivateInnerClass', returnedName, 'getClassName, when given an instance of a private inner class of a private class, will return its type' );
	}

	@isTest
	private static void getClassType_whenGivenAnInstanceOfAPrivateClass_willThrowAnException() // NOPMD: Test method name format
	{
		Object privateObject = new PrivateObjectUtilsTest();

		Test.startTest();
			ortoo_Exception thrownException;
			try
			{
				ObjectUtils.getClassType( privateObject );
			}
			catch ( ObjectUtils.UnableToDetermineTypeException e )
			{
				thrownException = e;
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'getClassType was unable to determine the type for the object.  Most likely it is private.', thrownException.getMessage(), 'getClassType, when given an instance of a private class, will throw an exception' );
		System.assertEquals( privateObject, thrownException.getContexts().next().getValue(), 'getClassType, when given an instance of a private class, will throw an exception with the object as a context property' );
	}

	@isTest
	private static void getClassType_whenGivenAnInstanceOfAPublicInnerClassOfAPrivateClass_willReturnItsType() // NOPMD: Test method name format
	{
		Type returnedType = ObjectUtils.getClassType( new PrivateObjectUtilsTest.PublicInnerClass() );
		System.assertEquals( PrivateObjectUtilsTest.PublicInnerClass.class, returnedType, 'getClassType, when given an instance of a public inner class of a private class, will return its type' );
	}

	@isTest
	private static void getClassType_whenGivenAnInstanceOfAPrivateInnerClassOfAPrivateClass_willThrowAnException() // NOPMD: Test method name format
	{
		Object privateObject = new PrivateObjectUtilsTest.PrivateInnerClass();

		Test.startTest();
			ortoo_Exception thrownException;
			try
			{
				ObjectUtils.getClassType( privateObject );
			}
			catch ( ObjectUtils.UnableToDetermineTypeException e )
			{
				thrownException = e;
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'getClassType was unable to determine the type for the object.  Most likely it is private.', thrownException.getMessage(), 'getClassType,when given an instance of a private inner class of a private class, will throw an exception' );
		System.assertEquals( privateObject, thrownException.getContexts().next().getValue(), 'getClassType, when given an instance of a private inner class of a private class, will throw an exception with the object as a context property' );
	}

	@isTest
	private static void getParentClassType_whenGivenATypeForAnInnerClassInAPrivateParent_willThrowAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				ObjectUtils.getParentClassType( PrivateObjectUtilsTest.PublicInnerClass.class );
			}
			catch ( Contract.AssertException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'getParentClassType called with a type that does not represent an inner class in a publically accessible class', exceptionMessage, 'getParentClassType, when given a type for a top level class, will throw an exception' );
	}

	@isTest
	private static void getParentClassType_whenGivenATypeForAPrivateInnerClassInAPrivateParent_willThrowAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				ObjectUtils.getParentClassType( PrivateObjectUtilsTest.PublicInnerClass.class );
			}
			catch ( Contract.AssertException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'getParentClassType called with a type that does not represent an inner class in a publically accessible class', exceptionMessage, 'getParentClassType, when given a type for a top level class, will throw an exception' );
	}

	@isTest
	private static void getParentClassType_whenGivenATypeForAPrivateTopLevelClass_willThrowAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				ObjectUtils.getParentClassType( PrivateObjectUtilsTest.class );
			}
			catch ( Contract.AssertException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'getParentClassType called with a type that does not represent an inner class in a publically accessible class', exceptionMessage, 'getParentClassType, when given a type for a top level class, will throw an exception' );
	}

	public class PublicInnerClass {}
	private class PrivateInnerClass {}
}