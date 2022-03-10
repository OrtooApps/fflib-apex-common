@isTest
private without sharing class CachedSoqlExecutorTest
{
	@isTest
	private static void query_whenCalledTwiceByAUserWithAccessToTheCache_onlyIssuesOneSoqlStatement() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor();

		Test.startTest();
			List<Sobject> originalResults = executor.query( soqlStatement );
			List<Sobject> secondResults   = executor.query( soqlStatement );
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 1, soqlCalls, 'query, when called twice by a user with access to the cache, will only issue one SOQL statement' );
		System.assertEquals( originalResults, secondResults, 'query, when called twice by a user with access to the cache, returns the same results in both calls' );
	}

	@isTest
	private static void query_org_whenCalledTwiceByAUserWithAccessToTheCache_onlyIssuesOneSoqlStatement() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		Test.startTest();
			List<Sobject> originalResults = executor.query( soqlStatement );
			List<Sobject> secondResults   = executor.query( soqlStatement );
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 1, soqlCalls, 'query, when called twice by a user with access to the cache, will only issue one SOQL statement' );
		System.assertEquals( originalResults, secondResults, 'query, when called twice by a user with access to the cache, returns the same results in both calls' );
	}

	@isTest
	private static void query_whenCalledTwiceByAUserWithoutAccessToTheCache_issuesTwoSoqlStatements() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( false );

		CachedSoqlExecutor executor = new CachedSoqlExecutor();

		Test.startTest();
			List<Sobject> originalResults = executor.query( soqlStatement );
			List<Sobject> secondResults   = executor.query( soqlStatement );
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 2, soqlCalls, 'query, when called twice by a user with no access to the cache, will issue two SOQL statements' );
		System.assertEquals( originalResults, secondResults, 'query, when called twice by a user with not access to the cache, returns the same results in both calls' );
	}

	@isTest
	private static void clearCacheFor_whenGivenASoqlStatementThatHasBeenExecuted_willClearTheCacheForThatStatement() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor();

		executor.query( soqlStatement );

		Test.startTest();
			executor.clearCacheFor( soqlStatement );
			executor.query( soqlStatement ); // should execute another soql
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 1, soqlCalls, 'clearCacheFor, when given a SOQL statement that is already in the cache, will clear that soql from the cache' );
	}

	@isTest
	private static void clearCacheFor_whenGivenASoqlStatementThatHasBeenExecuted_willNotClearTheCacheForOtherStatements() // NOPMD: Test method name format
	{
		String soqlStatement1 = 'SELECT Id FROM Account';
		String soqlStatement2 = 'SELECT Id FROM Account LIMIT 1';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor();

		executor.query( soqlStatement1 );
		executor.query( soqlStatement2 );

		Test.startTest();
			executor.clearCacheFor( soqlStatement1 );
			executor.query( soqlStatement2 ); // should not execute another soql
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 0, soqlCalls, 'clearCacheFor, when given a SOQL statement that is already in the cache, will not clear other soql from the cache' );
	}

	@isTest
	private static void clearCacheFor_whenGivenASoqlStatementThatHasNotBeenExecuted_willNotThrowAnException() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor();

		Test.startTest();
			executor.clearCacheFor( soqlStatement );
		Test.stopTest();

		System.assert( true, 'clearCacheFor, when given a SOQL statement that has not been executed, will not throw an exception' );
	}

	@isTest
	private static void clearCacheFor_whenTheUserDoesNotHaveAccessToTheCache_throwsAnException() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( false );

		CachedSoqlExecutor executor = new CachedSoqlExecutor();

		Test.startTest();
			Exception exceptionThrown;
			try
			{
				executor.clearCacheFor( soqlStatement );
			}
			catch ( OrgCache.AccessViolationException e )
			{
				exceptionThrown = e;
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( Label.ortoo_core_org_cache_access_violation, exceptionThrown?.getMessage(), 'clearCacheFor, when the user does not have access to the cache, will throw an exception' );
	}

	@isTest
	private static void query_whenRanFor100Queries_willNotThrowAnException()
	{
		List<String> soqlStatements = new List<String>();
		for ( Integer i=1; i<=100; i++ )
		{
			soqlStatements.add( 'SELECT Id FROM Account LIMIT ' + i );
		}

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor();

		Test.startTest();

			// Run each statement multiple times, one by one
			for ( String thisSoqlStatement : soqlStatements )
			{
				executor.query( thisSoqlStatement );
				executor.query( thisSoqlStatement );
				executor.query( thisSoqlStatement );
				executor.query( thisSoqlStatement );
				executor.query( thisSoqlStatement );
			}

			// Then run each statement again
			for ( String thisSoqlStatement : soqlStatements )
			{
				executor.query( thisSoqlStatement );
			}

		Test.stopTest();

		System.assert( true, 'query, when run multiple times for 100 distinct queries, will not throw an exception' );
	}

	@isTest
	private static void query_session_whenCalledTwiceByAUserWithAccessToTheCache_onlyIssuesOneSoqlStatement() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		Test.startTest();
			List<Sobject> originalResults = executor.query( soqlStatement );
			List<Sobject> secondResults   = executor.query( soqlStatement );
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 1, soqlCalls, 'query, when called twice by a user with access to the cache, will only issue one SOQL statement' );
		System.assertEquals( originalResults, secondResults, 'query, when called twice by a user with access to the cache, returns the same results in both calls' );
	}

	@isTest
	private static void query_session_whenCalledTwiceByAUserWithoutAccessToTheCache_issuesOneSoqlStatement() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( false );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		Test.startTest();
			List<Sobject> originalResults = executor.query( soqlStatement );
			List<Sobject> secondResults   = executor.query( soqlStatement );
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 1, soqlCalls, 'query, when called twice by a user with no access to the org cache, will issue one SOQL statement' );
		System.assertEquals( originalResults, secondResults, 'query, when called twice by a user with no access to the cache, returns the same results in both calls' );
	}

	@isTest
	private static void clearCacheFor_session_whenGivenASoqlStatementThatHasBeenExecuted_willClearTheCacheForThatStatement() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		executor.query( soqlStatement );

		Test.startTest();
			executor.clearCacheFor( soqlStatement );
			executor.query( soqlStatement ); // should execute another soql
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 1, soqlCalls, 'clearCacheFor, when given a SOQL statement that is already in the cache, will clear that soql from the cache' );
	}

	@isTest
	private static void clearCacheFor_session_whenGivenASoqlStatementThatHasBeenExecuted_willNotClearTheCacheForOtherStatements() // NOPMD: Test method name format
	{
		String soqlStatement1 = 'SELECT Id FROM Account';
		String soqlStatement2 = 'SELECT Id FROM Account LIMIT 1';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		executor.query( soqlStatement1 );
		executor.query( soqlStatement2 );

		Test.startTest();
			executor.clearCacheFor( soqlStatement1 );
			executor.query( soqlStatement2 ); // should not execute another soql
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 0, soqlCalls, 'clearCacheFor, when given a SOQL statement that is already in the cache, will not clear other soql from the cache' );
	}

	@isTest
	private static void clearCacheFor_session_whenGivenASoqlStatementThatHasNotBeenExecuted_willNotThrowAnException() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		Test.startTest();
			executor.clearCacheFor( soqlStatement );
		Test.stopTest();

		System.assert( true, 'clearCacheFor, when given a SOQL statement that has not been executed, will not throw an exception' );
	}

	@isTest
	private static void clearCacheFor_session_whenTheUserDoesNotHaveAccessToTheOrgCache_willNotThrowAnException() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( false );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		Test.startTest();
			executor.clearCacheFor( soqlStatement );
		Test.stopTest();

		System.assert( true, 'clearCacheFor, when the user does not have access to the org cache, will not throw an exception' );
   }

	@isTest
	private static void query_session_whenRanFor100Queries_willNotThrowAnException()
	{
		List<String> soqlStatements = new List<String>();
		for ( Integer i=1; i<=100; i++ )
		{
			soqlStatements.add( 'SELECT Id FROM Account LIMIT ' + i );
		}

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		Test.startTest();

			// Run each statement multiple times, one by one
			for ( String thisSoqlStatement : soqlStatements )
			{
				executor.query( thisSoqlStatement );
				executor.query( thisSoqlStatement );
				executor.query( thisSoqlStatement );
				executor.query( thisSoqlStatement );
				executor.query( thisSoqlStatement );
			}

			// Then run each statement again
			for ( String thisSoqlStatement : soqlStatements )
			{
				executor.query( thisSoqlStatement );
			}

		Test.stopTest();

		System.assert( true, 'query, when run multiple times for 100 distinct queries, will not throw an exception' );
	}

	@isTest
	private static void query_none_whenCalledTwiceByAUserWithAccessToTheCache_issuesTwoSoqlStatements() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.NONE );

		Test.startTest();
			List<Sobject> originalResults = executor.query( soqlStatement );
			List<Sobject> secondResults   = executor.query( soqlStatement );
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 2, soqlCalls, 'query against a NONE cache, when called twice by a user with access to the cache, will issue two SOQL statements' );
	}

	@isTest
	private static void query_none_whenCalledTwiceByAUserWithoutAccessToTheCache_issuesTwoSoqlStatements() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( false );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.NONE );

		Test.startTest();
			List<Sobject> originalResults = executor.query( soqlStatement );
			List<Sobject> secondResults   = executor.query( soqlStatement );
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 2, soqlCalls, 'query against a NONE cache, when called twice by a user with no access to the cache, will issue two SOQL statements' );
	}

	@isTest
	private static void clearCacheFor_none_doesNotAffectTheNumberOfSoqlStatementsIssued() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.NONE );

		executor.query( soqlStatement );

		Test.startTest();
			executor.clearCacheFor( soqlStatement );
			executor.query( soqlStatement );
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 1, soqlCalls, 'clearCacheFor against a none cache, does not affect the number of SOQL statements issued' );
	}

	@isTest
	private static void clearCacheFor_none_whenTheUserDoesNotHaveAccessToTheCache_throwsAnException() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( false );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.NONE );

		Test.startTest();
			executor.clearCacheFor( soqlStatement );
		Test.stopTest();

		System.assert( true, 'clearCacheFor against a none cache, when called by a user that does not have access to the org cache, will not throw an exception' );
	}

	@isTest
	private static void query_none_whenRanFor100Queries_willNotThrowAnException()
	{
		List<String> soqlStatements = new List<String>();
		for ( Integer i=1; i<=100; i++ )
		{
			soqlStatements.add( 'SELECT Id FROM Account LIMIT ' + i );
		}

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.NONE );

		Test.startTest();
			// Run each statement once - this is the maximum we can do
			for ( String thisSoqlStatement : soqlStatements )
			{
				executor.query( thisSoqlStatement );
			}
		Test.stopTest();

		System.assert( true, 'query against a none cache, when run for 100 queries, will not throw an exception' );
	}

	private static void setupAccessToSoqlCache( Boolean accessToCache )
	{
		ApplicationMockRegistrar.registerMockService( IPermissionsService.class )
			.when( 'hasAccessToCorePlatformCache' )
			.returns( accessToCache );
	}
}