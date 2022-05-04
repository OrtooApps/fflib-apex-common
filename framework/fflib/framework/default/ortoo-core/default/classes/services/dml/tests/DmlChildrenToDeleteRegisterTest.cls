@isTest
private without sharing class DmlChildrenToDeleteRegisterTest
{
    @isTest
    private static void addRecordToKeep_whenGivenAnId_willAddItToTheSet() // NOPMD: Test method name format
    {
        DmlChildrenToDeleteRegister register = new DmlChildrenToDeleteRegister();

        List<Id> idsToAdd = new List<Id>
        {
            TestIdUtils.generateId( Contact.sobjectType ),
            TestIdUtils.generateId( Contact.sobjectType ),
            TestIdUtils.generateId( Contact.sobjectType )
        };

        Test.startTest();
            register.addRecordToKeep( idsToAdd[0] );
            register.addRecordToKeep( idsToAdd[0] );
            register.addRecordToKeep( idsToAdd[1] );
            register.addRecordToKeep( idsToAdd[2] );
        Test.stopTest();

        System.assertEquals( 3, register.getIdsOfRecordsToKeep().size(), 'addRecordToKeep, when given Ids, will add them to the set' );
    }

    @isTest
    private static void addRecordToKeep_whenGivenNull_willNotAddItToTheSet() // NOPMD: Test method name format
    {
        DmlChildrenToDeleteRegister register = new DmlChildrenToDeleteRegister();

        Test.startTest();
            register.addRecordToKeep( null );
        Test.stopTest();

        System.assertEquals( 0, register.getIdsOfRecordsToKeep().size(), 'addRecordToKeep, when given null, will not add it to the set' );
    }

    @isTest
    private static void registerChildContextAndParent_whenCalledWithAChildContextAndAParentId_willAddThatContextAndTheId() // NOPMD: Test method name format
    {
        Amoss_Instance childContextController = new Amoss_Instance( DmlChildContext.class );
        DmlChildContext childContext = (DmlChildContext)childContextController.generateDouble();

        Amoss_Instance childFinderController = new Amoss_Instance( IChildRecordFinder.class );
        IChildRecordFinder childFinder = (IChildRecordFinder)childFinderController.generateDouble();

        childContextController
            .when( 'getChildFinderType' )
            .returns( DmlChildContext.class )
        .also()
            .when( 'getChildFinder' )
            .returns( childFinder );

        Id parentId = TestIdUtils.generateId( Contact.sobjectType );
        DmlChildrenToDeleteRegister register = new DmlChildrenToDeleteRegister();

        Test.startTest();
            register.registerChildContextAndParent( childContext, parentId );
        Test.stopTest();

        System.assertEquals( new Set<Id>{ parentId }, register.getChildFinderParentIdRegister().get( DmlChildContext.class ), 'registerChildContextAndParent, when called with a child context and an id, will add that id into the reigster based on the child context type' );
        System.assertEquals( childFinder            , register.getChildFinderRegister().get( DmlChildContext.class )        , 'registerChildContextAndParent, when called with a child context and an id, will add the context child finder based on the child context type' );
    }

    @isTest
    private static void registerChildContextAndParent_whenCalledWithMultipleParentIds_willAddEachOne() // NOPMD: Test method name format
    {
        Amoss_Instance childContextController = new Amoss_Instance( DmlChildContext.class );
        DmlChildContext childContext = (DmlChildContext)childContextController.generateDouble();

        Amoss_Instance childFinderController = new Amoss_Instance( IChildRecordFinder.class );
        IChildRecordFinder childFinder = (IChildRecordFinder)childFinderController.generateDouble();

        childContextController
            .when( 'getChildFinderType' )
            .returns( DmlChildContext.class )
        .also()
            .when( 'getChildFinder' )
            .returns( childFinder );

        List<Id> parentIds = new List<Id>
        {
            TestIdUtils.generateId( Contact.sobjectType ),
            TestIdUtils.generateId( Contact.sobjectType ),
            TestIdUtils.generateId( Contact.sobjectType )
        };
        DmlChildrenToDeleteRegister register = new DmlChildrenToDeleteRegister();

        Test.startTest();
            register.registerChildContextAndParent( childContext, parentIds[0] );
            register.registerChildContextAndParent( childContext, parentIds[0] );
            register.registerChildContextAndParent( childContext, parentIds[1] );
            register.registerChildContextAndParent( childContext, parentIds[2] );
        Test.stopTest();

        System.assertEquals( new Set<Id>{ parentIds[0], parentIds[1], parentIds[2] }, register.getChildFinderParentIdRegister().get( DmlChildContext.class ), 'registerChildContextAndParent, when called with a child context and an multiple ids, will add each id into the register based on the child context type' );
        System.assertEquals( 1, register.getChildFinderRegister().size(), 'registerChildContextAndParent, when called with a child context and an multiple ids, will add the context child finder based on the child context type' );
    }

    @isTest
    private static void registerChildContextAndParent_whenCalledGivenANullId_willNotAddIt() // NOPMD: Test method name format
    {
        Amoss_Instance childContextController = new Amoss_Instance( DmlChildContext.class );
        DmlChildContext childContext = (DmlChildContext)childContextController.generateDouble();

        Amoss_Instance childFinderController = new Amoss_Instance( IChildRecordFinder.class );
        IChildRecordFinder childFinder = (IChildRecordFinder)childFinderController.generateDouble();

        childContextController
            .when( 'getChildFinderType' )
            .returns( DmlChildContext.class )
        .also()
            .when( 'getChildFinder' )
            .returns( childFinder );

        DmlChildrenToDeleteRegister register = new DmlChildrenToDeleteRegister();

        Test.startTest();
            register.registerChildContextAndParent( childContext, null );
        Test.stopTest();

        System.assertEquals( 0, register.getChildFinderParentIdRegister().size(), 'registerChildContextAndParent, when called with a child context and a null id, will not add it to the register' );
        System.assertEquals( 0, register.getChildFinderRegister().size(), 'registerChildContextAndParent, when called with a child context and a null id, will not add the child finder to the register' );
    }

	@isTest
	private static void registerChildContextAndParent_whenGivenANullChildContext_willThrowAnException() // NOPMD: Test method name format
	{
		DmlChildrenToDeleteRegister register = new DmlChildrenToDeleteRegister();

		Test.startTest();
			String exceptionMessage;
			try
			{
				register.registerChildContextAndParent( null, TestIdUtils.generateId( Contact.sobjectType ) );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'registerChildContextAndParent called with a null childContext', exceptionMessage, 'registerChildContextAndParent, when given a null child context, will throw an exception' );
	}

	@isTest
	private static void registerChildContextAndParent_whenGetChildFinderTypeReturnsNull_willThrowAnException() // NOPMD: Test method name format
	{
		DmlChildrenToDeleteRegister register = new DmlChildrenToDeleteRegister();

        Amoss_Instance childContextController = new Amoss_Instance( DmlChildContext.class );
        DmlChildContext childContext = (DmlChildContext)childContextController.generateDouble();

        childContextController
            .when( 'getChildFinderType' )
            .returns( null );

		Test.startTest();
			String exceptionMessage;
			try
			{
				register.registerChildContextAndParent( childContext, TestIdUtils.generateId( Contact.sobjectType ) );
			}
			catch ( Contract.AssertException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'registerChildContextAndParent called with a DmlChildContext that returns a null Child Finder Type', exceptionMessage, 'registerChildContextAndParent, when getChildFinderType returns null, will throw an exception' );
	}

	@isTest
	private static void registerChildContextAndParent_whenGetChildFinderReturnsNull_willThrowAnException() // NOPMD: Test method name format
	{
		DmlChildrenToDeleteRegister register = new DmlChildrenToDeleteRegister();

        Amoss_Instance childContextController = new Amoss_Instance( DmlChildContext.class );
        DmlChildContext childContext = (DmlChildContext)childContextController.generateDouble();

        childContextController
            .when( 'getChildFinderType' )
            .returns( DmlChildContext.class )
        .also()
            .when( 'getChildFinder' )
            .returns( null );

		Test.startTest();
			String exceptionMessage;
			try
			{
				register.registerChildContextAndParent( childContext, TestIdUtils.generateId( Contact.sobjectType ) );
			}
			catch ( Contract.AssertException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'registerChildContextAndParent called with a DmlChildContext that returns a null Child Finder', exceptionMessage, 'registerChildContextAndParent, when getChildFinder returns null, will throw an exception' );
	}

	@isTest
	private static void deleteChildren_whenConfigured_willAskFindersForRecordsRemoveTheOnesToKeepAndSendTheRestForDeletion() // NOPMD: Test method name format
	{
        List<Id> parentIds = new List<Id>
        {
            TestIdUtils.generateId( Account.sobjectType ),
            TestIdUtils.generateId( Account.sobjectType ),
            TestIdUtils.generateId( Account.sobjectType )
        };

		// The list of the ids that we ultimately want to see deleted
		List<Id> idsOfRecordsToDelete = new List<Id>
		{
			TestIdUtils.generateId( Contact.sobjectType ),
			TestIdUtils.generateId( Contact.sobjectType ),
			TestIdUtils.generateId( Contact.sobjectType ),
			TestIdUtils.generateId( Contact.sobjectType ),
			TestIdUtils.generateId( Contact.sobjectType )
		};

		// The records that we will register as ones that need to be kept, and so should be filtered out of the list to be deleted
		List<Id> idsOfRecordsToKeep = new List<Id>
		{
			TestIdUtils.generateId( Contact.sobjectType ),
			TestIdUtils.generateId( Contact.sobjectType ),
			TestIdUtils.generateId( Contact.sobjectType )
		};

		// The records that are used to mimic the response from a child record finder - I.E. the existing child records that get 'found'
		// Is a mixture of those we want to keep and those that should be deleted
		List<Contact> existingRecords = new List<Contact>
		{
			new Contact( Id = idsOfRecordsToDelete[0] ),
			new Contact( Id = idsOfRecordsToDelete[1] ),
			new Contact( Id = idsOfRecordsToDelete[2] ),
			new Contact( Id = idsOfRecordsToKeep[0] ),
			new Contact( Id = idsOfRecordsToKeep[1] ),
			new Contact( Id = idsOfRecordsToDelete[3] ),
			new Contact( Id = idsOfRecordsToKeep[2] ),
			new Contact( Id = idsOfRecordsToDelete[4] )
		};

		// Build an SObject version of the idsOfRecordsToDelete, since this is what will get passed into the UOW
		List<Contact> recordsToDelete = new List<Contact>();
		for ( Id thisIdToDelete : idsOfRecordsToDelete ) {
			recordsToDelete.add( new Contact( Id = thisIdToDelete ) );
		}

        Amoss_Instance childContextController = new Amoss_Instance( DmlChildContext.class );
        DmlChildContext childContext = (DmlChildContext)childContextController.generateDouble();

        Amoss_Instance childFinderController = new Amoss_Instance( IChildRecordFinder.class );
        IChildRecordFinder childFinder = (IChildRecordFinder)childFinderController.generateDouble();

		Amoss_Instance uowController = new Amoss_Instance( fflib_SobjectUnitOfWork.class );
		fflib_SobjectUnitOfWork uow = (fflib_SobjectUnitOfWork)uowController.generateDouble();

        childContextController
            .when( 'getChildFinderType' )
            .returns( DmlChildContext.class )
        .also()
            .when( 'getChildFinder' )
            .returns( childFinder );

		childFinderController
			.expects( 'findRecords' )
			.withParameter().setToTheSameValueAs( SetUtils.convertToSetOfIds( parentIds ) )
			.returns( existingRecords );

		uowController
			.expects( 'registerDeleted' )
			.withParameter().setToTheSameValueAs( recordsToDelete );

        DmlChildrenToDeleteRegister register = new DmlChildrenToDeleteRegister();

		Test.startTest();

			// Configure each of the parent Ids one by one and the result should be all 3 passed into the call to 'findRecords'
			register.registerChildContextAndParent( childContext, parentIds[0] );
			register.registerChildContextAndParent( childContext, parentIds[1] );
			register.registerChildContextAndParent( childContext, parentIds[2] );

			// Configure each of the records to keep and they should be stripped out of the deletion call
			register.addRecordToKeep( idsOfRecordsToKeep[0] );
			register.addRecordToKeep( idsOfRecordsToKeep[1] );
			register.addRecordToKeep( idsOfRecordsToKeep[2] );

			register.deleteChildren( uow );

		Test.stopTest();

		childFinderController.verify();
		uowController.verify();
	}

	@isTest
	private static void deleteChildren_whenNoChildrenAreFound_willNotCallAgainstTheUow() // NOPMD: Test method name format
	{
		List<Contact> noRecords = new List<Contact>();

        Amoss_Instance childContextController = new Amoss_Instance( DmlChildContext.class );
        DmlChildContext childContext = (DmlChildContext)childContextController.generateDouble();

        Amoss_Instance childFinderController = new Amoss_Instance( IChildRecordFinder.class );
        IChildRecordFinder childFinder = (IChildRecordFinder)childFinderController.generateDouble();

		Amoss_Instance uowController = new Amoss_Instance( fflib_SobjectUnitOfWork.class );
		fflib_SobjectUnitOfWork uow = (fflib_SobjectUnitOfWork)uowController.generateDouble();

        childContextController
            .when( 'getChildFinderType' )
            .returns( DmlChildContext.class )
        .also()
            .when( 'getChildFinder' )
            .returns( childFinder );

		childFinderController
			.when( 'findRecords' )
			.returns( noRecords );

		uowController
			.expectsNoCalls();

        DmlChildrenToDeleteRegister register = new DmlChildrenToDeleteRegister();

		Test.startTest();

			register.registerChildContextAndParent( childContext, TestIdUtils.generateId( Account.sobjectType ) );
			register.deleteChildren( uow );

		Test.stopTest();

		childFinderController.verify();
		uowController.verify();
	}

	@isTest
	private static void deleteChildren_whenAllExistingRecordsShouldBeKept_willNotIssueADelete() // NOPMD: Test method name format
	{
		// The records that we will register as ones that need to be kept, and so should be filtered out of the list to be deleted
		List<Id> idsOfRecordsToKeep = new List<Id>
		{
			TestIdUtils.generateId( Contact.sobjectType ),
			TestIdUtils.generateId( Contact.sobjectType ),
			TestIdUtils.generateId( Contact.sobjectType )
		};

		// The records that are used to mimic the response from a child record finder - I.E. the existing child records that get 'found'
		// In this case, only consists of records that should remain
		List<Contact> existingRecords = new List<Contact>
		{
			new Contact( Id = idsOfRecordsToKeep[0] ),
			new Contact( Id = idsOfRecordsToKeep[1] )
		};

        Amoss_Instance childContextController = new Amoss_Instance( DmlChildContext.class );
        DmlChildContext childContext = (DmlChildContext)childContextController.generateDouble();

        Amoss_Instance childFinderController = new Amoss_Instance( IChildRecordFinder.class );
        IChildRecordFinder childFinder = (IChildRecordFinder)childFinderController.generateDouble();

		Amoss_Instance uowController = new Amoss_Instance( fflib_SobjectUnitOfWork.class );
		fflib_SobjectUnitOfWork uow = (fflib_SobjectUnitOfWork)uowController.generateDouble();

        childContextController
            .when( 'getChildFinderType' )
            .returns( DmlChildContext.class )
        .also()
            .when( 'getChildFinder' )
            .returns( childFinder );

		childFinderController
			.when( 'findRecords' )
			.returns( existingRecords );

		uowController
			.expectsNoCalls();

        DmlChildrenToDeleteRegister register = new DmlChildrenToDeleteRegister();

		Test.startTest();

			register.registerChildContextAndParent( childContext, TestIdUtils.generateId( Account.SobjectType ) );

			// Configure each of the records to keep and they should be stripped out of the deletion call
			register.addRecordToKeep( idsOfRecordsToKeep[0] );
			register.addRecordToKeep( idsOfRecordsToKeep[1] );
			register.addRecordToKeep( idsOfRecordsToKeep[2] );

			register.deleteChildren( uow );

		Test.stopTest();

		childFinderController.verify();
		uowController.verify();
	}

	@isTest
	private static void deleteChildren_whenNoContextsAreDefined_willNotIssueADelete() // NOPMD: Test method name format
	{

		Amoss_Instance uowController = new Amoss_Instance( fflib_SobjectUnitOfWork.class );
		fflib_SobjectUnitOfWork uow = (fflib_SobjectUnitOfWork)uowController.generateDouble();

		uowController
			.expectsNoCalls();

        DmlChildrenToDeleteRegister register = new DmlChildrenToDeleteRegister();

		Test.startTest();
			register.deleteChildren( uow );
		Test.stopTest();

		uowController.verify();
	}
}