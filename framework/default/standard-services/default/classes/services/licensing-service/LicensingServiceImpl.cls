/**
 * Implementation of the Licensing Service.  For details, see the Licensing Service.
 * No methods in this class should be called except by itself or the LicensingService
 */
public with sharing class LicensingServiceImpl implements ILicensingService
{
    public Boolean productIsLicensed()
    {
		return ( licenseDetails != null || OrganizationService.inDevOrg() || OrganizationService.inSandbox() );
	}

    private static PackageLicense licenseDetails
    {
        get
        {
            if ( licenseDetails == null )
            {
                licenseDetails = licenseSelector.selectSingleRow();
            }
            return licenseDetails;
        }
        set;
    }

    private static LicenseSelector licenseSelector
    {
        get
        {
            if ( licenseSelector == null )
            {
                licenseSelector = ((LicenseSelector)Application.selector.newInstance( PackageLicense.SobjectType ));
            }
            return licenseSelector;
        }
        set;
    }
}