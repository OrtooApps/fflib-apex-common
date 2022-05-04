@isTest
private without sharing class DmlChildContextTest
{
    @isTest
    private static void constructor_whenCalledWithANullField_willThrowAnException() // NOPMD: Test method name format
    {
        Test.startTest();
            String exceptionMessage;
            try
            {
                new DmlChildContext( null, IChildRecordFinder.class );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'DmlChildContext was constructed with a null relatedByField', exceptionMessage, 'constructor, when called with a null field, will throw an exception' );
    }

    @isTest
    private static void constructor_whenCalledWithANullFinder_willThrowAnException() // NOPMD: Test method name format
    {
        Test.startTest();
            String exceptionMessage;
            try
            {
                new DmlChildContext( Contact.AccountId, null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'DmlChildContext was constructed with a null childFinderType', exceptionMessage, 'constructor, when called with a null finder type, will throw an exception' );
    }

    @isTest
    private static void getChildFinderType_whenCalled_willReturnTheChildFinderType() // NOPMD: Test method name format
    {
        Type configuredChildFinder = IChildRecordFinder.class;
        DmlChildContext context = new DmlChildContext( Contact.AccountId, configuredChildFinder );

        Type gotChildFinderType = context.getChildFinderType();

        System.assertEquals( configuredChildFinder, gotChildFinderType, 'getChildFinderType, when called, will return the child finder type' );
    }

    @isTest
    private static void getChildFinder_whenTheChildFinderIsValid_willReturnTheChildFinder() // NOPMD: Test method name format
    {
        IChildRecordFinder registeredChildRecordFinder = (IChildRecordFinder)ApplicationMockRegistrar.registerMockChildRecordFinder( IChildRecordFinder.class ).getDouble();

        DmlChildContext context = new DmlChildContext( Contact.AccountId, IChildRecordFinder.class );

        IChildRecordFinder gotChildFinder = context.getChildFinder();

        System.assertEquals( registeredChildRecordFinder, gotChildFinder, 'getChildFinder, when the child finder is valid, will return a child finder constructed by the factory' );
    }

    @isTest
    private static void setParent_whenCalledWithANull_willThrowAnException() // NOPMD: Test method name format
    {
        DmlChildContext context = new DmlChildContext( Contact.AccountId, IChildRecordFinder.class );

        Test.startTest();
            String exceptionMessage;
            try
            {
                context.setParent( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'setParent was called with a null parent', exceptionMessage, 'setParent, when called with null, will throw an exception' );
    }

    @isTest
    private static void registerRelationship_whenCalledWithANullUnitOfWork_willThrowAnException() // NOPMD: Test method name format
    {
        DmlChildContext context = new DmlChildContext( Contact.AccountId, IChildRecordFinder.class );

        Test.startTest();
            String exceptionMessage;
            try
            {
                context.registerRelationship( null, new Contact() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'registerRelationship was called with a null unit of work', exceptionMessage, 'registerRelationship, when called with uow, will throw an exception' );
    }

    @isTest
    private static void registerRelationship_whenCalledWithANullChild_willThrowAnException() // NOPMD: Test method name format
    {
        DmlChildContext context = new DmlChildContext( Contact.AccountId, IChildRecordFinder.class );

        Test.startTest();
            String exceptionMessage;
            try
            {
                context.registerRelationship( Application.UNIT_OF_WORK.newInstance(), null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'registerRelationship was called with a null child', exceptionMessage, 'registerRelationship, when called with child, will throw an exception' );
    }

    @isTest
    private static void registerRelationship_whenCalledWithoutHavingSetAParent_willThrowAnException() // NOPMD: Test method name format
    {
        DmlChildContext context = new DmlChildContext( Contact.AccountId, IChildRecordFinder.class );

        Test.startTest();
            String exceptionMessage;
            try
            {
                context.registerRelationship( Application.UNIT_OF_WORK.newInstance(), new Contact() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'registerRelationship was called before a parent was set', exceptionMessage, 'registerRelationship, when called before a parent is set, will throw an exception' );
    }

    @isTest
    private static void registerRelationship_whenCalledAgainstANewChild_willRegisterTheConfiguredRelationshipWithTheUow() // NOPMD: Test method name format
    {
        DmlChildContext context = new DmlChildContext( Contact.AccountId, IChildRecordFinder.class );

        Account parent = new Account( Id = TestIdUtils.generateId( Account.SobjectType ) );
        Contact child = new Contact();

        Amoss_Instance uowController = ApplicationMockRegistrar.registerMockUnitOfWork();
        uowController
            .expects( 'registerRelationship' )
            .withParameter( child )
            .thenParameter( Contact.AccountId )
            .thenParameter( parent );

        fflib_ISObjectUnitOfWork uow = (fflib_ISObjectUnitOfWork)uowController.generateDouble();

        Test.startTest();
            context.setParent( parent );
            context.registerRelationship( uow, child );
        Test.stopTest();

        uowController.verify();
    }

    @isTest
    private static void registerRelationship_whenCalledAgainstAChildThatAlreadyHasTheRelationship_willNotRegisterTheRelationship() // NOPMD: Test method name format
    {
        DmlChildContext context = new DmlChildContext( Contact.AccountId, IChildRecordFinder.class );

        Account parent = new Account( Id = TestIdUtils.generateId( Account.SobjectType ) );
        Contact child = new Contact( AccountId = parent.Id );

        Amoss_Instance uowController = ApplicationMockRegistrar.registerMockUnitOfWork();
        uowController
            .expectsNoCalls();

        fflib_ISObjectUnitOfWork uow = (fflib_ISObjectUnitOfWork)uowController.generateDouble();

        Test.startTest();
            context.setParent( parent );
            context.registerRelationship( uow, child );
        Test.stopTest();

        uowController.verify();
    }

    @isTest
    private static void registerRelationship_whenCalledAgainstAnExistingChild_willRegisterTheConfiguredRelationshipWithTheUow() // NOPMD: Test method name format
    {
        DmlChildContext context = new DmlChildContext( Contact.AccountId, IChildRecordFinder.class );

        Account parent = new Account( Id = TestIdUtils.generateId( Account.SobjectType ) );
        Contact child = new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ));

        Amoss_Instance uowController = ApplicationMockRegistrar.registerMockUnitOfWork();
        uowController
            .expects( 'registerRelationship' )
            .withParameter( child )
            .thenParameter( Contact.AccountId )
            .thenParameter( parent );

        fflib_ISObjectUnitOfWork uow = (fflib_ISObjectUnitOfWork)uowController.generateDouble();

        Test.startTest();
            context.setParent( parent );
            context.registerRelationship( uow, child );
        Test.stopTest();

        uowController.verify();
    }

    @isTest
    private static void registerRelationship_whenCalledAgainstANonReparentableNewChild_willRegisterTheRelationship() // NOPMD: Test method name format
    {
        DmlChildContext context = new DmlChildContext( DuplicateRecordItem.DuplicateRecordSetId, IChildRecordFinder.class );

        DuplicateRecordSet parent = new DuplicateRecordSet( Id = TestIdUtils.generateId( DuplicateRecordSet.SobjectType ) );
        DuplicateRecordItem child = new DuplicateRecordItem();

        Amoss_Instance uowController = ApplicationMockRegistrar.registerMockUnitOfWork();
        uowController
            .expects( 'registerRelationship' )
            .withParameter( child )
            .thenParameter( DuplicateRecordItem.DuplicateRecordSetId )
            .thenParameter( parent );

        fflib_ISObjectUnitOfWork uow = (fflib_ISObjectUnitOfWork)uowController.generateDouble();

        Test.startTest();
            context.setParent( parent );
            context.registerRelationship( uow, child );
        Test.stopTest();

        uowController.verify();
    }

    @isTest
    private static void registerRelationship_whenCalledAgainstANonReparentableExistingChild_willNotRegisterTheRelationship() // NOPMD: Test method name format
    {
        DmlChildContext context = new DmlChildContext( DuplicateRecordItem.DuplicateRecordSetId, IChildRecordFinder.class );

        DuplicateRecordSet parent = new DuplicateRecordSet( Id = TestIdUtils.generateId( DuplicateRecordSet.SobjectType ) );
        DuplicateRecordItem child = new DuplicateRecordItem( Id = TestIdUtils.generateId( DuplicateRecordItem.SobjectType ));

        Amoss_Instance uowController = ApplicationMockRegistrar.registerMockUnitOfWork();
        uowController
            .expectsNoCalls();

        fflib_ISObjectUnitOfWork uow = (fflib_ISObjectUnitOfWork)uowController.generateDouble();

        Test.startTest();
            context.setParent( parent );
            context.registerRelationship( uow, child );
        Test.stopTest();

        uowController.verify();
    }
}