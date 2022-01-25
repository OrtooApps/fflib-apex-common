@isTest
private without sharing class ortoo_CriteriaTest
{
    @isTest
    private static void likeString_field_whenCalled_addsALikeToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.likeString( Contact.Name, 'thing%' );
        Test.stopTest();

        String expected = 'Name LIKE \'thing%\'';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'likeString, when called with a field, will add a LIKE to the Generated SOQL' );
    }

    @isTest
    private static void likeString_stringName_whenCalled_addsALikeToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.likeString( 'Account.Name', 'thing%' );
        Test.stopTest();

        String expected = 'Account.Name LIKE \'thing%\'';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'likeString, when called with a string name for a field will add a LIKE to the Generated SOQL' );
    }
}