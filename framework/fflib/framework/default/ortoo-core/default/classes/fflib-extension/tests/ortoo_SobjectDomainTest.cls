@isTest
private without sharing class ortoo_SobjectDomainTest
{
    @isTest
    private static void loadCurrentRecordsFromDatabase_whenCalled_willReturnAReloadedVersionOfTheRecordsBasedOnTheCurrentIds() // NOPMD: Test method name format
    {
        Amoss_Instance selectorController = ApplicationMockRegistrar.registerMockSelector( Contact.SobjectType );

        List<Id> sobjectIds = new List<Id>
        {
            TestIdUtils.generateId( Contact.SobjectType ),
            TestIdUtils.generateId( Contact.SobjectType ),
            TestIdUtils.generateId( Contact.SobjectType )
        };

        List<Contact> originalSobjects = new List<Contact>
        {
            new Contact( Id = sobjectIds[0], LastName = 'Original1' ),
            new Contact( Id = sobjectIds[1], LastName = 'Original2' ),
            new Contact( Id = sobjectIds[2], LastName = 'Original3' )
        };

        List<Contact> expectedReloadedSobjects = new List<Contact>
        {
            new Contact( Id = sobjectIds[0], LastName = 'Reloaded1' ),
            new Contact( Id = sobjectIds[1], LastName = 'Reloaded2' ),
            new Contact( Id = sobjectIds[2], LastName = 'Reloaded3' )
        };

        selectorController
            .expects( 'selectSObjectsById' )
            .withParameter().setToTheSameValueAs( sobjectIds )
            .returning( expectedReloadedSobjects );

        ortoo_SobjectDomain domain = new ortoo_SobjectDomain( originalSobjects );

        Test.startTest();
            List<Sobject> actualReloadedSobjects = domain.loadCurrentRecordsFromDatabase();
        Test.stopTest();

        selectorController.verify();
        System.assertEquals( expectedReloadedSobjects, actualReloadedSobjects, 'loadCurrentRecordsFromDatabase, when called, will return a reloaded version of the records based on the current ids' );
    }

    @isTest
    private static void triggerHandler_whenPassedANullDomain_willThrowAnException() // NOPMD: Test method name format
    {
        Test.startTest();
            String exceptionMessage;
            try
            {
                ortoo_SobjectDomain.triggerHandler( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'triggerHandler called with a null domainClass', exceptionMessage, 'triggerHandler, when passed a null domainClass, will throw an exception' );
    }

    @isTest
    private static void triggerHandler_whenCalledWithAValidDomain_willCallMethodsOnTheDomain() // NOPMD: Test method name format
    {
        // Setup the test environment so it will perform an 'onInsert'
		ortoo_SobjectDomain.Test.Database.onInsert( new List<Contact>{ new Contact() } );

        Test.startTest();
            ortoo_SobjectDomain.triggerHandler( NullDomain.class );
        Test.stopTest();

        Set<String> expectedMethodCalls = new Set<String>{ 'onBeforeInsert', 'onAfterInsert' };
        System.assertEquals( expectedMethodCalls, NullDomain.methodsCalled, 'triggerHandler, when called with a valid domain, will call methods on the domain' );
    }

    @isTest
    private static void triggerHandler_whenTheTriggerIsDeactivatedForThePassedDomain_willNotCallMethodsOnTheDomain() // NOPMD: Test method name format
    {
        // Setup the test environment so it will perform an 'onInsert'
		ortoo_SobjectDomain.Test.Database.onInsert( new List<Contact>{ new Contact() } );

        Test.startTest();
            TestProcessDeactivationUtils.deactivateTriggerByDomain( NullDomain.class );
            ortoo_SobjectDomain.triggerHandler( NullDomain.class );
        Test.stopTest();

        Set<String> expectedMethodCalls = new Set<String>();
        System.assertEquals( expectedMethodCalls, NullDomain.methodsCalled, 'triggerHandler, when the trigger is deactivated for the passed domain, will not call methods on the domain' );
    }

}