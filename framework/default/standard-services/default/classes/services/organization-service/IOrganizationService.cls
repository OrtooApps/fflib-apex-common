public interface IOrganizationService
{
    Boolean inDevOrg();
	Boolean inSandbox();
	String getOrgEdition();
}