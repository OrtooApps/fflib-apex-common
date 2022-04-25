@isTest
private without sharing class OrgCacheTest
{
	private final static Integer DEFAULT_LIFESPAN = 1000;

	@isTest
	private static void hasAccessToCache_whenCalledByUserWithCacheAccess_returnsTrue() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( true );
		OrgCache cache = new OrgCache();

		Boolean got = cache.hasAccessToCache();
		System.assertEquals( true, got, 'hasAccessToCache, when called, will return true' );
	}

	@isTest
	private static void hasAccessToCache_whenCalledByUserWithoutCacheAccess_returnsFalse() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( false );
		OrgCache cache = new OrgCache();

		Boolean got = cache.hasAccessToCache();
		System.assertEquals( false, got, 'hasAccessToCache, when called, will return false' );
	}

	@isTest
	private static void isACache_whenCalledByUserWithCacheAccess_returnsTrue() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( true );

		OrgCache cache = new OrgCache();
		Boolean got = cache.isACache();
		System.assertEquals( true, got, 'hasAccessToCache, when called, will return true' );
	}

	@isTest
	private static void isACache_whenCalledByUserWithoutCacheAccess_returnsTrue() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( false );

		OrgCache cache = new OrgCache();
		Boolean got = cache.isACache();
		System.assertEquals( true, got, 'hasAccessToCache, when called, will return true' );
	}

	@isTest
	private static void get_whenTheUserDoesNotHaveAccessToTheCache_throwsAnException() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( false );

		OrgCache cache = new OrgCache();

		Test.startTest();
			Exception exceptionThrown;
			try
			{
				cache.get( 'a key' );
			}
			catch ( OrgCache.AccessViolationException e )
			{
				exceptionThrown = e;
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( Label.ortoo_core_org_cache_access_violation, exceptionThrown?.getMessage(), 'get, when the user does not have access to the cache, will throw an exception' );
	}

	@isTest
	private static void get_whenCalledByUserWithCacheAccessWithAKeyNotInTheCache_returnsNull() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( true );

		OrgCache cache = new OrgCache();
		Object got = cache.get( 'doesnotexist' );
		System.assertEquals( null, got, 'get, when called with a key that is not in the cache, will return null' );
	}

	@isTest
	private static void get_whenCalledByUserWithCacheAccessWithAKeyThatWasPut_returnsIt() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( true );

		String expected = 'thecachedthing';
		new OrgCache().put( 'key', expected, DEFAULT_LIFESPAN );

		OrgCache cache = new OrgCache();
		Object got = cache.get( 'key' );
		System.assertEquals( expected, got, 'get, when called with a key that is in the cache, will return it' );
	}


	@isTest
	private static void put_whenTheUserDoesNotHaveAccessToTheCache_throwsAnException() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( false );

		OrgCache cache = new OrgCache();

		Test.startTest();
			Exception exceptionThrown;
			try
			{
				cache.put( 'a key', 'value', DEFAULT_LIFESPAN );
			}
			catch ( OrgCache.AccessViolationException e )
			{
				exceptionThrown = e;
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( Label.ortoo_core_org_cache_access_violation, exceptionThrown?.getMessage(), 'put, when the user does not have access to the cache, will throw an exception' );
	}

	@isTest
	private static void put_whenCalledByUserWithCacheAccessMultipleTimesWithTheSameKey_overwritesIt() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( true );

		new OrgCache().put( 'key', '1', DEFAULT_LIFESPAN );
		new OrgCache().put( 'key', '2', DEFAULT_LIFESPAN );
		new OrgCache().put( 'key', '3', DEFAULT_LIFESPAN );
		new OrgCache().put( 'key', '4', DEFAULT_LIFESPAN );

		OrgCache cache = new OrgCache();
		Object got = cache.get( 'key' );
		System.assertEquals( '4', got, 'put, when called multiple times with the same key, overwrites it' );
	}

	@isTest
	private static void put_whenCalledByUserWithCacheAccessMultipleTimesWithDifferentKeys_storesThem() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( true );

		new OrgCache().put( 'key1', '1', DEFAULT_LIFESPAN );
		new OrgCache().put( 'key2', '2', DEFAULT_LIFESPAN );
		new OrgCache().put( 'key3', '3', DEFAULT_LIFESPAN );
		new OrgCache().put( 'key4', '4', DEFAULT_LIFESPAN );

		OrgCache cache = new OrgCache();
		Object got = cache.get( 'key2' );
		System.assertEquals( '2', got, 'put, when called multiple times with different keys, stores them' );
	}

	@isTest
	private static void getKeyss_whenTheUserDoesNotHaveAccessToTheCache_throwsAnException() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( false );

		OrgCache cache = new OrgCache();

		Test.startTest();
			Exception exceptionThrown;
			try
			{
				cache.getKeys();
			}
			catch ( OrgCache.AccessViolationException e )
			{
				exceptionThrown = e;
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( Label.ortoo_core_org_cache_access_violation, exceptionThrown?.getMessage(), 'getKeys, when the user does not have access to the cache, will throw an exception' );
	}

	@isTest
	private static void getKeys_whenCalledByUserWithCacheAccess_returnsTheKeysInTheCache() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( true );

		new OrgCache().put( 'key1', '1', DEFAULT_LIFESPAN );
		new OrgCache().put( 'key2', '2', DEFAULT_LIFESPAN );
		new OrgCache().put( 'key3', '3', DEFAULT_LIFESPAN );
		new OrgCache().put( 'key4', '4', DEFAULT_LIFESPAN );

		OrgCache cache = new OrgCache();
		Object got = cache.getKeys();

		System.assertEquals( new Set<String>{ 'key1', 'key2', 'key3', 'key4' }, got, 'getKeys, when called by user with cache access, returns the keys in the cache' );
	}

	@isTest
	private static void contains_whenTheUserDoesNotHaveAccessToTheCache_throwsAnException() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( false );

		OrgCache cache = new OrgCache();

		Test.startTest();
			Exception exceptionThrown;
			try
			{
				cache.contains( 'a key' );
			}
			catch ( OrgCache.AccessViolationException e )
			{
				exceptionThrown = e;
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( Label.ortoo_core_org_cache_access_violation, exceptionThrown?.getMessage(), 'contains, when the user does not have access to the cache, will throw an exception' );
	}

	@isTest
	private static void contains_whenCalledByUserWithCacheAccessForAKeyThatWasPut_returnsTrue() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( true );

		new OrgCache().put( 'keythatexists', '1', DEFAULT_LIFESPAN );

		OrgCache cache = new OrgCache();
		Boolean got = cache.contains( 'keythatexists' );
		System.assertEquals( true, got, 'contains, when called for a key that was put, returns true' );
	}

	@isTest
	private static void contains_whenCalledByUserWithCacheAccessForAKeyThatWasNotPut_returnsFalse() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( true );

		new OrgCache().put( 'keythatexists', '1', DEFAULT_LIFESPAN );

		OrgCache cache = new OrgCache();
		Boolean got = cache.contains( 'keythatdoesnotexist' );
		System.assertEquals( false, got, 'contains, when called for a key that was not put, returns false' );
	}

	@isTest
	private static void remove_whenTheUserDoesNotHaveAccessToTheCache_throwsAnException() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( false );

		OrgCache cache = new OrgCache();

		Test.startTest();
			Exception exceptionThrown;
			try
			{
				cache.remove( 'a key' );
			}
			catch ( OrgCache.AccessViolationException e )
			{
				exceptionThrown = e;
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( Label.ortoo_core_org_cache_access_violation, exceptionThrown?.getMessage(), 'remove, when the user does not have access to the cache, will throw an exception' );
	}

	@isTest
	private static void remove_whenCalledByUserWithCacheAccessForAKeyThatWasPut_removesIt() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( true );

		new OrgCache().put( 'originalkey', '1', DEFAULT_LIFESPAN );

		OrgCache cache = new OrgCache();
		cache.remove( 'originalkey' );

		System.assertEquals( false, new OrgCache().contains( 'originalkey' ), 'remove, when called for a key that was put, will remove it - checking contains' );
		System.assertEquals( null, new OrgCache().get( 'originalkey' ), 'remove, when called for a key that was put, will remove it - checking get' );
	}

	@isTest
	private static void remove_whenCalledByUserWithCacheAccessForAKeyThatWasNotPut_doesNotError() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( true );

		OrgCache cache = new OrgCache();
		cache.remove( 'keythatneverexisted' );

		System.assertEquals( false, new OrgCache().contains( 'keythatneverexisted' ), 'remove, when called for a key that was put, will remove it - checking contains' );
		System.assertEquals( null, new OrgCache().get( 'keythatneverexisted' ), 'remove, when called for a key that was put, will remove it - checking get' );
	}

	@isTest
	private static void removeAll_whenTheUserDoesNotHaveAccessToTheCache_throwsAnException() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( false );

		OrgCache cache = new OrgCache();

		Test.startTest();
			Exception exceptionThrown;
			try
			{
				cache.removeAll();
			}
			catch ( OrgCache.AccessViolationException e )
			{
				exceptionThrown = e;
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( Label.ortoo_core_org_cache_access_violation, exceptionThrown?.getMessage(), 'remove, when the user does not have access to the cache, will throw an exception' );
	}

	@isTest
	private static void removeAll_whenCalledByUserWithCacheAccess_willRemoveAllKeysFromTheCache() // NOPMD: Test method name format
	{
		setupAccessToSoqlCache( true );

		new OrgCache().put( 'key1', '1', DEFAULT_LIFESPAN );
		new OrgCache().put( 'key2', '2', DEFAULT_LIFESPAN );
		new OrgCache().put( 'key3', '3', DEFAULT_LIFESPAN );

		Test.startTest();
			OrgCache cache = new OrgCache();
			cache.removeAll();
		Test.stopTest();

		System.assertEquals( false, new OrgCache().contains( 'key1' ), 'removeAll, when called for a key that was put, will remove it - checking contains - 1' );
		System.assertEquals( null, new OrgCache().get( 'key1' ), 'removeAll, when called for a key that was put, will remove it - checking get - 1' );

		System.assertEquals( false, new OrgCache().contains( 'key2' ), 'removeAll, when called for a key that was put, will remove it - checking contains - 2' );
		System.assertEquals( null, new OrgCache().get( 'key2' ), 'removeAll, when called for a key that was put, will remove it - checking get - 3' );

		System.assertEquals( false, new OrgCache().contains( 'key3' ), 'removeAll, when called for a key that was put, will remove it - checking contains - 3' );
		System.assertEquals( null, new OrgCache().get( 'key3' ), 'removeAll, when called for a key that was put, will remove it - checking get - 3' );
	}

	private static void setupAccessToSoqlCache( Boolean accessToCache )
	{
		ApplicationMockRegistrar.registerMockService( IPermissionsService.class )
			.when( 'hasAccessToCorePlatformCache' )
			.returns( accessToCache );
	}
}