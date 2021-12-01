public inherited sharing class LicensedUsersSelector extends ortoo_SObjectSelector {

    public final static String NAMESPACE_PREFIX = PackageUtils.NAMESPACE_PREFIX;

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            UserPackageLicense.UserId
        };
    }

    public Schema.SObjectType getSObjectType() {
        return UserPackageLicense.sObjectType;
    }

    public List<UserPackageLicense> selectActiveUsersByUserIds( Set<Id> userIds ) {
        return (List<UserPackageLicense>)
            Database.query(
                newQueryFactory()
                    .setCondition( 'UserId IN :userIds AND PackageLicense.NamespacePrefix = :NAMESPACE_PREFIX AND PackageLicense.Status != \'Expired\'' )
                    .toSoql()
        );
    }
}
