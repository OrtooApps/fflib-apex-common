public class OrgCache implements ICacheAdaptor
{
    public Boolean isACache()
    {
        return true;
    }

    public Object get( String key )
    {
        return Cache.Org.get( key );
    }

    public void put( String key, Object value, Integer lifespan )
    {
        Cache.Org.put( key, value, lifespan, Cache.Visibility.NAMESPACE, true ); // immutable outside of namespace
    }

    public Set<String> getKeys()
    {
        return Cache.Org.getKeys();
    }

    public Boolean contains( String key )
    {
        return Cache.Org.contains( key );
    }

    public void remove( String key )
    {
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