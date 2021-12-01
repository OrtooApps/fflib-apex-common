public inherited sharing class LicenseSelector extends ortoo_SobjectSelector {

    public final static String NAMESPACE_PREFIX = PackageUtils.NAMESPACE_PREFIX;

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            PackageLicense.AllowedLicenses,
            PackageLicense.ExpirationDate,
            PackageLicense.NamespacePrefix,
            PackageLicense.Status,
            PackageLicense.UsedLicenses
        };
    }

    public Schema.SObjectType getSObjectType() {
        return PackageLicense.sObjectType;
    }

    // TODO: potentially the namespace gets passed in?
    public PackageLicense selectSingleRow() {
        List<PackageLicense> licenses = (List<PackageLicense>)Database.query(
                                                                newQueryFactory()
                                                                    .setCondition( 'NamespacePrefix =:NAMESPACE_PREFIX AND Status != \'Expired\'' )
                                                                    .toSoql()
                                                            );
        if ( licenses.isEmpty() ) {
            return null; // I don't like returning null...
        }
        return licenses[0];
    }
}
