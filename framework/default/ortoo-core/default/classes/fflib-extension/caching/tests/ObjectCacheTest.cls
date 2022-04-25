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

		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );

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

		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );
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

		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );
		cache.put( 'key', new StringIdGetter(), new List<String>{ 'hit1', 'hit2' } );

		Test.startTest();
			ObjectCache.CacheRetrieval retrieval = cache.get( 'key', ids );
		Test.stopTest();

		System.assertEquals( new Set<String>{ 'miss1Id', 'miss2Id' }, retrieval.cacheMisses, 'get, when given some string ids that exist and some that do not, will return those that do not as cache misses' );
		System.assertEquals( new Set<String>{ 'hit1Id', 'hit2Id' }, retrieval.cacheHits.keySet(), 'get, when given some string ids that exist and some that do not, will return those that do indexed by their id (checking id)' );
		System.assertEquals( new List<String>{ 'hit1', 'hit2' }, retrieval.cacheHits.values(), 'get, when given some string ids that exist and some that do not, will return those that do indexed by their id (checking content)' );
	}

	@isTest
	private static void get_whenGivenAllStringIdsThatExist_willReturnHitsAndNoMisses() // NOPMD: Test method name format
	{
		Set<String> ids = new Set<String>{ 'hit1Id', 'hit2Id' };

		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );
		cache.put( 'key', new StringIdGetter(), new List<String>{ 'hit1', 'hit2' } );

		Test.startTest();
			ObjectCache.CacheRetrieval retrieval = cache.get( 'key', ids );
		Test.stopTest();

		System.assertEquals( new Set<String>(), retrieval.cacheMisses, 'get, when given all string ids that exist, will return no cache misses' );
		System.assertEquals( new Set<String>{ 'hit1Id', 'hit2Id' }, retrieval.cacheHits.keySet(), 'get, when given all string ids that exist, will return those that do indexed by their id (checking id)' );
		System.assertEquals( new List<String>{ 'hit1', 'hit2' }, retrieval.cacheHits.values(), 'get, when given all string ids that exist, will return those that do indexed by their id (checking content)' );
	}

	@isTest
	private static void get_whenGivenABlankKey_throwsAnException() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );

		Test.startTest();
			String exceptionMessage;
			try
			{
				ObjectCache.CacheRetrieval retrieval = cache.get( 'key', new Set<String>{ 'id1', '   ', 'id2' } );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'get called with a blank entry in ids', exceptionMessage, 'get, when given a blank key, will throw an exception' );
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

		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );
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

	@isTest
	private static void get_whenGivenASingleStringIdThatExists_willReturnAsAHit() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );
		cache.put( 'key', new StringIdGetter(), new List<String>{ 'hit1', 'hit2' } );

		Test.startTest();
			ObjectCache.CacheRetrieval retrieval = cache.get( 'key', 'hit1Id' );
		Test.stopTest();

		System.assertEquals( new Set<String>(), retrieval.cacheMisses, 'get, when given a string id that exists, will return no cache misses' );
		System.assertEquals( new Set<String>{ 'hit1Id' }, retrieval.cacheHits.keySet(), 'get, when given a string id that exists, will return it as a hit indexed by their id (checking id)' );
		System.assertEquals( new List<String>{ 'hit1' }, retrieval.cacheHits.values(), 'get, when given a string id that exists, will return it as a hit indexed by their id (checking content)' );
	}

	@isTest
	private static void get_whenGivenASingleStringIdThatDoesNotExist_willReturnAsAMiss() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );
		cache.put( 'key', new StringIdGetter(), new List<String>{ 'hit1', 'hit2' } );

		Test.startTest();
			ObjectCache.CacheRetrieval retrieval = cache.get( 'key', 'miss1' );
		Test.stopTest();

		System.assertEquals( new Set<String>{ 'miss1' }, retrieval.cacheMisses, 'get, when given a string id that does not exist, will return it as a cache miss' );
		System.assertEquals( 0, retrieval.cacheHits.size(), 'get, when given a single string id does not exist, will return no hits' );
	}

	@isTest
	private static void get_whenGivenASingleIdThatExists_willReturnAsAHit() // NOPMD: Test method name format
	{
		Map<String,Contact> contacts = new Map<String,Contact>{
			'hit1' => new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ) ),
			'hit2' => new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ) )
		};
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );
		cache.put( 'key', contacts.values() );

		Test.startTest();
			ObjectCache.CacheRetrieval retrieval = cache.get( 'key', contacts.get( 'hit1' ).Id );
		Test.stopTest();

		System.assertEquals( new Set<String>(), retrieval.cacheMisses, 'get, when given an id that exists, will return no cache misses' );
		System.assertEquals( new Set<String>{ contacts.get( 'hit1' ).Id }, retrieval.cacheHits.keySet(), 'get, when given an id that exists, will return it as a hit indexed by their id (checking id)' );
		System.assertEquals( contacts.get( 'hit1' ), retrieval.cacheHits.values()[0], 'get, when given an id that exists, will return it as a hit indexed by their id (checking content)' );
	}

	@isTest
	private static void get_whenGivenASingleIdThatDoesNotExist_willReturnAsAMiss() // NOPMD: Test method name format
	{
		List<Contact> hitContacts = new List<Contact>{
			new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ) )
		};

		Contact missContact = new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ) );

		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );
		cache.put( 'key', hitContacts );

		Test.startTest();
			ObjectCache.CacheRetrieval retrieval = cache.get( 'key', missContact.Id  );
		Test.stopTest();

		System.assertEquals( new Set<String>{ missContact.Id }, retrieval.cacheMisses, 'get, when given an id that does not exist, will return it as a cache miss' );
		System.assertEquals( 0, retrieval.cacheHits.size(), 'get, when given an id does not exist, will return no hits' );
	}

	@isTest
	private static void put_whenGivenSObjectsAndOneIsNull_throwsAnException() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );

		Test.startTest();
			String exceptionMessage;
			try
			{
				cache.put( 'key', new List<Contact>{
					new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ) ),
					null,
					new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ) )
				});
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'put called with a null entry in objects', exceptionMessage, 'put, when given SObjects and one is null, will throw an exception' );
	}

	@isTest
	private static void put_whenGivenSObjectsAndOneHasNullId_throwsAnException() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );

		Test.startTest();
			String exceptionMessage;
			try
			{
				cache.put( 'key', new List<Contact>{
					new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ) ),
					new Contact(),
					new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ) )
				});
			}
			catch ( Exception e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'put called with an object that has a blank Id', exceptionMessage, 'put, when given SObjects and one has a blank Id, will throw an exception' );
	}

	@isTest
	private static void put_whenGivenAListOfSobjectsAndAValidStringFieldName_willCacheBasedOnThePassedField() // NOPMD: Test method name format
	{
		List<Contact> contacts = new List<Contact>{
			new Contact( LastName = 'hit1' ),
			new Contact( LastName = 'hit2' )
		};
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );

		Test.startTest();
			cache.put( 'key', 'LastName', contacts );
		Test.stopTest();

		ObjectCache.CacheRetrieval retrieval = cache.get( 'key', 'hit1' );

		System.assertEquals( contacts[0], retrieval.cacheHits.get( 'hit1' ), 'put, when given a list of sobjects and a valid string field name, will index by the field passed' );
	}

	@isTest
	private static void put_whenGivenSobjectsAndAnInvalidFieldName_throwsAnException() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );

		Test.startTest();
			String exceptionMessage;
			try
			{
				cache.put( 'key', 'INVALID_FIELD_NAME', new List<Contact>{ new Contact( LastName = 'hit1' ) });
			}
			catch ( ObjectCache.InvalidIdentifierException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'Unable to retrieve the String Identifier from the field INVALID_FIELD_NAME from the SObject: Contact', exceptionMessage, 'put, when given a list of sobjects and an invalid field name, will throw an exception' );
	}

	@isTest
	private static void put_whenGivenSobjectsAndANonStringFieldName_throwsAnException() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );

		Test.startTest();
			String exceptionMessage;
			try
			{
				cache.put( 'key', 'MailingLatitude', new List<Contact>{ new Contact( MailingLatitude = 0 ) });
			}
			catch ( ObjectCache.InvalidIdentifierException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'Unable to retrieve the String Identifier from the field MailingLatitude from the SObject: Contact', exceptionMessage, 'put, when given a list of sobjects and a non string field name, will throw an exception' );
	}

	@isTest
	private static void put_whenGivenSobjectsAndASobjectWithNullField_throwsAnException() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );

		Test.startTest();
			String exceptionMessage;
			try
			{
				cache.put( 'key', 'LastName', new List<Contact>{
															new Contact( LastName = 'hit1' ),
															new Contact()
														});
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'put called with an object that has a blank Id: Contact', exceptionMessage, 'put, when given a list of sobjects and one with a null Id will throw an exception' );
	}

	@isTest
	private static void put_whenGivenObjectAndOneWithANullId_throwsAnException() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );

		Test.startTest();
			String exceptionMessage;
			try
			{
				cache.put( 'key', new StringIdGetter(), new List<String>{
																'hit1',
																'nullid',
																'hit2'
															});
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'put called with an object that has a blank Id: nullid', exceptionMessage, 'put, when given a list of sobjects one with a null Id, will throw an exception' );
	}

	@isTest
	private static void put_whenGivenDifferentKeysWithTheSameIds_willNotOverwriteEachOther() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );
		String OBJECT_ID = 'id1';

		List<ObjectToStore> objectsToStore = new List<ObjectToStore>{
			new ObjectToStore( OBJECT_ID, 'value1' ),
			new ObjectToStore( OBJECT_ID, 'value2' )
		};

		Test.startTest();
			cache.put( 'key1', new ObjectIdGetter(), new List<ObjectToStore>{ objectsToStore[0] } );
			cache.put( 'key2', new ObjectIdGetter(), new List<ObjectToStore>{ objectsToStore[1] } );
		Test.stopTest();

		ObjectCache.CacheRetrieval retrieval;

		retrieval = cache.get( 'key1', OBJECT_ID );
		System.assertEquals( objectsToStore[0], retrieval.cacheHits.get( OBJECT_ID ), 'put, when given objects with the same ids, but different keys, will index them independently' );

		retrieval = cache.get( 'key2', OBJECT_ID );
		System.assertEquals( objectsToStore[1], retrieval.cacheHits.get( OBJECT_ID ), 'put, when given objects with the same ids, but different keys, will index them independently (checking index 2)' );
	}

	@isTest
	private static void put_whenGivenDifferentObjectsWithTheSameKeyAndId_willOverwriteEachOther() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );
		String OBJECT_ID = 'id1';

		List<ObjectToStore> objectsToStore = new List<ObjectToStore>{
			new ObjectToStore( OBJECT_ID, 'value1' ),
			new ObjectToStore( OBJECT_ID, 'value2' )
		};

		Test.startTest();
			cache.put( 'key1', new ObjectIdGetter(), new List<ObjectToStore>{ objectsToStore[0] } );
			cache.put( 'key1', new ObjectIdGetter(), new List<ObjectToStore>{ objectsToStore[1] } );
		Test.stopTest();

		ObjectCache.CacheRetrieval retrieval;

		retrieval = cache.get( 'key1', OBJECT_ID );
		System.assertEquals( objectsToStore[1], retrieval.cacheHits.get( OBJECT_ID ), 'put, when given objects with the same ids and keys, the latter will overwrite the earlier' );
	}

	@isTest
	private static void put_whenGivenASingleSobject_storesIt() // NOPMD: Test method name format
	{
		Contact contact = new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ) );

		Test.startTest();
			new ObjectCache().setScope( ObjectCache.CacheScope.SESSION )
					.put( 'key', contact );

		Test.stopTest();

		ObjectCache.cacheRetrieval got = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION )
											.get( 'key', contact.Id );

		System.assertEquals( contact, (Contact)got.cacheHits.get( contact.Id ), 'put, when given a single SObject, will store it' );
	}

	@isTest
	private static void put_whenGivenASingleSobjectAndAFieldName_storesIt() // NOPMD: Test method name format
	{
		Contact contact = new Contact( AccountId = TestIdUtils.generateId( Account.SobjectType ) );

		Test.startTest();
			new ObjectCache().setScope( ObjectCache.CacheScope.SESSION )
					.put( 'key', 'AccountId', contact );

		Test.stopTest();

		ObjectCache.cacheRetrieval got = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION )
											.get( 'key', contact.AccountId );

		System.assertEquals( contact, (Contact)got.cacheHits.get( contact.AccountId ), 'put, when given a single SObject and a field name, will store it' );
	}

	@isTest
	private static void put_whenGivenASingleObjectAndAnIdGetter_storesIt() // NOPMD: Test method name format
	{
		Test.startTest();
			new ObjectCache().setScope( ObjectCache.CacheScope.SESSION )
								.put( 'key', new StringIdGetter(), 'value1' );

		Test.stopTest();

		ObjectCache.cacheRetrieval got = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION )
											.get( 'key', 'value1Id' );

		System.assertEquals( 'value1', got.cacheHits.get( 'value1Id' ), 'put, when given a single object and an id getter, will store it' );
	}

	@isTest
	private static void put_whenGivenASingleObjectAndAnId_storesIt() // NOPMD: Test method name format
	{
		Test.startTest();
			new ObjectCache().setScope( ObjectCache.CacheScope.SESSION )
								.put( 'key', 'id1', 'value1' );

		Test.stopTest();

		ObjectCache.cacheRetrieval got = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION )
											.get( 'key', 'id1' );

		System.assertEquals( 'value1', got.cacheHits.get( 'id1' ), 'put, when given a single object and an id, will store it' );
	}

	@isTest
	private static void put_whenGivenASingleObjectAndAnEmptyKey_throwsAnException() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );

		Test.startTest();
			String exceptionMessage;
			try
			{
				cache.put( '	 	', 'id', 'value' );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'put called with a blank key', exceptionMessage, 'put, when given a single object and an empty key, will throw an exception' );
	}

	@isTest
	private static void put_whenGivenASingleObjectAndAnEmptyId_throwsAnException() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );

		Test.startTest();
			String exceptionMessage;
			try
			{
				cache.put( 'key', '	 	', 'value' );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'put called with a blank id', exceptionMessage, 'put, when given a single object and an empty id, will throw an exception' );
	}

	@isTest
	private static void put_whenGivenASingleNullObject_throwsAnException() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );

		Object nullObject = null;

		Test.startTest();
			String exceptionMessage;
			try
			{
				cache.put( 'key', 'id', nullObject );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'put called with a null objectToStore', exceptionMessage, 'put, when given a single object that is null, will throw an exception' );
	}

	@isTest
	private static void remove_whenGivenAKeyThatExists_willRemoveAllObjectsFromThatKey() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION )
									.put( 'key', new StringIdGetter(), new List<String>{ 'value1', 'value2', 'value3' } );

		Test.startTest();
			new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).remove( 'key' );
		Test.stopTest();

		ObjectCache.CacheRetrieval retrieval;

		retrieval = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).get( 'key', 'value1Id' );
		System.assertEquals( 0, retrieval.cacheHits.size(), 'remove, when given a key that exists, will remove all objects from that key - 1' );

		retrieval = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).get( 'key', 'value2Id' );
		System.assertEquals( 0, retrieval.cacheHits.size(), 'remove, when given a key that exists, will remove all objects from that key - 2' );

		retrieval = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).get( 'key', 'value3Id' );
		System.assertEquals( 0, retrieval.cacheHits.size(), 'remove, when given a key that exists, will remove all objects from that key - 3' );
	}

	@isTest
	private static void remove_whenGivenAKeyThatExists_willNotRemoveObjectsFromOtherKeys() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION )
											.put( 'key', new StringIdGetter(), new List<String>{ 'value1', 'value2', 'value3' } );

		Test.startTest();
			new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).remove( 'otherKey' );
		Test.stopTest();

		ObjectCache.CacheRetrieval retrieval;

		retrieval = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).get( 'key', 'value1Id' );
		System.assertEquals( 1, retrieval.cacheHits.size(), 'remove, when given a key that exists, will not remove obejcts from other keys - 1' );

		retrieval = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).get( 'key', 'value2Id' );
		System.assertEquals( 1, retrieval.cacheHits.size(), 'remove, when given a key that exists, will not remove obejcts from other keys - 2' );

		retrieval = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).get( 'key', 'value3Id' );
		System.assertEquals( 1, retrieval.cacheHits.size(), 'remove, when given a key that exists, will not remove obejcts from other keys - 3' );
	}

	@isTest
	private static void remove_whenGivenAKeyThatDoesNotExist_willNotThrowAnExecption() // NOPMD: Test method name format
	{
		Test.startTest();
			new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).remove( 'key' );
		Test.stopTest();

		System.assert( true, 'remove, when given a key that does not exist, will not throw an exception' );
	}

	@isTest
	private static void remove_whenGivenAKeyAndStringIdsThatExist_willRemoveTheOnesThatExist() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION )
									.put( 'key', new StringIdGetter(), new List<String>{ 'value1', 'value2', 'value3' } );

		Test.startTest();
			new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).remove( 'key', new Set<String>{ 'value1Id', 'value3Id' } );
		Test.stopTest();

		ObjectCache.CacheRetrieval retrieval;

		retrieval = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).get( 'key', 'value1Id' );
		System.assertEquals( 0, retrieval.cacheHits.size(), 'remove, when given a key and String ids that exist, will remove the ones that exist - 1' );

		retrieval = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).get( 'key', 'value2Id' );
		System.assertEquals( 1, retrieval.cacheHits.size(), 'remove, when given a key and String ids that exist, will not remove the ones that are not specified' );

		retrieval = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).get( 'key', 'value3Id' );
		System.assertEquals( 0, retrieval.cacheHits.size(), 'remove, when given a key and String ids that exist, will remove the ones that exist - 2' );
	}

	@isTest
	private static void remove_whenGivenAKeyAndStringIdCombinationThatDoesNotExist_willNotThrowAnExecption() // NOPMD: Test method name format
	{
		Test.startTest();
			new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).remove( 'key', new Set<String>{ 'value1Id', 'value3Id' }  );
		Test.stopTest();

		System.assert( true, 'remove, when given a key and String Id combination that does not exist, will not throw an exception' );
	}

	@isTest
	private static void remove_whenGivenAKeyAndIdsThatExist_willRemoveTheOnesThatExist() // NOPMD: Test method name format
	{
		List<Contact> contacts = new List<Contact>{
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ),
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ),
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) )
		};

		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION )
									.put( 'key', contacts );

		Test.startTest();
			new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).remove( 'key', new Set<String>{ contacts[0].Id, contacts[2].Id } );
		Test.stopTest();

		ObjectCache.CacheRetrieval retrieval;

		retrieval = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).get( 'key', contacts[0].Id );
		System.assertEquals( 0, retrieval.cacheHits.size(), 'remove, when given a key and ids that exist, will remove the ones that exist - 1' );

		retrieval = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).get( 'key', contacts[1].Id );
		System.assertEquals( 1, retrieval.cacheHits.size(), 'remove, when given a key and ids that exist, will not remove the ones that are not specified' );

		retrieval = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).get( 'key', contacts[2].Id );
		System.assertEquals( 0, retrieval.cacheHits.size(), 'remove, when given a key and ids that exist, will remove the ones that exist - 2' );
	}

	@isTest
	private static void remove_whenGivenAKeyAndIdCombinationThatDoesNotExist_willNotThrowAnExecption() // NOPMD: Test method name format
	{
		Test.startTest();
			new ObjectCache().setScope( ObjectCache.CacheScope.SESSION ).remove( 'key', new Set<Id>{ TestIdUtils.generateId( Contact.SobjectType ) }  );
		Test.stopTest();

		System.assert( true, 'remove, when given a key and Id combination that does not exist, will not throw an exception' );
	}

	@isTest
	private static void remove_whenGivenANullKey_throwsAnException() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );

		Test.startTest();
			String exceptionMessage;
			try
			{
				cache.remove( 'key', new Set<String>{ 'id1', '	 ', 'id2' } );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'remove called with a blank entry in ids', exceptionMessage, 'remove, when given a blank key, will throw an exception' );
	}

	@isTest
	private static void remove_whenGivenABlankKey_throwsAnException() // NOPMD: Test method name format
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION );

		Test.startTest();
			String exceptionMessage;
			try
			{
				cache.remove( 'key', new Set<String>{ 'id1', '	', 'id2' } );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( 'remove called with a blank entry in ids', exceptionMessage, 'remove, when given a blank key, will throw an exception' );
	}

	@isTest
	private static void remove_whenGivenABlankKey_willNotRemoveTheOtherKeys()
	{
		ObjectCache cache = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION )
									.put( 'key', new StringIdGetter(), new List<String>{ 'value1', 'value2', 'value3' } );

		Test.startTest();
			String exceptionMessage;
			try
			{
				cache.remove( 'key', new Set<String>{ 'value1Id', '	', 'value3Id' } );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ObjectCache.CacheRetrieval retrieval = new ObjectCache().setScope( ObjectCache.CacheScope.SESSION )
													.get( 'key', new Set<String>{ 'value1Id', 'value2Id', 'value3Id' } );

		System.assertEquals( 3, retrieval.cacheHits.size(), 'remove, when given a mix of blank and non-blank keys, will not remove the blank ones' );
	}

	public class StringIdGetter implements ObjectCache.IdGetter
	{
		public String getIdFor( Object objectToGetIdFor )
		{
			if ( objectToGetIdFor == 'nullid' )
			{
				return null;
			}
			return (String)objectToGetIdFor + 'Id';
		}
	}

	public class ObjectToStore
	{
		public String id;
		public String value;

		public ObjectToStore( String id, String value )
		{
			this.id = id;
			this.value = value;
		}
	}

	public class ObjectIdGetter implements ObjectCache.IdGetter
	{
		public String getIdFor( Object objectToGetIdFor )
		{
			return ((ObjectToStore)objectToGetIdFor).id;
		}
	}
}