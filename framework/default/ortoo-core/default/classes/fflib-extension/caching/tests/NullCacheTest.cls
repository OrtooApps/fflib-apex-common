@isTest
private without sharing class NullCacheTest
{
	private final static Long NULL_AGE = null;
	private final static DateTime NULL_MIN_DATE_TIME = null;

	@isTest
	private static void hasAccessToCache_whenCalled_returnsTrue() // NOPMD: Test method name format
	{
		NullCache cache = new NullCache();
		Boolean got = cache.hasAccessToCache();
		System.assertEquals( true, got, 'hasAccessToCache, when called, will return true' );
	}

	@isTest
	private static void isACache_whenCalled_returnsFalse() // NOPMD: Test method name format
	{
		NullCache cache = new NullCache();
		Boolean got = cache.isACache();
		System.assertEquals( false, got, 'hasAccessToCache, when called, will return false' );
	}

	@isTest
	private static void get_whenCalled_returnsNull() // NOPMD: Test method name format
	{
		NullCache cache = new NullCache();
		Object got = cache.get( null );
		System.assertEquals( null, got, 'get, when called, will return null' );
	}

	@isTest
	private static void get_maxAge_whenCalled_returnsNull() // NOPMD: Test method name format
	{
		NullCache cache = new NullCache();
		Object got = cache.get( null, NULL_AGE );
		System.assertEquals( null, got, 'get, when called with a max age, will return null' );
	}

	@isTest
	private static void get_minDate_whenCalled_returnsNull() // NOPMD: Test method name format
	{
		NullCache cache = new NullCache();
		Object got = cache.get( null, NULL_MIN_DATE_TIME );
		System.assertEquals( null, got, 'get, when called with a min datetime, will return null' );
	}

	@isTest
	private static void put_whenCalled_doesNothing() // NOPMD: Test method name format
	{
		NullCache cache = new NullCache();
		cache.put( null, null, null );
		System.assert( true, 'put, when called, will do nothing and not throw an exception' );
	}

	@isTest
	private static void getKeys_whenCalled_returnsAnEmptySet() // NOPMD: Test method name format
	{
		NullCache cache = new NullCache();
		Set<String> got = cache.getKeys();
		System.assertEquals( 0, got.size(), 'getKeys, when called, will return an empty set' );
	}

	@isTest
	private static void contains_whenCalled_returnsFalse() // NOPMD: Test method name format
	{
		NullCache cache = new NullCache();
		Boolean got = cache.contains( null );
		System.assertEquals( false, got, 'contains, when called, will return false' );
	}

	@isTest
	private static void remove_whenCalled_doesNothing() // NOPMD: Test method name format
	{
		NullCache cache = new NullCache();
		cache.remove( null );
		System.assert( true, 'remove, when called, will do nothing and not throw an exception' );
	}
}