@isTest
private without sharing class ortoo_DynamicSobjectSelectorTest
{
	@isTest
	private static void selectByCriteria_whenTheSobjectHasBeenSetByName_willReturnAListOfSobjects() // NOPMD: Test method name format
	{
		ortoo_DynamicSobjectSelector selector = new ortoo_DynamicSobjectSelector()
														.setSobjectType( 'Contact' );

		List<Sobject> returnedSobjects = selector.selectByCriteria( new ortoo_Criteria() );

		System.assertEquals( new List<Sobject>(), returnedSobjects, 'selectByCriteria, when the SObject Type has been set by name, will return a list of SObjects' );
	}

	@isTest
	private static void selectByCriteria_whenTheSobjectHasBeenSetByType_willReturnAListOfSobjects() // NOPMD: Test method name format
	{
		ortoo_DynamicSobjectSelector selector = new ortoo_DynamicSobjectSelector()
														.setSobjectType( Contact.sobjectType );

		List<Sobject> returnedSobjects = selector.selectByCriteria( new ortoo_Criteria() );

		System.assertEquals( new List<Sobject>(), returnedSobjects, 'selectByCriteria, when the SObject Type has been set by type, will return a list of SObjects' );
	}

	@isTest
	private static void selectByCriteria_whenToldToUseTheCache_willUseTheOrgSoqlCache() // NOPMD: Test method name format
	{
		ortoo_DynamicSobjectSelector selector = new ortoo_DynamicSobjectSelector()
														.setSobjectType( Contact.sobjectType );

		List<Contact> expects = new List<Contact>{ new Contact() };
		Amoss_Instance cacheController = ApplicationMockRegistrar.registerMockAppLogic( OrgCachedSoqlExecutor.class );
		cacheController
			.expects( 'query' )
			.withParameter().containing( 'SELECT Id FROM Contact' )
			.returning( expects );

		Test.startTest();
			List<Sobject> returnedSobjects = selector.selectByCriteria( new ortoo_Criteria(), true );
		Test.stopTest();

		cacheController.verify();

		System.assertEquals( expects, returnedSobjects, 'selectByCriteria, when told to use the cache, will direct the query via the OrgCachedSoqlExecutor' );
	}

	@isTest
	private static void selectByCriteria_whenToldNotToUseTheCache_willNotUseTheOrgSoqlCache() // NOPMD: Test method name format
	{
		ortoo_DynamicSobjectSelector selector = new ortoo_DynamicSobjectSelector()
														.setSobjectType( Contact.sobjectType );

		Amoss_Instance cacheController = ApplicationMockRegistrar.registerMockAppLogic( OrgCachedSoqlExecutor.class );
		cacheController
			.expectsNoCalls();

		Test.startTest();
			List<Sobject> returnedSobjects = selector.selectByCriteria( new ortoo_Criteria(), false );
		Test.stopTest();

		System.assertEquals( new List<Sobject>(), returnedSobjects, 'selectByCriteria, when told to not use the cache, will not direct the query via the OrgCachedSoqlExecutor' );
	}

	@isTest
	private static void selectByCriteria_whenTheSobjectTypeHasNotBeenSet_willThrowAnException() // NOPMD: Test method name format
	{
		ortoo_DynamicSobjectSelector selector = new ortoo_DynamicSobjectSelector();

		Test.startTest();
			String exceptionMessage;
			try
			{
				selector.selectByCriteria( new ortoo_Criteria() );
			}
			catch ( Contract.AssertException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'selectByCriteria called when sobjectType has not been set', exceptionMessage, 'selectByCriteria, when the sobject type has not been set, will throw an exception' );
	}

	@isTest
	private static void selectByCriteria_whenGivenANullCriteria_willThrowAnException() // NOPMD: Test method name format
	{
		ortoo_DynamicSobjectSelector selector = new ortoo_DynamicSobjectSelector()
														.setSobjectType( Contact.sobjectType );

		Test.startTest();
			String exceptionMessage;
			try
			{
				selector.selectByCriteria( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'selectByCriteria called with a null criteria', exceptionMessage, 'selectByCriteria, when given a null criteria, will throw an exception' );
	}

	@isTest
	private static void addField_whenGivenAString_willAddThatFieldToTheSelection() // NOPMD: Test method name format
	{
		ortoo_DynamicSobjectSelector selector = new ortoo_DynamicSobjectSelector()
														.setSobjectType( Contact.sobjectType );

		Test.startTest();
			selector.addField( 'Name' );
			String generatedSoql = selector.generateSoqlByCriteria( new ortoo_Criteria() );
		Test.stopTest();

		Amoss_asserts.assertStartsWith( 'SELECT Name FROM Contact', generatedSoql, 'addField, when given a string that represents a valid field, will add that field to the selection' );
	}

	@isTest
	private static void addField_whenGivenMultipleStrings_willAddThoseFieldsToTheSelection() // NOPMD: Test method name format
	{
		ortoo_DynamicSobjectSelector selector = new ortoo_DynamicSobjectSelector()
														.setSobjectType( Contact.sobjectType );

		Test.startTest();
			selector.addField( 'Name' )
				.addField( 'FirstName' )
				.addField( 'LastName' );
			String generatedSoql = selector.generateSoqlByCriteria( new ortoo_Criteria() );
		Test.stopTest();

		Amoss_asserts.assertStartsWith( 'SELECT FirstName, LastName, Name FROM Contact', generatedSoql, 'addField, when given multiple strings that represent valid fields, will add them to the selection' );
	}

	@isTest
	private static void addField_whenPassedANullString_willThrowAnException() // NOPMD: Test method name format
	{
		ortoo_DynamicSobjectSelector selector = new ortoo_DynamicSobjectSelector()
														.setSobjectType( Contact.sobjectType );

		Test.startTest();
			String exceptionMessage;
			try
			{
				selector.addField( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'addField called with a null fieldToAdd', exceptionMessage, 'addField, when passed a null field name, will throw an exception' );
	}

	@isTest
	private static void setSobjectType_whenPassedANullString_willThrowAnException() // NOPMD: Test method name format
	{
		String nullString;

		ortoo_DynamicSobjectSelector selector = new ortoo_DynamicSobjectSelector();

		Test.startTest();
			String exceptionMessage;
			try
			{
				selector.setSobjectType( nullString );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'setSobjectType called with a null sobjectTypeName', exceptionMessage, 'setSobjectType, when passed a null string, will throw an exception' );
	}

	@isTest
	private static void setSobjectType_whenPassedAnInvalidString_willThrowAnException() // NOPMD: Test method name format
	{
		ortoo_DynamicSobjectSelector selector = new ortoo_DynamicSobjectSelector();

		Test.startTest();
			String exceptionMessage;
			try
			{
				selector.setSobjectType( 'NotAnSObject' );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'setSobjectType called with an sobjectTypeName that does not represent a valid SObject Type', exceptionMessage, 'setSobjectType, when passed a string that does not represent an sobject, will throw an exception' );
	}

	@isTest
	private static void setSobjectType_whenPassedANullSobjectType_willThrowAnException() // NOPMD: Test method name format
	{
		SobjectType nullSobjectType;

		ortoo_DynamicSobjectSelector selector = new ortoo_DynamicSobjectSelector();

		Test.startTest();
			String exceptionMessage;
			try
			{
				selector.setSobjectType( nullSobjectType );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'setSobjectType called with a null sobjectType', exceptionMessage, 'setSobjectType, when passed a null sobject type, will throw an exception' );
	}

	@isTest
	private static void clearCacheFor_whenCalled_forwardsTheCallToTheOrgCache() // NOPMD: Test method name format
	{
		ortoo_DynamicSobjectSelector selector = new ortoo_DynamicSobjectSelector()
														.setSobjectType( Contact.sobjectType );

		Amoss_Instance cacheController = ApplicationMockRegistrar.registerMockAppLogic( OrgCachedSoqlExecutor.class );
		cacheController
			.expects( 'clearCacheFor' )
			.withParameter().containing( 'SELECT Id FROM Contact' );

		Test.startTest();
			selector.clearCacheFor( new ortoo_Criteria() );
		Test.stopTest();

		cacheController.verify();
	}
}