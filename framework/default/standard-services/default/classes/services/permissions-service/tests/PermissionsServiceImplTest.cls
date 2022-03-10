@isTest
private with sharing class PermissionsServiceImplTest
{
    @isTest
    private static void hasAccessToCorePlatformCache_doesNotThrowAnException() // NOPMD: test method format
    {
        Boolean hasPermission = new PermissionsServiceImpl().hasAccessToCorePlatformCache();

        System.assertNotEquals( null, hasPermission, 'hasAccessToCorePlatformCache, does not throw an exception, and returns a value' );
    }
}