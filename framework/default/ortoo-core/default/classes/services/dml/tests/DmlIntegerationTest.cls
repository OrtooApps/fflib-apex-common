@isTest
private without sharing class DmlIntegerationTest
{
    @isTest
    private static void saveSobjects_whenConfiguredNotToDeleteChildren_willNotDeletePreExistingChildren() // NOPMD: Test method name format
    {
        Amoss_Instance uowController = ApplicationMockRegistrar.registerMockUnitOfWork();
        fflib_ISObjectUnitOfWork uow = (fflib_ISObjectUnitOfWork)uowController.generateDouble();

        Amoss_Instance contactFinderController = ApplicationMockRegistrar.registerMockChildRecordFinder( DmlIntegerationTest.ContactRowsFinder.class );

        Account accountToUpdate = new Account( Id = TestIdUtils.generateId( Account.getSObjectType() ) );
        Contact contactToUpdate = new Contact( Id = TestIdUtils.generateId( Contact.getSObjectType() ) );

        // Since we're not asking to delete, the finder should not get any calls against it
        contactFinderController
            .expectsNoCalls();

        uowController
            .expects( 'registerUpsert' )
            .withParameter( accountToUpdate )
        .then()
            .expects( 'registerRelationship' )
            .withParameter( contactToUpdate )
            .thenParameter( Contact.AccountId )
            .thenParameter( accountToUpdate )
        .then()
            .expects( 'registerUpsert' )
            .withParameter( contactToUpdate );

        Test.startTest();
            TestableAccountDmlRecord accountDmlRecord = new TestableAccountDmlRecord( accountToUpdate )
                                                                    .addContact( contactToUpdate );  // the use of add implies that any pre-existing records should remain

            new DmlDefiner( accountDmlRecord ).saveSobjects( uow );
        Test.stopTest();

        uowController.verify();
        contactFinderController.verify();
    }

    @isTest
    private static void saveSobjects_whenConfiguredToDeleteChildren_willDeletePreExistingChildrenThatAreNotBeingUpdated() // NOPMD: Test method name format
    {
        Amoss_Instance uowController = ApplicationMockRegistrar.registerMockUnitOfWork();
        fflib_ISObjectUnitOfWork uow = (fflib_ISObjectUnitOfWork)uowController.generateDouble();

        Amoss_Instance contactFinderController = ApplicationMockRegistrar.registerMockChildRecordFinder( DmlIntegerationTest.ContactRowsFinder.class );

        Account accountToUpdate = new Account( Id = TestIdUtils.generateId( Account.getSObjectType() ) );
        Contact contactToUpdate = new Contact( Id = TestIdUtils.generateId( Contact.getSObjectType() ) );

        List<Contact> preExistingContacts = new List<Contact>
        {
            new Contact( Id = TestIdUtils.generateId( Contact.getSObjectType() ) ),
            contactToUpdate,
            new Contact( Id = TestIdUtils.generateId( Contact.getSObjectType() ) )
        };

        // Set up the child record finder so it returns the pre-existing contacts
        contactFinderController
            .expects( 'findRecords' )
            .withParameter().setToTheSameValueAs( new Set<Id>{ accountToUpdate.Id } )
            .returning( preExistingContacts );

        uowController
            .expects( 'registerDeleted' )
            .withParameterNamed( 'records' ).withElementAt( 0 ).setTo( preExistingContacts[0] )
            .withParameterNamed( 'records' ).withElementAt( 1 ).setTo( preExistingContacts[2] )
        .then()
            .expects( 'registerUpsert' )
            .withParameter( accountToUpdate )
        .then()
            .expects( 'registerRelationship' )
            .withParameter( contactToUpdate )
            .thenParameter( Contact.AccountId )
            .thenParameter( accountToUpdate )
        .then()
            .expects( 'registerUpsert' )
            .withParameter( contactToUpdate );

        Test.startTest();
            TestableAccountDmlRecord accountDmlRecord = new TestableAccountDmlRecord( accountToUpdate )
                                                                    .setContacts( new List<Contact>{ contactToUpdate } );  // the use of set implies that any pre-existing records should be deleted
            new DmlDefiner( accountDmlRecord ).saveSobjects( uow );
        Test.stopTest();

        uowController.verify();
        contactFinderController.verify();
    }

    @isTest
    private static void saveSobjects_whenConfiguredToDeleteChildrenAndNoneExist_willNotIssueADelete() // NOPMD: Test method name format
    {
        Amoss_Instance uowController = ApplicationMockRegistrar.registerMockUnitOfWork();
        fflib_ISObjectUnitOfWork uow = (fflib_ISObjectUnitOfWork)uowController.generateDouble();

        Amoss_Instance contactFinderController = ApplicationMockRegistrar.registerMockChildRecordFinder( DmlIntegerationTest.ContactRowsFinder.class );

        Account accountToUpdate = new Account( Id = TestIdUtils.generateId( Account.getSObjectType() ) );
        Contact contactToUpdate = new Contact( Id = TestIdUtils.generateId( Contact.getSObjectType() ) );

        // Set up the child record finder so it returns an empty list
        contactFinderController
            .when( 'findRecords' )
            .returns( new List<Contact>() );

        uowController
            .expects( 'registerUpsert' )
            .withParameter( accountToUpdate )
        .then()
            .expects( 'registerRelationship' )
            .withParameter( contactToUpdate )
            .thenParameter( Contact.AccountId )
            .thenParameter( accountToUpdate )
        .then()
            .expects( 'registerUpsert' )
            .withParameter( contactToUpdate );

        Test.startTest();
            TestableAccountDmlRecord accountDmlRecord = new TestableAccountDmlRecord( accountToUpdate )
                                                                    .setContacts( new List<Contact>{ contactToUpdate } );  // the use of set implies that any pre-existing records should be deleted
            new DmlDefiner( accountDmlRecord ).saveSobjects( uow );
        Test.stopTest();

        uowController.verify();
    }

    @isTest
    private static void saveSobjects_whenConfiguredToDeleteChildrenAndNoneNeedDeleting_willNotIssueADelete() // NOPMD: Test method name format
    {
        Amoss_Instance uowController = ApplicationMockRegistrar.registerMockUnitOfWork();
        fflib_ISObjectUnitOfWork uow = (fflib_ISObjectUnitOfWork)uowController.generateDouble();

        Amoss_Instance contactFinderController = ApplicationMockRegistrar.registerMockChildRecordFinder( DmlIntegerationTest.ContactRowsFinder.class );

        Account accountToUpdate = new Account( Id = TestIdUtils.generateId( Account.getSObjectType() ) );
        Contact contactToUpdate = new Contact( Id = TestIdUtils.generateId( Contact.getSObjectType() ) );

        List<Contact> preExistingContacts = new List<Contact>{ contactToUpdate };

        // Set up the child record finder so it returns the pre-existing contacts
        contactFinderController
            .when( 'findRecords' )
            .returns( preExistingContacts );

        uowController
            .expects( 'registerUpsert' )
            .withParameter( accountToUpdate )
        .then()
            .expects( 'registerRelationship' )
            .withParameter( contactToUpdate )
            .thenParameter( Contact.AccountId )
            .thenParameter( accountToUpdate )
        .then()
            .expects( 'registerUpsert' )
            .withParameter( contactToUpdate );

        Test.startTest();
            TestableAccountDmlRecord accountDmlRecord = new TestableAccountDmlRecord( accountToUpdate )
                                                                    .setContacts( new List<Contact>{ contactToUpdate } );  // the use of set implies that any pre-existing records should be deleted
            new DmlDefiner( accountDmlRecord ).saveSobjects( uow );
        Test.stopTest();

        uowController.verify();
    }

    @isTest
    private static void saveSobjects_whenGivenMultipleRecords_willBunchThemTogether() // NOPMD: Test method name format
    {
        Amoss_Instance uowController = ApplicationMockRegistrar.registerMockUnitOfWork();
        fflib_ISObjectUnitOfWork uow = (fflib_ISObjectUnitOfWork)uowController.generateDouble();

        Amoss_Instance contactFinderController = ApplicationMockRegistrar.registerMockChildRecordFinder( DmlIntegerationTest.ContactRowsFinder.class );

        List<Account> accountsToUpdate = new List<Account>
        {
            new Account( Id = TestIdUtils.generateId( Account.getSObjectType() ) ), // will setContacts on this one
            new Account( Id = TestIdUtils.generateId( Account.getSObjectType() ) ), // will addContact on this one
            new Account( Id = TestIdUtils.generateId( Account.getSObjectType() ) )  // will setContacts on this one
        };

        List<Contact> contactsToUpdate = new List<Contact>
        {
            new Contact( Id = TestIdUtils.generateId( Contact.getSObjectType() ) ),
            new Contact( Id = TestIdUtils.generateId( Contact.getSObjectType() ) ),
            new Contact( Id = TestIdUtils.generateId( Contact.getSObjectType() ) ),
            new Contact( Id = TestIdUtils.generateId( Contact.getSObjectType() ) )
        };

        List<Contact> preExistingContacts = new List<Contact>
        {
            new Contact( Id = TestIdUtils.generateId( Contact.getSObjectType() ) ),
            contactsToUpdate[0],
            contactsToUpdate[1], // even though this one shouldn't come back in the selector (we're not deleting against this account), it should not end up in the delete list
            contactsToUpdate[2],
            contactsToUpdate[3],
            new Contact( Id = TestIdUtils.generateId( Contact.getSObjectType() ) )
        };

        // Set up the child record finder so it returns the pre-existing contacts
        contactFinderController
            .expects( 'findRecords' )
            .withParameter().setToTheSameValueAs( new Set<Id>{ accountsToUpdate[0].Id, accountsToUpdate[2].Id } ) // accountsToUpdate[1] should not appear as we're 'adding' to that one
            .returning( preExistingContacts );

        uowController
        // Will register the deletes of the redundant contacts
            .expects( 'registerDeleted' )
                .withParameterNamed( 'records' ).withElementAt( 0 ).setTo( preExistingContacts[0] )
                .withParameterNamed( 'records' ).withElementAt( 1 ).setTo( preExistingContacts[5] )
        // Will register the updates for the first account and its contacts
        .then()
            .expects( 'registerUpsert' )
            .withParameter( accountsToUpdate[0] )
        .then()
            .expects( 'registerRelationship' )
            .withParameter( contactsToUpdate[0] )
            .thenParameter( Contact.AccountId )
            .thenParameter( accountsToUpdate[0] )
        .then()
            .expects( 'registerUpsert' )
            .withParameter( contactsToUpdate[0] )
        // Will register the updates for the second account and its contacts
        .then()
            .expects( 'registerUpsert' )
            .withParameter( accountsToUpdate[1] )
        .then()
            .expects( 'registerRelationship' )
            .withParameter( contactsToUpdate[1] )
            .thenParameter( Contact.AccountId )
            .thenParameter( accountsToUpdate[1] )
        .then()
            .expects( 'registerUpsert' )
            .withParameter( contactsToUpdate[1] )
        // Will register the updates for the third account and its contacts
        .then()
            .expects( 'registerUpsert' )
            .withParameter( accountsToUpdate[2] )
        .then()
            .expects( 'registerRelationship' )
            .withParameter( contactsToUpdate[2] )
            .thenParameter( Contact.AccountId )
            .thenParameter( accountsToUpdate[2] )
        .then()
            .expects( 'registerUpsert' )
            .withParameter( contactsToUpdate[2] )
        .then()
            .expects( 'registerRelationship' )
            .withParameter( contactsToUpdate[3] )
            .thenParameter( Contact.AccountId )
            .thenParameter( accountsToUpdate[2] )
        .then()
            .expects( 'registerUpsert' )
            .withParameter( contactsToUpdate[3] );

        Test.startTest();
            List<TestableAccountDmlRecord> accountDmlRecords = new List<TestableAccountDmlRecord>
            {
                new TestableAccountDmlRecord( accountsToUpdate[0] ).setContacts( new List<Contact>{ contactsToUpdate[0] } ),
                new TestableAccountDmlRecord( accountsToUpdate[1] ).addContact( contactsToUpdate[1] ),
                new TestableAccountDmlRecord( accountsToUpdate[2] ).setContacts( new List<Contact>{ contactsToUpdate[2], contactsToUpdate[3] } )
            };

            new DmlDefiner( accountDmlRecords ).saveSobjects( uow );
        Test.stopTest();

        uowController.verify();
        contactFinderController.verify();
    }

    class TestableContactDmlRecord extends DmlRecord
    {
        public TestableContactDmlRecord( Contact recordToDml )
        {
            super( recordToDml );
        }
    }

    class TestableAccountDmlRecord extends DmlRecord
    {
        public TestableAccountDmlRecord( Account recordToDml )
        {
            super( recordToDml );
            addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, ContactRowsFinder.class ) );
        }

        public TestableAccountDmlRecord addContact( Contact contactToAdd )
        {
            addChild( 'Contacts', new TestableContactDmlRecord( contactToAdd ) );
            return this;
        }

        public TestableAccountDmlRecord setContacts( List<Contact> contactsToAdd )
        {
            List<TestableContactDmlRecord> contactDmlRecords = new List<TestableContactDmlRecord>();
            for ( Contact thisContact : contactsToAdd )
            {
                contactDmlRecords.add( new TestableContactDmlRecord( thisContact ) );
            }
            setChildren( 'Contacts', new DmlDefiner( contactDmlRecords ) );
            return this;
        }
    }

    // In a proper implementation, this would be an inner class of TestableAccountDmlRecord
    // It doesn't need to do anything in the test as it will be mocked, but in reality it
    // would reference a Selector
    class ContactRowsFinder implements IChildRecordFinder
    {
        public List<Sobject> findRecords( Set<Id> parentIds )
        {
            return new List<Sobject>();
        }
    }
}