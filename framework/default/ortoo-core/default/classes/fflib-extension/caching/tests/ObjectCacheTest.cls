@isTest
private without sharing class ObjectCacheTest
{
	@isTest
	private static void constructor_setsTheCacheToOrgCache() // NOPMD: Test method name format
	{
		Test.startTest();
			ObjectCache cache = new ObjectCache();
		Test.stopTest();

		System.assert( cache.cacheWrapper instanceOf OrgCache, 'constructor, will set the cache to SessionCache' );
	}

	@isTest
	private static void setScope_whenGivenOrg_setsTheCacheToOrgCache() // NOPMD: Test method name format
	{

		ObjectCache cache = new ObjectCache();

		Test.startTest();
			cache.setScope( ObjectCache.CacheScope.ORG );
		Test.stopTest();

		System.assert( cache.cacheWrapper instanceOf OrgCache, 'setScope, when given Org, will set the cache to SessionCache' );
	}

	@isTest
	private static void setScope_whenGivenSession_setsTheCacheToSessionCache() // NOPMD: Test method name format
	{

		ObjectCache cache = new ObjectCache();

		Test.startTest();
			cache.setScope( ObjectCache.CacheScope.SESSION );
		Test.stopTest();

		System.assert( cache.cacheWrapper instanceOf SessionCache, 'setScope, when given SESSION, will set the cache to SessionCache' );
	}

	@isTest
	private static void get_whenGivenAStringKeyThatDoesNotExist_willReturnAllAsCacheMisses() // NOPMD: Test method name format
	{
		Set<String> ids = new Set<String>{ 'missId1', 'missId2' };

		ObjectCache cache = new ObjectCache();

		Test.startTest();
			ObjectCache.CacheRetrieval retrieval = cache.get( 'nonekey', ids );
		Test.stopTest();

		System.assertEquals( ids, retrieval.cacheMisses, 'get, when given a string key that does not exist, will return all as cache misses' );
		System.assertEquals( 0, retrieval.cacheHits.size(), 'get, when given a string key that does not exist, will return no cache hits' );
	}

	@isTest
	private static void get_whenGivenStringIdsThatDoNotExist_willReturnAllAsCacheMisses() // NOPMD: Test method name format
	{
		Set<String> ids = new Set<String>{ 'miss1Id', 'miss2Id' };

		ObjectCache cache = new ObjectCache();
		cache.put( 'key', new StringIdGetter(), new List<String>{ 'hit1', 'hit2' } );

		Test.startTest();
			ObjectCache.CacheRetrieval retrieval = cache.get( 'key', ids );
		Test.stopTest();

		System.assertEquals( ids, retrieval.cacheMisses, 'get, when given string ids that do not exist in the given key, will return all as cache misses' );
		System.assertEquals( 0, retrieval.cacheHits.size(), 'get, when given string ids that do not exist in the given key, will return no cache hits' );
	}

	@isTest
	private static void get_whenGivenSomeStringIdsThatExist_willReturnHitsAndMisses() // NOPMD: Test method name format
	{
		Set<String> ids = new Set<String>{ 'miss1Id', 'miss2Id', 'hit1Id', 'hit2Id' };

		ObjectCache cache = new ObjectCache();
		cache.put( 'key', new StringIdGetter(), new List<String>{ 'hit1', 'hit2' } );

		Test.startTest();
			ObjectCache.CacheRetrieval retrieval = cache.get( 'key', ids );
		Test.stopTest();

		System.assertEquals( new Set<String>{ 'miss1Id', 'miss2Id' }, retrieval.cacheMisses,       'get, when given some string ids that exist and some that do not, will return those that do not as cache misses' );
		System.assertEquals( new Set<String>{ 'hit1Id', 'hit2Id' }, retrieval.cacheHits.keySet(),  'get, when given some string ids that exist and some that do not, will return those that do indexed by their id (checking id)' );
		System.assertEquals( new List<String>{ 'hit1', 'hit2' }, retrieval.cacheHits.values(), 'get, when given some string ids that exist and some that do not, will return those that do indexed by their id (checking content)' );
	}

	@isTest
	private static void get_whenGivenAllStringIdsThatExist_willReturnHitsAndNoMisses() // NOPMD: Test method name format
	{
		Set<String> ids = new Set<String>{ 'hit1Id', 'hit2Id' };

		ObjectCache cache = new ObjectCache();
		cache.put( 'key', new StringIdGetter(), new List<String>{ 'hit1', 'hit2' } );

		Test.startTest();
			ObjectCache.CacheRetrieval retrieval = cache.get( 'key', ids );
		Test.stopTest();

		System.assertEquals( new Set<String>(), retrieval.cacheMisses, 'get, when given all string ids that exist, will return no cache misses' );
		System.assertEquals( new Set<String>{ 'hit1Id', 'hit2Id' }, retrieval.cacheHits.keySet(),  'get, when given all string ids that exist, will return those that do indexed by their id (checking id)' );
		System.assertEquals( new List<String>{ 'hit1', 'hit2' }, retrieval.cacheHits.values(), 'get, when given all string ids that exist, will return those that do indexed by their id (checking content)' );
	}

	@isTest
	private static void get_whenGivenANullKey_throwsAnException() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache();

		Test.startTest();
			String exceptionMessage;
			try
			{
				ObjectCache.CacheRetrieval retrieval = cache.get( 'key', new Set<String>{ 'id1', null, 'id2' } );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'get called with a null entry in ids', exceptionMessage, 'get, when given a null key, will throw an exception' );
	}

	@isTest
	private static void get_whenGivenSomeSobjectIdsThatExist_willReturnHitsAndMisses() // NOPMD: Test method name format
	{
		Map<String,Contact> contacts = new Map<String,Contact>{
			'hit1' => new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ) ),
			'hit2' => new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ) ),
			'miss1' => new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ) ),
			'miss2' => new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ) )
		};

		Set<Id> ids = new Set<Id>{
			contacts.get( 'hit1' ).Id,
			contacts.get( 'hit2' ).Id,
			contacts.get( 'miss1' ).Id,
			contacts.get( 'miss2' ).Id
		};

		ObjectCache cache = new ObjectCache();
		cache.put( 'key', new List<SObject>{ contacts.get( 'hit1' ), contacts.get( 'hit2' ) } );

		Test.startTest();
			ObjectCache.CacheRetrieval retrieval = cache.get( 'key', ids );
		Test.stopTest();

		Set<String> expectedMisses = new Set<String>{ contacts.get( 'miss1' ).Id, contacts.get( 'miss2' ).Id };
		Set<String> expectedHitIds = new Set<String>{ contacts.get( 'hit1' ).Id, contacts.get( 'hit2' ).Id };
		List<Sobject> expectedHits = new List<Sobject>{  contacts.get( 'hit1' ), contacts.get( 'hit2' ) };

		System.assertEquals( expectedMisses, retrieval.cacheMisses, 'get, when given some ids that exist and some that do not, will return those that do not as cache misses' );
		System.assertEquals( expectedHitIds, retrieval.cacheHits.keySet(), 'get, when given some ids that exist and some that do not, will return those that do indexed by their id (checking id)' );
		System.assertEquals( expectedHits[0], retrieval.cacheHits.values()[0], 'get, when given some ids that exist and some that do not, will return those that do indexed by their id (checking content)' );
		System.assertEquals( expectedHits[1], retrieval.cacheHits.values()[1], 'get, when given some ids that exist and some that do not, will return those that do indexed by their id (checking content)' );
	}

	// get, when given a single string key that exists, will return it as a cache hit
	// get, when given a single string key that does not exist, will return it as a cache miss
	// get, when given a single id key that exists, will return it as a cache hit
	// get, when given a single id key that does not exist, will return it as a cache miss

	// put, when given a list of sobjects, will cache them by their id
	// put, when given a list of sobjects, and one is null, will throw an exception
	// put, when given a list of sobjects, and one has a null id, will throw an exception
	// put, when given a list of sobjects and a name of a string field, will cache the sobjects by the value in that field
	// put, when given a list of sobjects and a name of a string field, and one has a null value, will throw an exception

	// put, when given a list of sobjects and the name of a non string field, will throw an exception

	// put, when given a list of objects and an idgetter, will cache them based on the return of the idgetter
	// put, when given a list of objects and an idgetter, and one of the objects is null, will throw an exception
	// put, when given a list of objects and an idgetter, and one of the objects returns a null id, will throw an exception

	// put, when given a list of objects and an idgetter, when objects are already in the cache, will not overwrite ones not referenced twice
	// put, when given a list of objects and an idgetter, when objects are already in the cache, will not overwrite ones that are referenced twice

	// put, when called multiple times with different base keys will not overwrite the other keys

	// remove, when called with a key that exists, will remove all objects from the cache for that key
	// remove, when called with a key that does not exist, will not throw an exception

	// remove, when called with a key and and a set of Ids that exist, will remove the ones that do, leave the others
	// remove, when called with a key and and a set of Ids that do not exist, will not throw an exception

	// remove, when called with a key and and a set of Strings that exist, will remove the ones that do, leave the others
	// remove, when called with a key and and a set of Strings that do not exist, will not throw an exception

	public class StringIdGetter implements ObjectCache.IdGetter
	{
		public String getIdFor( Object objectToGetIdFor )
		{
			return (String)objectToGetIdFor + 'Id';
		}
	}


}

