@isTest
private without sharing class ortoo_DynamicSobjectUnitOfWorkTest
{
	@isTest
	private static void constructor_whenCalledWithNoParameters_setsTheSobjectTypesToEmpty() // NOPMD: Test method name format
	{
		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork();
		Test.stopTest();

		System.assertEquals( 0, uow.m_sObjectTypes.size(), 'constructor, when called with no parameters, will set the registered SobjectTypes to empty' );
	}

	@isTest
	private static void constructor_whenCalledWithAnIDml_setsTheSobjectTypesToEmpty() // NOPMD: Test method name format
	{
		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( new MockDml() );
		Test.stopTest();

		System.assertEquals( 0, uow.m_sObjectTypes.size(), 'constructor, when called with an IDml, will set the registered SobjectTypes to empty' );
	}

	@isTest
	private static void registerEmptyRecycleBin_whenGivenAnSobject_registersTheTypeForDml() // NOPMD: Test method name format
	{
		Contact expected = new Contact( LastName = 'test' );
		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerEmptyRecycleBin( expected );
			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 1, dml.recordsForRecycleBin.size(), 'registerEmptyRecycleBin, when given an SObject, will queue the record for empty' );
		System.assertEquals( expected, dml.recordsForRecycleBin[0], 'registerEmptyRecycleBin, when given an SObject, will queue the record for empty' );
	}

	@isTest
	private static void registerEmptyRecycleBin_whenGivenMultipleSobjects_registersTheTypesAndDml() // NOPMD: Test method name format
	{
		List<Sobject> records = new List<Sobject>
		{
			new Contact( LastName = 'test' ),
			new Account( Name = 'test' ),
			new Opportunity( Name = 'test' )
		};
		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerEmptyRecycleBin( records );
			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 3, dml.recordsForRecycleBin.size(), 'registerEmptyRecycleBin, when given a list of SObjects, will register the types and the DML' );
		System.assertEquals( records[0], dml.recordsForRecycleBin[0], 'registerEmptyRecycleBin, when given a list of SObjects, will register the types and the DML - checking record 0' );
		System.assertEquals( records[1], dml.recordsForRecycleBin[1], 'registerEmptyRecycleBin, when given a list of SObjects, will register the types and the DML - checking record 1' );
		System.assertEquals( records[2], dml.recordsForRecycleBin[2], 'registerEmptyRecycleBin, when given a list of SObjects, will register the types and the DML - checking record 2' );
	}

	@isTest
	private static void registerNew_whenGivenAnSobject_registersTheTypeForDml() // NOPMD: Test method name format
	{
		Contact expected = new Contact( LastName = 'test' );
		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerNew( expected );
			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 1, dml.recordsForInsert.size(), 'registerNew, when given an SObject, will queue the record' );
		System.assertEquals( expected, dml.recordsForInsert[0], 'registerNew, when given an SObject, will queue the record' );
	}

	@isTest
	private static void registerNew_whenGivenMultipleSobjects_registersTheTypesAndDml() // NOPMD: Test method name format
	{
		List<Sobject> records = new List<Sobject>
		{
			new Contact( LastName = 'test' ),
			new Account( Name = 'test' ),
			new Opportunity( Name = 'test' )
		};
		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerNew( records );
			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 3, dml.recordsForInsert.size(), 'registerNew, when given a list of SObjects, will register the types and the DML' );
		// Don't really know why it reverses it on inserts, but not on empty recycle bin - but it does!
		System.assertEquals( records[2], dml.recordsForInsert[0], 'registerNew, when given a list of SObjects, will register the types and the DML - checking record 0' );
		System.assertEquals( records[1], dml.recordsForInsert[1], 'registerNew, when given a list of SObjects, will register the types and the DML - checking record 1' );
		System.assertEquals( records[0], dml.recordsForInsert[2], 'registerNew, when given a list of SObjects, will register the types and the DML - checking record 2' );
	}

	@isTest
	private static void registerNew_whenGivenMultipleSobjectsAndRelationships_registersTheTypesAndDmlInOrder() // NOPMD: Test method name format
	{
		Opportunity opportunityRecord = new Opportunity( Name = 'test' );
		Contact contactRecord = new Contact( LastName = 'test' );
		Account accountRecord = new Account( Name = 'test' );

		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerNew( accountRecord );
			uow.registerNew( opportunityRecord, Opportunity.AccountId, accountRecord );
			uow.registerNew( contactRecord, Contact.AccountId, accountRecord );
			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 3, dml.recordsForInsert.size(), 'registerNew, when given sobjects with relationships, will register the types and the DML' );

		System.assertEquals( accountRecord, dml.recordsForInsert[0], 'registerNew, when given sobjects with relationships, will register the types and the DML in the right order - checking record 0' );
		System.assertEquals( contactRecord, dml.recordsForInsert[1], 'registerNew, when given sobjects with relationships, will register the types and the DML in the right order - checking record 1' );
		System.assertEquals( opportunityRecord, dml.recordsForInsert[2], 'registerNew, when given sobjects with relationships, will register the types and the DML in the right order - checking record 2' );
	}

	@isTest
	private static void registerRelationship_whenGivenMultipleSobjectsAndRelationships_registersTheTypesAndDmlInOrder() // NOPMD: Test method name format
	{
		Opportunity opportunityRecord = new Opportunity( Name = 'test' );
		Contact contactRecord = new Contact( LastName = 'test' );
		Account accountRecord = new Account( Name = 'test' );

		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerNew( opportunityRecord );
			uow.registerNew( contactRecord );
			uow.registerNew( accountRecord );

			uow.registerRelationship( opportunityRecord, Opportunity.AccountId, accountRecord );
			uow.registerRelationship( contactRecord, Contact.AccountId, accountRecord );

			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 3, dml.recordsForInsert.size(), 'registerRelationship, when given sobjects with relationships, will register the types and the DML' );

		System.assertEquals( accountRecord, dml.recordsForInsert[0], 'registerRelationship, when given sobjects with relationships, will register the types and the DML in the right order - checking record 0' );
		System.assertEquals( contactRecord, dml.recordsForInsert[1], 'registerRelationship, when given sobjects with relationships, will register the types and the DML in the right order - checking record 1' );
		System.assertEquals( opportunityRecord, dml.recordsForInsert[2], 'registerRelationship, when given sobjects with relationships, will register the types and the DML in the right order - checking record 2' );
	}

	@isTest
	private static void registerDirty_whenGivenAnSobject_registersTheTypeForDml() // NOPMD: Test method name format
	{
		Contact expected = new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ), LastName = 'test' );
		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerDirty( expected );
			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 1, dml.recordsForUpdate.size(), 'registerDirty, when given an SObject, will queue the record' );
		System.assertEquals( expected, dml.recordsForUpdate[0], 'registerDirty, when given an SObject, will queue the record' );
	}

	@isTest
	private static void registerDirty_whenGivenAnSobjectAndDirtyFields_registersTheTypeForDml() // NOPMD: Test method name format
	{
		Contact expected = new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ), LastName = 'test', FirstName = 'ignored' );
		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerDirty( expected, new List<SObjectField>{ Contact.LastName } );
			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 1, dml.recordsForUpdate.size(), 'registerDirty, when given an SObject and dirty fields, will queue the record' );
		System.assertEquals( expected.Id, dml.recordsForUpdate[0].Id, 'registerDirty, when given an SObject and dirty fields, will queue the record' );
		System.assertEquals( expected.LastName, ((Contact)dml.recordsForUpdate[0]).LastName, 'registerDirty, when given an SObject and dirty fields, will queue the record' );
		System.assertEquals( false, SobjectUtils.hasFieldPopulated( dml.recordsForUpdate[0], Contact.FirstName ), 'registerDirty, when given an SObject and dirty fields, will queue the record, only with the dirty fields included' );
	}

	@isTest
	private static void registerDirty_whenGivenMultipleSobjects_registersTheTypesAndDml() // NOPMD: Test method name format
	{
		List<Sobject> records = new List<Sobject>
		{
			new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ), LastName = 'test' ),
			new Account( Id = TestIdUtils.generateId( Account.SobjectType ), Name = 'test' ),
			new Opportunity( Id = TestIdUtils.generateId( Opportunity.SobjectType ), Name = 'test' )
		};
		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerDirty( records );
			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 3, dml.recordsForUpdate.size(), 'registerDirty, when given a list of SObjects, will register the types and the DML' );
		System.assertEquals( records[2], dml.recordsForUpdate[0], 'registerDirty, when given a list of SObjects, will register the types and the DML - checking record 0' );
		System.assertEquals( records[1], dml.recordsForUpdate[1], 'registerDirty, when given a list of SObjects, will register the types and the DML - checking record 1' );
		System.assertEquals( records[0], dml.recordsForUpdate[2], 'registerDirty, when given a list of SObjects, will register the types and the DML - checking record 2' );
	}

	@isTest
	private static void registerDirty_whenGivenMultipleSobjectsAndDirtyFields_registersTheTypesAndDml() // NOPMD: Test method name format
	{
		List<Contact> records = new List<Contact>
		{
			new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ), FirstName = 'ignored', LastName = 'test 1' ),
			new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ), FirstName = 'ignored', LastName = 'test 2' )
		};
		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerDirty( records, new List<SobjectField>{ Contact.LastName } );
			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 2, dml.recordsForUpdate.size(), 'registerDirty, when given a list of SObject and dirty fields, will queue the records' );

		System.assertEquals( records[0].Id, dml.recordsForUpdate[0].Id, 'registerDirty, when given a list of SObject and dirty fields, will queue the records - 0' );
		System.assertEquals( records[0].LastName, ((Contact)dml.recordsForUpdate[0]).LastName, 'registerDirty, when given a list of SObject and dirty fields, will queue the records - 0' );
		System.assertEquals( false, SobjectUtils.hasFieldPopulated( dml.recordsForUpdate[0], Contact.FirstName ), 'registerDirty, when given an SObject and dirty fields, will queue the records, only with the dirty fields included - 0' );

		System.assertEquals( records[1].Id, dml.recordsForUpdate[1].Id, 'registerDirty, when given a list of SObject and dirty fields, will queue the records - 1' );
		System.assertEquals( records[1].LastName, ((Contact)dml.recordsForUpdate[1]).LastName, 'registerDirty, when given a list of SObject and dirty fields, will queue the records - 1' );
		System.assertEquals( false, SobjectUtils.hasFieldPopulated( dml.recordsForUpdate[1], Contact.FirstName ), 'registerDirty, when given an SObject and dirty fields, will queue the records, only with the dirty fields included - 1' );
	}


	@isTest
	private static void registerDirty_whenGivenMultipleSobjectsAndRelationships_registersTheTypesAndDmlInOrder() // NOPMD: Test method name format
	{
		Opportunity opportunityRecord = new Opportunity( Id = TestIdUtils.generateId( Opportunity.SobjectType ), Name = 'test' );
		Contact contactRecord = new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ), LastName = 'test' );
		Account accountRecord = new Account( Id = TestIdUtils.generateId( Account.SobjectType ), Name = 'test' );

		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerDirty( accountRecord );
			uow.registerDirty( opportunityRecord, Opportunity.AccountId, accountRecord );
			uow.registerDirty( contactRecord, Contact.AccountId, accountRecord );
			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 3, dml.recordsForUpdate.size(), 'registerDirty, when given sobjects with relationships, will register the types and the DML' );

		System.assertEquals( accountRecord, dml.recordsForUpdate[0], 'registerDirty, when given sobjects with relationships, will register the types and the DML in the right order - checking record 0' );
		System.assertEquals( contactRecord, dml.recordsForUpdate[1], 'registerDirty, when given sobjects with relationships, will register the types and the DML in the right order - checking record 1' );
		System.assertEquals( opportunityRecord, dml.recordsForUpdate[2], 'registerDirty, when given sobjects with relationships, will register the types and the DML in the right order - checking record 2' );
	}

	@isTest
	private static void registerUpsert_whenGivenAnSobject_registersTheTypeForDml() // NOPMD: Test method name format
	{
		Contact expected = new Contact( LastName = 'test' );
		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerUpsert( expected );
			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 1, dml.recordsForInsert.size(), 'registerUpsert, when given an SObject, will queue the record' );
		System.assertEquals( expected, dml.recordsForInsert[0], 'registerUpsert, when given an SObject, will queue the record' );
	}

	@isTest
	private static void registerUpsert_whenGivenMultipleSobjects_registersTheTypesAndDml() // NOPMD: Test method name format
	{
		List<Sobject> records = new List<Sobject>
		{
			new Contact( LastName = 'test' ),
			new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'test' ),
			new Opportunity( Name = 'test' )
		};
		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerUpsert( records );
			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 2, dml.recordsForInsert.size(), 'registerUpsert, when given a list of SObjects, will register the types and the DML - insert' );
		System.assertEquals( records[2], dml.recordsForInsert[0], 'registerUpsert, when given a list of SObjects, will register the types and the DML - checking record 0 - insert' );
		System.assertEquals( records[0], dml.recordsForInsert[1], 'registerUpsert, when given a list of SObjects, will register the types and the DML - checking record 2 - insert' );

		System.assertEquals( 1, dml.recordsForUpdate.size(), 'registerUpsert, when given a list of SObjects, will register the types and the DML - update' );
		System.assertEquals( records[1], dml.recordsForUpdate[0], 'registerUpsert, when given a list of SObjects, will register the types and the DML - checking record 1 - update' );
	}

	@isTest
	private static void registerDeleted_whenGivenAnSobject_registersTheTypeForDml() // NOPMD: Test method name format
	{
		Contact expected = new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ), LastName = 'test' );
		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerDeleted( expected );
			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 1, dml.recordsForDelete.size(), 'registerDeleted, when given an SObject, will queue the record' );
		System.assertEquals( expected, dml.recordsForDelete[0], 'registerDeleted, when given an SObject, will queue the record' );
	}

	@isTest
	private static void registerDeleted_whenGivenMultipleSobjects_registersTheTypesAndDml() // NOPMD: Test method name format
	{
		List<Sobject> records = new List<Sobject>
		{
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ), LastName = 'test' ),
			new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'test' ),
			new Opportunity( Id = TestIdUtils.generateId( Opportunity.sobjectType ), Name = 'test' )
		};
		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerDeleted( records );
			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 3, dml.recordsForDelete.size(), 'registerDeleted, when given a list of SObjects, will register the types and the DML' );
		System.assertEquals( records[0], dml.recordsForDelete[0], 'registerDeleted, when given a list of SObjects, will register the types and the DML - checking record 0' );
		System.assertEquals( records[1], dml.recordsForDelete[1], 'registerDeleted, when given a list of SObjects, will register the types and the DML - checking record 1' );
		System.assertEquals( records[2], dml.recordsForDelete[2], 'registerDeleted, when given a list of SObjects, will register the types and the DML - checking record 2' );
	}

	@isTest
	private static void registerPermanentlyDeleted_whenGivenAnSobject_registersTheTypeForDml() // NOPMD: Test method name format
	{
		Contact expected = new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ), LastName = 'test' );
		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerPermanentlyDeleted( expected );
			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 1, dml.recordsForDelete.size(), 'registerPermanentlyDeleted, when given an SObject, will queue the record' );
		System.assertEquals( expected, dml.recordsForDelete[0], 'registerPermanentlyDeleted, when given an SObject, will queue the record' );
	}

	@isTest
	private static void registerPermanentlyDeleted_whenGivenMultipleSobjects_registersTheTypesAndDml() // NOPMD: Test method name format
	{
		List<Sobject> records = new List<Sobject>
		{
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ), LastName = 'test' ),
			new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'test' ),
			new Opportunity( Id = TestIdUtils.generateId( Opportunity.sobjectType ), Name = 'test' )
		};
		MockDml dml = new MockDml();

		Test.startTest();
			ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
			uow.registerPermanentlyDeleted( records );
			uow.commitWork();
		Test.stopTest();

		System.assertEquals( 3, dml.recordsForDelete.size(), 'registerPermanentlyDeleted, when given a list of SObjects, will register the types and the DML' );
		System.assertEquals( records[0], dml.recordsForDelete[0], 'registerPermanentlyDeleted, when given a list of SObjects, will register the types and the DML - checking record 0' );
		System.assertEquals( records[1], dml.recordsForDelete[1], 'registerPermanentlyDeleted, when given a list of SObjects, will register the types and the DML - checking record 1' );
		System.assertEquals( records[2], dml.recordsForDelete[2], 'registerPermanentlyDeleted, when given a list of SObjects, will register the types and the DML - checking record 2' );

		System.assertEquals( 3, dml.recordsForRecycleBin.size(), 'registerPermanentlyDeleted, when given a list of SObjects, will register the types and the DML - recordsForRecycleBin' );
		System.assertEquals( records[0], dml.recordsForRecycleBin[0], 'registerPermanentlyDeleted, when given a list of SObjects, will register the types and the DML - checking record 0 - recordsForRecycleBin' );
		System.assertEquals( records[1], dml.recordsForRecycleBin[1], 'registerPermanentlyDeleted, when given a list of SObjects, will register the types and the DML - checking record 1 - recordsForRecycleBin' );
		System.assertEquals( records[2], dml.recordsForRecycleBin[2], 'registerPermanentlyDeleted, when given a list of SObjects, will register the types and the DML - checking record 2 - recordsForRecycleBin' );
	}

	@isTest
	private static void registerPublishBeforeTransaction_whenCalledWithANonEvent_throwsAnException() // NOPMD: Test method name format
	{
		Contact notAnEvent = new Contact();
		MockDml dml = new MockDml();

		Test.startTest();
			String exceptionMessage;
			try
			{
				ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
				uow.registerPublishBeforeTransaction( notAnEvent );
				uow.commitWork();
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'SObject type Contact is invalid for publishing within this unit of work', exceptionMessage, 'registerPublishBeforeTransaction, when called with a non event, will throw an exception' );
	}

	@isTest
	private static void registerPublishBeforeTransaction_whenCalledWithNonEvents_throwsAnException() // NOPMD: Test method name format
	{
		List<Contact> notEvents = new List<Contact>{ new Contact() };
		MockDml dml = new MockDml();

		Test.startTest();
			String exceptionMessage;
			try
			{
				ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
				uow.registerPublishBeforeTransaction( notEvents );
				uow.commitWork();
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'SObject type Contact is invalid for publishing within this unit of work', exceptionMessage, 'registerPublishBeforeTransaction, when called with a non event, will throw an exception' );
	}

	@isTest
	private static void registerPublishAfterSuccessTransaction_whenCalledWithANonEvent_throwsAnException() // NOPMD: Test method name format
	{
		Contact notAnEvent = new Contact();
		MockDml dml = new MockDml();

		Test.startTest();
			String exceptionMessage;
			try
			{
				ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
				uow.registerPublishAfterSuccessTransaction( notAnEvent );
				uow.commitWork();
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'SObject type Contact is invalid for publishing within this unit of work', exceptionMessage, 'registerPublishAfterSuccessTransaction, when called with a non event, will throw an exception' );
	}

	@isTest
	private static void registerPublishAfterSuccessTransaction_whenCalledWithNonEvents_throwsAnException() // NOPMD: Test method name format
	{
		List<Contact> notEvents = new List<Contact>{ new Contact() };
		MockDml dml = new MockDml();

		Test.startTest();
			String exceptionMessage;
			try
			{
				ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
				uow.registerPublishAfterSuccessTransaction( notEvents );
				uow.commitWork();
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'SObject type Contact is invalid for publishing within this unit of work', exceptionMessage, 'registerPublishAfterSuccessTransaction, when called with a non event, will throw an exception' );
	}

	@isTest
	private static void registerPublishAfterFailureTransaction_whenCalledWithANonEvent_throwsAnException() // NOPMD: Test method name format
	{
		Contact notAnEvent = new Contact();
		MockDml dml = new MockDml();

		Test.startTest();
			String exceptionMessage;
			try
			{
				ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
				uow.registerPublishAfterFailureTransaction( notAnEvent );
				uow.commitWork();
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'SObject type Contact is invalid for publishing within this unit of work', exceptionMessage, 'registerPublishAfterFailureTransaction, when called with a non event, will throw an exception' );
	}

	@isTest
	private static void registerPublishAfterFailureTransaction_whenCalledWithNonEvents_throwsAnException() // NOPMD: Test method name format
	{
		List<Contact> notEvents = new List<Contact>{ new Contact() };
		MockDml dml = new MockDml();

		Test.startTest();
			String exceptionMessage;
			try
			{
				ortoo_DynamicSobjectUnitOfWork uow = new ortoo_DynamicSobjectUnitOfWork( dml );
				uow.registerPublishAfterFailureTransaction( notEvents );
				uow.commitWork();
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'SObject type Contact is invalid for publishing within this unit of work', exceptionMessage, 'registerPublishAfterFailureTransaction, when called with a non event, will throw an exception' );
	}


	// TODO: when given a circular reference

	// IDml is defined as an inner class, and so cannot be mocked using Amoss at time of writing
	private class MockDml implements fflib_SObjectUnitOfWork.IDml
    {
        public List<SObject> recordsForInsert = new List<SObject>();
        public List<SObject> recordsForUpdate = new List<SObject>();
        public List<SObject> recordsForDelete = new List<SObject>();
        public List<SObject> recordsForRecycleBin = new List<SObject>();
        public List<SObject> recordsForEventPublish = new List<SObject>();

        public void dmlInsert(List<SObject> objList)
        {
            this.recordsForInsert.addAll(objList);
        }

        public void dmlUpdate(List<SObject> objList)
        {
            this.recordsForUpdate.addAll(objList);
        }

        public void dmlDelete(List<SObject> objList)
        {
            this.recordsForDelete.addAll(objList);
        }

        public void eventPublish(List<SObject> objList)
        {
            this.recordsForEventPublish.addAll(objList);
        }

        public void emptyRecycleBin(List<SObject> objList)
        {
            this.recordsForRecycleBin.addAll(objList);
        }
    }
}