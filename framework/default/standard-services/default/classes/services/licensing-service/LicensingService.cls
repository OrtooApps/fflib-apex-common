/**
 * Provides the ability to request information on the licensing of the current product, in the current org
 */
public with sharing class LicensingService {

    public class LicenseInvalidException extends Exception {}

    /**
     * States if the current product is licensed for use in this org
     *
     * @return Boolean States if this product is licensed in this orgs
     */
    public static Boolean productIsLicensed() {
        return service().productIsLicensed();
    }

    private static ILicensingService service() {
        return (ILicensingService)Application.SERVICE.newInstance( ILicensingService.class );
	}
}
