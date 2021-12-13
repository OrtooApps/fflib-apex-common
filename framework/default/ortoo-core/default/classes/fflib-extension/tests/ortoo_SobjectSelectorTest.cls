@isTest
private without sharing class ortoo_SobjectSelectorTest
{
    @isTest
    private static void constructor_whenCalled_willCreateASelectorThatHasSecurityEnabled() // NOPMD: Test method name format
    {
        ortoo_SobjectSelector selector = new TestableSelector();

        System.assertEquals( true, selector.isEnforcingFls(), 'constructor, when called, will create a selector that has FLS enabled' );
        System.assertEquals( true, selector.isEnforcingCrud(), 'constructor, when called, will create a selector that has CRUD security enabled' );
    }

    @isTest
    private static void ignoreFls_whenCalled_willDisableFlsChecking() // NOPMD: Test method name format
    {
        ortoo_SobjectSelector selector = new TestableSelector();
        selector.ignoreFls();

        System.assertEquals( false, selector.isEnforcingFls(), 'ignoreFls, when called, will disable FLS checking' );
    }

    class TestableSelector extends ortoo_SobjectSelector
    {
        public List<Schema.SObjectField> getSObjectFieldList() {
            return new List<Schema.SObjectField> {
                Account.Name
            };
        }

        public Schema.SObjectType getSObjectType() {
            return Account.sObjectType;
        }
    }
}