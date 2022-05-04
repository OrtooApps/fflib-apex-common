@isTest
private without sharing class ortoo_SobjectUnitOfWorkTest
{
    @isTest
    private static void elevatedContext_whenCalled_willReturnAnElevatedContext() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>() );

        ortoo_SobjectUnitOfWork.ElevatedContext elevatedUow = uow.elevatedContext();

        System.assertEquals( uow, elevatedUow.uow, 'elevatedContext, when called, will return an elevated context with the UOW set to "this"' );
    }


    @isTest
    private static void getNumberOfPendingDmlRows_whenNothingHasBeenSentToTheUow_willReturnOne() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>() );
        Integer numberOfRows = uow.getNumberOfPendingDmlRows();
        System.assertEquals( 1, numberOfRows, 'getNumberOfPendingDmlRows, when nothing has been sent to the Unit of Work, will return one - for the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlRows_whenMultipleRowsOfDifferentTypesHaveBeenAddedAsNew_willReturnTheCount() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Test.startTest();
            uow.registerNew( new Contact() );
            uow.registerNew( new Contact() );
            uow.registerNew( new Account() );

            Integer numberOfRows = uow.getNumberOfPendingDmlRows();
        Test.stopTest();
        System.assertEquals( 4, numberOfRows, 'getNumberOfPendingDmlRows, when multiple rows of different types have been added as new, will return the count of them, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlRows_whenMultipleRowsOfDifferentTypesHaveBeenAddedAsDirty_willReturnTheCount() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Test.startTest();
            uow.registerDirty( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDirty( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDirty( new Account( Id = TestIdUtils.generateId( Account.sobjectType ) ) );

            Integer numberOfRows = uow.getNumberOfPendingDmlRows();
        Test.stopTest();
        System.assertEquals( 4, numberOfRows, 'getNumberOfPendingDmlRows, when multiple rows of different types have been added as dirty, will return the count of them, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlRows_whenMultipleRowsWithTheSameIdAreMarkedAsUpdate_willReturnAUniqueCount() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Id duplicateContactId = TestIdUtils.generateId( Contact.sobjectType );

        Test.startTest();
            uow.registerDirty( new Contact( Id = duplicateContactId ) );
            uow.registerDirty( new Contact( Id = duplicateContactId ) );
            uow.registerDirty( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDirty( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDirty( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDirty( new Account( Id = TestIdUtils.generateId( Account.sobjectType ) ) );

            Integer numberOfRows = uow.getNumberOfPendingDmlRows();
        Test.stopTest();
        System.assertEquals( 6, numberOfRows, 'getNumberOfPendingDmlRows, when multiple rows with the same id are added as dirty, will return the unique count of them, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlRows_whenMultipleRowsOfDifferentTypesHaveBeenAddedAsUpsert_willReturnTheCount() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Test.startTest();
            uow.registerUpsert( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerUpsert( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerUpsert( new Account( Id = TestIdUtils.generateId( Account.sobjectType ) ) );
            uow.registerUpsert( new Contact() );
            uow.registerUpsert( new Account() );

            Integer numberOfRows = uow.getNumberOfPendingDmlRows();
        Test.stopTest();
        System.assertEquals( 6, numberOfRows, 'getNumberOfPendingDmlRows, when multiple rows of different types have been added as upsert, will return the count of them, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlRows_whenMultipleRowsWithTheSameIdAreMarkedAsUpsert_willReturnAUniqueCount() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Id duplicateContactId = TestIdUtils.generateId( Contact.sobjectType );

        Test.startTest();
            uow.registerUpsert( new Contact() );
            uow.registerUpsert( new Contact( Id = duplicateContactId ) );
            uow.registerUpsert( new Contact( Id = duplicateContactId ) );
            uow.registerUpsert( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerUpsert( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerUpsert( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerUpsert( new Account( Id = TestIdUtils.generateId( Account.sobjectType ) ) );

            Integer numberOfRows = uow.getNumberOfPendingDmlRows();
        Test.stopTest();
        System.assertEquals( 7, numberOfRows, 'getNumberOfPendingDmlRows, when multiple rows with the same id are added as upsert, will return the unique count of them, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlRows_whenMultipleRowsOfDifferentTypesHaveBeenAddedAsDeleted_willReturnTheCount() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Test.startTest();
            uow.registerDeleted( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDeleted( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDeleted( new Account( Id = TestIdUtils.generateId( Account.sobjectType ) ) );

            Integer numberOfRows = uow.getNumberOfPendingDmlRows();
        Test.stopTest();
        System.assertEquals( 4, numberOfRows, 'getNumberOfPendingDmlRows, when multiple rows of different types have been added as deleted, will return the count of them, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlRows_whenMultipleRowsWithTheSameIdAreMarkedAsDeleted_willReturnAUniqueCount() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Id duplicateContactId = TestIdUtils.generateId( Contact.sobjectType );

        Test.startTest();
            uow.registerDeleted( new Contact( Id = duplicateContactId ) );
            uow.registerDeleted( new Contact( Id = duplicateContactId ) );
            uow.registerDeleted( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDeleted( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDeleted( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDeleted( new Account( Id = TestIdUtils.generateId( Account.sobjectType ) ) );

            Integer numberOfRows = uow.getNumberOfPendingDmlRows();
        Test.stopTest();
        System.assertEquals( 6, numberOfRows, 'getNumberOfPendingDmlRows, when multiple rows with the same id are added as deleted, will return the unique count of them, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlRows_whenMultipleRowsOfDifferentTypesHaveBeenAddedAsEmptyRecycleBin_willReturnTheCount() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Test.startTest();
            uow.registerEmptyRecycleBin( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerEmptyRecycleBin( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerEmptyRecycleBin( new Account( Id = TestIdUtils.generateId( Account.sobjectType ) ) );
            uow.registerEmptyRecycleBin( new Contact() );
            uow.registerEmptyRecycleBin( new Account() );

            Integer numberOfRows = uow.getNumberOfPendingDmlRows();
        Test.stopTest();
        System.assertEquals( 6, numberOfRows, 'getNumberOfPendingDmlRows, when multiple rows of different types have been added as empty recycle bin, will return the count of them, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlRows_whenMultipleRowsOfDuplicateIdsHaveBeenAddedAsEmptyRecycleBin_willReturnTheUniqueCount() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Id duplicateContactId = TestIdUtils.generateId( Contact.sobjectType );

        Test.startTest();
            uow.registerEmptyRecycleBin( new Contact( Id = duplicateContactId ) );
            uow.registerEmptyRecycleBin( new Contact( Id = duplicateContactId ) );
            uow.registerEmptyRecycleBin( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerEmptyRecycleBin( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerEmptyRecycleBin( new Account( Id = TestIdUtils.generateId( Account.sobjectType ) ) );
            uow.registerEmptyRecycleBin( new Contact() );
            uow.registerEmptyRecycleBin( new Account() );

            Integer numberOfRows = uow.getNumberOfPendingDmlRows();
        Test.stopTest();
        System.assertEquals( 7, numberOfRows, 'getNumberOfPendingDmlRows, when multiple rows with duplicate ids have been added as empty recycle bin, will return the unique count of them, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlRows_whenMultipleRowsWithDifferentOperations_willReturnTheCount() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Test.startTest();
            uow.registerNew( new Contact() );
            uow.registerNew( new Contact() );
            uow.registerNew( new Account() );
            uow.registerUpsert( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerUpsert( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDirty( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );

            Integer numberOfRows = uow.getNumberOfPendingDmlRows();
        Test.stopTest();
        System.assertEquals( 7, numberOfRows, 'getNumberOfPendingDmlRows, when multiple rows with different transactions, will return the unique count of them, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlRows_whenMultipleRowsWithDifferentOperationsSomeDuplicateIds_willReturnTheUniqueCountasBestItCan() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Id duplicateContactId = TestIdUtils.generateId( Contact.sobjectType );

        Test.startTest();
            uow.registerNew( new Contact() );
            uow.registerNew( new Contact() );
            uow.registerNew( new Account() );
            uow.registerUpsert( new Contact( Id = duplicateContactId ) );
            uow.registerUpsert( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDirty( new Contact( Id = duplicateContactId ) );
            uow.registerDeleted( new Contact( Id = duplicateContactId ) ); // this is not a duplicate, as the updates will occur and then the record will be deleted

            Integer numberOfRows = uow.getNumberOfPendingDmlRows();
        Test.stopTest();
        System.assertEquals( 7, numberOfRows, 'getNumberOfPendingDmlRows, when multiple rows with different transactions and duplicate ids, will return the unique count of them as best it can, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlStatements_whenNothingHasBeenSentToTheUow_willReturnOne() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>() );
        Integer numberOfRows = uow.getNumberOfPendingDmlStatements();
        System.assertEquals( 1, numberOfRows, 'getNumberOfPendingDmlStatements, when nothing has been sent to the Unit of Work, will return one - for the savepoint, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlStatements_whenMultipleRowsOfDifferentTypesHaveBeenAddedAsNew_willReturnTheCount() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Test.startTest();
            uow.registerNew( new Contact() );
            uow.registerNew( new Contact() );
            uow.registerNew( new Account() );

            Integer numberOfRows = uow.getNumberOfPendingDmlStatements();
        Test.stopTest();
        System.assertEquals( 3, numberOfRows, 'getNumberOfPendingDmlStatements, when multiple rows of different types have been added as new, will return the count of them, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlStatements_whenMultipleRowsOfDifferentTypesHaveBeenAddedAsDirty_willReturnTheCount() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Test.startTest();
            uow.registerDirty( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDirty( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDirty( new Account( Id = TestIdUtils.generateId( Account.sobjectType ) ) );

            Integer numberOfRows = uow.getNumberOfPendingDmlStatements();
        Test.stopTest();
        System.assertEquals( 3, numberOfRows, 'getNumberOfPendingDmlStatements, when multiple rows of different types have been added as dirty, will return the count of them, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlStatements_whenMultipleRowsOfDifferentTypesHaveBeenAddedAsUpsert_willReturnTheCount() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Test.startTest();
            uow.registerUpsert( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerUpsert( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerUpsert( new Account( Id = TestIdUtils.generateId( Account.sobjectType ) ) );
            uow.registerUpsert( new Contact() );
            uow.registerUpsert( new Account() );

            Integer numberOfRows = uow.getNumberOfPendingDmlStatements();
        Test.stopTest();
        System.assertEquals( 5, numberOfRows, 'getNumberOfPendingDmlStatements, when multiple rows of different types have been added as upsert, will return the count of them, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlStatements_whenMultipleRowsOfDifferentTypesHaveBeenAddedAsDeleted_willReturnTheCount() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Test.startTest();
            uow.registerDeleted( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDeleted( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDeleted( new Account( Id = TestIdUtils.generateId( Account.sobjectType ) ) );

            Integer numberOfRows = uow.getNumberOfPendingDmlStatements();
        Test.stopTest();
        System.assertEquals( 3, numberOfRows, 'getNumberOfPendingDmlStatements, when multiple rows of different types have been added as deleted, will return the count of them, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlStatements_whenMultipleRowsOfDifferentTypesHaveBeenAddedAsEmptyRecycleBin_willReturnTheCount() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Test.startTest();
            uow.registerEmptyRecycleBin( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerEmptyRecycleBin( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerEmptyRecycleBin( new Account( Id = TestIdUtils.generateId( Account.sobjectType ) ) );
            uow.registerEmptyRecycleBin( new Contact() );
            uow.registerEmptyRecycleBin( new Account() );

            Integer numberOfRows = uow.getNumberOfPendingDmlStatements();
        Test.stopTest();
        System.assertEquals( 3, numberOfRows, 'getNumberOfPendingDmlStatements, when multiple rows of different types have been added as empty recycle bin, will return the count of them, plus the savepoint' );
    }

    @isTest
    private static void getNumberOfPendingDmlStatements_whenMultipleRowsWithDifferentOperations_willReturnTheCount() // NOPMD: Test method name format
    {
        ortoo_SobjectUnitOfWork uow = new ortoo_SobjectUnitOfWork( new List<SobjectType>{ Account.sobjectType, Contact.sobjectType } );

        Test.startTest();
            uow.registerNew( new Contact() );
            uow.registerNew( new Contact() );
            uow.registerNew( new Account() );
            uow.registerUpsert( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerUpsert( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDirty( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );
            uow.registerDeleted( new Account( Id = TestIdUtils.generateId( Account.sobjectType ) ) );
            uow.registerDeleted( new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ) );

            Integer numberOfRows = uow.getNumberOfPendingDmlStatements();
        Test.stopTest();
        System.assertEquals( 6, numberOfRows, 'getNumberOfPendingDmlStatements, when multiple rows with different transactions, will return the unique count of them, plus the savepoint' );
    }
}