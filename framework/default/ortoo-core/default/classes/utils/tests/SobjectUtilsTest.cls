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
	private static void getSobjectType_whenGivenARecord_willReturnItsType() // NOPMD: Test method name format
	{
		SobjectType expectedType = Contact.getSObjectType();
		SobjectType actualType = SobjectUtils.getSobjectType( new Contact() );

		System.assertEquals( expectedType, actualType, 'getSobjectType, when given an SObject record, will its type' );
	}

	@isTest
	private static void getSobjectType_whenGivenARecordHeldInAGenericVariable_willReturnItsType() // NOPMD: Test method name format
	{
		SobjectType expectedType = Contact.getSObjectType();

		Sobject contactRecord = new Contact();
		SobjectType actualType = SobjectUtils.getSobjectType( contactRecord );

		System.assertEquals( expectedType, actualType, 'getSobjectType, when given an SObject record held in a generic variable, will its type' );
	}

	@isTest
	private static void getSobjectType_whenPassedANullRecord_willThrowAnException() // NOPMD: Test method name format
	{
		Sobject nullRecord = null;

		Test.startTest();
			String exceptionMessage;
			try
			{
				SobjectUtils.getSobjectType( nullRecord );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'getSobjectType called with a null record', exceptionMessage, 'getSobjectType, when passed a null record, will throw an exception' );
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

	@isTest
	private static void isCreateable_whenCalled_willReturnIsCreatableOfThatSobject() // NOPMD: Test method name format
	{
		SObject record = new Contact();

		Boolean expectedIsCreateable = record.getSObjectType().getDescribe().isCreateable();
		Boolean actualIsCreateable   = SobjectUtils.isCreateable( record );

		System.assertEquals( expectedIsCreateable, actualIsCreateable, 'isCreatable, when called with an SObject, will return if that SObject Type is createable by the current user' );
	}

	@isTest
	private static void isCreateable_whenGivenANullSobject_willThrowAnException() // NOPMD: Test method name format
	{
		SObject nullRecord = null;

		Test.startTest();
			String exceptionMessage;
			try
			{
				SobjectUtils.isCreateable( nullRecord );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'isCreateable called with a null record', exceptionMessage, 'isCreateable, when given a null record, will throw an exception' );
	}

	@isTest
	private static void isUpdateable_whenCalled_willReturnIsUpdateableOfThatSobject() // NOPMD: Test method name format
	{
		SObject record = new Contact();

		Boolean expectedIsUpdateable = record.getSObjectType().getDescribe().isUpdateable();
		Boolean actualIsUpdateable   = SobjectUtils.isUpdateable( record );

		System.assertEquals( expectedIsUpdateable, actualIsUpdateable, 'isUpdateable, when called with an SObject, will return if that SObject Type is updateable by the current user' );
	}

	@isTest
	private static void isUpdateable_whenGivenANullSobject_willThrowAnException() // NOPMD: Test method name format
	{
		SObject nullRecord = null;

		Test.startTest();
			String exceptionMessage;
			try
			{
				SobjectUtils.isUpdateable( nullRecord );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'isUpdateable called with a null record', exceptionMessage, 'isUpdateable, when given a null record, will throw an exception' );
	}

	@isTest
	private static void isDeletable_whenCalled_willReturnIsUpdateableOfThatSobject() // NOPMD: Test method name format
	{
		SObject record = new Contact();

		Boolean expectedIsDeletable = record.getSObjectType().getDescribe().isDeletable();
		Boolean actualIsDeletable   = SobjectUtils.isDeletable( record );

		System.assertEquals( expectedIsDeletable, actualIsDeletable, 'isDeletable, when called with an SObject, will return if that SObject Type is deletable by the current user' );
	}

	@isTest
	private static void isDeletable_whenGivenANullSobject_willThrowAnException() // NOPMD: Test method name format
	{
		SObject nullRecord = null;

		Test.startTest();
			String exceptionMessage;
			try
			{
				SobjectUtils.isDeletable( nullRecord );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'isDeletable called with a null record', exceptionMessage, 'isDeletable, when given a null record, will throw an exception' );
	}

	@isTest
	private static void isCreateable_sobjectType_whenCalled_willReturnIsCreatableOfThatSobjectType() // NOPMD: Test method name format
	{
		Boolean expectedIsCreateable = Contact.sObjectType.getDescribe().isCreateable();
		Boolean actualIsCreateable   = SobjectUtils.isCreateable( Contact.sObjectType );

		System.assertEquals( expectedIsCreateable, actualIsCreateable, 'isCreatable, when called with an SObjectType, will return if that SObject Type is createable by the current user' );
	}

	@isTest
	private static void isCreateable_sobjectType_whenGivenANullSobject_willThrowAnException() // NOPMD: Test method name format
	{
		SobjectType nullType = null;

		Test.startTest();
			String exceptionMessage;
			try
			{
				SobjectUtils.isCreateable( nullType );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'isCreateable called with a null type', exceptionMessage, 'isCreateable, when given a null SObjectType, will throw an exception' );
	}

	@isTest
	private static void isUpdateable_sobjectType_whenCalled_willReturnIsUpdateableOfThatSobject() // NOPMD: Test method name format
	{
		Boolean expectedIsUpdateable = Contact.sObjectType.getDescribe().isUpdateable();
		Boolean actualIsUpdateable   = SobjectUtils.isUpdateable( Contact.sObjectType );

		System.assertEquals( expectedIsUpdateable, actualIsUpdateable, 'isUpdateable, when called with an SObjectType, will return if that SObject Type is updateable by the current user' );
	}

	@isTest
	private static void isUpdateable_sobjectType_whenGivenANullSobject_willThrowAnException() // NOPMD: Test method name format
	{
		SobjectType nullType = null;

		Test.startTest();
			String exceptionMessage;
			try
			{
				SobjectUtils.isUpdateable( nullType );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'isUpdateable called with a null type', exceptionMessage, 'isUpdateable, when given a null SObjectType, will throw an exception' );
	}

	@isTest
	private static void isDeletable_sobjectType_whenCalled_willReturnIsUpdateableOfThatSobject() // NOPMD: Test method name format
	{
		Boolean expectedIsDeletable = Contact.sObjectType.getDescribe().isDeletable();
		Boolean actualIsDeletable   = SobjectUtils.isDeletable( Contact.sobjectType );

		System.assertEquals( expectedIsDeletable, actualIsDeletable, 'isDeletable, when called with an SObjectType, will return if that SObject Type is deletable by the current user' );
	}

	@isTest
	private static void isDeletable_sobjectType_whenGivenANullSobject_willThrowAnException() // NOPMD: Test method name format
	{
		SobjectType nullType = null;

		Test.startTest();
			String exceptionMessage;
			try
			{
				SobjectUtils.isDeletable( nullType );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'isDeletable called with a null type', exceptionMessage, 'isDeletable, when given a null SObjectType, will throw an exception' );
	}

	@isTest
	private static void isAccessible_sobjectType_whenCalled_willReturnIsUpdateableOfThatSobject() // NOPMD: Test method name format
	{
		Boolean expectedIsAccessible = Contact.sObjectType.getDescribe().isAccessible();
		Boolean actualIsAccessible   = SobjectUtils.isAccessible( Contact.sobjectType );

		System.assertEquals( expectedIsAccessible, actualIsAccessible, 'isAccessible, when called with an SObjectType, will return if that SObject Type is accessible by the current user' );
	}

	@isTest
	private static void isAccessible_sobjectType_whenGivenANullSobject_willThrowAnException() // NOPMD: Test method name format
	{
		SobjectType nullType = null;

		Test.startTest();
			String exceptionMessage;
			try
			{
				SobjectUtils.isAccessible( nullType );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'isAccessible called with a null type', exceptionMessage, 'isAccessible, when given a null SObjectType, will throw an exception' );
	}
}