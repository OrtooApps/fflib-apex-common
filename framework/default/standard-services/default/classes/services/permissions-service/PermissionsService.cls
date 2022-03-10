/**
 * Provides the ability to check if the current user has particular permissions.
 */
public with sharing class PermissionsService {

	/**
	 * States if the user has rights to access the core platform cache
	 *
	 * @return	Boolean	Does the current user have the stated permission.
	 */
	public static Boolean hasAccessToCorePlatformCache()
	{
		return service().hasAccessToCorePlatformCache();
	}

    private static IPermissionsService service()
	{
        return (IPermissionsService)Application.SERVICE.newInstance( IPermissionsService.class );
	}
}
