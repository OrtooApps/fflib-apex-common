/**
 * Provides the ability to cache the results of particular SOQL statements in the Org Wide Platform Cache.
 *
 * Should only be used for queries that reference data that does not generally change.
 *
 * If used, it is recommended that triggers are added to those objects, or code added to the UI that updates the objects
 * referenced in the SOQL that invalidate the cache.
 */
public inherited sharing class OrgCachedSoqlExecutor
{
	public class OrgCacheAccessViolationException extends Exceptions.DeveloperException {}	// this looks like a config exception, but actually the system should be built
																							// in such a way that it's never possible to get this exception

	private final static String SOQL_PARTITION_NAME = 'soql';
	private final static Integer CACHE_LIFESPAN_SECONDS = 43200;   // TODO: soft setting / option

	@testVisible
	private final static String CAN_ACCESS_SOQL_CACHE_PERMISSION = 'ProcessesCanAccessSOQLCache';

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
			if ( hasAccessToCache )
			{
				returnValues = (List<Sobject>)Cache.Org.get( key );
			}
			else
			{
				System.debug( LoggingLevel.INFO, 'Opportunity to use Org Platform Cache skipped since user does not have required permission (custom permission: ' + CAN_ACCESS_SOQL_CACHE_PERMISSION + ')' );
			}
		}
		catch ( cache.Org.OrgCacheException e )
		{
			System.debug( LoggingLevel.ERROR, 'Attempt to read from the Org Platform Cache failed for the SOQL: ' + soql );
			System.debug( LoggingLevel.ERROR, e );
		}

		if ( returnValues == null )
		{
			if ( hasAccessToCache )
			{
				System.debug( LoggingLevel.INFO, 'Org Platform Cache miss when running the SOQL: ' + soql );
			}

			returnValues = Database.query( soql );

			try
			{
				if ( hasAccessToCache )
				{
					Cache.Org.put( key, returnValues, CACHE_LIFESPAN_SECONDS, Cache.Visibility.NAMESPACE, false ); // immutable results
				}
			}
			catch ( Exception e )
			{
				System.debug( LoggingLevel.ERROR, 'Attempt to write into the Org Platform Cache failed for the SOQL: ' + soql );
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

		if ( ! hasAccessToCache )
		{
			throw new OrgCacheAccessViolationException( Label.ortoo_core_soql_cache_access_violation )
						.setErrorCode( FrameworkErrorCodes.CACHE_ACCESS_VIOLATION )
						.addContext( 'method', 'clearCacheFor' )
						.addContext( 'soql', soql );
		}
		Cache.Org.remove( generateKey( soql ) );
	}

	/**
	 * Clears the cached results for all cached SOQL
	 */
	public void clearAllCache()
	{
		if ( ! hasAccessToCache )
		{
			throw new OrgCacheAccessViolationException( Label.ortoo_core_soql_cache_access_violation )
						.setErrorCode( FrameworkErrorCodes.CACHE_ACCESS_VIOLATION )
						.addContext( 'method', 'clearAllCache' );
		}

		String fullSoqlPartitionName = Cache.OrgPartition.createFullyQualifiedPartition( PackageUtils.NAMESPACE_PREFIX, SOQL_PARTITION_NAME );
		for ( String thisKey : Cache.Org.getKeys() )
		{
			String qualifiedKey = qualifiedKey( thisKey );
			if ( Cache.Org.contains( qualifiedKey ) )
			{
				Cache.Org.remove( qualifiedKey );
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
		return Cache.OrgPartition.createFullyQualifiedKey( PackageUtils.NAMESPACE_PREFIX, SOQL_PARTITION_NAME, subkey );
	}
}