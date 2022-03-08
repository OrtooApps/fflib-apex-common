public interface ICacheAdaptor
{
    Boolean isACache();
    Object get( String key );
    void put( String key, Object value, Integer lifespan );
    Set<String> getKeys();
    Boolean contains( String key );
    void remove( String key );
    String createFullyQualifiedPartitionName( String namespace, String partitionName );
    String createFullyQualifiedKey( String namespace, String partitionName, String subKey );
}