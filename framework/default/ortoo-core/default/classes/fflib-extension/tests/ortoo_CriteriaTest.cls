@isTest
private without sharing class ortoo_CriteriaTest
{
    @isTest
    private static void byDefault_joinsCriteriaWithAnd() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            String got = criteria
                            .equalTo(Account.Name, 'Example')
                            .equalTo(Account.AccountNumber, '1234567')
                            .toSoql();
        Test.stopTest();

        String expected = 'Name=\'Example\' AND AccountNumber=\'1234567\'';

        System.assertEquals( expected, got, 'by default, will join the generated SOQL with AND' );
    }

    @isTest
    private static void orCriteria_whenGivenCriteria_resultsInOrsInTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            String got = criteria
                            .orCriteria()
                            .equalTo(Account.Name, 'Example')
                            .equalTo(Account.AccountNumber, '1234567')
                            .toSoql();
        Test.stopTest();

        String expected = 'Name=\'Example\' OR AccountNumber=\'1234567\'';

        System.assertEquals( expected, got, 'orCriteria, when given further criteria, will join the generated SOQL with OR' );
    }

    @isTest
    private static void andCriteria_whenGivenCriteria_resultsInAndsInTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            String got = criteria
                            .andCriteria()
                            .equalTo(Account.Name, 'Example')
                            .equalTo(Account.AccountNumber, '1234567')
                            .toSoql();
        Test.stopTest();

        String expected = 'Name=\'Example\' AND AccountNumber=\'1234567\'';

        System.assertEquals( expected, got, 'andCriteria, when given further criteria, will join the generated SOQL with AND' );
    }

    @isTest
    private static void andOrCriteria_whenGivenSubCriteria_addsTheSubCriteriaSetAsOr() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            String got = criteria
                            .equalTo(Account.Name, 'Example')
                            .addOrCriteria(
                                new ortoo_Criteria()
                                        .equalTo(Account.AccountNumber, '0001')
                                        .equalTo(Account.AccountNumber, '0002'))
                            .toSoql();
        Test.stopTest();

        String expected = 'Name=\'Example\' AND (AccountNumber=\'0001\' OR AccountNumber=\'0002\')';

        System.assertEquals( expected, got, 'andOrCriteria, when given sub criteria, will add the subcriteria set as OR criteria' );
    }

    @isTest
    private static void andAndCriteria_whenGivenSubCriteria_addsTheSubCriteriaSetAsAnd() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            String got = criteria
                            .equalTo(Account.Name, 'Example')
                            .addAndCriteria(
                                new ortoo_Criteria()
                                        .equalTo(Account.AccountNumber, '0001')
                                        .equalTo(Account.AccountNumber, '0002'))
                            .toSoql();
        Test.stopTest();

        String expected = 'Name=\'Example\' AND (AccountNumber=\'0001\' AND AccountNumber=\'0002\')';

        System.assertEquals( expected, got, 'andAndCriteria, when given sub criteria, will add the subcriteria set as AND criteria' );
    }

    @isTest
    private static void formulaCriteria_whenGivenCriteria_addsTheCriteriaInLineWithTheFormula() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            String got = criteria
                            .formulaCriteria('(1 OR 2) AND 3')
                            .equalTo(Account.AccountNumber, '0001')
                            .equalTo(Account.AccountNumber, '0002')
                            .equalTo(Account.ShippingCountry, 'USA')
                            .toSoql();
        Test.stopTest();

        String expected = '(AccountNumber=\'0001\' OR AccountNumber=\'0002\') AND ShippingCountry=\'USA\'';

        System.assertEquals( expected, got, 'formulaCriteria, when given futher criteria, will add the criteria in line with the formula' );
    }

    @isTest
    private static void formulaCriteria_whenGivenRepeatedReferences_addsTheCriteriaInLineWithTheFormula() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            String got = criteria
                            .formulaCriteria('(1 OR 2) AND (1 OR 3)')
                            .equalTo(Account.AccountNumber, '0001')
                            .equalTo(Account.AccountNumber, '0002')
                            .equalTo(Account.ShippingCountry, 'USA')
                            .toSoql();
        Test.stopTest();

        String expected = '(AccountNumber=\'0001\' OR AccountNumber=\'0002\') AND (AccountNumber=\'0001\' OR ShippingCountry=\'USA\')';

        System.assertEquals( expected, got, 'formulaCriteria, when given repeated references in the formula criteria, will add the repeated references' );
    }

    @isTest
    private static void formulaCriteria_whenGivenFewerCriteriaThanReferenced_willThrowAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            String exceptionMessage;
            try
            {
                String got = criteria
                    .formulaCriteria('(1 OR 2) AND 3')
                    .equalTo(Account.AccountNumber, '0001')
                    .equalTo(Account.AccountNumber, '0002')
                    .toSoql();
            }
            catch ( fflib_Criteria.CriteriaException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'Expected a formula expression with number: 3', exceptionMessage, 'formulaCriteria, when given a formula and fewer criteria than referenced, will throw an exception' );
    }

    @isTest
    private static void equalTo_field_whenGivenAString_addsAnEqualsToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.equalTo( Contact.Name, 'contactName' );
        Test.stopTest();

        String expected = 'Name=\'contactName\'';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'equalTo, when called with a field and a string value, will add a = to the generated SOQL' );
    }

    @isTest
    private static void equalTo_field_whenGivenANumber_addsAnEqualsToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.equalTo( Contact.Name, 12 );
        Test.stopTest();

        String expected = 'Name=12';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'equalTo, when called with a field and a numeric value, will add a = to the generated SOQL' );
    }

    @isTest
    private static void equalTo_stringName_whenGivenAString_addsAnEqualsToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.equalTo( 'Contact.Name', 'contactName' );
        Test.stopTest();

        String expected = 'Contact.Name=\'contactName\'';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'equalTo, when called with a string field name and a string value, will add a = to the generated SOQL' );
    }

    @isTest
    private static void equalTo_stringName_whenGivenANumber_addsAnEqualsToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.equalTo( 'Contact.Name', 12 );
        Test.stopTest();

        String expected = 'Contact.Name=12';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'equalTo, when called with a string field name and a numeric value, will add a = to the generated SOQL' );
    }

    @isTest
    private static void notEqualTo_field_whenGivenAString_addsANotEqualsToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notEqualTo( Contact.Name, 'contactName' );
        Test.stopTest();

        String expected = 'Name!=\'contactName\'';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notEqualTo, when called with a field and a string value, will add a != to the generated SOQL' );
    }

    @isTest
    private static void notEqualTo_field_whenGivenANumber_addsANotEqualsToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notEqualTo( Contact.Name, 12 );
        Test.stopTest();

        String expected = 'Name!=12';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notEqualTo, when called with a field and a numeric value, will add a != to the generated SOQL' );
    }

    @isTest
    private static void notEqualTo_stringName_whenGivenAString_addsANotEqualsToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notEqualTo( 'Contact.Name', 'contactName' );
        Test.stopTest();

        String expected = 'Contact.Name!=\'contactName\'';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notEqualTo, when called with a string field name and a string value, will add a != to the generated SOQL' );
    }

    @isTest
    private static void notEqualTo_stringName_whenGivenANumber_addsANotEqualsToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notEqualTo( 'Contact.Name', 12 );
        Test.stopTest();

        String expected = 'Contact.Name!=12';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'notEqualTo, when called with a string field name and a numeric value, will add a != to the generated SOQL' );
    }

    @isTest
    private static void greaterOrEqualTo_field_whenGivenAString_addsAClauseToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.greaterOrEqualTo( Contact.Name, 'contactName' );
        Test.stopTest();

        String expected = 'Name>=\'contactName\'';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'greaterOrEqualTo, when called with a field and a string value, will add a >= to the generated SOQL' );
    }

    @isTest
    private static void greaterOrEqualTo_field_whenGivenANumber_addsAClauseToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.greaterOrEqualTo( Contact.Name, 12 );
        Test.stopTest();

        String expected = 'Name>=12';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'greaterOrEqualTo, when called with a field and a numeric value, will add a >= to the generated SOQL' );
    }

    @isTest
    private static void greaterOrEqualTo_stringName_whenGivenAString_addsAClauseToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.greaterOrEqualTo( 'Contact.Name', 'contactName' );
        Test.stopTest();

        String expected = 'Contact.Name>=\'contactName\'';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'greaterOrEqualTo, when called with a string field name and a string value, will add a >= to the generated SOQL' );
    }

    @isTest
    private static void greaterOrEqualTo_stringName_whenGivenANumber_addsAClauseToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.greaterOrEqualTo( 'Contact.Name', 12 );
        Test.stopTest();

        String expected = 'Contact.Name>=12';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'greaterOrEqualTo, when called with a string field name and a numeric value, will add a >= to the generated SOQL' );
    }

    @isTest
    private static void greaterThan_field_whenGivenAString_addsAClauseToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.greaterThan( Contact.Name, 'contactName' );
        Test.stopTest();

        String expected = 'Name>\'contactName\'';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'greaterThan, when called with a field and a string value, will add a > to the generated SOQL' );
    }

    @isTest
    private static void greaterThan_field_whenGivenANumber_addsAClauseToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.greaterThan( Contact.Name, 12 );
        Test.stopTest();

        String expected = 'Name>12';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'greaterThan, when called with a field and a numeric value, will add a > to the generated SOQL' );
    }

    @isTest
    private static void greaterThan_stringName_whenGivenAString_addsAClauseToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.greaterThan( 'Contact.Name', 'contactName' );
        Test.stopTest();

        String expected = 'Contact.Name>\'contactName\'';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'greaterThan, when called with a string field name and a string value, will add a > to the generated SOQL' );
    }

    @isTest
    private static void greaterThan_stringName_whenGivenANumber_addsAClauseToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.greaterThan( 'Contact.Name', 12 );
        Test.stopTest();

        String expected = 'Contact.Name>12';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'greaterThan, when called with a string field name and a numeric value, will add a > to the generated SOQL' );
    }

    @isTest
    private static void lessOrEqualTo_field_whenGivenAString_addsAClauseToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.lessOrEqualTo( Contact.Name, 'contactName' );
        Test.stopTest();

        String expected = 'Name<=\'contactName\'';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'lessOrEqualTo, when called with a field and a string value, will add a <= to the generated SOQL' );
    }

    @isTest
    private static void lessOrEqualTo_field_whenGivenANumber_addsAClauseToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.lessOrEqualTo( Contact.Name, 12 );
        Test.stopTest();

        String expected = 'Name<=12';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'lessOrEqualTo, when called with a field and a numeric value, will add a <= to the generated SOQL' );
    }

    @isTest
    private static void lessOrEqualTo_stringName_whenGivenAString_addsAClauseToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.lessOrEqualTo( 'Contact.Name', 'contactName' );
        Test.stopTest();

        String expected = 'Contact.Name<=\'contactName\'';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'lessOrEqualTo, when called with a string field name and a string value, will add a <= to the generated SOQL' );
    }

    @isTest
    private static void lessOrEqualTo_stringName_whenGivenANumber_addsAClauseToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.lessOrEqualTo( 'Contact.Name', 12 );
        Test.stopTest();

        String expected = 'Contact.Name<=12';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'lessOrEqualTo, when called with a string field name and a numeric value, will add a <= to the generated SOQL' );
    }


    @isTest
    private static void lessThan_field_whenGivenAString_addsAClauseToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.lessThan( Contact.Name, 'contactName' );
        Test.stopTest();

        String expected = 'Name<\'contactName\'';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'lessThan, when called with a field and a string value, will add a < to the generated SOQL' );
    }

    @isTest
    private static void lessThan_field_whenGivenANumber_addsAClauseToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.lessThan( Contact.Name, 12 );
        Test.stopTest();

        String expected = 'Name<12';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'lessThan, when called with a field and a numeric value, will add a < to the generated SOQL' );
    }

    @isTest
    private static void lessThan_stringName_whenGivenAString_addsAClauseToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.lessThan( 'Contact.Name', 'contactName' );
        Test.stopTest();

        String expected = 'Contact.Name<\'contactName\'';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'lessThan, when called with a string field name and a string value, will add a < to the generated SOQL' );
    }

    @isTest
    private static void lessThan_stringName_whenGivenANumber_addsAClauseToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.lessThan( 'Contact.Name', 12 );
        Test.stopTest();

        String expected = 'Contact.Name<12';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'lessThan, when called with a string field name and a numeric value, will add a < to the generated SOQL' );
    }

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
    private static void likeString_field_whenCalledWithAnEmptyString_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.likeString( Contact.Name, '' );
        Test.stopTest();

        String expected = '';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'likeString, when called with a field and an empty string, will not add a LIKE to the generated SOQL' );
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
    private static void likeString_stringName_whenCalledWithAnEmptyString_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.likeString( 'Contact.Name', '' );
        Test.stopTest();

        String expected = '';
        String got = criteria.toSOQL();

        System.assertEquals( expected, got, 'likeString, when called with a string name and an empty string, will not add a LIKE to the generated SOQL' );
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
    private static void isSet_field_stringValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( Account.Name, new Set<String>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a field and an empty set of Strings, will throw an exception' );
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
    private static void isSet_stringName_stringValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( 'Account.Name', new Set<String>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a string name and an empty set of Strings, will throw an exception' );
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
    private static void isSet_field_longValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( Account.Name, new Set<Long>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a field and an empty set of Strings, will throw an exception' );
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
    private static void isSet_stringName_longValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( 'Account.Name', new Set<Long>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a string name and an empty set of Longs, will throw an exception' );
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
    private static void isSet_field_integerValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( Account.Name, new Set<Integer>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a field and an empty set of Integers, will throw an exception' );
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
    private static void isSet_stringName_integerValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( 'Account.Name', new Set<Integer>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a string field name and an empty set of Integers, will throw an exception' );
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
    private static void isSet_field_IdValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( Account.Name, new Set<Id>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a field and an empty set of Ids, will throw an exception' );
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
    private static void isSet_stringName_IdValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( 'Account.Name', new Set<Id>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a string name and an empty set of Ids, will throw an exception' );
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
    private static void isSet_field_doubleValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( Account.Name, new Set<Double>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a field and an empty set of Doubles, will throw an exception' );
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
    private static void isSet_stringName_doubleValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( 'Account.Name', new Set<Double>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a string field name and an empty set of Doubles, will throw an exception' );
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
    private static void isSet_field_decimalValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( Account.Name, new Set<Decimal>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a field and an empty set of Decimal, will throw an exception' );
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
    private static void isSet_stringName_decimalValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( 'Account.Name', new Set<Decimal>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a string field name and an empty set of Decimals, will throw an exception' );
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
    private static void isSet_field_dateValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( Account.Name, new Set<Date>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a field and an empty set of Dates, will throw an exception' );
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
    private static void isSet_stringName_dateValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( 'Account.Name', new Set<Date>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a string field name and an empty set of Dates, will throw an exception' );
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
    private static void isSet_field_dateTimeValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( Account.Name, new Set<DateTime>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a field and an empty set of DateTime, will throw an exception' );
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
    private static void isSet_stringName_dateTimeValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( 'Account.Name', new Set<DateTime>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a string field name and an empty set of DateTime, will throw an exception' );
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
    private static void isSet_field_objectValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( Account.Name, new Set<Object>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a field and an empty set of Objects, will throw an exception' );
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
    private static void isSet_stringName_objectValues_whenGivenAnEmptySet_throwsAnException() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();
        Test.startTest();
            String exceptionMessage;
            try
            {
                criteria.inSet( 'Account.Name', new Set<Object>() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'inSet called with an empty values', exceptionMessage, 'isSet, when called with a string field name and an empty set of Objects, will throw an exception' );
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
    private static void notInSet_field_stringValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<String>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a field and an empty set of Strings, will not add to the generated SOQL' );
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
    private static void notInSet_stringName_stringValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( 'Account.Name', new Set<String>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a string name and an empty set of Strings, will not add to the generated SOQL' );
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
    private static void notInSet_field_longValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Long>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a field and an empty set of Longs, will not add to the generated SOQL' );
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
    private static void notInSet_stringName_longValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Long>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a string name and an empty set of Longs, will not add to the generated SOQL' );
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
    private static void notInSet_field_integerValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Integer>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a field and an empty set of Integers, will not add to the generated SOQL' );
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
    private static void notInSet_stringName_IntegerValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Integer>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a string name and an empty set of Integer, will not add to the generated SOQL' );
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
    private static void notInSet_field_idValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Id>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a field and an empty set of Ids, will not add to the generated SOQL' );
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
    private static void notInSet_stringName_idValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( 'Account.Name', new Set<Id>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a string name and an empty set of Ids, will not add to the generated SOQL' );
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
    private static void notInSet_field_doubleValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Double>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a field and an empty set of Doubles, will not add to the generated SOQL' );
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
    private static void notInSet_stringName_doubleValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( 'Account.Name', new Set<Double>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a string name and an empty set of Doubles, will not add to the generated SOQL' );
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
    private static void notInSet_field_decimalValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Decimal>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a field and an empty set of Decimals, will not add to the generated SOQL' );
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
    private static void notInSet_stringName_decimalValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Decimal>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a string name and an empty set of Decimals, will not add to the generated SOQL' );
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
    private static void notInSet_field_dateValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Date>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a field and an empty set of Dates, will not add to the generated SOQL' );
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
    private static void notInSet_stringName_dateValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( 'Account.Name', new Set<Date>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a string name and an empty set of Dates, will not add to the generated SOQL' );
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
    private static void notInSet_field_dateTimeValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<DateTime>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a field and an empty set of DateTime, will not add to the generated SOQL' );
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
    private static void notInSet_stringName_dateTimeValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( 'Account.Name', new Set<DateTime>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a string name and an empty set of DateTime, will not add to the generated SOQL' );
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
    private static void notInSet_field_objectValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( Account.Name, new Set<Object>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a field and an empty set of Objects, will not add to the generated SOQL' );
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

    @isTest
    private static void notInSet_stringName_objectValues_whenGivenAnEmptySet_doesNotAddToTheGeneratedSoql() // NOPMD: Test method name format
    {
        ortoo_Criteria criteria = new ortoo_Criteria();

        Test.startTest();
            criteria.notInSet( 'Account.Name', new Set<Object>() );
        Test.stopTest();

        String got = criteria.toSOQL();

        System.assertEquals( '', got, 'notInSet, when called with a string name and an empty set of Object, will not add to the generated SOQL' );
    }
}