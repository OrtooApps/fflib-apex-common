/**
 * An implementation of the ICacheAdaptor that utilises the Session Level Platform Cache.
 *
 * All users are assumed to have access to the cache.
 */
public class SessionCache implements ICacheAdaptor
{
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
		return Cache.Session.get( key );
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
		Cache.Session.put( key, value, lifespan, Cache.Visibility.NAMESPACE, true ); // immutable outside of namespace
	}

	/**
	 * Retrieve a set of the current keys of objects stored in this cache.
	 *
	 * @return	Set<String>	The keys that currently exist in the cache
	 */
	public Set<String> getKeys()
	{
		return Cache.Session.getKeys();
	}

	/**
	 * States if the cache currently contains an object in the given key.
	 *
	 * @param	String	The key for the object to look for
	 * @return	Boolean	Whether the key exists in the cache
	 */
	public Boolean contains( String key )
	{
		return Cache.Session.contains( key );
	}

	/**
	 * Instucts the cache to remove the object at the given key
	 *
	 * @param	String	The key to remove
	 */
	public void remove( String key )
	{
		Cache.Session.remove( key );
	}

	public String createFullyQualifiedPartitionName( String partitionName )
	{
		return Cache.SessionPartition.createFullyQualifiedPartition( PackageUtils.NAMESPACE_PREFIX, partitionName );
	}

	public String createFullyQualifiedKey( String partitionName, String subKey )
	{
		return Cache.SessionPartition.createFullyQualifiedKey( PackageUtils.NAMESPACE_PREFIX, partitionName, subkey );
	}
}