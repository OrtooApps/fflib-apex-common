/**
 * An implementation of the ICacheAdaptor that is benign - conforms to the Null Object Pattern.
 *
 * Allows for the use of code that will automatically interact with a cache and be able to switch that off dynamically and simply.
 *
 * All users are assumed to be allowed to use the cache, but it describes itself as 'not a cache' and effectively does nothing.
 */
public inherited sharing class NullCache implements ICacheAdaptor
{
	public Boolean hasAccessToCache()
	{
		return true;
	}

	public Boolean isACache()
	{
		return false;
	}

	public Object get( String key )
	{
		return null;
	}

	public Set<String> getKeys()
	{
		return new Set<String>();
	}

	public void put( String key, Object value, Integer lifespan ) // NOPMD: Intentionally left empty, as this should do nothing in a NullCache
	{
	}

	public Boolean contains( String key )
	{
		return false;
	}

	public void remove( String key ) // NOPMD: Intentionally left empty, as this should do nothing in a NullCache
	{
	}
}