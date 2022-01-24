@isTest
public inherited sharing class SearchControllerTest
{
	private static final Map<String,Object> UNIMPORTANT_CRITERIA = new Map<String,Object>();
	private static final Map<String,Object> UNIMPORTANT_WINDOW = new Map<String,Object>();
	private static final Map<String,Object> UNIMPORTANT_ORDERBY = new Map<String,Object>();

	@isTest
	private static void setSearchConfigurationType_whenPassedANullSearchConfigurationType_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchController().setSearchConfigurationType( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'setSearchConfigurationType called with a null searchConfigurationType', exceptionMessage, 'setSearchConfigurationType, when passed a null searchConfigurationType, will throw an exception' );
	}

	@isTest
	private static void search_whenCalled_buildObjectsAndAskTheSearchServiceToPerformASearch() // NOPMD: Test method name format
	{
		Type searchConfigurationType = ISearchConfiguration.class;

		Amoss_Instance searchServiceController = ApplicationMockRegistrar.registerMockService( ISearchService.class );
		Amoss_Instance searchOrderByController = ApplicationMockRegistrar.registerMockAppLogic( SearchOrderBy.class );
		Amoss_Instance searchWindowController = ApplicationMockRegistrar.registerMockAppLogic( SearchWindow.class );

		Amoss_Instance searchCriteriaFactoryController = new Amoss_Instance( ISearchCriteriaFactory.class );
		ISearchCriteriaFactory searchCriteriaFactory = (ISearchCriteriaFactory)searchCriteriaFactoryController.generateDouble();

		ISearchCriteria generatedSearchCriteria = (ISearchCriteria)new Amoss_Instance( ISearchCriteria.class ).generateDouble();

		Map<String,Object> criteria = new Map<String,Object>{
			'someField' => 'someValue'
		};

		Map<String,Object> window = new Map<String,Object>{
			'offset' => 10,
			'length' => 20
		};

		Map<String,Object> orderBy = new Map<String,Object>{
			'fieldName' => 'someField',
			'direction' => 'asc'
		};

		searchCriteriaFactoryController
			.expects( 'setProperties' )
			.withParameter( criteria )
			.returning( searchCriteriaFactory )
		.then()
			.expects( 'build' )
			.returning( generatedSearchCriteria );

		searchWindowController
			.expects( 'configure' )
			.withParameter( window )
			.returning( searchWindowController.getDouble() );

		searchOrderByController
			.expects( 'configure' )
			.withParameter( orderBy )
			.thenParameter( searchConfigurationType )
			.returning( searchOrderByController.getDouble() );

		SearchResults expectedResults = new SearchResults( 10, new List<Object>{ 'a result' } );

		searchServiceController
			.expects( 'search' )
			.withParameter( searchConfigurationType )
			.thenParameter( generatedSearchCriteria )
			.thenParameter( searchWindowController.getDouble() )
			.thenParameter( searchOrderByController.getDouble() )
			.returning( expectedResults );

		SearchController searchController = new SearchController().setSearchConfigurationType( searchConfigurationType );

		Test.startTest();
			SearchResults gotResults = searchController.search( searchCriteriaFactory, criteria, window, orderBy );
		Test.stopTest();

		searchCriteriaFactoryController.verify();
		searchServiceController.verify();

		System.assertEquals( expectedResults, gotResults, 'search, when called with configuration, criteria, window and orderby, will call the SearchService and return the results' );
	}

	@isTest
	private static void search_whenPassedANullSearchCriteriaFactory_throwsAnException() // NOPMD: Test method name format
	{
		SearchController searchController = new SearchController().setSearchConfigurationType( ISearchConfiguration.class );

		Test.startTest();
			String exceptionMessage;
			try
			{
				searchController.search( null, UNIMPORTANT_CRITERIA, UNIMPORTANT_WINDOW, UNIMPORTANT_ORDERBY );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'search called with a null searchCriteriaFactory', exceptionMessage, 'search, when passed a null searchCriteriaFactory, will throw an exception' );
	}

	@isTest
	private static void search_whenPassedANullCriteria_throwsAnException() // NOPMD: Test method name format
	{
		ISearchCriteriaFactory unimportantFactory = (ISearchCriteriaFactory)new Amoss_Instance( ISearchCriteriaFactory.class ).generateDouble();
		SearchController searchController = new SearchController().setSearchConfigurationType( ISearchConfiguration.class );

		Test.startTest();
			String exceptionMessage;
			try
			{
				searchController.search( unimportantFactory, null, UNIMPORTANT_WINDOW, UNIMPORTANT_ORDERBY );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'search called with a null criteria', exceptionMessage, 'search, when passed a null criteria, will throw an exception' );
	}

	@isTest
	private static void search_whenPassedANullWindow_throwsAnException() // NOPMD: Test method name format
	{
		ISearchCriteriaFactory unimportantFactory = (ISearchCriteriaFactory)new Amoss_Instance( ISearchCriteriaFactory.class ).generateDouble();
		SearchController searchController = new SearchController().setSearchConfigurationType( ISearchConfiguration.class );

		Test.startTest();
			String exceptionMessage;
			try
			{
				searchController.search( unimportantFactory, UNIMPORTANT_CRITERIA, null, UNIMPORTANT_ORDERBY );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'search called with a null window', exceptionMessage, 'search, when passed a null window, will throw an exception' );
	}

	@isTest
	private static void search_whenPassedANullOrderBy_throwsAnException() // NOPMD: Test method name format
	{
		ISearchCriteriaFactory unimportantFactory = (ISearchCriteriaFactory)new Amoss_Instance( ISearchCriteriaFactory.class ).generateDouble();
		SearchController searchController = new SearchController().setSearchConfigurationType( ISearchConfiguration.class );

		Test.startTest();
			String exceptionMessage;
			try
			{
				searchController.search( unimportantFactory, UNIMPORTANT_CRITERIA, UNIMPORTANT_WINDOW, null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'search called with a null orderBy', exceptionMessage, 'search, when passed a null orderBy, will throw an exception' );
	}

	@isTest
	private static void search_whenConfigTypeNotSet_throwsAnException() // NOPMD: Test method name format
	{
		ISearchCriteriaFactory unimportantFactory = (ISearchCriteriaFactory)new Amoss_Instance( ISearchCriteriaFactory.class ).generateDouble();

		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchController().search( unimportantFactory, UNIMPORTANT_CRITERIA, UNIMPORTANT_WINDOW, UNIMPORTANT_ORDERBY );
			}
			catch ( Contract.AssertException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'search called when searchConfigurationType was null', exceptionMessage, 'search, when searchConfigurationType is not configured, will throw an exception' );
	}

	@isTest
	private static void getSortableFields_whenCalled_requestsFromTheSearchService() // NOPMD: Test method name format
	{
		Amoss_Instance searchServiceController = ApplicationMockRegistrar.registerMockService( ISearchService.class );

		Type searchConfigurationType = ISearchConfiguration.class;
		List<String> expectedSortableFields = new List<String>{ 'field1', 'field2' };

		searchServiceController
			.expects( 'getSortableFields' )
			.withParameter( searchConfigurationType )
			.returning( expectedSortableFields );

		SearchController searchController = new SearchController().setSearchConfigurationType( ISearchConfiguration.class );

		Test.startTest();
			List<String> got = searchController.getSortableFields();
		Test.stopTest();

		System.assertEquals( expectedSortableFields, got, 'getSortableFields, when called, will request the sortable fields from the SearchService and returns them' );
	}

	@isTest
	private static void getSortableFields_whenConfigTypeNotSet_throwsAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				new SearchController().getSortableFields();
			}
			catch ( Contract.AssertException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		Amoss_Asserts.assertContains( 'getSortableFields called when searchConfigurationType was null', exceptionMessage, 'getSortableFields,when searchConfigurationType is not configured, will throw an exception' );
	}
}