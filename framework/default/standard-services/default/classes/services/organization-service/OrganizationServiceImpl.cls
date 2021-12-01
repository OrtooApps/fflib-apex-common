public with sharing class OrganizationServiceImpl implements IOrganizationService
{
    public Boolean inDevOrg()
	{
		return org.OrganizationType == 'Developer Edition';
	}

	public Boolean inSandbox()
	{
		return org.IsSandbox;
	}

	public String getOrgEdition()
	{
		return org.OrganizationType;
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