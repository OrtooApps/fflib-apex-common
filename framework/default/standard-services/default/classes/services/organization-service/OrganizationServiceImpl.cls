public with sharing class OrganizationServiceImpl implements IOrganizationService
{
	public Boolean inDevOrg()
	{
		Boolean inDevOrg = false;
		try
		{
			inDevOrg = org.OrganizationType == 'Developer Edition';
		}
		catch ( Exception e )
		{
			ServiceUtils.logAndRethrow( e );
		}
		return inDevOrg;
	}

	public Boolean inSandbox()
	{
		Boolean inSandbox = false;
		try
		{
			inSandbox = org.IsSandbox;
		}
		catch ( Exception e )
		{
			ServiceUtils.logAndRethrow( e );
		}
		return inSandbox;
	}

	public String getOrgEdition()
	{
		String orgEdition;
		try
		{
			orgEdition = org.OrganizationType;
		}
		catch ( Exception e )
		{
			ServiceUtils.logAndRethrow( e );
		}
		return orgEdition;
	}

	private static Organization org
	{
		get
		{
			if ( org == null )
			{
				org = organizationSelector.selectSingleRow();
			}
			return org;
		}
		set;
	}

	private static OrganizationSelector organizationSelector
	{
		get
		{
			if ( organizationSelector == null )
			{
				organizationSelector = ((OrganizationSelector)Application.SELECTOR.newInstance( Organization.SobjectType ) );
			}
			return organizationSelector;
		}
		set;
	}
}