public class SessionCache implements ICacheAdaptor
{
    public Boolean isACache()
    {
        return true;
    }

    public Object get( String key )
    {
        return Cache.Session.get( key );
    }

    public void put( String key, Object value, Integer lifespan )
    {
        Cache.Session.put( key, value, lifespan, Cache.Visibility.NAMESPACE, true ); // immutable outside of namespace
    }

    public Set<String> getKeys()
    {
        return Cache.Session.getKeys();
    }

    public Boolean contains( String key )
    {
        return Cache.Session.contains( key );
    }

    public void remove( String key )
    {
        Cache.Session.remove( key );
    }

    public String createFullyQualifiedPartitionName( String namespace, String partitionName )
    {
        return Cache.SessionPartition.createFullyQualifiedPartition( namespace, partitionName );
    }

    public String createFullyQualifiedKey( String namespace, String partitionName, String subKey )
    {
        return Cache.SessionPartition.createFullyQualifiedKey( namespace, partitionName, subkey );
    }
}