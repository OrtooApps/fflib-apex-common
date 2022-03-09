/**
 * Provides the ability to cache the results of particular SOQL statements in the Org Wide Platform Cache.
 *
 * Should only be used for queries that reference data that does not generally change.
 *
 * If used, it is recommended that triggers are added to those objects, or code added to the UI that updates the objects
 * referenced in the SOQL that invalidate the cache.
 */
public inherited sharing class CachedSoqlExecutor //NOPMD: incorrect report of too many public methods caused by inner classes
{
	public enum CacheScope { NONE, ORG, SESSION }

	ICacheAdaptor cacheWrapper = new OrgCache(); // by default, configure the cache to use the org version

	private final static String SOQL_PARTITION_NAME = 'core';
	private final static Integer CACHE_LIFESPAN_SECONDS = 28800;   // TODO: soft setting / option

	/**
	 * Set the scope of the this cache instance.
	 *
	 * @param	CacheScope			The scope of this cache instance.
	 * @return	CachedSoqlExecutor	Itself, allowing for a fluent interface
	 */
	public CachedSoqlExecutor setScope( CacheScope scope )
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
			when NONE
			{
				cacheWrapper = new NullCache();
			}
		}

		return this;
	}

	/**
	 * Perform the given query, first checking if the Org Platform Cache Partition contains results for that SOQL.
	 * If so, the cached versions are returned.
	 * If not, the query is executed against the database and the result cached.
	 * If, for any reason, a cache read or write cannot be performed, the method will continue without an exception.
	 * Errors can be seen in the System.debug log.
	 *
	 * @param   String			The SOQL to return the results for
	 * @return	List<Sobject>	The records that match
	 */
	public List<Sobject> query( String soql )
	{
		Contract.requires( soql != null, 'query called with a null soql' );

		String key = generateKey( soql );
		List<Sobject> returnValues = null;

		try
		{
			if ( cacheWrapper.hasAccessToCache() )
			{
				returnValues = (List<Sobject>)cacheWrapper.get( key );
			}
			else
			{
				if ( cacheWrapper.isACache() )
				{
					System.debug( LoggingLevel.INFO, 'Opportunity to use Platform Cache skipped since user does not have required permission' ); // TODO: can we get the permission name into this?
				}
			}
		}
		catch ( Exception e )
		{
			System.debug( LoggingLevel.ERROR, 'Attempt to read from the Platform Cache failed for the SOQL: ' + soql );
			System.debug( LoggingLevel.ERROR, e );
		}

		if ( returnValues == null )
		{
			if ( cacheWrapper.hasAccessToCache() && cacheWrapper.isACache() )
			{
				System.debug( LoggingLevel.INFO, 'Platform Cache miss when running the SOQL: ' + soql );
			}

			returnValues = Database.query( soql );

			try
			{
				if ( cacheWrapper.hasAccessToCache() )
				{
					cacheWrapper.put( key, returnValues, CACHE_LIFESPAN_SECONDS );
				}
			}
			catch ( Exception e )
			{
				System.debug( LoggingLevel.ERROR, 'Attempt to write into the Platform Cache failed for the SOQL: ' + soql );
				System.debug( LoggingLevel.ERROR, e );
			}
		}

		return returnValues;
	}

	/**
	 * Clears the cached results for the given SOQL that are held in the Org Platform Cache Partition
	 *
	 * @param   String			The SOQL to clear the cache for
	 */
	public void clearCacheFor( String soql )
	{
		Contract.requires( soql != null, 'clearCacheFor called with a null soql' );
		cacheWrapper.remove( generateKey( soql ) );
	}

	/**
	 * Clears the cached results for all cached SOQL
	 */
	public void clearAllCache()
	{
		String fullSoqlPartitionName = cacheWrapper.createFullyQualifiedPartitionName( PackageUtils.NAMESPACE_PREFIX, SOQL_PARTITION_NAME );
		for ( String thisKey : cacheWrapper.getKeys() )
		{
			String qualifiedKey = qualifiedKey( thisKey );
			if ( cacheWrapper.contains( qualifiedKey ) )
			{
				cacheWrapper.remove( qualifiedKey );
			}
		}
	}

	private String generateKey( String soql )
	{
		String subkey = EncodingUtil.convertToHex( Crypto.generateDigest( 'SHA1', Blob.valueOf( soql ) ) );
		return qualifiedKey( subkey );
	}

	private String qualifiedKey( String subkey )
	{
		return cacheWrapper.createFullyQualifiedKey( PackageUtils.NAMESPACE_PREFIX, SOQL_PARTITION_NAME, subkey );
	}
}