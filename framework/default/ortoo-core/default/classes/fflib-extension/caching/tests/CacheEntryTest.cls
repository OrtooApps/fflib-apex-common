@isTest
private without sharing class CacheEntryTest
{
	@isTest
	private static void getValue_whenCalled_returnsTheValue() // NOPMD: Test method name format
	{
		Object expected = 'thevalue';
		CacheEntry entry = new CacheEntry( expected );

		Test.startTest();
			Object got = entry.getValue();
		Test.stopTest();

		System.assertEquals( expected, got, 'getValue, when called, will return the value' );
	}

	@isTest
	private static void isYoungerThanOrEqualTo_whenTheCacheIsYounger_returnsTrue() // NOPMD: Test method name format
	{
		TestDateTimeUtils.setCurrentDateTime( 0 );
		CacheEntry entry = new CacheEntry( 'TheCachedEntry' );

		Test.startTest();
			TestDateTimeUtils.addToCurrentTime( 100 ); // this means the cache entry is 100 seconds old
			Boolean got = entry.isYoungerThanOrEqualTo( 150 );
		Test.stopTest();

		System.assert( got, 'isYoungerThanOrEqualTo, when the cache entry is younger, will return true' );
	}

	@isTest
	private static void isYoungerThanOrEqualTo_whenTheCacheIsExactlyTheGivenAge_returnsTrue() // NOPMD: Test method name format
	{
		TestDateTimeUtils.setCurrentDateTime( 0 );
		CacheEntry entry = new CacheEntry( 'TheCachedEntry' );

		Test.startTest();
			TestDateTimeUtils.addToCurrentTime( 100 ); // this means the cache entry is 100 seconds old
			Boolean got = entry.isYoungerThanOrEqualTo( 100 );
		Test.stopTest();

		System.assert( got, 'isYoungerThanOrEqualTo, when the cache entry is exactly the stated age, will return true' );
	}

	@isTest
	private static void isYoungerThanOrEqualTo_whenTheCacheIsOlder_returnsFalse() // NOPMD: Test method name format
	{
		TestDateTimeUtils.setCurrentDateTime( 0 );
		CacheEntry entry = new CacheEntry( 'TheCachedEntry' );

		Test.startTest();
			TestDateTimeUtils.addToCurrentTime( 100 ); // this means the cache entry is 100 seconds old
			Boolean got = entry.isYoungerThanOrEqualTo( 50 );
		Test.stopTest();

		System.assert( ! got, 'isYoungerThanOrEqualTo, when the cache entry is older, will return false' );
	}

	@isTest
	private static void isYoungerThanOrEqualTo_whenPassedANullAge_throwsAnException() // NOPMD: Test method name format
	{
		CacheEntry entry = new CacheEntry( 'TheCachedEntry' );

		Test.startTest();
			String exceptionMessage;
			try
			{
				entry.isYoungerThanOrEqualTo( null );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'isYoungerThanOrEqualTo called with a null compareAgeInSeconds', exceptionMessage, 'isYoungerThanOrEqualTo, when passed a null age, will throw an exception' );
	}
}