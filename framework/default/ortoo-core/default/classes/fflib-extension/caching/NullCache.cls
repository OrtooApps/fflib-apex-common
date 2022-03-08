public class NullCache implements ICacheAdaptor
{
    public Boolean isACache()
    {
        return false;
    }

    public Object get( String key )
    {
        return null;
    }

    public void put( String key, Object value, Integer lifespan ) // NOPMD: Intentionally left empty, as this should do nothing in a NullCache
    {
    }

    public Set<String> getKeys()
    {
        return new Set<String>();
    }

    public Boolean contains( String key )
    {
        return false;
    }

    public void remove( String key ) // NOPMD: Intentionally left empty, as this should do nothing in a NullCache
    {
    }

    public String createFullyQualifiedPartitionName( String namespace, String partitionName )
    {
        return namespace + '.' + partitionName;
    }

    public String createFullyQualifiedKey( String namespace, String partitionName, String subKey )
    {
        return namespace + '.' + partitionName + '.' + subkey;
    }
}