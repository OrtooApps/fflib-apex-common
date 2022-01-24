@isTest
private without sharing class ortoo_SobjectSelectorTest
{
    @isTest
    private static void constructor_whenCalled_willCreateASelectorThatHasSecurityEnabled() // NOPMD: Test method name format
    {
        ortoo_SobjectSelector selector = new TestableSelector();

        System.assertEquals( true, selector.isEnforcingFls(), 'constructor, when called, will create a selector that has FLS enabled' );
        System.assertEquals( true, selector.isEnforcingCrud(), 'constructor, when called, will create a selector that has CRUD security enabled' );
    }

    @isTest
    private static void ignoreFls_whenCalled_willDisableFlsChecking() // NOPMD: Test method name format
    {
        ortoo_SobjectSelector selector = new TestableSelector();
        selector.ignoreFls();

        System.assertEquals( false, selector.isEnforcingFls(), 'ignoreFls, when called, will disable FLS checking' );
    }

    @isTest
    private static void selectBySearchCriteria_whenGivenCriteria_returnsRecordsThatMatchWithACount() // NOPMD: Test method name format
    {
        List<Account> accountList = new List<Account>
        {
            new Account( Name = 'Acc1', AnnualRevenue = 123 ),
            new Account( Name = 'Acc2', AnnualRevenue = 234 ),
            new Account( Name = 'Acc3', AnnualRevenue = 345 ),
            new Account( Name = 'Acc4', AnnualRevenue = 456 ),
            new Account( Name = 'Acc5', AnnualRevenue = 567 )
        };
        insert accountList;

        Amoss_Instance configController = ApplicationMockRegistrar.registerMockAppLogic( ISearchConfiguration.class );
        Amoss_Instance criteriaController = new Amoss_Instance( ISearchCriteria.class );

        ISearchConfiguration config = (ISearchConfiguration)configController.generateDouble();
        configController
            .expects( 'getRequiredFields' )
            .returns( new List<String>{ 'AnnualRevenue' } )
        .also()
            .when( 'getMappedSobjectField' )
            .returns( 'Name' );

        ISearchCriteria criteria = (ISearchCriteria)criteriaController.generateDouble();
        criteriaController
            .when( 'toSOQL' )
            .returns( 'AnnualRevenue > 200' );

        SearchWindow window = new SearchWindow().configure( new Map<String,Object>{ 'offset' => 1, 'length' => 2 } );
        SearchOrderBy orderBy = new SearchOrderBy().configure( new Map<String,Object>{ 'fieldName' => 'Name', 'direction' => 'desc' }, ISearchConfiguration.class );

        Test.startTest();
            SearchResults got = new TestableSelector().selectBySearchCriteria( config, criteria, window, orderBy );
        Test.stopTest();

        configController.verify();

        System.assertEquals( 4, got.totalNumberOfRecords, 'selectBySearchCriteria, when given config, criteria, window and orderby, will return the total number of records that match' );

        List<Account> returnedAccounts = (List<Account>)got.records;
        System.assertEquals( 2, returnedAccounts.size(), 'selectBySearchCriteria, when given config, criteria, window and orderby, will return records that match, limited by the window size' );

        System.assertEquals( 'Acc4', returnedAccounts[0].Name, 'selectBySearchCriteria, when given config, criteria, window and orderby, will return records that match, ordered by the orderBy, with the base selector fields included (1)' );
        System.assertEquals( 'Acc3', returnedAccounts[1].Name, 'selectBySearchCriteria, when given config, criteria, window and orderby, will return records that match, ordered by the orderBy, with the base selector fields included (2)' );

        System.assertEquals( 456, returnedAccounts[0].AnnualRevenue, 'selectBySearchCriteria, when given config, criteria, window and orderby, will return records that match, ordered by the orderBy, with the passed config fields included (2)' );
        System.assertEquals( 345, returnedAccounts[1].AnnualRevenue, 'selectBySearchCriteria, when given config, criteria, window and orderby, will return records that match, ordered by the orderBy, with the passed config fields included (2)' );
    }

    @isTest
    private static void selectBySearchCriteria_whenNoWindowIsSet_willReturnAllTheResults() // NOPMD: Test method name format
    {
        List<Account> accountList = new List<Account>
        {
            new Account( Name = 'Acc1', AnnualRevenue = 123 ),
            new Account( Name = 'Acc2', AnnualRevenue = 234 ),
            new Account( Name = 'Acc3', AnnualRevenue = 345 ),
            new Account( Name = 'Acc4', AnnualRevenue = 456 ),
            new Account( Name = 'Acc5', AnnualRevenue = 567 )
        };
        insert accountList;

        Amoss_Instance configController = ApplicationMockRegistrar.registerMockAppLogic( ISearchConfiguration.class );
        Amoss_Instance criteriaController = new Amoss_Instance( ISearchCriteria.class );

        ISearchConfiguration config = (ISearchConfiguration)configController.generateDouble();
        configController
            .when( 'getRequiredFields' )
            .returns( new List<String>() )
        .also()
            .when( 'getMappedSobjectField' )
            .returns( 'Name' );

        ISearchCriteria criteria = (ISearchCriteria)criteriaController.generateDouble();
        criteriaController
            .when( 'toSOQL' )
            .returns( 'AnnualRevenue > 200' );

        SearchWindow emptyWindow = new SearchWindow();
        SearchOrderBy orderBy = new SearchOrderBy().configure( new Map<String,Object>{ 'fieldName' => 'Name', 'direction' => 'desc' }, ISearchConfiguration.class );

        Test.startTest();
            SearchResults got = new TestableSelector().selectBySearchCriteria( config, criteria, emptyWindow, orderBy );
        Test.stopTest();

        configController.verify();

        System.assertEquals( 4, got.totalNumberOfRecords, 'selectBySearchCriteria, when given config, criteria, window and orderby, will return the total number of records that match' );

        List<Account> returnedAccounts = (List<Account>)got.records;
        System.assertEquals( 4, returnedAccounts.size(), 'selectBySearchCriteria, when given an empty window, will return all the records that match' );
    }

    @isTest
    private static void selectBySearchCriteria_whenGivenEmptyOrderBy_stillReturnsResults() // NOPMD: Test method name format
    {
        List<Account> accountList = new List<Account>
        {
            new Account( Name = 'Acc1', AnnualRevenue = 123 ),
            new Account( Name = 'Acc2', AnnualRevenue = 234 ),
            new Account( Name = 'Acc3', AnnualRevenue = 345 ),
            new Account( Name = 'Acc4', AnnualRevenue = 456 ),
            new Account( Name = 'Acc5', AnnualRevenue = 567 )
        };
        insert accountList;

        Amoss_Instance configController = ApplicationMockRegistrar.registerMockAppLogic( ISearchConfiguration.class );
        Amoss_Instance criteriaController = new Amoss_Instance( ISearchCriteria.class );

        ISearchConfiguration config = (ISearchConfiguration)configController.generateDouble();
        configController
            .when( 'getRequiredFields' )
            .returns( new List<String>() );

        ISearchCriteria criteria = (ISearchCriteria)criteriaController.generateDouble();
        criteriaController
            .when( 'toSOQL' )
            .returns( 'AnnualRevenue > 200' );

        SearchWindow window = new SearchWindow().configure( new Map<String,Object>{ 'offset' => 1, 'length' => 2 } );
        SearchOrderBy emptyOrderBy = new SearchOrderBy();

        Test.startTest();
            SearchResults got = new TestableSelector().selectBySearchCriteria( config, criteria, window, emptyOrderBy );
        Test.stopTest();

        System.assertEquals( 4, got.totalNumberOfRecords, 'selectBySearchCriteria, when given an empty order by, will return the total number of records that match' );

        List<Account> returnedAccounts = (List<Account>)got.records;
        System.assertEquals( 2, returnedAccounts.size(), 'selectBySearchCriteria, when given an empty order by, will return records that match, limited by the window size' );
    }

    @isTest
    private static void selectBySearchCriteria_whenGivenEmptyCriteria_throwsAnException() // NOPMD: Test method name format
    {
        Amoss_Instance configController = ApplicationMockRegistrar.registerMockAppLogic( ISearchConfiguration.class );
        Amoss_Instance criteriaController = new Amoss_Instance( ISearchCriteria.class );

        ISearchConfiguration config = (ISearchConfiguration)configController.generateDouble();

        SearchWindow window = new SearchWindow();
        SearchOrderBy orderBy = new SearchOrderBy();

        ISearchCriteria criteria = (ISearchCriteria)criteriaController.generateDouble();
        criteriaController
            .when( 'toSOQL' )
            .returns( '' );

        Test.startTest();
            String exceptionMessage;
            try
            {
                new TestableSelector().selectBySearchCriteria( config, criteria, window, orderBy );
            }
            catch ( ortoo_SobjectSelector.UnboundCountQueryException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'Attempted to perform the count of an unbound query against ' + Account.sobjectType.getDescribe().getName(), exceptionMessage, 'selectBySearchCriteria, when given empty criteria, will throw an exception' );
    }

    @isTest
    private static void selectBySearchCriteria_whenPassedANullConfig_throwsAnException() // NOPMD: Test method name format
    {
        ISearchCriteria criteria = (ISearchCriteria)new Amoss_Instance( ISearchCriteria.class ).generateDouble();
        SearchWindow window = new SearchWindow();
        SearchOrderBy orderBy = new SearchOrderBy();

        Test.startTest();
            String exceptionMessage;
            try
            {
                new TestableSelector().selectBySearchCriteria( null, criteria, window, orderBy );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'selectBySearchCriteria called with a null searchConfiguration', exceptionMessage, 'selectBySearchCriteria, when passed a null searchConfiguration, will throw an exception' );
    }

    @isTest
    private static void selectBySearchCriteria_whenPassedANullCriteria_throwsAnException() // NOPMD: Test method name format
    {
        ISearchConfiguration config = (ISearchConfiguration)new Amoss_Instance( ISearchConfiguration.class ).generateDouble();
        SearchWindow window = new SearchWindow();
        SearchOrderBy orderBy = new SearchOrderBy();

        Test.startTest();
            String exceptionMessage;
            try
            {
                new TestableSelector().selectBySearchCriteria( config, null, window, orderBy );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'selectBySearchCriteria called with a null criteria', exceptionMessage, 'selectBySearchCriteria, when passed a null criteria, will throw an exception' );
    }

    @isTest
    private static void selectBySearchCriteria_whenPassedANullWindow_throwsAnException() // NOPMD: Test method name format
    {
        ISearchConfiguration config = (ISearchConfiguration)new Amoss_Instance( ISearchConfiguration.class ).generateDouble();
        ISearchCriteria criteria = (ISearchCriteria)new Amoss_Instance( ISearchCriteria.class ).generateDouble();
        SearchOrderBy orderBy = new SearchOrderBy();

        Test.startTest();
            String exceptionMessage;
            try
            {
                new TestableSelector().selectBySearchCriteria( config, criteria, null, orderBy );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'selectBySearchCriteria called with a null window', exceptionMessage, 'selectBySearchCriteria, when passed a null window, will throw an exception' );
    }

    @isTest
    private static void selectBySearchCriteria_whenPassedANullOrderBy_throwsAnException() // NOPMD: Test method name format
    {
        ISearchConfiguration config = (ISearchConfiguration)new Amoss_Instance( ISearchConfiguration.class ).generateDouble();
        ISearchCriteria criteria = (ISearchCriteria)new Amoss_Instance( ISearchCriteria.class ).generateDouble();
        SearchWindow window = new SearchWindow();

        Test.startTest();
            String exceptionMessage;
            try
            {
                new TestableSelector().selectBySearchCriteria( config, criteria, window, null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'selectBySearchCriteria called with a null orderBy', exceptionMessage, 'selectBySearchCriteria, when passed a null orderBy, will throw an exception' );
    }

    class TestableSelector extends ortoo_SobjectSelector
    {
        public List<Schema.SObjectField> getSObjectFieldList() {
            return new List<Schema.SObjectField> {
                Account.Name
            };
        }

        public Schema.SObjectType getSObjectType() {
            return Account.sObjectType;
        }
    }
}