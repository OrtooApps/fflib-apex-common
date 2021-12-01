public inherited sharing class OrganizationSelector extends ortoo_SobjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Organization.OrganizationType,
            Organization.IsSandbox
        };
    }

    public Organization selectSingleRow() {
        return (Organization)
            Database.query(
                newQueryFactory()
                    .setLimit(1)
                    .toSoql()
        );
    }

    public Schema.SObjectType getSObjectType() {
        return Organization.sObjectType;
    }
}
