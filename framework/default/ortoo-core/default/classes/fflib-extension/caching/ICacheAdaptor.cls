/**
 * Defines an interface that can be used to wrap / adapt a caching mechanism.
 *
 * Specifically designed to support the wrapping of the static Apex methods for:
 *      * Cache.Org / Cache.OrgPartition
 *      * Cache.Session / Cache.SessionPartition
 *
 * This allows for the types of cache to be used interchangably / and dynamically
 *
 * @group Cache
 */
public interface ICacheAdaptor
{
	Boolean hasAccessToCache();
	Boolean isACache();
	Object get( String key );
	Object get( String key, DateTime minimumDateTime );
	Object get( String key, Long maximumAgeInSeconds );
	void put( String key, Object value, Integer lifespan );
	Boolean contains( String key );
	void remove( String key );
	Set<String> getKeys();
}