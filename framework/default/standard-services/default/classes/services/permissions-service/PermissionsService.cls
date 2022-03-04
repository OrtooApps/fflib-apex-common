public with sharing class PermissionsService {

    public static Boolean hasPermission( String customPermissionName )
	{
		return service().hasPermission( customPermissionName );
	}

    private static IPermissionsService service()
	{
        return (IPermissionsService)Application.SERVICE.newInstance( IPermissionsService.class );
	}
}
