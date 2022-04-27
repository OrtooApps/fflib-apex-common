@isTest
private without sharing class CachedSoqlExecutorTest
{
	private static final String CACHE_MISS_LOG_MESSAGE = 'Platform Cache miss when running the SOQL';
	private static final String NO_ACCESS_LOG_MESSAGE = 'Opportunity to use Platform Cache skipped since user does not have required permission';

	@isTest
	private static void query_whenCalledTwiceByUserWithAccessToCache_onlyIssuesOneSoql() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor();
		logger.clearLogHistory();

		Test.startTest();
			List<Sobject> originalResults = executor.query( soqlStatement );
			List<Sobject> secondResults   = executor.query( soqlStatement );
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 1, soqlCalls, 'query on org cache, when called twice by a user with access to the cache, will only issue one SOQL statement' );
		System.assertEquals( originalResults, secondResults, 'query on org cache, when called twice by a user with access to the cache, returns the same results in both calls' );

		logger.assertNumberOfLogCalls( 1, 'query on org cache, when called twice by a user with access to the cache, will log once' );
		logger.assertCallIsLog( 0, 'query on org cache, when called twice by a user with access to the cache, will log once' );
		logger.assertLogLevelIs( 0, LoggerService.Level.INFO, 'query on org cache, when called twice by a user with access to the cache, will log once with an info message' );
		logger.assertLogEntryContains( 0, CACHE_MISS_LOG_MESSAGE, 'query on org cache, when called twice by a user with access to the cache, will log once to say there was a cache miss' );
		logger.assertLogEntryContains( 0, soqlStatement, 'query on org cache, when called twice by a user with access to the cache, will log once to say there was a cache miss and reference the SOQL statement' );
	}

	@isTest
	private static void query_org_whenCalledTwiceByUserWithAccessToCache_onlyIssuesOneSoql() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.ORG );
		logger.clearLogHistory();

		Test.startTest();
			List<Sobject> originalResults = executor.query( soqlStatement );
			List<Sobject> secondResults   = executor.query( soqlStatement );
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 1, soqlCalls, 'query on org cache, when called twice by a user with access to the cache, will only issue one SOQL statement' );
		System.assertEquals( originalResults, secondResults, 'query on org cache, when called twice by a user with access to the cache, returns the same results in both calls' );

		logger.assertNumberOfLogCalls( 1, 'query against an org cache, when called twice by a user with access to the cache, will log once' );

		logger.assertCallIsLog( 0, 'query against an org cache, when called twice by a user with access to the cache, will log once' );
		logger.assertLogLevelIs( 0, LoggerService.Level.INFO, 'query against an org cache, when called twice by a user with access to the cache, will log once with an info message' );
		logger.assertLogEntryContains( 0, CACHE_MISS_LOG_MESSAGE, 'query against an org cache, when called twice by a user with access to the cache, will log once to say there was a cache miss' );
		logger.assertLogEntryContains( 0, soqlStatement, 'query against an org cache, when called twice by a user with access to the cache, will log once to say there was a cache miss and reference the SOQL statement' );
	}

	@isTest
	private static void query_whenCalledTwiceByUserWithoutAccessToCache_issuesTwoSoqls() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( false );

		CachedSoqlExecutor executor = new CachedSoqlExecutor();
		logger.clearLogHistory();

		Test.startTest();
			List<Sobject> originalResults = executor.query( soqlStatement );
			List<Sobject> secondResults   = executor.query( soqlStatement );
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 2, soqlCalls, 'query on org cache, when called twice by a user with no access to the cache, will issue two SOQL statements' );
		System.assertEquals( originalResults, secondResults, 'query on org cache, when called twice by a user with no access to the cache, returns the same results in both calls' );

		logger.assertNumberOfLogCalls( 2, 'query on org cache, when called twice by a user with no access to the cache, will log twice' );
		logger.assertLogEntryContains( 0, NO_ACCESS_LOG_MESSAGE, 'query on org cache, when called twice by a user with no access to the cache, will log twice to say user could not access the cache - 1' );
		logger.assertLogEntryContains( 1, NO_ACCESS_LOG_MESSAGE, 'query on org cache, when called twice by a user with no access to the cache, will log twice to say user could not access the cache - 2' );
	}

	@isTest
	private static void clearCacheFor_whenGivenSoqlThatWasExecuted_clearsCacheForThatStatement() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor();

		executor.query( soqlStatement );
		logger.clearLogHistory();

		Test.startTest();

			executor.clearCacheFor( soqlStatement );
			logger.assertNumberOfLogCalls( 0, 'clearCacheFor on org cache does not generate any logs' );

			logger.clearLogHistory();
			executor.query( soqlStatement ); // should execute another soql
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 1, soqlCalls, 'clearCacheFor on org cache, when given a SOQL statement that is already in the cache, will clear that soql from the cache' );

		logger.assertNumberOfLogCalls( 1, 'query on org cache, when called after the cache has been cleared for that statement, will log a cache miss' );
		logger.assertLogEntryContains( 0, CACHE_MISS_LOG_MESSAGE, 'query on org cache, when called after the cache has been cleared for that statement, will log a cache miss' );
	}

	@isTest
	private static void clearCacheFor_whenGivenSoqlThatWasExecuted_willNotClearCacheForOthers() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement1 = 'SELECT Id FROM Account';
		String soqlStatement2 = 'SELECT Id FROM Account LIMIT 1';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor();

		executor.query( soqlStatement1 );
		executor.query( soqlStatement2 );

		Test.startTest();
			executor.clearCacheFor( soqlStatement1 );

			logger.clearLogHistory();
			executor.query( soqlStatement2 ); // should not execute another soql
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 0, soqlCalls, 'clearCacheFor on org cache, when given a SOQL statement that is already in the cache, will not clear other soql from the cache' );
		logger.assertNumberOfLogCalls( 0, 'query on org cache, after clear cache called for a different statement, will not generate a log entry' );
	}

	@isTest
	private static void clearCacheFor_whenGivenSoqlThatHasNotBeenExecuted_willNotThrow() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor();
		logger.clearLogHistory();

		Test.startTest();
			executor.clearCacheFor( soqlStatement );
		Test.stopTest();

		System.assert( true, 'clearCacheFor on org cache, when given a SOQL statement that has not been executed, will not throw an exception' );
		logger.assertNumberOfLogCalls( 0, 'clearCacheFor on org cache, when given a SOQL statement that has not been executed, will not generate a log entry' );
	}

	@isTest
	private static void clearCacheFor_whenTheUserDoesNotHaveAccessToCache_throwsAnException() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( false );

		CachedSoqlExecutor executor = new CachedSoqlExecutor();
		logger.clearLogHistory();

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

		ortoo_Asserts.assertContains( Label.ortoo_core_org_cache_access_violation, exceptionThrown?.getMessage(), 'clearCacheFor on org cache, when the user does not have access to the cache, will throw an exception' );
		logger.assertNumberOfLogCalls( 0,  'clearCacheFor on org cache, when the user does not have access to the cache, will not generate a log entry' );
	}

	@isTest
	private static void query_whenRanFor100Queries_willNotThrow()
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		List<String> soqlStatements = new List<String>();
		for ( Integer i=1; i<=100; i++ )
		{
			soqlStatements.add( 'SELECT Id FROM Account LIMIT ' + i );
		}

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor();

		Test.startTest();

			// Run each statement multiple times, one by one
			for ( String thisSoql : soqlStatements )
			{
				executor.query( thisSoql );
				executor.query( thisSoql );
				executor.query( thisSoql );
				executor.query( thisSoql );
				executor.query( thisSoql );
			}

			// Then run each statement again
			for ( String thisSoql : soqlStatements )
			{
				executor.query( thisSoql );
			}

		Test.stopTest();

		System.assert( true, 'query on org cache, when run multiple times for 100 distinct queries, will not throw an exception' );
	}

	@isTest
	private static void query_session_whenCalledTwiceByUserWithAccessToCache_onlyIssuesOneSoql() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		Test.startTest();
			List<Sobject> originalResults = executor.query( soqlStatement );

			logger.clearLogHistory();
			List<Sobject> secondResults   = executor.query( soqlStatement );
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 1, soqlCalls, 'query on session cache, when called twice by a user with access to the cache, will only issue one SOQL statement' );
		System.assertEquals( originalResults, secondResults, 'query on session cache, when called twice by a user with access to the cache, returns the same results in both calls' );

		logger.assertNumberOfLogCalls( 0, 'query on session cache, when called a second time by a user with access to the cache, does not generate a log entry' );
	}

	@isTest
	private static void query_session_whenCalledTwiceByUserWithoutAccessToCache_issuesOneSoql() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( false );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		Test.startTest();
			List<Sobject> originalResults = executor.query( soqlStatement );
			List<Sobject> secondResults   = executor.query( soqlStatement );
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 1, soqlCalls, 'query on session cache, when called twice by a user with no access to the org cache, will issue one SOQL statement' );
		System.assertEquals( originalResults, secondResults, 'query on session cache, when called twice by a user with no access to the cache, returns the same results in both calls' );
	}

	@isTest
	private static void clearCacheFor_session_whenGivenSoqlThatWasExecuted_clearsCacheForThatStatement() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		executor.query( soqlStatement );

		Test.startTest();
			executor.clearCacheFor( soqlStatement );

			logger.clearLogHistory();
			executor.query( soqlStatement ); // should execute another soql
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 1, soqlCalls, 'clearCacheFor on session cache, when given a SOQL statement that is already in the cache, will clear that soql from the cache' );

		logger.assertNumberOfLogCalls( 1, 'query on session cache when called after the cache is cleared for that statement, will log a cache miss' );
		logger.assertLogEntryContains( 0, CACHE_MISS_LOG_MESSAGE, 'query on session cache when called after the cache is cleared for that statement, will log a cache miss' );
	}

	@isTest
	private static void clearCacheFor_session_whenGivenSoqlThatWasExecuted_willNotClearCacheForOthers() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement1 = 'SELECT Id FROM Account';
		String soqlStatement2 = 'SELECT Id FROM Account LIMIT 1';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		executor.query( soqlStatement1 );
		executor.query( soqlStatement2 );

		Test.startTest();
			executor.clearCacheFor( soqlStatement1 );

			logger.clearLogHistory();
			executor.query( soqlStatement2 ); // should not execute another soql
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 0, soqlCalls, 'clearCacheFor on session cache, when given a SOQL statement that is already in the cache, will not clear other soql from the cache' );

		logger.assertNumberOfLogCalls( 0, 'query on session cache when called after the cache is cleared for a different statement, will not log a cache miss' );
	}

	@isTest
	private static void clearCacheFor_session_whenGivenSoqlThatHasNotBeenExecuted_willNotThrow() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );
		logger.clearLogHistory();

		Test.startTest();
			executor.clearCacheFor( soqlStatement );
		Test.stopTest();

		System.assert( true, 'clearCacheFor on session cache, when given a SOQL statement that has not been executed, will not throw an exception' );
		logger.assertNumberOfLogCalls( 0, 'clearCacheFor on session, when given a SOQL statement that has not been executed, will not create a log' );
	}

	@isTest
	private static void clearCacheFor_session_whenTheUserDoesNotHaveAccessToTheOrgCache_willNotThrow() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( false );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );
		logger.clearLogHistory();

		Test.startTest();
			executor.clearCacheFor( soqlStatement );
		Test.stopTest();

		System.assert( true, 'clearCacheFor on session cache, when the user does not have access to the org cache, will not throw an exception' );
		logger.assertNumberOfLogCalls( 0, 'clearCacheFor on session, when the user does not have access to the org cache, will not create a log' );
   }

	@isTest
	private static void query_session_whenRanFor100Queries_willNotThrow()
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		List<String> soqlStatements = new List<String>();
		for ( Integer i=1; i<=100; i++ )
		{
			soqlStatements.add( 'SELECT Id FROM Account LIMIT ' + i );
		}

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		Test.startTest();

			// Run each statement multiple times, one by one
			for ( String thisSoql : soqlStatements )
			{
				executor.query( thisSoql );
				executor.query( thisSoql );
				executor.query( thisSoql );
				executor.query( thisSoql );
				executor.query( thisSoql );
			}

			// Then run each statement again
			for ( String thisSoql : soqlStatements )
			{
				executor.query( thisSoql );
			}

		Test.stopTest();

		System.assert( true, 'query on session cache, when run multiple times for 100 distinct queries, will not throw an exception' );
	}

	@isTest
	private static void query_none_whenCalledTwiceByUserWithAccessToCache_issuesTwoSoqls() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.NONE );
		logger.clearLogHistory();

		Test.startTest();
			List<Sobject> originalResults = executor.query( soqlStatement );
			List<Sobject> secondResults   = executor.query( soqlStatement );
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 2, soqlCalls, 'query against a NONE cache, when called twice by a user with access to the cache, will issue two SOQL statements' );
		logger.assertNumberOfLogCalls( 0, 'query against a NONE cache, when called twice by a user with access to the cache, will not create a log' );
	}

	@isTest
	private static void query_none_whenCalledTwiceByUserWithoutAccessToCache_issuesTwoSoqls() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( false );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.NONE );
		logger.clearLogHistory();

		Test.startTest();
			List<Sobject> originalResults = executor.query( soqlStatement );
			List<Sobject> secondResults   = executor.query( soqlStatement );
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 2, soqlCalls, 'query against a NONE cache, when called twice by a user with no access to the cache, will issue two SOQL statements' );
		logger.assertNumberOfLogCalls( 0, 'query against a NONE cache, when called twice by a user with no access to the cache, will not create a log' );
	}

	@isTest
	private static void clearCacheFor_none_doesNotAffectTheNumberOfSoqlsIssued() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.NONE );

		executor.query( soqlStatement );

		Test.startTest();
			logger.clearLogHistory();
			executor.clearCacheFor( soqlStatement );
			executor.query( soqlStatement );
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 1, soqlCalls, 'clearCacheFor against a none cache, does not affect the number of SOQL statements issued' );
		logger.assertNumberOfLogCalls( 0, 'clearCacheFor against a none cache, will not create a log' );
	}

	@isTest
	private static void clearCacheFor_none_whenTheUserDoesNotHaveAccessToCache_throwsAnException() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( false );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.NONE );
		logger.clearLogHistory();

		Test.startTest();
			executor.clearCacheFor( soqlStatement );
		Test.stopTest();

		System.assert( true, 'clearCacheFor against a none cache, when called by a user that does not have access to the org cache, will not throw an exception' );
		logger.assertNumberOfLogCalls( 0, 'clearCacheFor against a none cache, when called by a user that does not have access to the org cache, will not create a log' );
	}

	@isTest
	private static void query_maxAge_session_whenCalledTwiceWithinAge_onlyIssuesOneSoql() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		Test.startTest();
			TestDateTimeUtils.setCurrentDateTime( 0 );
			List<Sobject> originalResults = executor.query( soqlStatement, 100 );

			TestDateTimeUtils.addToCurrentTime( 50 ); // it is now 50 seconds later
			logger.clearLogHistory();
			List<Sobject> secondResults   = executor.query( soqlStatement, 100 );  // so this should still return the results
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 1, soqlCalls, 'query with a maximum age on session cache, when called twice within the required age, will only issue one SOQL statement' );
		System.assertEquals( originalResults, secondResults, 'query with a maximum age on session cache, when called twice within the required age, returns the same results in both calls' );

		logger.assertNumberOfLogCalls( 0, 'query with a maximum age on session cache,when called twice within the required age, does not generate a log entry' );
	}

	@isTest
	private static void query_maxAge_session_whenCalledTwiceOutsideAge_issuesTwoSoql() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		Test.startTest();
			TestDateTimeUtils.setCurrentDateTime( 0 );
			List<Sobject> originalResults = executor.query( soqlStatement, 100 );

			TestDateTimeUtils.addToCurrentTime( 100 ); // it is now 50 seconds later
			logger.clearLogHistory();
			List<Sobject> secondResults   = executor.query( soqlStatement, 50 );  // so this should result in a new query because the previous results are too old
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 2, soqlCalls, 'query with a maximum age on session cache, when called twice with the second outside the required age, will issue two SOQL statements' );
	}

	@isTest
	private static void query_whenPassedANullMaxAge_throwsAnException() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';
		CachedSoqlExecutor executor = new CachedSoqlExecutor();

		Long nullAge;

		Test.startTest();
			String exceptionMessage;
			try
			{
				executor.query( soqlStatement, nullAge );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'query called with a null maximumAgeInSeconds', exceptionMessage, 'query, when passed a null maximumAgeInSeconds, will throw an exception' );
	}

	@isTest
	private static void query_minDate_session_whenCalledTwiceWithinDate_onlyIssuesOneSoql() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		DateTime earliestDate = DateTime.newInstance( 2020, 2, 4, 14, 00, 00 );
		DateTime middleDate   = DateTime.newInstance( 2020, 2, 5, 14, 00, 00 );
		DateTime latestDate   = DateTime.newInstance( 2020, 2, 6, 14, 00, 00 );

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		Test.startTest();
			TestDateTimeUtils.setCurrentDateTime( middleDate );
			List<Sobject> originalResults = executor.query( soqlStatement, middleDate );

			TestDateTimeUtils.setCurrentDateTime( latestDate );
			logger.clearLogHistory();
			List<Sobject> secondResults   = executor.query( soqlStatement, earliestDate ); // this date is earlier than the first query ran, so the cache should be used
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 1, soqlCalls, 'query with a minimum date on session cache, when called twice within the required age, will only issue one SOQL statement' );
		System.assertEquals( originalResults, secondResults, 'query with a minimum date  on session cache, when called twice within the required age, returns the same results in both calls' );

		logger.assertNumberOfLogCalls( 0, 'query with a minimum date  on session cache,when called twice within the required age, does not generate a log entry' );
	}

	@isTest
	private static void query_minDate_session_whenCalledTwiceOutsideDate_issuesTwoSoql() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		DateTime earliestDate = DateTime.newInstance( 2020, 2, 4, 14, 00, 00 );
		DateTime middleDate   = DateTime.newInstance( 2020, 2, 5, 14, 00, 00 );
		DateTime latestDate   = DateTime.newInstance( 2020, 2, 6, 14, 00, 00 );

		String soqlStatement = 'SELECT Id FROM Account';

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.SESSION );

		Test.startTest();
			TestDateTimeUtils.setCurrentDateTime( earliestDate );
			List<Sobject> originalResults = executor.query( soqlStatement, earliestDate );

			TestDateTimeUtils.setCurrentDateTime( latestDate );
			logger.clearLogHistory();
			List<Sobject> secondResults   = executor.query( soqlStatement, middleDate ); // this date is later than the first query ran, so the cache should not be used
			Integer soqlCalls = Limits.getQueries();
		Test.stopTest();

		System.assertEquals( 2, soqlCalls, 'query with a maximum age on session cache, when called twice with the second outside the required age, will issue two SOQL statements' );
	}

	@isTest
	private static void query_minDate_whenPassedANullMinDate_throwsAnException() // NOPMD: Test method name format
	{
		String soqlStatement = 'SELECT Id FROM Account';
		CachedSoqlExecutor executor = new CachedSoqlExecutor();

		DateTime nullDateTime;

		Test.startTest();
			String exceptionMessage;
			try
			{
				executor.query( soqlStatement, nullDateTime );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'query called with a null minimumDateTimeAdded', exceptionMessage, 'query, when passed a null minimumDateTimeAdded, will throw an exception' );
	}

	@isTest
	private static void query_none_whenRanFor100Queries_willNotThrow() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();

		List<String> soqlStatements = new List<String>();
		for ( Integer i=1; i<=100; i++ )
		{
			soqlStatements.add( 'SELECT Id FROM Account LIMIT ' + i );
		}

		setupAccessToSoqlCache( true );

		CachedSoqlExecutor executor = new CachedSoqlExecutor().setScope( CachedSoqlExecutor.CacheScope.NONE );

		Test.startTest();
			// Run each statement once - this is the maximum we can do
			for ( String thisSoql : soqlStatements )
			{
				executor.query( thisSoql );
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