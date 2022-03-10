public with sharing class PermissionsServiceImpl implements IPermissionsService
{
	public Boolean hasAccessToCorePlatformCache()
	{
		return hasCustomPermission( 'customPermissionName' );
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