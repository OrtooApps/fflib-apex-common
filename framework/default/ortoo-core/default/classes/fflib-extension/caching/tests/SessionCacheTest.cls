@isTest
private without sharing class SessionCacheTest
{
	private final static Integer DEFAULT_LIFESPAN = 1000;
	private final static DateTime BASE_TIME = DateTime.newInstanceGmt( 1974, 08, 24, 22, 45, 00 );
	private final static Long NULL_AGE = null;
	private final static DateTime NULL_MIN_DATE_TIME = null;

	@isTest
	private static void hasAccessToCache_whenCalled_returnsTrue() // NOPMD: Test method name format
	{
		SessionCache cache = new SessionCache();
		Boolean got = cache.hasAccessToCache();
		System.assertEquals( true, got, 'hasAccessToCache, when called, will return true' );
	}

	@isTest
	private static void isACache_whenCalled_returnsTrue() // NOPMD: Test method name format
	{
		SessionCache cache = new SessionCache();
		Boolean got = cache.isACache();
		System.assertEquals( true, got, 'hasAccessToCache, when called, will return true' );
	}

	@isTest
	private static void get_whenCalledWithAKeyNotInTheCache_returnsNull() // NOPMD: Test method name format
	{
		SessionCache cache = new SessionCache();
		Object got = cache.get( 'doesnotexist' );
		System.assertEquals( null, got, 'get, when called with a key that is not in the cache, will return null' );
	}

	@isTest
	private static void get_whenCalledWithAKeyThatWasPut_returnsIt() // NOPMD: Test method name format
	{
		String expected = 'thecachedthing';
		new SessionCache().put( 'key', expected, DEFAULT_LIFESPAN );

		SessionCache cache = new SessionCache();
		Object got = cache.get( 'key' );
		System.assertEquals( expected, got, 'get, when called with a key that is in the cache, will return it' );
	}

	@isTest
	private static void get_maxAge_whenTheEntryIsTooOld_returnsNull() // NOPMD: Test method name format
	{
		String cachedObject = 'thecachedthing';

		SessionCache cache = new SessionCache();

		TestDateTimeUtils.setCurrentDateTime( BASE_TIME );
		cache.put( 'key', cachedObject, DEFAULT_LIFESPAN );

		Test.startTest();
			TestDateTimeUtils.addToCurrentTime( 100 );
			Object got = cache.get( 'key', 50 );
		Test.stopTest();

		System.assertEquals( null, got, 'get, passing maximumAge, when the entry is older than the stated number of seconds, will return null' );
	}

	@isTest
	private static void get_maxAge_whenTheEntryIsExactlyRight_returnsTheValue() // NOPMD: Test method name format
	{
		String cachedObject = 'thecachedthing';

		SessionCache cache = new SessionCache();

		TestDateTimeUtils.setCurrentDateTime( BASE_TIME );
		cache.put( 'key', cachedObject, DEFAULT_LIFESPAN );

		Test.startTest();
			TestDateTimeUtils.addToCurrentTime( 100 );
			Object got = cache.get( 'key', 100 );
		Test.stopTest();

		System.assertEquals( cachedObject, got, 'get, passing maximumAge, when the entry is exactly the stated number of seconds, will return the cached value' );
	}

	@isTest
	private static void get_maxAge_whenTheEntryIsYounger_returnsTheValue() // NOPMD: Test method name format
	{
		String cachedObject = 'thecachedthing';

		SessionCache cache = new SessionCache();

		TestDateTimeUtils.setCurrentDateTime( BASE_TIME );
		cache.put( 'key', cachedObject, DEFAULT_LIFESPAN );

		Test.startTest();
			TestDateTimeUtils.addToCurrentTime( 50 );
			Object got = cache.get( 'key', 100 );
		Test.stopTest();

		System.assertEquals( cachedObject, got, 'get, passing maximumAge, when the entry is younger than the stated number of seconds, will return the cached value' );
	}

	@isTest
	private static void get_maxAge_doesNotResetTheAge() // NOPMD: Test method name format
	{
		String cachedObject = 'thecachedthing';

		SessionCache cache = new SessionCache();

		TestDateTimeUtils.setCurrentDateTime( BASE_TIME );
		cache.put( 'key', cachedObject, DEFAULT_LIFESPAN );

		Test.startTest();
			TestDateTimeUtils.addToCurrentTime( 50 );
			cache.get( 'key', 100 );

			TestDateTimeUtils.addToCurrentTime( 50 );
			cache.get( 'key', 100 );

			TestDateTimeUtils.addToCurrentTime( 50 );
			Object got = cache.get( 'key', 100 );
		Test.stopTest();

		System.assertEquals( null, got, 'get, passing maximumAge, does not reset the age of the cached entity, so when its too old it returns null' );
	}

	@isTest
	private static void get_maxAge_whenNoAgeSpecifiedAndTheCachedValueHasNoAge_returnsTheValue() // NOPMD: Test method name format
	{
		String cachedObject = 'thecachedthing';

		SessionCache cacheInstance = new SessionCache();

		Cache.Session.put( cacheInstance.createFullyQualifiedKey( 'key' ), cachedObject );

		Test.startTest();
			Object got = cacheInstance.get( 'key', NULL_AGE );
		Test.stopTest();

		System.assertEquals( cachedObject, got, 'get, passing maximumAge, when no age is specified and the cached value has no age, will return the value' );
	}

	@isTest
	private static void get_maxAge_whenAgeSpecifiedAndTheCachedValueHasNoAge_returnsNull() // NOPMD: Test method name format
	{
		String cachedObject = 'thecachedthing';

		SessionCache cacheInstance = new SessionCache();

		Cache.Session.put( cacheInstance.createFullyQualifiedKey( 'key' ), cachedObject );

		Test.startTest();
			Object got = cacheInstance.get( 'key', 100 );
		Test.stopTest();

		System.assertEquals( null, got, 'get, passing maximumAge, when an age is specified and the cached value has no age, will return null' );
	}

	@isTest
	private static void get_minDateTime_whenTheEntryIsTooOld_returnsNull() // NOPMD: Test method name format
	{
		String cachedObject = 'thecachedthing';

		SessionCache cache = new SessionCache();

		TestDateTimeUtils.setCurrentDateTime( BASE_TIME );
		cache.put( 'key', cachedObject, DEFAULT_LIFESPAN );

		Test.startTest();
			Object got = cache.get( 'key', BASE_TIME.addSeconds( 50 ) );
		Test.stopTest();

		System.assertEquals( null, got, 'get, passing minimumDateTime, when the entry is older than the stated time, will return null' );
	}

	@isTest
	private static void get_minDateTime_whenTheEntryIsExactlyRight_returnsTheValue() // NOPMD: Test method name format
	{
		String cachedObject = 'thecachedthing';

		SessionCache cache = new SessionCache();

		TestDateTimeUtils.setCurrentDateTime( BASE_TIME );
		cache.put( 'key', cachedObject, DEFAULT_LIFESPAN );

		Test.startTest();
			Object got = cache.get( 'key', BASE_TIME );
		Test.stopTest();

		System.assertEquals( cachedObject, got, 'get, passing minimumDateTime, when the entry is exactly the stated time, will return the cached value' );
	}

	@isTest
	private static void get_minDateTime_whenTheEntryIsYounger_returnsTheValue() // NOPMD: Test method name format
	{
		String cachedObject = 'thecachedthing';

		SessionCache cache = new SessionCache();

		TestDateTimeUtils.setCurrentDateTime( BASE_TIME );
		cache.put( 'key', cachedObject, DEFAULT_LIFESPAN );

		Test.startTest();
			Object got = cache.get( 'key', BASE_TIME.addSeconds( -50 ) );
		Test.stopTest();

		System.assertEquals( cachedObject, got, 'get, passing minimumDateTime, when the entry is younger than the stated time, will return the cached value' );
	}

	@isTest
	private static void get_minDateTime_doesNotResetTheAge() // NOPMD: Test method name format
	{
		String cachedObject = 'thecachedthing';

		SessionCache cache = new SessionCache();

		TestDateTimeUtils.setCurrentDateTime( BASE_TIME );
		cache.put( 'key', cachedObject, DEFAULT_LIFESPAN );

		Test.startTest();
			TestDateTimeUtils.addToCurrentTime( 50 );
			cache.get( 'key', BASE_TIME.addSeconds( -50 ) );

			TestDateTimeUtils.addToCurrentTime( 50 );
			cache.get( 'key', BASE_TIME.addSeconds( -100 ) );

			TestDateTimeUtils.addToCurrentTime( 50 );
			Object got = cache.get( 'key', BASE_TIME.addSeconds( 100 ) );
		Test.stopTest();

		System.assertEquals( null, got, 'get, passing minimumDateTime, does not reset the age of the cached entity, so when its too old it returns null' );
	}

	@isTest
	private static void get_minDateTime_whenNoAgeSpecifiedAndTheCachedValueHasNoAge_returnsTheValue() // NOPMD: Test method name format
	{
		String cachedObject = 'thecachedthing';

		SessionCache cacheInstance = new SessionCache();

		Cache.Session.put( cacheInstance.createFullyQualifiedKey( 'key' ), cachedObject );

		Test.startTest();
			Object got = cacheInstance.get( 'key', NULL_MIN_DATE_TIME );
		Test.stopTest();

		System.assertEquals( cachedObject, got, 'get, passing minimumDateTime, when no time is specified and the cached value has no age, will return the value' );
	}

	@isTest
	private static void get_minDateTime_whenAgeSpecifiedAndTheCachedValueHasNoAge_returnsNull() // NOPMD: Test method name format
	{
		String cachedObject = 'thecachedthing';

		SessionCache cacheInstance = new SessionCache();

		Cache.Session.put( cacheInstance.createFullyQualifiedKey( 'key' ), cachedObject );

		Test.startTest();
			Object got = cacheInstance.get( 'key', BASE_TIME.addSeconds( 100 ) );
		Test.stopTest();

		System.assertEquals( null, got, 'get, passing minimumDateTime, when a time is specified and the cached value has no age, will return null' );
	}


	@isTest
	private static void put_whenCalledMultipleTimesWithTheSameKey_overwritesIt() // NOPMD: Test method name format
	{
		new SessionCache().put( 'key', '1', DEFAULT_LIFESPAN );
		new SessionCache().put( 'key', '2', DEFAULT_LIFESPAN );
		new SessionCache().put( 'key', '3', DEFAULT_LIFESPAN );
		new SessionCache().put( 'key', '4', DEFAULT_LIFESPAN );

		SessionCache cache = new SessionCache();
		Object got = cache.get( 'key' );
		System.assertEquals( '4', got, 'put, when called multiple times with the same key, overwrites it' );
	}

	@isTest
	private static void put_whenCalledMultipleTimesWithDifferentKeys_storesThem() // NOPMD: Test method name format
	{
		new SessionCache().put( 'key1', '1', DEFAULT_LIFESPAN );
		new SessionCache().put( 'key2', '2', DEFAULT_LIFESPAN );
		new SessionCache().put( 'key3', '3', DEFAULT_LIFESPAN );
		new SessionCache().put( 'key4', '4', DEFAULT_LIFESPAN );

		SessionCache cache = new SessionCache();
		Object got = cache.get( 'key2' );
		System.assertEquals( '2', got, 'put, when called multiple times with different keys, stores them' );
	}


	@isTest
	private static void getKeys_returnsTheKeysInTheCache() // NOPMD: Test method name format
	{
		new SessionCache().put( 'key1', '1', DEFAULT_LIFESPAN );
		new SessionCache().put( 'key2', '2', DEFAULT_LIFESPAN );
		new SessionCache().put( 'key3', '3', DEFAULT_LIFESPAN );
		new SessionCache().put( 'key4', '4', DEFAULT_LIFESPAN );

		SessionCache cache = new SessionCache();
		Object got = cache.getKeys();

		System.assertEquals( new Set<String>{ 'key1', 'key2', 'key3', 'key4' }, got, 'getKeys, returns the keys in the cache' );
	}

	@isTest
	private static void contains_whenCalledForAKeyThatWasPut_returnsTrue() // NOPMD: Test method name format
	{
		new SessionCache().put( 'keythatexists', '1', DEFAULT_LIFESPAN );

		SessionCache cache = new SessionCache();
		Boolean got = cache.contains( 'keythatexists' );
		System.assertEquals( true, got, 'contains, when called for a key that was put, returns true' );
	}

	@isTest
	private static void contains_whenCalledForAKeyThatWasNotPut_returnsFalse() // NOPMD: Test method name format
	{
		new SessionCache().put( 'keythatexists', '1', DEFAULT_LIFESPAN );

		SessionCache cache = new SessionCache();
		Boolean got = cache.contains( 'keythatdoesnotexist' );
		System.assertEquals( false, got, 'contains, when called for a key that was not put, returns false' );
	}

	@isTest
	private static void remove_whenCalledForAKeyThatWasPut_removesIt() // NOPMD: Test method name format
	{
		new SessionCache().put( 'originalkey', '1', DEFAULT_LIFESPAN );

		SessionCache cache = new SessionCache();
		cache.remove( 'originalkey' );

		System.assertEquals( false, new SessionCache().contains( 'originalkey' ), 'remove, when called for a key that was put, will remove it - checking contains' );
		System.assertEquals( null, new SessionCache().get( 'originalkey' ), 'remove, when called for a key that was put, will remove it - checking get' );
	}

	@isTest
	private static void remove_whenCalledForAKeyThatWasNotPut_doesNotError() // NOPMD: Test method name format
	{
		SessionCache cache = new SessionCache();
		cache.remove( 'keythatneverexisted' );

		System.assertEquals( false, new SessionCache().contains( 'keythatneverexisted' ), 'remove, when called for a key that was put, will remove it - checking contains' );
		System.assertEquals( null, new SessionCache().get( 'keythatneverexisted' ), 'remove, when called for a key that was put, will remove it - checking get' );
	}

	@isTest
	private static void removeAll_whenCalled_removesEverythingFromTheCache() // NOPMD: Test method name format
	{
		new SessionCache().put( 'key1', '1', DEFAULT_LIFESPAN );
		new SessionCache().put( 'key2', '2', DEFAULT_LIFESPAN );
		new SessionCache().put( 'key3', '3', DEFAULT_LIFESPAN );

		SessionCache cache = new SessionCache();
		cache.removeAll();

		System.assertEquals( false, new SessionCache().contains( 'key1' ), 'remove, when called for a key that was put, will remove it - checking contains' );
		System.assertEquals( false, new SessionCache().contains( 'key2' ), 'remove, when called for a key that was put, will remove it - checking contains' );
		System.assertEquals( false, new SessionCache().contains( 'key3' ), 'remove, when called for a key that was put, will remove it - checking contains' );
	}
}