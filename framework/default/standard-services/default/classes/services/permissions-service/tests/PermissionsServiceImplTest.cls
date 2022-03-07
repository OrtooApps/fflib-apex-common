@isTest
private with sharing class PermissionsServiceImplTest
{
    @isTest
    private static void hasPermission_givenACustomPermissionThatExists_doesNotThrowAnException() // NOPMD: test method format
    {
        Boolean hasPermission = PermissionsService.hasPermission( 'ProcessesCanAccessSOQLCache' );

        System.assert( true, 'hasPermission, when given a custom permission that exists, does not throw an exception' );
    }

    @isTest
    private static void hasPermission_givenACustomPermissionThatDoesNotExists_returnsFalse() // NOPMD: test method format
    {
        Boolean hasPermission = PermissionsService.hasPermission( 'invalid-permission-that-does-not-exist' );

        System.assertEquals( false, hasPermission, 'hasPermission, when given a custom permission that does not exist, returns false' );
    }
}