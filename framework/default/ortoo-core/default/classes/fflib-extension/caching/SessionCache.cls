/**
 * An implementation of the ICacheAdaptor that utilises the Session Level Platform Cache.
 *
 * All users are assumed to have access to the cache.
 */
public inherited sharing class SessionCache implements ICacheAdaptor
{
	private static final String PARTITION_NAME = 'core';

	/**
	 * States if this user has access to the cache - which is always true
	 *
	 * @return	Boolean	True - Stating that the current user has access to the cache
	 */
	public Boolean hasAccessToCache()
	{
		return true;
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
	 * @param	String	The key for the object to retrieve
	 * @return	Object	The cached object, if it exists
	 */
	public Object get( String key )
	{
		Contract.requires( String.isNotBlank( key ), 'get called with a blank key' );
		return Cache.Session.get( key );
	}

	/**
	 * Retrieve all the keys that are currently stored in the cache.
	 *
	 * @return	Set<String>	The keys for all cached objects
	 */
	public Set<String> getKeys()
	{
		return Cache.Session.getKeys();
	}

	/**
	 * Put the stated value into the stated key for the specified duration (in seconds)
	 *
	 * @param	String	The key to use for the storage of the object
	 * @param	Object	The object to store
	 * @param	Integer	The lifespan of the object within the cache, in seconds
	 * @return	Object	The cached object, if it exists
	 */
	public void put( String key, Object value, Integer lifespan )
	{
		Contract.requires( String.isNotBlank( key ), 'put called with a blank key' );
		Contract.requires( value != null, 'put called with a null value (call remove instead)' );
		Contract.requires( lifespan != null, 'put called with a null lifespan' );
		Contract.requires( lifespan >= 0, 'put called with a negative lifespan' );
		// Note that the maximum is handled by Salesforce, just in case it increases

		Cache.Session.put( key, value, lifespan, Cache.Visibility.NAMESPACE, true ); // immutable outside of namespace
	}

	/**
	 * States if the cache currently contains an object in the given key.
	 *
	 * @param	String	The key for the object to look for
	 * @return	Boolean	Whether the key exists in the cache
	 */
	public Boolean contains( String key )
	{
		Contract.requires( String.isNotBlank( key ), 'contains called with a blank key' );

		return Cache.Session.contains( key );
	}

	/**
	 * Instructs the cache to remove the object at the given key
	 *
	 * @param	String	The key to remove
	 */
	public void remove( String key )
	{
		Contract.requires( String.isNotBlank( key ), 'remove called with a blank key' );

		Cache.Session.remove( key );
	}

	private String createFullyQualifiedPartitionName()
	{
		return Cache.SessionPartition.createFullyQualifiedPartition( PackageUtils.NAMESPACE_PREFIX, PARTITION_NAME );
	}

	private String createFullyQualifiedKey( String key )
	{
		return Cache.SessionPartition.createFullyQualifiedKey( PackageUtils.NAMESPACE_PREFIX, PARTITION_NAME, key );
	}
}