public class OrgCache implements ICacheAdaptor
{
	public class AccessViolationException extends Exceptions.DeveloperException {}	// this looks like a config exception, but actually the system should be built
																							// in such a way that it's never possible to get this exception

    @testVisible
	private final static String CAN_ACCESS_CACHE_PERMISSION = 'ProcessesCanAccessCache';

	public Boolean hasAccessToCache
	{
		get
		{
			if ( hasAccessToCache == null )
			{
				hasAccessToCache = PermissionsService.hasPermission( CAN_ACCESS_CACHE_PERMISSION );
			}
			return hasAccessToCache;
		}
		private set;
	}

    public Boolean hasAccessToCache()
    {
        return this.hasAccessToCache;
    }

    public Boolean isACache()
    {
        return true;
    }

    public Object get( String key )
    {
        if ( ! hasAccessToCache )
        {
            throw new AccessViolationException( Label.ortoo_core_org_cache_access_violation )
                            .setErrorCode( FrameworkErrorCodes.CACHE_ACCESS_VIOLATION )
                            .addContext( 'method', 'get' )
                            .addContext( 'key', key );
        }

        return Cache.Org.get( key );
    }

    public void put( String key, Object value, Integer lifespan )
    {
        if ( ! hasAccessToCache )
        {
            throw new AccessViolationException( Label.ortoo_core_org_cache_access_violation )
                            .setErrorCode( FrameworkErrorCodes.CACHE_ACCESS_VIOLATION )
                            .addContext( 'method', 'put' )
                            .addContext( 'key', key )
                            .addContext( 'value', value );
        }

        Cache.Org.put( key, value, lifespan, Cache.Visibility.NAMESPACE, true ); // immutable outside of namespace
    }

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

    public Boolean contains( String key )
    {
        if ( ! hasAccessToCache )
        {
            throw new AccessViolationException( Label.ortoo_core_org_cache_access_violation )
                            .setErrorCode( FrameworkErrorCodes.CACHE_ACCESS_VIOLATION )
                            .addContext( 'method', 'contains' )
                            .addContext( 'key', key );
        }
        return Cache.Org.contains( key );
    }

    public void remove( String key )
    {
        if ( ! hasAccessToCache )
        {
            throw new AccessViolationException( Label.ortoo_core_org_cache_access_violation )
                            .setErrorCode( FrameworkErrorCodes.CACHE_ACCESS_VIOLATION )
                            .addContext( 'method', 'remove' )
                            .addContext( 'key', key );
        }
        Cache.Org.remove( key );
    }

    public String createFullyQualifiedPartitionName( String namespace, String partitionName )
    {
        return Cache.OrgPartition.createFullyQualifiedPartition( namespace, partitionName );
    }

    public String createFullyQualifiedKey( String namespace, String partitionName, String subKey )
    {
        return Cache.OrgPartition.createFullyQualifiedKey(  namespace, partitionName, subkey );
    }
}