@isTest
private without sharing class MapUtilsTest
{
	/**
	 * @method	remove( Map<Id,Sobject> sobjectsById, Set<Id> idsToRemove )
	 * @case  	When given a Map and Set of Ids to remove
	 * @result	Will remove the objects from the map that are keyed with the given ids
	 */
	@isTest
	private static void remove_whenGivenAMapAndASetOfIds_willRemoveTheObjectsFromTheMapThatAreKeyedByTheIds() // NOPMD: Test method name format
	{
		List<Id> idsToRemove = new List<Id>{
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() ) // includes a couple that are not in the original map
		};

		List<Id> idsToKeep = new List<Id>{
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() ),
			TestIdUtils.generateId( Account.getSObjectType() )
		};

		Map<Id,Sobject> mapToUpdate = new Map<Id,Sobject>(
			new List<Sobject>
			{
				new Account( Id = idsToKeep[0] ),
				new Account( Id = idsToRemove[0] ),
				new Account( Id = idsToKeep[1] ),
				new Account( Id = idsToRemove[1] ),
				new Account( Id = idsToKeep[2] ),
				new Account( Id = idsToRemove[2] )
			}
		);

		MapUtils.remove( mapToUpdate, SetUtils.convertToSetOfIds( idsToRemove ) );

		System.assertEquals( 3, mapToUpdate.size(), 'remove, when given a map and a set of ids, will remove the objects from the map that are keyed with the given ids - checking size' );
		System.assert( mapToUpdate.keySet().contains( idsToKeep[0] ), 'remove, when given a map and a set of ids, will remove the objects from the map that are keyed with the given ids - checking id to keep 0' );
		System.assert( mapToUpdate.keySet().contains( idsToKeep[1] ), 'remove, when given a map and a set of ids, will remove the objects from the map that are keyed with the given ids - checking id to keep 1' );
		System.assert( mapToUpdate.keySet().contains( idsToKeep[2] ), 'remove, when given a map and a set of ids, will remove the objects from the map that are keyed with the given ids - checking id to keep 2' );
	}

	/**
	 * @method	remove( Map<Id,Sobject> sobjectsById, Set<Id> idsToRemove )
	 * @case  	When given a null map
	 * @result	Will throw an exception
	 */
	@isTest
	private static void remove_whenGivenANullMap_willThrowAnException() // NOPMD: Test method name format
	{
		Test.startTest();
			String exceptionMessage;
			try
			{
				MapUtils.remove( null, new Set<Id>{ TestIdUtils.generateId( Account.sobjectType ) } );
			}
			catch ( Contract.RequiresException e )
			{
				exceptionMessage = e.getMessage();
			}
		Test.stopTest();

		ortoo_Asserts.assertContains( '', exceptionMessage, 'remove, when given a null map, will throw an exception' );
	}

	/**
	 * @method	remove( Map<Id,Sobject> sobjectsById, Set<Id> idsToRemove )
	 * @case  	When given a null set
	 * @result	Will not change the map
	 */
	@isTest
	private static void remove_whenGivenANullSet_willNotChangeTheMap() // NOPMD: Test method name format
	{
		Map<Id,Sobject> mapToUpdate = new Map<Id,Sobject>(
			new List<Sobject>
			{
				new Account( Id = TestIdUtils.generateId( Account.sobjectType ) ),
				new Account( Id = TestIdUtils.generateId( Account.sobjectType ) )
			}
		);

		MapUtils.remove( mapToUpdate, null );

		System.assertEquals( 2, mapToUpdate.size(), 'remove, when given a map and a null set of ids, will not change the map' );
	}

	/**
	 * @method	remove( Map<Id,Sobject> sobjectsById, Set<Id> idsToRemove )
	 * @case  	When given an empty set
	 * @result	Will not change the map
	 */
	@isTest
	private static void remove_whenGivenAnEmptySet_willNotChangeTheMap() // NOPMD: Test method name format
	{
		Map<Id,Sobject> mapToUpdate = new Map<Id,Sobject>(
			new List<Sobject>
			{
				new Account( Id = TestIdUtils.generateId( Account.sobjectType ) ),
				new Account( Id = TestIdUtils.generateId( Account.sobjectType ) )
			}
		);

		MapUtils.remove( mapToUpdate, new Set<Id>() );

		System.assertEquals( 2, mapToUpdate.size(), 'remove, when given a map and an empty set of ids, will not change the map' );
	}

	/**
	 * @method	remove( Map<Id,Sobject> sobjectsById, Set<Id> idsToRemove )
	 * @case  	When given an empty map
	 * @result	Will not change the map
	 */
	@isTest
	private static void remove_whenGivenAnEmptyMap_willNotChangeTheMap() // NOPMD: Test method name format
	{
		Map<Id,Sobject> mapToUpdate = new Map<Id,Sobject>();

		Set<Id> idsToRemove = new Set<Id>
		{
			TestIdUtils.generateId( Account.SobjectType ),
			TestIdUtils.generateId( Account.SobjectType ),
			TestIdUtils.generateId( Account.SobjectType )
		};

		MapUtils.remove( mapToUpdate, idsToRemove );

		System.assertEquals( 0, mapToUpdate.size(), 'remove, when given an empty map and a set of ids, will not change the map' );
	}
}