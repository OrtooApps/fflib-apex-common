public with sharing class BulkSobjectCache
{
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

    public BulkSobjectCache setScope( CacheScope scope )
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

    public CacheRetrieval get( String key, Set<Id> ids )
    {
        CacheRetrieval values = new CacheRetrieval();

        Map<Id,Sobject> cachedObjects = (Map<Id,Sobject>)cacheWrapper.get( createFullyQualifiedKey( key ) );

        if ( cachedObjects == null )
        {
            return values.setCacheMisses( ids );
        }

        for ( Id thisId : ids )
        {
            SObject thisValue = cachedObjects.get( thisId );
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

    public BulkSobjectCache put( String key, List<Sobject> sobjects )
    {
        return put( key, 'Id', sobjects );
    }

    public BulkSobjectCache put( String key, String idField, List<Sobject> sobjects )
    {
        String fullyQualifiedKey  = createFullyQualifiedKey( key );
        Map<Id,Sobject> cachedObjects = (Map<Id,Sobject>)cacheWrapper.get( fullyQualifiedKey );

        if ( cachedObjects == null )
        {
            cachedObjects = new Map<Id,Sobject>();
        }

        for ( Sobject thisSobject : sobjects )
        {
            cachedObjects.put( (Id)thisSobject.get( idField ), thisSobject );
        }
        cacheWrapper.put( fullyQualifiedKey, cachedObjects, CACHE_LIFESPAN_SECONDS );

        return this;
    }

    public BulkSobjectCache remove( String key )
    {
        cacheWrapper.remove( createFullyQualifiedKey( key ) );
        return this;
    }

    public BulkSobjectCache remove( String key, Set<Id> ids )
    {
        Map<Id,Sobject> cachedObjects = (Map<Id,Sobject>)cacheWrapper.get( createFullyQualifiedKey( key ) );
        for ( Id thisId : ids )
        {
            cachedObjects.remove( thisId );
        }
        cacheWrapper.put( createFullyQualifiedKey( key ), cachedObjects, CACHE_LIFESPAN_SECONDS );
        return this;
    }

    private String createFullyQualifiedKey( String subKey )
    {
        return cacheWrapper.createFullyQualifiedKey( PackageUtils.NAMESPACE_PREFIX, PARTITION_NAME, subkey );
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

        private CacheRetrieval setCacheMisses( Set<Id> ids )
        {
            cacheMisses = ids;
            return this;
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
