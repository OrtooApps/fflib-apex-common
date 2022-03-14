/**
 * Provides the ability to cache the lists of objects using either the Session or Org Platform Cache
 *
 * Lists of objects, with a mechanism for identifying individual ones can be cached in one call.
 *
 * Its primary use case is the caching of SObjects, and the codebase contains shortcuts for handling SObjects in particular.
 *
 * Note: The lifespan of a given object is reset whenever any object in that object's list is written.
 *       That is, either the whole of the list is aged out, or none of it is.
 */
public inherited sharing class ObjectCache
{
	public class InvalidIdentifierException extends Exceptions.DeveloperException {}

	public enum CacheScope { ORG, SESSION }

	/**
	 * The data object that is returned whenever a call to retrieve objects from the cache is made.
	 *
	 * Represents:
	 * 		* The objects that could be retieved
	 * 		* The Identifiers that resulted in cache misses
	 */
	public class CacheRetrieval
	{
		/**
		 * The found records, indexed by their Ids
		 */
		public Map<String,Object> cacheHits { get; private set; }

		/**
		 * The Ids of the records that could not be found in the cache
		 */
		public Set<String> cacheMisses { get; private set; }

		private CacheRetrieval()
		{
			cacheHits = new Map<String,Object>();
			cacheMisses = new Set<String>();
		}

		private CacheRetrieval setCacheMisses( Set<String> ids )
		{
			cacheMisses = ids;
			return this;
		}

		private CacheRetrieval addCacheMiss( String id )
		{
			cacheMisses.add( id );
			return this;
		}

		private CacheRetrieval addCacheHit( String id, Object value )
		{
			cacheHits.put( id, value );
			return this;
		}
	}

	/**
	 * Interface that allows for any Object to be put into the cache.
	 * Defines the mechanism for getting the cache Id for the given object.
	 *
	 * E.g. an internal version is implemented: SobjectIdGetter.
	 * That implementation calls 'get' against the given Sobject for a configured field (which defaults to Id).
	 */
	public interface IdGetter
	{
		String getIdFor( Object objectToGetIdFor );
	}

	@testVisible
	ICacheAdaptor cacheWrapper = new OrgCache(); // by default, configure the cache to use the org version

	private final static Integer CACHE_LIFESPAN_SECONDS = 28800;   // TODO: soft setting / option

	/**
	 * Set the scope of the this cache instance.
	 *
	 * @param	CacheScope			The scope of this cache instance.
	 * @return	CachedSoqlExecutor	Itself, allowing for a fluent interface
	 */
	public ObjectCache setScope( CacheScope scope )
	{
		Contract.requires( scope != null, 'setScope called with a null scope' );

		switch on scope
		{
			when ORG
			{
				cacheWrapper = new OrgCache();
			}
			when SESSION
			{
				cacheWrapper = new SessionCache();
			}
		}

		return this;
	}

	/**
	 * Get the objects with the provided String Ids from the given object list cache key
	 *
	 * @param	String			The base key to get the objects from
	 * @param	Set<String>		The Ids of the objects to retrieve
	 * @return	CacheRetrieval	A representation of the objects retrieved from the cache along with a list of the cache misses
	 */
	public CacheRetrieval get( String key, Set<String> ids )
	{
		Contract.requires( key != null, 'get called with a null key' );
		Contract.requires( ids != null, 'get called with a null ids' );

		for ( String thisId : ids )
		{
			Contract.requires( thisId != null, 'get called with a null entry in ids' );
		}

		CacheRetrieval values = new CacheRetrieval();

		for ( String thisId : ids )
		{
			Object thisValue = cacheWrapper.get( buildFullKey( key, thisId ) );
			if ( thisValue != null )
			{
				values.addCacheHit( thisId, thisValue );
			}
			else
			{
				values.addCacheMiss( thisId );
			}
		}
		return values;
	}

	/**
	 * Get the objects with the provided SObject Ids from the given object list cache key
	 *
	 * @param	String			The base key to get the objects from
	 * @param	Set<Id>			The Ids of the SObjects to retrieve
	 * @return	CacheRetrieval	A representation of the objects retrieved from the cache along with a list of the cache misses
	 */
	public CacheRetrieval get( String key, Set<Id> ids )
	{
		Contract.requires( ids != null, 'get called with a null ids' );

		return get( key, SetUtils.convertToSetOfStrings( ids ) );
	}

	/**
	 * Get the single object with the provided String Id from the given object list cache key
	 *
	 * @param	String			The base key to get the objects from
	 * @param	String			The Id of the object to retrieve
	 * @return	CacheRetrieval	A representation of the object retrieved from the cache including if it was a cache miss
	 */
	public CacheRetrieval get( String key, String id )
	{
		Contract.requires( id != null, 'get called with a null id' );

		return get( key, new Set<String>{ id } );
	}

	/**
	 * Get the single object with the provided String Id from the given object list cache key
	 *
	 * @param	String			The base key to get the objects from
	 * @param	String			The Id of the SObject to retrieve
	 * @return	CacheRetrieval	A representation of the object retrieved from the cache including if it was a cache miss
	 */
	public CacheRetrieval get( String key, Id id )
	{
		Contract.requires( key != null, 'get called with a null key' );
		Contract.requires( id != null, 'get called with a null id' );

		return get( key, new Set<String>{ id } );
	}

	/**
	 * Put the given SObjects into the cache, using the given base key combined with the SObject's Id
	 *
	 * @param	String			The base key to put the objects into
	 * @param	List<Sobject>	The SObjects to store
	 * @return	ObjectCache	Itself, allowing for a fluent interface
	 */
	public ObjectCache put( String key, List<Sobject> sobjects )
	{
		return put( key, 'Id', sobjects );
	}

	/**
	 * Put the given SObjects into the cache, using the given base key combined with the value stored
	 * in the SObject field as defined by idField
	 *
	 * @param	String			The base key to put the objects into
	 * @param	String			The field to get the individual SObject identifiers from (field value must be a non-null String)
	 * @param	List<Sobject>	The SObjects to store
	 * @return	ObjectCache	Itself, allowing for a fluent interface
	 */
	public ObjectCache put( String key, String idField, List<Sobject> sobjects )
	{
		Contract.requires( idField != null, 'put called with a null idField' );
		return put( key, new SobjectIdGetter( idField ), sobjects );
	}

	// TODO: implement put( String key, IdGetter idGetter, Object objectToStore )
	// TODO: implement put( String key, String idField, Sobject sobjectToStore )
	// TODO: implement put( String key, Sobject sobjectToStore )

	/**
	 * Put the given Objects into the cache, using the given base key combined with the value that is returned from
	 * each object when the IdGetter is called against it
	 *
	 * @param	String			The base key to put the objects into
	 * @param	IdGetter		The mechanism for getting the Id from each of the given objects
	 * @param	List<Object>	The Objects to store
	 * @return	ObjectCache	Itself, allowing for a fluent interface
	 */
	public ObjectCache put( String key, IdGetter idGetter, List<Object> objects )
	{
		Contract.requires( key != null, 'put called with a null key' );
		Contract.requires( idGetter != null, 'put called with a null idGetter' );
		Contract.requires( objects != null, 'put called with a null objects' );

		for ( Object thisObject : objects )
		{
			Contract.assert( thisObject != null, 'put called with a null entry in objects' );
			String thisId = idGetter.getIdFor( thisObject );

			Contract.assert( thisId != null, 'put called with an object that has a null Id: ' + thisObject );

			cacheWrapper.put( buildFullKey( key, thisId ), thisObject, CACHE_LIFESPAN_SECONDS );
		}

		return this;
	}

	/**
	 * Remove all the cached objects from the given base key.
	 *
	 * @param	String			The base key to remove the objects from.
	 * @return	ObjectCache	Itself, allowing for a fluent interface
	 */
	public ObjectCache remove( String keyToRemove )
	{
		Contract.requires( keyToRemove != null, 'remove called with a null keyToRemove' );

		Set<String> allExistingKeys = cacheWrapper.getKeys();

		for ( String thisExistingKey : allExistingKeys )
		{
			if ( isForKey( thisExistingKey, keyToRemove ) )
			{
				cacheWrapper.remove( thisExistingKey );
			}
		}
		return this;
	}

	/**
	 * Remove the cached SObjects from the given base key that been stored against the given Ids
	 *
	 * @param	String			The base key to remove the SObjects from.
	 * @param	Set<Id>			The cache identifiers of the SObjects to remove.
	 * @return	ObjectCache	Itself, allowing for a fluent interface
	 */
	public ObjectCache remove( String key, Set<Id> ids )
	{
		Contract.requires( ids != null, 'remove called with a null ids' );
		return remove( key, SetUtils.convertToSetOfStrings( ids ) );
	}

	/**
	 * Remove the cached objects from the given base key that been stored against the given String Ids
	 *
	 * @param	String			The base key to remove the objects from.
	 * @param	Set<Id>			The cache identifiers of the objects to remove.
	 * @return	ObjectCache	Itself, allowing for a fluent interface
	 */
	public ObjectCache remove( String key, Set<String> ids )
	{
		Contract.requires( key != null, 'remove called with a null key' );
		Contract.requires( ids != null, 'remove called with a null ids' );

		// This is two loops because we want to check all the ids before we remove anything
		for ( String thisId : ids )
		{
			Contract.assert( thisId != null, 'remove called with a null entry in ids' );
		}

		for ( String thisId : ids )
		{
			cacheWrapper.remove( buildFullKey( key, thisId ) );
		}
		return this;
	}

	private String buildFullKey( String key, String id )
	{
		return buildKeyPrefix( key ) + id;
	}

	private Boolean isForKey( String fullKey, String key )
	{
		return fullKey.startsWith( buildKeyPrefix( key ) );
	}

	private String buildKeyPrefix( String key )
	{
		return key + 'xXXx';
	}

	private class SobjectIdGetter implements IdGetter
	{
		String idField;

		private SobjectIdGetter( String idField )
		{
			this.idField = idField;
		}

		public String getIdFor( Object objectToGetIdFor )
		{
			try
			{
				return (String)((Sobject)objectToGetIdFor).get( idField );
			}
			catch ( Exception e )
			{
				throw new InvalidIdentifierException( 'Unable to retrieve the String Identifier from the field ' + idField + ' from the SObject: ' + objectToGetIdFor + ' - maybe it is not a String or Id?', e )
							.setErrorCode( FrameworkErrorCodes.UNABLE_TO_RETRIEVE_IDENTIFIER )
							.addContext( 'object', objectToGetIdFor )
							.addContext( 'idField', idField );
			}
		}
	}
}
