@isTest
private without sharing class NullCacheTest
{
	@isTest
	private static void hasAccessToCache_whenCalled_returnsTrue() // NOPMD: Test method name format
	{
		Boolean got = new NullCache().hasAccessToCache();
		System.assertEquals( true, got, 'hasAccessToCache, when called, will return true' );
	}

	@isTest
	private static void isACache_whenCalled_returnsFalse() // NOPMD: Test method name format
	{
		Boolean got = new NullCache().isACache();
		System.assertEquals( false, got, 'hasAccessToCache, when called, will return false' );
	}

	@isTest
	private static void get_whenCalled_returnsNull() // NOPMD: Test method name format
	{
		Object got = new NullCache().get( null );
		System.assertEquals( null, got, 'get, when called, will return null' );
	}

	@isTest
	private static void put_whenCalled_doesNothing() // NOPMD: Test method name format
	{
		new NullCache().put( null, null, null );
		System.assert( true, 'put, when called, will do nothing and not throw an exception' );
	}

	@isTest
	private static void contains_whenCalled_returnsFalse() // NOPMD: Test method name format
	{
		Boolean got = new NullCache().contains( null );
		System.assertEquals( false, got, 'contains, when called, will return false' );
	}

	@isTest
	private static void remove_whenCalled_doesNothing() // NOPMD: Test method name format
	{
		new NullCache().remove( null );
		System.assert( true, 'remove, when called, will do nothing and not throw an exception' );
	}
}