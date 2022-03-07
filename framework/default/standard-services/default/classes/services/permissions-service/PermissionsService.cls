/**
 * Provides the ability to check if the current user has particular permissions.
 */
public with sharing class PermissionsService {

	/**
	 * States if the user has the custom permission with the given API name.
	 *
	 * @param	String	The API name of the custom permission to check the assignment of.
	 * @return	Boolean	Does the current user have the stated permission.
	 */
    public static Boolean hasPermission( String customPermissionName )
	{
		return service().hasPermission( customPermissionName );
	}

    private static IPermissionsService service()
	{
        return (IPermissionsService)Application.SERVICE.newInstance( IPermissionsService.class );
	}
}
