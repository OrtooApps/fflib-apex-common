@isTest
private class ortoo_FabricatedSObjectRegisterTest {

    @isTest
    private static void registerObject_whenCalled_willQueueTheObjectForCommit() // NOPMD: Test method name format
    {
        Amoss_Instance uowController = ApplicationMockRegistrar.registerMockUnitOfWork();

        Amoss_Instance fabricatedContactController = new Amoss_Instance( sfab_FabricatedSobject.class );
        sfab_FabricatedSobject fabricatedContact = (sfab_FabricatedSobject)fabricatedContactController.generateDouble();

        Contact contactToPersist = new Contact( FirstName = 'firstName' );

        fabricatedContactController
            .expects( 'getSobjectType' )
            .returning( Contact.sobjectType )
        .then()
            .expects( 'toPersistableSobject' )
            .returning( contactToPersist );

        uowController
            .expects( 'registerNew' )
            .withParameter( contactToPersist )
        .then()
            .expects( 'commitWork' );

        Test.startTest();
            ortoo_FabricatedSObjectRegister.registerObject( fabricatedContact );
            ortoo_FabricatedSObjectRegister.persist();
        Test.stopTest();

        fabricatedContactController.verify();
        uowController.verify();
    }

    @isTest
    private static void registerObject_whenCalledMultipleTimes_willQueueEachObjectForCommit() // NOPMD: Test method name format
    {
        Amoss_Instance uowController = ApplicationMockRegistrar.registerMockUnitOfWork();

        Amoss_Instance fabricatedContactController = new Amoss_Instance( sfab_FabricatedSobject.class );
        List<sfab_FabricatedSobject> fabricatedContacts = new List<sfab_FabricatedSobject>
        {
            (sfab_FabricatedSobject)fabricatedContactController.generateDouble(),
            (sfab_FabricatedSobject)fabricatedContactController.generateDouble(),
            (sfab_FabricatedSobject)fabricatedContactController.generateDouble()
        };

        List<Contact> contactsToPersist = new List<Contact>
        {
            new Contact( FirstName = 'firstName' ),
            new Contact( FirstName = 'firstName2' ),
            new Contact( FirstName = 'firstName3' )
        };

        fabricatedContactController
            .when( 'getSobjectType' )
            .returns( Contact.sobjectType )
        .also()
            .expects( 'toPersistableSobject' )
            .returning( contactsToPersist[0] )
        .then()
            .expects( 'toPersistableSobject' )
            .returning( contactsToPersist[1] )
        .then()
            .expects( 'toPersistableSobject' )
            .returning( contactsToPersist[2] );

        uowController
            .expects( 'registerNew' )
            .withParameter( contactsToPersist[0] )
        .then()
            .expects( 'registerNew' )
            .withParameter( contactsToPersist[1] )
        .then()
            .expects( 'registerNew' )
            .withParameter( contactsToPersist[2] )
        .then()
            .expects( 'commitWork' );

        Test.startTest();
            ortoo_FabricatedSObjectRegister.registerObject( fabricatedContacts[0] );
            ortoo_FabricatedSObjectRegister.registerObject( fabricatedContacts[1] );
            ortoo_FabricatedSObjectRegister.registerObject( fabricatedContacts[2] );
            ortoo_FabricatedSObjectRegister.persist();
        Test.stopTest();

        fabricatedContactController.verify();
        uowController.verify();
    }

    @isTest
    private static void registerChildOfRelationship_whenCalled_willSetupARelationship() // NOPMD: Test method name format
    {
        Amoss_Instance uowController = ApplicationMockRegistrar.registerMockUnitOfWork();

        Amoss_Instance fabricatedContactController = new Amoss_Instance( sfab_FabricatedSobject.class );
        sfab_FabricatedSobject fabricatedContact = (sfab_FabricatedSobject)fabricatedContactController.generateDouble();

        Amoss_Instance fabricatedAccountController = new Amoss_Instance( sfab_FabricatedSobject.class );
        sfab_FabricatedSobject fabricatedAccount = (sfab_FabricatedSobject)fabricatedAccountController.generateDouble();

        Contact contactToPersist = new Contact( FirstName = 'firstName' );
        Account accountToPersist = new Account( Name = 'accountName' );

        configureToReturn( fabricatedContactController, contactToPersist );
        configureToReturn( fabricatedAccountController, accountToPersist );

        uowController
            .expects( 'registerNew' )
            .withParameter( contactToPersist )
        .then()
            .expects( 'registerNew' )
            .withParameter( accountToPersist )
        .then()
            .expects( 'registerRelationship' )
            .withParameter( contactToPersist )
            .thenParameter( Contact.AccountId )
            .thenParameter( accountToPersist )
        .then()
            .expects( 'commitWork' );

        Test.startTest();
            ortoo_FabricatedSObjectRegister.registerObject( fabricatedContact );
            ortoo_FabricatedSObjectRegister.registerObject( fabricatedAccount );
            ortoo_FabricatedSObjectRegister.registerChildOfRelationship( fabricatedContact, 'Account', fabricatedAccount );
            ortoo_FabricatedSObjectRegister.persist();
        Test.stopTest();

        uowController.verify();
    }

    @isTest
    private static void registerParentOfRelationship_whenCalled_willSetupARelationship() // NOPMD: Test method name format
    {
        Amoss_Instance uowController = ApplicationMockRegistrar.registerMockUnitOfWork();

        Amoss_Instance fabricatedContactController = new Amoss_Instance( sfab_FabricatedSobject.class );
        sfab_FabricatedSobject fabricatedContact = (sfab_FabricatedSobject)fabricatedContactController.generateDouble();

        Amoss_Instance fabricatedAccountController = new Amoss_Instance( sfab_FabricatedSobject.class );
        sfab_FabricatedSobject fabricatedAccount = (sfab_FabricatedSobject)fabricatedAccountController.generateDouble();

        Contact contactToPersist = new Contact( FirstName = 'firstName' );
        Account accountToPersist = new Account( Name = 'accountName' );

        configureToReturn( fabricatedContactController, contactToPersist );
        configureToReturn( fabricatedAccountController, accountToPersist );

        uowController
            .expects( 'registerNew' )
            .withParameter( contactToPersist )
        .then()
            .expects( 'registerNew' )
            .withParameter( accountToPersist )
        .then()
            .expects( 'registerRelationship' )
            .withParameter( contactToPersist )
            .thenParameter( Contact.AccountId )
            .thenParameter( accountToPersist )
        .then()
            .expects( 'commitWork' );

        Test.startTest();
            ortoo_FabricatedSObjectRegister.registerObject( fabricatedContact );
            ortoo_FabricatedSObjectRegister.registerObject( fabricatedAccount );
            ortoo_FabricatedSObjectRegister.registerParentOfRelationship( fabricatedAccount, 'Contacts', fabricatedContact );
            ortoo_FabricatedSObjectRegister.persist();
        Test.stopTest();

        uowController.verify();
    }

    @isTest
    private static void getOrderOfInserts_whenCalled_willWorkOutTheOrderForTheUow() // NOPMD: Test method name format
    {
        Amoss_Instance fabricatedOpportunityController = new Amoss_Instance( sfab_FabricatedSobject.class );
        sfab_FabricatedSobject fabricatedOpportunity = (sfab_FabricatedSobject)fabricatedOpportunityController.generateDouble();

        Amoss_Instance fabricatedContactController = new Amoss_Instance( sfab_FabricatedSobject.class );
        sfab_FabricatedSobject fabricatedContact = (sfab_FabricatedSobject)fabricatedContactController.generateDouble();

        Amoss_Instance fabricatedAccountController = new Amoss_Instance( sfab_FabricatedSobject.class );
        sfab_FabricatedSobject fabricatedAccount = (sfab_FabricatedSobject)fabricatedAccountController.generateDouble();

        Opportunity opportunityToPersist = new Opportunity( Name = 'opportunityName' );
        Contact contactToPersist = new Contact( FirstName = 'firstName' );
        Account accountToPersist = new Account( Name = 'accountName' );

        configureToReturn( fabricatedOpportunityController, opportunityToPersist );
        configureToReturn( fabricatedContactController, contactToPersist );
        configureToReturn( fabricatedAccountController, accountToPersist );

        Test.startTest();
            ortoo_FabricatedSObjectRegister.registerObject( fabricatedContact );
            ortoo_FabricatedSObjectRegister.registerObject( fabricatedAccount );
            ortoo_FabricatedSObjectRegister.registerObject( fabricatedOpportunity );
            ortoo_FabricatedSObjectRegister.registerParentOfRelationship( fabricatedAccount, 'Contacts', fabricatedContact );
            ortoo_FabricatedSObjectRegister.registerParentOfRelationship( fabricatedAccount, 'Opportunities', fabricatedOpportunity );

            List<SobjectType> actualOrderOfInserts = ortoo_FabricatedSObjectRegister.instance.getOrderOfInserts();
        Test.stopTest();

        List<SobjectType> expectedOrderOfInserts = new List<SobjectType>{ Account.sobjectType, Opportunity.sobjectType, Contact.sobjectType };

        System.assertEquals( expectedOrderOfInserts, actualOrderOfInserts, 'getOrderOfInserts, when called, will work out the order for the Unit of Work' );
    }

    private static Amoss_Instance configureToReturn( Amoss_Instance controller, Contact contactToReturn )
    {
        controller
            .when( 'getSobjectName' )
            .returns( 'Contact' )
        .also()
            .when( 'getSobjectType' )
            .returns( Contact.sobjectType )
        .also()
            .when( 'toPersistableSobject' )
            .returns( contactToReturn );
        return controller;
    }

    private static Amoss_Instance configureToReturn( Amoss_Instance controller, Account accountToReturn )
    {
        controller
            .when( 'getSobjectName' )
            .returns( 'Account' )
        .also()
            .when( 'getSobjectType' )
            .returns( Account.sobjectType )
        .also()
            .when( 'toPersistableSobject' )
            .returns( accountToReturn );
        return controller;
    }

    private static Amoss_Instance configureToReturn( Amoss_Instance controller, Opportunity opportunityToReturn )
    {
        controller
            .when( 'getSobjectName' )
            .returns( 'Opportunity' )
        .also()
            .when( 'getSobjectType' )
            .returns( Opportunity.sobjectType )
        .also()
            .when( 'toPersistableSobject' )
            .returns( opportunityToReturn );
        return controller;
    }
}