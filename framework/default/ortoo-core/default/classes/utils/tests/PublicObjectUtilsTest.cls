@isTest
public without sharing class PublicObjectUtilsTest
{
	@isTest
	private static void stripLocalNamespace_whenGivenANameWithTheNamespace_stripsIt() // NOPMD: Test method name format
	{
		String originalClassName = PackageUtils.NAMESPACE_PREFIX + '.' + 'theouterclass.theinnerclass';
		Test.startTest();
			String got = ObjectUtils.stripLocalNamespace( originalClassName );
		Test.stopTest();

		System.assertEquals( 'theouterclass.theinnerclass', got, 'stripLocalNamespace, when given a class name with the local namespace prefix, will strip it' );
	}

	@isTest
	private static void stripLocalNamespace_whenGivenANameWithTheNamespaceInUppercase_stripsIt() // NOPMD: Test method name format
	{
		String originalClassName = PackageUtils.NAMESPACE_PREFIX.toUppercase() + '.' + 'theouterclass.theinnerclass';
		Test.startTest();
			String got = ObjectUtils.stripLocalNamespace( originalClassName );
		Test.stopTest();

		System.assertEquals( 'theouterclass.theinnerclass', got, 'stripLocalNamespace, when given a class name with the local namespace prefix in uppercase, will strip it' );
	}

	@isTest
	private static void stripLocalNamespace_whenGivenANameWithTheNamespaceInTheMiddle_doesNotStripIt() // NOPMD: Test method name format
	{
		String originalClassName = 'anotherbit.' + PackageUtils.NAMESPACE_PREFIX + '.' + 'theouterclass.theinnerclass';
		Test.startTest();
			String got = ObjectUtils.stripLocalNamespace( originalClassName );
		Test.stopTest();

		System.assertEquals( originalClassName, got, 'stripLocalNamespace, when given a class name with the local namespace prefix in the middle, will not strip it' );
	}

	@isTest
	private static void stripLocalNamespace_whenGivenANameWithNoLocalNamespace_doesNotStripIt() // NOPMD: Test method name format
	{
		String originalClassName = 'adifferentnamespace.theouterclass.theinnerclass';
		Test.startTest();
			String got = ObjectUtils.stripLocalNamespace( originalClassName );
		Test.stopTest();

		System.assertEquals( originalClassName, got, 'stripLocalNamespace, when given a class name with a different namespace, will not strip it' );
	}

	@isTest
	private static void getParentClassType_whenGivenATypeForAnInnerClassInAPublicParent_willReturnTheTypeForTheContainingClass() // NOPMD: Test method name format
	{
		Type parentType = ObjectUtils.getParentClassType( PublicObjectUtilsTest.PublicInnerClass.class );
		System.assertEquals( PublicObjectUtilsTest.class, parentType, 'getParentClassType, when given a type for a public inner class inside a public parent class, will return the type for the containing class' );
	}

	@isTest
	private static void getParentClassType_whenGivenATypeForAPrivateInnerClassInAPublicParent_willReturnTheTypeForTheContainingClass() // NOPMD: Test method name format
	{
		Type parentType = ObjectUtils.getParentClassType( PublicObjectUtilsTest.PrivateInnerClass.class );
		System.assertEquals( PublicObjectUtilsTest.class, parentType, 'getParentClassType, when given a type for a private inner class inside a public parent class, will return the type for the containing class' );
	}

	@isTest
	private static void getClassName_whenGivenAnInstanceOfAPublicClass_willReturnItsName() // NOPMD: Test method name format
	{
		String returnedName = ObjectUtils.getClassName( new PublicObjectUtilsTest() );
		Amoss_Asserts.assertEndsWith( 'PublicObjectUtilsTest', returnedName, 'getClassName, when given an instance of a public class, will return its type' );
	}

	@isTest
	private static void getClassName_whenGivenAnInstanceOfAPublicInnerClassOfAPublicClass_willReturnItsName() // NOPMD: Test method name format
	{
		String returnedName = ObjectUtils.getClassName( new PublicObjectUtilsTest.PublicInnerClass() );
		Amoss_Asserts.assertEndsWith( 'PublicObjectUtilsTest.PublicInnerClass', returnedName, 'getClassName, when given an instance of a public inner class of a public class, will return its type' );
	}

	@isTest
	private static void getClassName_whenGivenAnInstanceOfAPrivateInnerClassOfAPublicClass_willReturnItsName() // NOPMD: Test method name format
	{
		String returnedName = ObjectUtils.getClassName( new PublicObjectUtilsTest.PrivateInnerClass() );
		Amoss_Asserts.assertEndsWith( 'PublicObjectUtilsTest.PrivateInnerClass', returnedName, 'getClassName, when given an instance of a private inner class of a public class, will return its type' );
	}

	@isTest
	private static void getClassName_whenCalledWithANullObject_willThrowAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				ObjectUtils.getClassName( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'getClassName called with a null obj', exceptionMessage, 'getClassName, when called with a null object, will throw an exception' );
	}

	@isTest
	private static void getClassType_whenGivenAnInstanceOfAPublicClass_willReturnItsType() // NOPMD: Test method name format
	{
		Type returnedType = ObjectUtils.getClassType( new PublicObjectUtilsTest() );
		System.assertEquals( PublicObjectUtilsTest.class, returnedType, 'getClassType, when given an instance of a public class, will return its type' );
	}

	@isTest
	private static void getClassType_whenGivenAnInstanceOfAPublicInnerClassOfAPublicClass_willReturnItsType() // NOPMD: Test method name format
	{
		Type returnedType = ObjectUtils.getClassType( new PublicObjectUtilsTest.PublicInnerClass() );
		System.assertEquals( PublicObjectUtilsTest.PublicInnerClass.class, returnedType, 'getClassType, when given an instance of a public inner class of a public class, will return its type' );
	}

	@isTest
	private static void getClassType_whenGivenAnInstanceOfAPrivateInnerClassOfAPublicClass_willReturnNull() // NOPMD: Test method name format
	{
		Object privateObject = new PublicObjectUtilsTest.PrivateInnerClass();

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

		ortoo_Asserts.assertContains( 'getClassType was unable to determine the type for the object.  Most likely it is private.', thrownException.getMessage(), 'getClassType, when called with a private inner class of a public class, will throw an exception' );
		System.assertEquals( privateObject, thrownException.getContexts().next().getValue(), 'getClassType, when called with a private inner class of a public class, will throw an exception with the object as a context property' );
	}

	@isTest
	private static void getClassType_whenCalledWithANullObject_willThrowAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				ObjectUtils.getClassType( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'getClassType called with a null obj', exceptionMessage, 'getClassType, when called with a null object, will throw an exception' );
	}

	@isTest
	private static void getParentClassType_whenGivenATypeForAPublicTopLevelClass_willThrowAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				ObjectUtils.getParentClassType( PublicObjectUtilsTest.class );
			}
			catch ( Contract.AssertException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'getParentClassType called with a type that does not represent an inner class in a publically accessible class', exceptionMessage, 'getParentClassType, when given a type for a top level class, will throw an exception' );
	}

	@isTest
	private static void getParentClassType_whenCalledWithANullObject_willThrowAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				ObjectUtils.getParentClassType( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'getParentClassType called with a null innerClassType', exceptionMessage, 'getParentClassType, when called with a null object, will throw an exception' );
	}

	public class PublicInnerClass {}
	private class PrivateInnerClass {}
}