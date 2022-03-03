public inherited sharing class OrgCachedSoqlExecutor
{
    private final static string SOQL_PARTITION_NAME = 'soql';

    public List<Sobject> query( String soql )
    {
        String key = generateKey( soql );
        List<Sobject> returnValues = null;

        try
        {
            returnValues = (List<Sobject>)Cache.Org.get( key );
        }
        catch ( cache.Org.OrgCacheException e )
        {
            System.debug( LoggingLevel.ERROR, 'Attempt to read from the Org Platform Cache failed for the SOQL: ' + soql );
            System.debug( LoggingLevel.ERROR, e );
        }
        if ( returnValues == null )
        {
            System.debug( LoggingLevel.INFO, 'Org Platform Cache miss when running the SOQL: ' + soql );

            returnValues = Database.query( soql );

            try
            {
                Cache.Org.put( key, returnValues, 43200, Cache.Visibility.NAMESPACE, false ); // immutable results
            }
            catch ( Exception e )
            {
                System.debug( LoggingLevel.ERROR, 'Attempt to write into the Org Platform Cache failed for the SOQL: ' + soql );
                System.debug( LoggingLevel.ERROR, e );
            }
        }

        return returnValues;
    }

    public void clearCacheFor( String soql )
    {
        Cache.Org.remove( generateKey( soql ) );
    }

    // TODO: how do we get this to just try to remove things that are in this partition?
    public void clearAllCache()
    {
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

    public String generateKey( String soql )
    {
        String subkey = EncodingUtil.convertToHex( Crypto.generateDigest( 'SHA1', Blob.valueOf( soql ) ) );
        return qualifiedKey( subkey );
    }

    private String qualifiedKey( String subkey )
    {
        return Cache.OrgPartition.createFullyQualifiedKey( PackageUtils.NAMESPACE_PREFIX, SOQL_PARTITION_NAME, subkey );
    }
}