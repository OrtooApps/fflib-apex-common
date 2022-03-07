public with sharing class PermissionsServiceImpl implements IPermissionsService
{
	public Boolean hasPermission( String customPermissionName )
	{
		return FeatureManagement.checkPermission( customPermissionName );
	}
}