/**
 * An implementation of the ICacheAdaptor that utilises the Org Level Platform Cache.
 *
 * Due to the shared nature of the cache, all interactions with the cache require the user to have the
 * custom permission as defined in 'CAN_ACCESS_CACHE_PERMISSION'.
 *
 * Attempting to access the cache without this permission will result in an OrgCache.AccessViolationException
 */
public inherited sharing class OrgCache implements ICacheAdaptor
{
	public class AccessViolationException extends Exceptions.DeveloperException {}	// this looks like a config exception, but actually the system should be built
																							// in such a way that it's never possible to get this exception

	private final static String PARTITION_NAME = 'core';

	private Boolean hasAccessToCache
	{
		get
		{
			if ( hasAccessToCache == null )
			{
				hasAccessToCache = PermissionsService.hasAccessToCorePlatformCache();
			}
			return hasAccessToCache;
		}
		private set;
	}

	/**
	 * States if this user has access to the cache - I.E. has the custom permission defined in CAN_ACCESS_CACHE_PERMISSION
	 *
	 * @return	Boolean	States if the current user has access to the cache
	 */
	public Boolean hasAccessToCache()
	{
		return this.hasAccessToCache;
	}

	/**
	 * States that this is a cache
	 *
	 * @return	Boolean	True, stating that this instance represents a true cache
	 */
	public Boolean isACache()
	{
		return true;
	}

	/**
	 * Retrieve the cache entry with the given key.
	 *
	 * If the user does not have access to the cache, will throw an AccessViolationException.
	 * If the entry does not exist in the cache (I.E. is a "cache miss"), will return null
	 *
	 * @param	String	The key for the object to retrieve
	 * @return	Object	The cached object, if it exists
	 */
	public Object get( String key )
	{
		Long maximumAgeInSeconds = null;
		return get( key, maximumAgeInSeconds );
	}

	/**
	 * Retrieve the cache entry with the given key, but only if it was created after the stated date time
	 *
	 * If the user does not have access to the cache, will throw an AccessViolationException.
	 * If the entry does not exist in the cache (I.E. is a "cache miss"), will return null
	 *
	 * @param	String	The key for the object to retrieve
	 * @return	Object	The cached object, if it exists
	 */
	public Object get( String key, DateTime minimumDateTime )
	{
		Long maximumAgeInSeconds;
		if ( minimumDateTime != null )
		{
			maximumAgeInSeconds = DateTimeUtils.getEpochTime() - DateTimeUtils.getEpochTime( minimumDateTime );
		}
		return get( key, maximumAgeInSeconds );
	}

	/**
	 * Retrieve the cache entry with the given key, but only if it is younger than the stated number of seconds
	 *
	 * If the user does not have access to the cache, will throw an AccessViolationException.
	 * If the entry does not exist in the cache (I.E. is a "cache miss"), will return null
	 *
	 * @param	String	The key for the object to retrieve
	 * @return	Object	The cached object, if it exists
	 */
	public Object get( String key, Long maximumAgeInSeconds )
	{
		Contract.requires( String.isNotBlank( key ), 'get called with a blank key' );

		if ( ! hasAccessToCache )
		{
			throw new AccessViolationException( Label.ortoo_core_org_cache_access_violation )
							.setErrorCode( FrameworkErrorCodes.CACHE_ACCESS_VIOLATION )
							.addContext( 'method', 'get' )
							.addContext( 'key', key )
							.addContext( 'maximumAgeInSeconds', maximumAgeInSeconds );
		}

		Object rawCacheValue = Cache.Org.get( createFullyQualifiedKey( key ) );

		if ( rawCacheValue instanceOf CacheEntry )
		{
			CacheEntry cacheValue = (CacheEntry)rawCacheValue;
			if ( maximumAgeInSeconds == null || cacheValue.isYoungerThanOrEqualTo( maximumAgeInSeconds ) )
			{
				return cacheValue.getValue();
			}
		}

		if ( maximumAgeInSeconds == null ) // if we don't care about the age, then return it
		{
			return rawCacheValue;
		}

		return null; // if there is no age, or it is too old, regard it as a cache miss
	}

	/**
	 * Retrieve all the keys that are currently stored in the cache.
	 *
	 * If the user does not have access to the cache, will throw an AccessViolationException.
	 *
	 * @return	Set<String>	The keys for all cached objects
	 */
	public Set<String> getKeys()
	{
		if ( ! hasAccessToCache )
		{
			throw new AccessViolationException( Label.ortoo_core_org_cache_access_violation )
							.setErrorCode( FrameworkErrorCodes.CACHE_ACCESS_VIOLATION )
							.addContext( 'method', 'getKeys' );
		}
		return Cache.Org.getKeys();
	}

	/**
	 * Put the stated value into the stated key for the specified duration (in seconds)
	 *
	 * If the user does not have access to the cache, will throw an AccessViolationException.
	 *
	 * @param	String	The key to use for the storage of the object
	 * @param	Object	The object to store
	 * @param	Integer	The lifespan of the object within the cache, in seconds
	 * @return	Object	The cached object, if it exists
	 */
	public void put( String key, Object value, Integer lifespan )
	{
		Contract.requires( String.isNotBlank( key ), 'put called with a blank key' );
		Contract.requires( lifespan != null, 'put called with a null lifespan' );
		Contract.requires( value != null, 'put called with a null value' );
		Contract.requires( lifespan >= 0, 'put called with a negaitve lifespan' );

		if ( ! hasAccessToCache )
		{
			throw new AccessViolationException( Label.ortoo_core_org_cache_access_violation )
							.setErrorCode( FrameworkErrorCodes.CACHE_ACCESS_VIOLATION )
							.addContext( 'method', 'put' )
							.addContext( 'key', key )
							.addContext( 'value', value );
		}

		CacheEntry cacheEntry = new CacheEntry( value );

		Cache.Org.put( createFullyQualifiedKey( key ), cacheEntry, lifespan, Cache.Visibility.NAMESPACE, true ); // immutable outside of namespace
	}

	/**
	 * States if the cache currently contains an object in the given key.
	 *
	 * If the user does not have access to the cache, will throw an AccessViolationException.
	 *
	 * @param	String	The key for the object to look for
	 * @return	Boolean	Whether the key exists in the cache
	 */
	public Boolean contains( String key )
	{
		Contract.requires( String.isNotBlank( key ), 'contains called with a blank key' );

		if ( ! hasAccessToCache )
		{
			throw new AccessViolationException( Label.ortoo_core_org_cache_access_violation )
							.setErrorCode( FrameworkErrorCodes.CACHE_ACCESS_VIOLATION )
							.addContext( 'method', 'contains' )
							.addContext( 'key', key );
		}
		return Cache.Org.contains( createFullyQualifiedKey( key ) );
	}

	/**
	 * Instructs the cache to remove the object at the given key
	 *
	 * If the user does not have access to the cache, will throw an AccessViolationException.
	 *
	 * @param	String	The key to remove
	 */
	public void remove( String key )
	{
		Contract.requires( String.isNotBlank( key ), 'remove called with a blank key' );

		if ( ! hasAccessToCache )
		{
			throw new AccessViolationException( Label.ortoo_core_org_cache_access_violation )
							.setErrorCode( FrameworkErrorCodes.CACHE_ACCESS_VIOLATION )
							.addContext( 'method', 'remove' )
							.addContext( 'key', key );
		}
		Cache.Org.remove( createFullyQualifiedKey( key ) );
	}

	/**
	 * Instructs the cache to remove all objects from the cache.
	 *
	 * Is useful for clearing the cache out completely when the majority of entries would otherwise be dirty.
	 *
	 * If the user does not have access to the cache, will throw an AccessViolationException.
	 */
	public void removeAll()
	{
		if ( ! hasAccessToCache )
		{
			throw new AccessViolationException( Label.ortoo_core_org_cache_access_violation )
							.setErrorCode( FrameworkErrorCodes.CACHE_ACCESS_VIOLATION )
							.addContext( 'method', 'removeAll' );
		}

		for ( String thisKey : Cache.Org.getKeys() )
		{
			Cache.Org.remove( thisKey );
		}
	}

	private String createFullyQualifiedPartitionName()
	{
		return Cache.OrgPartition.createFullyQualifiedPartition( PackageUtils.NAMESPACE_PREFIX, PARTITION_NAME );
	}

	@testVisible
	private String createFullyQualifiedKey( String key )
	{
		return Cache.OrgPartition.createFullyQualifiedKey( PackageUtils.NAMESPACE_PREFIX, PARTITION_NAME, key );
	}
}