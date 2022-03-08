public with sharing class SobjectCache
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

    public CacheRetrieval get( String key, Set<Id> ids )
    {
        CacheRetrieval values = new CacheRetrieval();
        for ( Id thisId : ids )
        {
            SObject thisValue = (SObject)cacheWrapper.get( createFullyQualifiedKey( key, thisId ) );
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

    public SobjectCache put( String key, List<Sobject> sobjects )
    {
        return put( key, 'Id', sobjects );
    }

    public SobjectCache put( String key, String idField, List<Sobject> sobjects )
    {
        for ( Sobject thisSobject : sobjects )
        {
            final String thisKey = createFullyQualifiedKey( key, (Id)thisSobject.get( idField ) );
            cacheWrapper.put( thisKey, thisSobject, CACHE_LIFESPAN_SECONDS );
        }
        return this;
    }

    public SobjectCache remove( String subkeyToRemove )
    {
        Set<String> keys = cacheWrapper.getKeys();

        for ( String thisKey : keys )
        {
            if ( isAKeyFor( thisKey, subkeyToRemove ) )
            {
                cacheWrapper.remove( thisKey );
            }
        }
        return this;
    }

    public SobjectCache remove( String key, Set<Id> ids )
    {
        for ( Id thisId : ids )
        {
            cacheWrapper.remove( createFullyQualifiedKey( key, thisId ) );
        }
        return this;
    }

    private Boolean isAKeyFor( String keyToCheck, String keyToCheckAgainst )
    {
        return keyToCheck.startsWith( createKeyPrefix( keyToCheckAgainst ) );
    }

    private String createFullyQualifiedKey( String subKey, String id )
    {
        return createKeyPrefix( subKey ) + id;
    }

    private String createKeyPrefix( String subKey )
    {
        return cacheWrapper.createFullyQualifiedKey( PackageUtils.NAMESPACE_PREFIX, PARTITION_NAME, subkey ) + 'x';
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
