public with sharing class PermissionsServiceImpl implements IPermissionsService
{
	/**
    * States if the user has the custom permission required to acces the core platform cache
    *
    * @return	Boolean	Does the current user have the platform cache
    */
	public Boolean hasAccessToCorePlatformCache()
	{
		return hasCustomPermission( 'ProcessesCanAccessCache' );
	}

	/**
	 * States if the user has the custom permission with the given API name.
	 *
	 * @param	String	The API name of the custom permission to check the assignment of.
	 * @return	Boolean	Does the current user have the stated permission.
	 */
	private Boolean hasCustomPermission( String customPermissionName )
	{
		return FeatureManagement.checkPermission( customPermissionName );
	}
}