@isTest
private without sharing class ObjectCacheTest
{
    @isTest
    private static void constructor_setsTheCacheToOrgCache() // NOPMD: Test method name format
    {
        Test.startTest();
            ObjectCache cache = new ObjectCache();
        Test.stopTest();

        System.assert( cache.cacheWrapper instanceOf OrgCache, 'constructor, will set the cache to SessionCache' );
    }

    @isTest
    private static void setScope_whenGivenOrg_setsTheCacheToOrgCache() // NOPMD: Test method name format
    {

        ObjectCache cache = new ObjectCache();

        Test.startTest();
            cache.setScope( ObjectCache.CacheScope.ORG );
        Test.stopTest();

        System.assert( cache.cacheWrapper instanceOf OrgCache, 'setScope, when given Org, will set the cache to SessionCache' );
    }

    @isTest
    private static void setScope_whenGivenSession_setsTheCacheToSessionCache() // NOPMD: Test method name format
    {

        ObjectCache cache = new ObjectCache();

        Test.startTest();
            cache.setScope( ObjectCache.CacheScope.SESSION );
        Test.stopTest();

        System.assert( cache.cacheWrapper instanceOf SessionCache, 'setScope, when given SESSION, will set the cache to SessionCache' );
    }
}