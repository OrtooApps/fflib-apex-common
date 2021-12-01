@isTest
private without sharing class SobjectUtilsTest
{
	@isTest
	private static void describe_whenReferenced_willReturnTheGlobalDescribe() // NOPMD: Test method name format
	{
		Map<String,Schema.SobjectType> returnedDescribe = SobjectUtils.DESCRIBE;
		System.assertEquals( Schema.getGlobalDescribe(), returnedDescribe, 'describe, when referenced, will return the global describe' );
	}

	@isTest
	private static void getSobjectType_whenGivenAValidSobjectName_willReturnTheTypeForIt() // NOPMD: Test method name format
	{
		SobjectType returnedType = SobjectUtils.getSobjectType( 'Contact' );
		System.assertEquals( Contact.sobjectType, returnedType, 'getSobjectType, when given a valid SObject Name, will return the type for it' );
	}

	@isTest
	private static void getSobjectType_whenGivenAnInvalidSobjectName_willReturnNull() // NOPMD: Test method name format
	{
		SobjectType returnedType = SobjectUtils.getSobjectType( 'InvalidType' );
		System.assertEquals( null, returnedType, 'getSobjectType, when given an invalid SObject Name, will return null' );
	}

	@isTest
	private static void getSobjectType_whenGivenANullSobject_willThrowAnException() // NOPMD: Test method name format
	{
		Contact nullContact;

		Test.startTest();
			String exceptionMessage;
			try
			{
				SobjectUtils.getSobjectName( nullContact );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'Attempted to get the name of a null SObject', exceptionMessage, 'getSobjectType, when given a null Sobject, will throw an exception' );
	}

	@isTest
	private static void getSobjectName_whenGivenAnSobject_willReturnTheApiNameOfIt() // NOPMD: Test method name format
	{
		String returnedName = SobjectUtils.getSobjectName( new Contact() );
		System.assertEquals( 'Contact', returnedName, 'getSobjectName, when given an SObject, will return the API name of it' );
	}

	@isTest
	private static void getSobjectName_whenGivenANullSobject_willThrowAnException() // NOPMD: Test method name format
	{
		Contact nullContact;

		Test.startTest();
			String exceptionMessage;
			try
			{
				SobjectUtils.getSobjectName( nullContact );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'Attempted to get the name of a null SObject', exceptionMessage, 'getSobjectName, when given a null Sobject, will throw an exception' );
	}

	@isTest
	private static void getSobjectName_whenGivenAnSobjectType_willReturnTheApiNameOfIt() // NOPMD: Test method name format
	{
		String returnedName = SobjectUtils.getSobjectName( Contact.sobjectType );
		System.assertEquals( 'Contact', returnedName, 'getSobjectName, when given an SObjectType, will return the API name of it' );
	}

	@isTest
	private static void getSobjectName_whenGivenANullSobjectType_willThrowAnException() // NOPMD: Test method name format
	{
		SobjectType nullType = null;

		Test.startTest();
			String exceptionMessage;
			try
			{
				SobjectUtils.getSobjectName( nullType );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'Attempted to get the name of a null SObjectType', exceptionMessage, 'getSobjectName, when given a null SobjectType, will throw an exception' );
	}
}