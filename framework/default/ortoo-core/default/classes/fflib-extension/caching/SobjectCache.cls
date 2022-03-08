public with sharing class SobjectCache
{
    // TODO: try writing something that gets some things from the cache, then deals with the difference.
    // TODO: maybe we need a return object that contains a list of the cache misses.

	public class CacheAccessViolationException extends Exceptions.DeveloperException {}	// this looks like a config exception, but actually the system should be built
																							// in such a way that it's never possible to get this exception
	public enum CacheScope { ORG, SESSION }

	ICacheAdaptor cacheWrapper = new OrgCache(); // by default, configure the cache to use the org version

	private final static String PARTITION_NAME = 'soql'; // TODO: same partition?
	private final static Integer CACHE_LIFESPAN_SECONDS = 28800;   // TODO: soft setting / option

	@testVisible
	private final static String CAN_ACCESS_SOQL_CACHE_PERMISSION = 'ProcessesCanAccessSOQLCache';  // TODO: same permission?

	private Boolean hasAccessToCache
	{
		get
		{
			if ( hasAccessToCache == null )
			{
				hasAccessToCache = PermissionsService.hasPermission( CAN_ACCESS_SOQL_CACHE_PERMISSION );
			}
			return hasAccessToCache;
		}
		set;
	}

    public SobjectCache setScope( CacheScope scope )
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

    // returns as many of the objects from the cache as can be returned
    public CacheRetrieval get( String key, Set<Id> ids )
    {
        return new CacheRetrieval();
    }

    public SobjectCache put( String key, String idField, List<Sobject> sobjects )
    {
        return this;
    }

    public SobjectCache clear( String key )
    {
        return this;
    }

    public SobjectCache clear( String key, Set<Id> ids )
    {
        return this;
    }

    public class CacheRetrieval
    {
        public Map<Id,SObject> cacheHits { get; private set; }
        public Set<Id> cacheMisses { get; private set; }

        private CacheRetrieval()
        {
            cacheHits = new Map<Id,SObject>();
            cacheMisses = new Set<Id>();
        }

        private CacheRetrieval addCacheMiss( Id id )
        {
            cacheMisses.add( id );
            return this;
        }

        private CacheRetrieval addCacheHit( Id id, Sobject value )
        {
            cacheHits.put( id, value );
            return this;
        }
    }
}
