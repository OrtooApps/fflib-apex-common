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

        System.assertEquals( expected, got, 'likeString, when called with a field, will add a LIKE to the generated SOQL' );
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

        System.assertEquals( expected, got, 'likeString, when called with a string name for a field will add a LIKE to the generated SOQL' );
    }

    @isTest
    private static void inSet_field_stringValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.inSet( Account.Name, new Set<String>{ 'one', 'two' } );
        Test.stopTest();

        String expected = 'Name IN (\'one\',\'two\')';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a field and a set of Strings, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_stringName_stringValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.inSet( 'Account.Name', new Set<String>{ 'one', 'two' } );
        Test.stopTest();

        String expected = 'Account.Name IN (\'one\',\'two\')';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a string field name and a set of Strings, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_field_longValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.inSet( Account.Name, new Set<Long>{ 1, 2, 3 } );
        Test.stopTest();

        String expected = 'Name IN (1,2,3)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a field and a set of Longs, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_stringName_longValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.inSet( 'Account.Name', new Set<Long>{ 1, 2, 3 } );
        Test.stopTest();

        String expected = 'Account.Name IN (1,2,3)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a string field name and a set of Longs, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_field_integerValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.inSet( Account.Name, new Set<Integer>{ 1, 2, 3 } );
        Test.stopTest();

        String expected = 'Name IN (1,2,3)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a field and a set of Integers, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_stringName_integerValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.inSet( 'Account.Name', new Set<Integer>{ 1, 2, 3 } );
        Test.stopTest();

        String expected = 'Account.Name IN (1,2,3)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a string field name and a set of Integers, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_field_idValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Id testId1 = TestIdUtils.generateId( Account.sobjectType );
        Id testId2 = TestIdUtils.generateId( Account.sobjectType );

        Test.startTest();
            criteria.inSet( Account.Name, new Set<Id>{ testId1, testId2 } );
        Test.stopTest();

        String expected = 'Name IN (\''+ testId1 +'\',\''+ testId2 +'\')';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a field and a set of Ids, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_stringName_idValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Id testId1 = TestIdUtils.generateId( Account.sobjectType );
        Id testId2 = TestIdUtils.generateId( Account.sobjectType );

        Test.startTest();
            criteria.inSet( 'Account.Name', new Set<Id>{ testId1, testId2 } );
        Test.stopTest();

        String expected = 'Account.Name IN (\''+ testId1 +'\',\''+ testId2 +'\')';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a string field name and a set of Ids, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_field_doubleValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.inSet( Account.Name, new Set<Double>{ 1.1, 2.2, 3.3 } );
        Test.stopTest();

        String expected = 'Name IN (1.1,2.2,3.3)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a field and a set of Doubles, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_stringName_doubleValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.inSet( 'Account.Name', new Set<Double>{ 1.1, 2.2, 3.3 } );
        Test.stopTest();

        String expected = 'Account.Name IN (1.1,2.2,3.3)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a string field name and a set of Doubles, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_field_decimalValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.inSet( Account.Name, new Set<Decimal>{ 1.1, 2.2, 3.3 } );
        Test.stopTest();

        String expected = 'Name IN (1.1,2.2,3.3)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a field and a set of Decimals, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_stringName_decimalValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.inSet( 'Account.Name', new Set<Decimal>{ 1.1, 2.2, 3.3 } );
        Test.stopTest();

        String expected = 'Account.Name IN (1.1,2.2,3.3)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a string field name and a set of Decimals, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_field_dateValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Date date1 = Date.newInstance( 2021, 10, 28 );
        Date date2 = Date.newInstance( 2021, 1, 28 );

        Test.startTest();
            criteria.inSet( Account.Name, new Set<Date>{ date1, date2 } );
        Test.stopTest();

        String expected = 'Name IN (2021-10-28,2021-01-28)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a field and a set of Dates, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_stringName_dateValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Date date1 = Date.newInstance( 2021, 10, 28 );
        Date date2 = Date.newInstance( 2021, 1, 28 );

        Test.startTest();
            criteria.inSet( 'Account.Name', new Set<Date>{ date1, date2 } );
        Test.stopTest();

        String expected = 'Account.Name IN (2021-10-28,2021-01-28)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a string field name and a set of Dates, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_field_dateTimeValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        DateTime date1 = DateTime.newInstanceGmt( 2021, 10, 28, 11, 30, 00 );
        DateTime date2 = DateTime.newInstanceGmt( 2021, 1, 28, 11, 35, 00 );

        Test.startTest();
            criteria.inSet( Account.Name, new Set<DateTime>{ date1, date2 } );
        Test.stopTest();

        String expected = 'Name IN (2021-10-28T11:30:00Z,2021-01-28T11:35:00Z)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a field and a set of DateTimes, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_stringName_dateTimeValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        DateTime date1 = DateTime.newInstanceGmt( 2021, 10, 28, 11, 30, 00 );
        DateTime date2 = DateTime.newInstanceGmt( 2021, 1, 28, 11, 35, 00 );

        Test.startTest();
            criteria.inSet( 'Account.Name', new Set<DateTime>{ date1, date2 } );
        Test.stopTest();

        String expected = 'Account.Name IN (2021-10-28T11:30:00Z,2021-01-28T11:35:00Z)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a string field name and a set of DateTimes, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_field_objectValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.inSet( Account.Name, new Set<Object>{ 1, 2 } );
        Test.stopTest();

        String expected = 'Name IN (1,2)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a field and a set of DateTimes, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void inSet_stringName_objectValues_whenCalled_addsAnInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.inSet( 'Account.Name', new Set<Object>{ 1, 2 } );
        Test.stopTest();

        String expected = 'Account.Name IN (1,2)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'inSet, when called with a string field name and a set of DateTimes, will add an IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_field_stringValues_whenCalled_addsANotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<String>{ 'one', 'two' } );
        Test.stopTest();

        String expected = 'Name NOT IN (\'one\',\'two\')';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a field and a set of Strings, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_stringName_stringValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( 'Account.Name', new Set<String>{ 'one', 'two' } );
        Test.stopTest();

        String expected = 'Account.Name NOT IN (\'one\',\'two\')';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a string field name and a set of Strings, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_field_longValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Long>{ 1, 2, 3 } );
        Test.stopTest();

        String expected = 'Name NOT IN (1,2,3)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a field and a set of Longs, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_stringName_longValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( 'Account.Name', new Set<Long>{ 1, 2, 3 } );
        Test.stopTest();

        String expected = 'Account.Name NOT IN (1,2,3)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a string field name and a set of Longs, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_field_integerValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Integer>{ 1, 2, 3 } );
        Test.stopTest();

        String expected = 'Name NOT IN (1,2,3)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a field and a set of Integers, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_stringName_integerValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( 'Account.Name', new Set<Integer>{ 1, 2, 3 } );
        Test.stopTest();

        String expected = 'Account.Name NOT IN (1,2,3)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a string field name and a set of Integers, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_field_idValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Id testId1 = TestIdUtils.generateId( Account.sobjectType );
        Id testId2 = TestIdUtils.generateId( Account.sobjectType );

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Id>{ testId1, testId2 } );
        Test.stopTest();

        String expected = 'Name NOT IN (\''+ testId1 +'\',\''+ testId2 +'\')';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a field and a set of Ids, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_stringName_idValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Id testId1 = TestIdUtils.generateId( Account.sobjectType );
        Id testId2 = TestIdUtils.generateId( Account.sobjectType );

        Test.startTest();
            criteria.notInSet( 'Account.Name', new Set<Id>{ testId1, testId2 } );
        Test.stopTest();

        String expected = 'Account.Name NOT IN (\''+ testId1 +'\',\''+ testId2 +'\')';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a string field name and a set of Ids, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_field_doubleValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Double>{ 1.1, 2.2, 3.3 } );
        Test.stopTest();

        String expected = 'Name NOT IN (1.1,2.2,3.3)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a field and a set of Doubles, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_stringName_doubleValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( 'Account.Name', new Set<Double>{ 1.1, 2.2, 3.3 } );
        Test.stopTest();

        String expected = 'Account.Name NOT IN (1.1,2.2,3.3)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a string field name and a set of Doubles, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_field_decimalValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Decimal>{ 1.1, 2.2, 3.3 } );
        Test.stopTest();

        String expected = 'Name NOT IN (1.1,2.2,3.3)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a field and a set of Decimals, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_stringName_decimalValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( 'Account.Name', new Set<Decimal>{ 1.1, 2.2, 3.3 } );
        Test.stopTest();

        String expected = 'Account.Name NOT IN (1.1,2.2,3.3)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a string field name and a set of Decimals, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_field_dateValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Date date1 = Date.newInstance( 2021, 10, 28 );
        Date date2 = Date.newInstance( 2021, 1, 28 );

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Date>{ date1, date2 } );
        Test.stopTest();

        String expected = 'Name NOT IN (2021-10-28,2021-01-28)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a field and a set of Dates, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_stringName_dateValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Date date1 = Date.newInstance( 2021, 10, 28 );
        Date date2 = Date.newInstance( 2021, 1, 28 );

        Test.startTest();
            criteria.notInSet( 'Account.Name', new Set<Date>{ date1, date2 } );
        Test.stopTest();

        String expected = 'Account.Name NOT IN (2021-10-28,2021-01-28)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a string field name and a set of Dates, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_field_dateTimeValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        DateTime date1 = DateTime.newInstanceGmt( 2021, 10, 28, 11, 30, 00 );
        DateTime date2 = DateTime.newInstanceGmt( 2021, 1, 28, 11, 35, 00 );

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<DateTime>{ date1, date2 } );
        Test.stopTest();

        String expected = 'Name NOT IN (2021-10-28T11:30:00Z,2021-01-28T11:35:00Z)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a field and a set of DateTimes, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_stringName_dateTimeValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        DateTime date1 = DateTime.newInstanceGmt( 2021, 10, 28, 11, 30, 00 );
        DateTime date2 = DateTime.newInstanceGmt( 2021, 1, 28, 11, 35, 00 );

        Test.startTest();
            criteria.notInSet( 'Account.Name', new Set<DateTime>{ date1, date2 } );
        Test.stopTest();

        String expected = 'Account.Name NOT IN (2021-10-28T11:30:00Z,2021-01-28T11:35:00Z)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a string field name and a set of DateTimes, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_field_objectValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Object>{ 1, 2 } );
        Test.stopTest();

        String expected = 'Name NOT IN (1,2)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a field and a set of DateTimes, will add NOT IN to the generated SOQL' );
    }

    @isTest
    private static void notInSet_stringName_objectValues_whenCalled_addsNotInToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( 'Account.Name', new Set<Object>{ 1, 2 } );
        Test.stopTest();

        String expected = 'Account.Name NOT IN (1,2)';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notInSet, when called with a string field name and a set of DateTimes, will add NOT IN to the generated SOQL' );
    }

}