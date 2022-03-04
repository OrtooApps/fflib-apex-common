public with sharing class OrganizationService
{
	public static Boolean inDevOrg()
	{
		return service().inDevOrg();
	}

	public static Boolean inSandbox()
	{
		return service().inSandbox();
	}

	public static String getOrgEdition()
	{
		return service().getOrgEdition();
	}

	private static IOrganizationService service()
	{
		return (IOrganizationService)Application.SERVICE.newInstance( IOrganizationService.class );
	}
}
