@isTest
public inherited sharing class SearchServiceImplTest
{
	@isTest
	private static void search_whenCalled_runsASearchAndAddsDataToItReturningTheSearchResults() // NOPMD: Test method name format
	{
		SobjectType searchSobjectType = Contact.sobjectType;
		Type searchConfigurationType = ISearchConfiguration.class;

		// Define all the mocks and register them where appropriate
		ISearchCriteria criteria = (ISearchCriteria)new Amoss_Instance( ISearchCriteria.class ).generateDouble();
		SearchWindow window = (SearchWindow)new Amoss_Instance( SearchWindow.class ).generateDouble();
		SearchOrderBy orderBy = (SearchOrderBy)new Amoss_Instance( SearchOrderBy.class ).generateDouble();

		ISearchResult finalResult = (ISearchResult)new Amoss_Instance( ISearchResult.class ).generateDouble();

		Amoss_Instance searchConfigController = ApplicationMockRegistrar.registerMockAppLogic( searchConfigurationType );
		Amoss_Instance selectorController = ApplicationMockRegistrar.registerMockSelector( searchSobjectType, SearchServiceMockSearchSelector.class ); // the config will say this is the SobjectType we're searching for
		Amoss_Instance domainController = ApplicationMockRegistrar.registerMockDomain( searchSobjectType, SearchServiceMockDomain.class );

		// it looks like it shouldn't, but selectBySearchCriteria does appear to return a list based on the actual SObject type, if there are records
		// Therefore we return a SearchResults built with List<Contact>, and not List<Sobject>, as you might expect.
		SearchResults interimSearchResults = new SearchResults( 1, new List<Contact>{ new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ), FirstName = 'Interim') } );
		List<ISearchResult> adjustedObjects = new List<ISearchResult>{ finalResult };

		// configure the expected behaviours
		searchConfigController
			.expects( 'getBaseSobjectType' )
			.returns( searchSobjectType );

		selectorController
			.expects( 'selectBySearchCriteria' )
			.withParameter( searchConfigController.getDouble() )
			.thenParameter( criteria )
			.thenParameter( window )
			.thenParameter( orderBy )
			.returning( interimSearchResults );

		domainController
			.expects( 'buildSearchResults' )
			.withParameter( searchConfigController.getDouble() )
			.returning( adjustedObjects );

		Test.startTest();

			SearchResults results = new SearchServiceImpl().search( searchConfigurationType, criteria, window, orderBy );

		Test.stopTest();

		searchConfigController.verify();
		selectorController.verify();
		domainController.verify();

		System.assertEquals( interimSearchResults.totalNumberOfRecords, results.totalNumberOfRecords, 'search, when called with a config, criteria, window and order by, will request a search from the configured selector and keep the total records from there' );
		System.assertEquals( adjustedObjects, results.records, 'search, when called with a config, criteria, window and order by, will construct a domain object based on the cofig, with the results from the selector and then ask it to buildSearchResults from them' );
	}

	@isTest
	private static void search_whenNoRecordsAreReturnedByTheSearch_doesNotTryToCreateTheDomain() // NOPMD: Test method name format
	{
		SobjectType searchSobjectType = Contact.sobjectType;
		Type searchConfigurationType = ISearchConfiguration.class;

		// Define all the mocks and register them where appropriate
		ISearchCriteria criteria = (ISearchCriteria)new Amoss_Instance( ISearchCriteria.class ).generateDouble();
		SearchWindow window = (SearchWindow)new Amoss_Instance( SearchWindow.class ).generateDouble();
		SearchOrderBy orderBy = (SearchOrderBy)new Amoss_Instance( SearchOrderBy.class ).generateDouble();

		ISearchResult finalResult = (ISearchResult)new Amoss_Instance( ISearchResult.class ).generateDouble();

		Amoss_Instance searchConfigController = ApplicationMockRegistrar.registerMockAppLogic( searchConfigurationType );
		Amoss_Instance selectorController = ApplicationMockRegistrar.registerMockSelector( searchSobjectType, SearchServiceMockSearchSelector.class ); // the config will say this is the SobjectType we're searching for

		SearchResults interimSearchResults = new SearchResults( 0, new List<Sobject>() );

		// configure the expected behaviours
		searchConfigController
			.expects( 'getBaseSobjectType' )
			.returns( searchSobjectType );

		selectorController
			.when( 'selectBySearchCriteria' )
			.returns( interimSearchResults );

		Test.startTest();

			SearchResults results = new SearchServiceImpl().search( searchConfigurationType, criteria, window, orderBy );

		Test.stopTest();

		searchConfigController.verify();
		selectorController.verify();

		System.assertEquals( 0, results.totalNumberOfRecords, 'search, when the search matches no records, will give a total number of records of zero' );
		System.assertEquals( 0, results.records.size(), 'search, when the search matches no records, will return an empty search results' );
	}

	@isTest
	private static void search_whenPassedANullSearchConfigurationType_throwsAnException() // NOPMD: Test method name format
	{
		ISearchCriteria criteria = (ISearchCriteria)new Amoss_Instance( ISearchCriteria.class ).generateDouble();
		SearchWindow window = (SearchWindow)new Amoss_Instance( SearchWindow.class ).generateDouble();
		SearchOrderBy orderBy = (SearchOrderBy)new Amoss_Instance( SearchOrderBy.class ).generateDouble();

		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchServiceImpl().search( null, criteria, window, orderBy );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'search called with a null searchConfigurationType', exceptionMessage, 'search, when passed a null searchConfigurationType, will throw an exception' );
	}

	@isTest
	private static void search_whenPassedANullCriteria_throwsAnException() // NOPMD: Test method name format
	{
		Type searchConfigurationType = ISearchConfiguration.class;
		SearchWindow window = (SearchWindow)new Amoss_Instance( SearchWindow.class ).generateDouble();
		SearchOrderBy orderBy = (SearchOrderBy)new Amoss_Instance( SearchOrderBy.class ).generateDouble();

		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchServiceImpl().search( searchConfigurationType, null, window, orderBy );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'search called with a null criteria', exceptionMessage, 'search, when passed a null criteria, will throw an exception' );
	}

	@isTest
	private static void search_whenPassedANullWindow_throwsAnException() // NOPMD: Test method name format
	{
		Type searchConfigurationType = ISearchConfiguration.class;
		ISearchCriteria criteria = (ISearchCriteria)new Amoss_Instance( ISearchCriteria.class ).generateDouble();
		SearchOrderBy orderBy = (SearchOrderBy)new Amoss_Instance( SearchOrderBy.class ).generateDouble();

		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchServiceImpl().search( searchConfigurationType, criteria, null, orderBy );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'search called with a null window', exceptionMessage, 'search, when passed a null window, will throw an exception' );
	}

	@isTest
	private static void search_whenPassedANullOrderBy_throwsAnException() // NOPMD: Test method name format
	{
		Type searchConfigurationType = ISearchConfiguration.class;
		ISearchCriteria criteria = (ISearchCriteria)new Amoss_Instance( ISearchCriteria.class ).generateDouble();
		SearchWindow window = (SearchWindow)new Amoss_Instance( SearchWindow.class ).generateDouble();

		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchServiceImpl().search( searchConfigurationType, criteria, window, null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'search called with a null orderBy', exceptionMessage, 'search, when passed a null orderBy, will throw an exception' );
	}

	@isTest
	private static void getSortableFields_whenGivenAConfigType_getsTheSortableFieldsFromThatType() // NOPMD: Test method name format
	{
		Type searchConfigurationType = ISearchConfiguration.class;
		List<String> expectedSortableFields = new List<String>{ 'expected', 'fields' };

		Amoss_Instance searchConfigController = ApplicationMockRegistrar.registerMockAppLogic( searchConfigurationType );

		searchConfigController
			.expects( 'getSortableFields' )
			.returning( expectedSortableFields );

		Test.startTest();

			List<String> got = new SearchServiceImpl().getSortableFields( searchConfigurationType );

		Test.stopTest();

		System.assertEquals( expectedSortableFields, got, 'getSortableFields, when given a valid config type, will call getSortableFields against that type' );
	}

	@isTest
	private static void getSortableFields_whenPassedANullSearchConfigurationType_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchServiceImpl().getSortableFields( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'getSortableFields called with a null searchConfigurationType', exceptionMessage, 'getSortableFields, when passed a null searchConfigurationType, will throw an exception' );
	}
}