@isTest
private without sharing class SecureDmlTest
{
    private static final Integer LOTS_OF_RECORDS = 10000;

    @isTest
    private static void dmlInsert_whenTheUserCanCreateTheRecords_willInsertTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml();
            dml.dmlInsert( accounts );

        Test.stopTest();

        System.assertNotEquals( null, accounts[0].Id, 'dmlInsert, when the user can create the records, will insert the records, setting the Id on them (0)' );
        System.assertNotEquals( null, accounts[1].Id, 'dmlInsert, when the user can create the records, will insert the records, setting the Id on them (1)' );

        List<Account> createdAccounts = getAccountsInserted();

        System.assertEquals( 'Account1', createdAccounts[0].Name, 'dmlInsert, when the user can create the records, will insert the records, setting the fields on the records that are created (0)' );
        System.assertEquals( 'Account2', createdAccounts[1].Name, 'dmlInsert, when the user can create the records, will insert the records, setting the fields on the records that are created (1)' );
    }

    @isTest
    private static void dmlInsert_whenAskedToCreateALotOfRecords_willInsertTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>();
        for ( Integer i=0; i < LOTS_OF_RECORDS; i++ )
        {
            accounts.add( new Account( Name = 'Account' + i ) );
        }

        Test.startTest();

            SecureDml dml = new TestableSecureDml();
            dml.dmlInsert( accounts );

        Test.stopTest();

        List<Account> createdAccounts = getAccountsInserted();

        System.assertEquals( LOTS_OF_RECORDS, createdAccounts.size(), 'dmlInsert, when the user can create the records, will insert the records without blowing CPU or Heap size limits' );
    }

    @isTest
    private static void dmlInsert_whenTheUserCannotCreateRecords_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Test.startTest();
            ortoo_Exception thrownException;
            try
            {
                SecureDml dml = new TestableSecureDml();
                ((TestableSecureDml)dml).canCreate = false;

                dml.dmlInsert( accounts );
            }
            catch ( SecureDml.SecureDmlException e )
            {
                thrownException = e;
            }
        Test.stopTest();

        System.assertNotEquals( null, thrownException, 'dmlInsert, when the user cannot create records, will throw an exception' );

        ortoo_Exception.Contexts contexts = thrownException.getContexts();
        ortoo_Exception.Context context;

        context = contexts.next();
        System.assertEquals( 'sobjectTypeName', context.getName(), 'dmlInsert, when the user cannot create records, will throw an exception with a context named sobjectTypeName' );
        System.assertEquals( Account.getSObjectType().getDescribe().getName(), context.getValue(), 'dmlInsert, when the user cannot create records, will throw an exception with a context named sobjectTypeName set to the name of the SObject' );

        context = contexts.next();
        System.assertEquals( 'records', context.getName(), 'dmlInsert, when the user cannot create records, will throw an exception with a context named records' );
        System.assertEquals( accounts, context.getValue(), 'dmlInsert, when the user cannot create records, will throw an exception with a context named records set to the records that where sent' );

        System.assertEquals( 'dmlInsert', thrownException.getStackTrace().getInnermostMethodName(), 'dmlInsert, when the user cannot create records, will throw an exception with the stack trace pointing to the insert method' );
    }

    @isTest
    private static void dmlInsert_whenTheUserCanNotCreateButCudOff_willInsertTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml();

            ((TestableSecureDml)dml).canCreate = false; // mimics not having write access

            dml.ignoreCudSettings();
            dml.dmlInsert( accounts );

        Test.stopTest();

        System.assertNotEquals( null, accounts[0].Id, 'dmlInsert, when the user cannot create the records but cud switched off, will insert the records, setting the Id on them (0)' );
        System.assertNotEquals( null, accounts[1].Id, 'dmlInsert, when the user cannot create the records but cud switched off, will insert the records, setting the Id on them (1)' );
    }

    @isTest
    private static void dmlInsert_whenTheUserCanNotCreateButCudOffForThatObject_willInsertTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml()
                                    .ignoreCudSettingsFor( Account.SobjectType );

            ((TestableSecureDml)dml).canCreate = false; // mimics not having write access

            dml.dmlInsert( accounts );

        Test.stopTest();

        System.assertNotEquals( null, accounts[0].Id, 'dmlInsert, when the user cannot create the records but cud switched off for that sobject type, will insert the records, setting the Id on them (0)' );
        System.assertNotEquals( null, accounts[1].Id, 'dmlInsert, when the user cannot create the records but cud switched off for that sobject type, will insert the records, setting the Id on them (1)' );
    }

    @isTest
    private static void dmlInsert_whenTheUserCanNotCreateButCudOffForMultipleObjects_willInsertTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml()
                                    .ignoreCudSettingsFor( Account.SobjectType )
                                    .ignoreCudSettingsFor( Contact.SobjectType );

            ((TestableSecureDml)dml).canCreate = false; // mimics not having write access

            dml.dmlInsert( accounts );

        Test.stopTest();

        System.assertNotEquals( null, accounts[0].Id, 'dmlInsert, when the user cannot create the records but cud switched off for multiple sobject types, including that one, will insert the records, setting the Id on them (0)' );
        System.assertNotEquals( null, accounts[1].Id, 'dmlInsert, when the user cannot create the records but cud switched off for multiple sobject types, including that one, will insert the records, setting the Id on them (1)' );
    }

    @isTest
    private static void dmlInsert_whenTheUserCannotCreateRecordsAndCudOfForOtherObjects_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Test.startTest();
            ortoo_Exception thrownException;
            try
            {
                SecureDml dml = new TestableSecureDml()
                                        .ignoreCudSettingsFor( Contact.sobjectType );

                ((TestableSecureDml)dml).canCreate = false;

                dml.dmlInsert( accounts );
            }
            catch ( SecureDml.SecureDmlException e )
            {
                thrownException = e;
            }
        Test.stopTest();

        System.assertNotEquals( null, thrownException, 'dmlInsert, when the user cannot create records and cud is off for other objects, will still throw an exception' );
    }

    @isTest
    private static void dmlInsert_whenGivenAnEmptyList_willDoNothing() // NOPMD: Test method name format
    {
        List<Account> emptyList = new List<Account>();

        Test.startTest();

            SecureDml dml = new TestableSecureDml();
            dml.dmlInsert( emptyList );

        Test.stopTest();

        System.assertEquals( null, getAccountsInserted(), 'dmlInsert, when given an empty list, will not issue any DML' );
    }

    @isTest
    private static void dmlInsert_whenGivenAnEmptyListAndCreateIsNotAllowed_willDoNothing() // NOPMD: Test method name format
    {
        List<Account> emptyList = new List<Account>();

        Test.startTest();

            SecureDml dml = new TestableSecureDml();

            ((TestableSecureDml)dml).canCreate = false;

            dml.dmlInsert( emptyList );

        Test.stopTest();

        System.assertEquals( null, getAccountsInserted(), 'dmlInsert, when given an empty list of objects the user cannot create, will not issue any DML or throw an exception' );
    }

    @isTest
    private static void dmlInsert_whenTheUserCannotCreateRecordsDueToFls_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1', NumberOfEmployees = 1 ),
            new Account( Name = 'Account2', NumberOfEmployees = 2 )
        };

        List<Account> strippedAccounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Set<String> accountFieldsBlockedByFls = new Set<String>{ 'NumberOfEmployees' };
        Map<String,Set<String>> removedFields = new Map<String,Set<String>>{ 'Account' => accountFieldsBlockedByFls };
        SecureDml.SecurityDecision stripsNumberOfEmployees = new SecureDml.SecurityDecision( removedFields, strippedAccounts );

        Test.startTest();
            ortoo_Exception thrownException;
            try
            {
                SecureDml dml = new TestableSecureDml();
                ((TestableSecureDml)dml).stripInaccessibleSecurityDecision = stripsNumberOfEmployees;

                dml.dmlInsert( accounts );
            }
            catch ( SecureDml.SecureDmlException e )
            {
                thrownException = e;
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'NumberOfEmployees', thrownException.getMessage(), 'dmlInsert, when the user cannot create records because of FLS, will throw an exception' );

        ortoo_Exception.Contexts contexts = thrownException.getContexts();
        ortoo_Exception.Context context;

        context = contexts.next();
        System.assertEquals( 'sobjectTypeName', context.getName(), 'dmlInsert, when the user cannot create records because of FLS, will throw an exception with a context named sobjectTypeName' );
        System.assertEquals( Account.getSObjectType().getDescribe().getName(), context.getValue(), 'dmlInsert, when the user cannot create records because of FLS, will throw an exception with a context named sobjectTypeName set to the name of the SObject' );

        context = contexts.next();
        System.assertEquals( 'fieldsInViolation', context.getName(), 'dmlInsert, when the user cannot create records because of FLS, will throw an exception with a context named fieldsInViolation' );
        System.assertEquals( accountFieldsBlockedByFls, context.getValue(), 'dmlInsert, when the user cannot create records because of FLS, will throw an exception with a context named fieldsInViolation set to the fields that were in violation' );

        System.assertEquals( 'dmlInsert', thrownException.getStackTrace().getInnermostMethodName(), 'dmlInsert, when the user cannot create records because of FLS, will throw an exception with the stack trace pointing to the insert method' );
    }

    @isTest
    private static void dmlInsert_whenTheUserCanNotCreateButFlsCheckOff_willInsertTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1', NumberOfEmployees = 1 ),
            new Account( Name = 'Account2', NumberOfEmployees = 2 )
        };

        List<Account> strippedAccounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Set<String> accountFieldsBlockedByFls = new Set<String>{ 'NumberOfEmployees' };
        Map<String,Set<String>> removedFields = new Map<String,Set<String>>{ 'Account' => accountFieldsBlockedByFls };
        SecureDml.SecurityDecision stripsNumberOfEmployees = new SecureDml.SecurityDecision( removedFields, strippedAccounts );

        Test.startTest();

            SecureDml dml = new TestableSecureDml()
                                    .ignoreFls();

            ((TestableSecureDml)dml).stripInaccessibleSecurityDecision = stripsNumberOfEmployees;

            dml.dmlInsert( accounts );

        Test.stopTest();

        System.assertNotEquals( null, accounts[0].Id, 'dmlInsert, when the user cannot create the records, but fls switched off, will insert the records, setting the Id on them (0)' );

        List<Account> createdAccounts = getAccountsInserted();

        System.assertEquals( 1, createdAccounts[0].NumberOfEmployees, 'dmlInsert, when the user can create the records, but fls switched off,  will insert the records, setting the fields on the records that are created (0)' );
    }

    @isTest
    private static void dmlInsert_whenTheUserCanNotCreateButFlsCheckOffForSobject_willInsertTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1', NumberOfEmployees = 1 ),
            new Account( Name = 'Account2', NumberOfEmployees = 2 )
        };

        List<Account> strippedAccounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Set<String> accountFieldsBlockedByFls = new Set<String>{ 'NumberOfEmployees' };
        Map<String,Set<String>> removedFields = new Map<String,Set<String>>{ 'Account' => accountFieldsBlockedByFls };
        SecureDml.SecurityDecision stripsNumberOfEmployees = new SecureDml.SecurityDecision( removedFields, strippedAccounts );

        Test.startTest();

            SecureDml dml = new TestableSecureDml()
                                    .ignoreFlsFor( Account.sobjectType );

            ((TestableSecureDml)dml).stripInaccessibleSecurityDecision = stripsNumberOfEmployees;

            dml.dmlInsert( accounts );

        Test.stopTest();

        System.assertNotEquals( null, accounts[0].Id, 'dmlInsert, when the user cannot create the records, but fls switched off for that sobject type, will insert the records, setting the Id on them (0)' );
        System.assertEquals( 1, accounts[0].NumberOfEmployees, 'dmlInsert, when the user can create the records, but fls switched off for that sobject type,  will insert the records, leaving the field set on the original record' );

        List<Account> createdAccounts = getAccountsInserted();

        System.assertEquals( 1, createdAccounts[0].NumberOfEmployees, 'dmlInsert, when the user can create the records, but fls switched off for that sobject type,  will insert the records, setting the fields on the records that are created (0)' );
    }

    @isTest
    private static void dmlInsert_whenTheUserCanNotCreateButFlsCheckOffForSobjectField_willInsertTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1', NumberOfEmployees = 1 ),
            new Account( Name = 'Account2', NumberOfEmployees = 2 )
        };

        List<Account> strippedAccounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Set<String> accountFieldsBlockedByFls = new Set<String>{ 'NumberOfEmployees' };
        Map<String,Set<String>> removedFields = new Map<String,Set<String>>{ 'Account' => accountFieldsBlockedByFls };
        SecureDml.SecurityDecision stripsNumberOfEmployees = new SecureDml.SecurityDecision( removedFields, strippedAccounts );

        Test.startTest();

            SecureDml dml = new TestableSecureDml()
                                    .ignoreFlsFor( Account.sobjectType, Account.NumberOfEmployees );

            ((TestableSecureDml)dml).stripInaccessibleSecurityDecision = stripsNumberOfEmployees;

            dml.dmlInsert( accounts );

        Test.stopTest();

        System.assertNotEquals( null, accounts[0].Id, 'dmlInsert, when the user cannot create the records, but fls switched off for that field, will insert the records, setting the Id on them (0)' );
        System.assertEquals( 1, accounts[0].NumberOfEmployees, 'dmlInsert, when the user can create the records, but fls switched off for that field,  will insert the records, leaving the field set on the original record' );

        List<Account> createdAccounts = getAccountsInserted();

        System.assertEquals( 1, createdAccounts[0].NumberOfEmployees, 'dmlInsert, when the user can create the records, but fls switched off for that field,  will insert the records, setting the fields on the records that are created (0)' );
    }

    @isTest
    private static void dmlInsert_whenTheUserCannotCreateRecordsDueToFlsAndOtherObjectSwitchedOff_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1', NumberOfEmployees = 1 ),
            new Account( Name = 'Account2', NumberOfEmployees = 2 )
        };

        List<Account> strippedAccounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Set<String> accountFieldsBlockedByFls = new Set<String>{ 'NumberOfEmployees' };
        Map<String,Set<String>> removedFields = new Map<String,Set<String>>{ 'Account' => accountFieldsBlockedByFls };
        SecureDml.SecurityDecision stripsNumberOfEmployees = new SecureDml.SecurityDecision( removedFields, strippedAccounts );

        Test.startTest();
            ortoo_Exception thrownException;
            try
            {
                SecureDml dml = new TestableSecureDml()
                                        .ignoreFlsFor( Contact.sobjectType );

                ((TestableSecureDml)dml).stripInaccessibleSecurityDecision = stripsNumberOfEmployees;

                dml.dmlInsert( accounts );
            }
            catch ( SecureDml.SecureDmlException e )
            {
                thrownException = e;
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'NumberOfEmployees', thrownException.getMessage(), 'dmlInsert, when the user cannot create records because of FLS and FLS switched off for a different object, will throw an exception' );
    }

    @isTest
    private static void dmlInsert_whenTheUserCannotCreateRecordsDueToFlsAndOtherFieldSwitchedOff_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1', NumberOfEmployees = 1 ),
            new Account( Name = 'Account2', NumberOfEmployees = 2 )
        };

        List<Account> strippedAccounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Set<String> accountFieldsBlockedByFls = new Set<String>{ 'NumberOfEmployees' };
        Map<String,Set<String>> removedFields = new Map<String,Set<String>>{ 'Account' => accountFieldsBlockedByFls };
        SecureDml.SecurityDecision stripsNumberOfEmployees = new SecureDml.SecurityDecision( removedFields, strippedAccounts );

        Test.startTest();
            ortoo_Exception thrownException;
            try
            {
                SecureDml dml = new TestableSecureDml()
                                        .ignoreFlsFor( Account.sobjectType, Account.Name );

                ((TestableSecureDml)dml).stripInaccessibleSecurityDecision = stripsNumberOfEmployees;

                dml.dmlInsert( accounts );
            }
            catch ( SecureDml.SecureDmlException e )
            {
                thrownException = e;
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'NumberOfEmployees', thrownException.getMessage(), 'dmlInsert, when the user cannot create records because of FLS and FLS switched off for a different field, will throw an exception' );
    }

    @isTest
    private static void dmlInsert_whenTheUserCannotCreateRecordsDueToFlsAndNotAllFieldsOff_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1', NumberOfEmployees = 1 ),
            new Account( Name = 'Account2', NumberOfEmployees = 2 )
        };

        List<Account> strippedAccounts = new List<Account>
        {
            new Account(),
            new Account()
        };

        Set<String> accountFieldsBlockedByFls = new Set<String>{ 'Name', 'NumberOfEmployees' };
        Map<String,Set<String>> removedFields = new Map<String,Set<String>>{ 'Account' => accountFieldsBlockedByFls };
        SecureDml.SecurityDecision stripsNumberOfEmployees = new SecureDml.SecurityDecision( removedFields, strippedAccounts );

        Test.startTest();
            ortoo_Exception thrownException;
            try
            {
                SecureDml dml = new TestableSecureDml()
                                        .ignoreFlsFor( Account.sobjectType, Account.NumberOfEmployees );

                ((TestableSecureDml)dml).stripInaccessibleSecurityDecision = stripsNumberOfEmployees;

                dml.dmlInsert( accounts );
            }
            catch ( SecureDml.SecureDmlException e )
            {
                thrownException = e;
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'Name', thrownException.getMessage(), 'dmlInsert, when the user cannot create records because of FLS and not all fields are switched off, will throw an exception naming the fields in violation' );
        Amoss_Asserts.assertDoesNotContain( 'NumberOfEmployees', thrownException.getMessage(), 'dmlInsert, when the user cannot create records because of FLS and not all fields are switched off, will throw an exception, not naming the fields that are supressed' );

        ortoo_Exception.Contexts contexts = thrownException.getContexts();
        ortoo_Exception.Context context;

        context = contexts.next();
        System.assertEquals( 'sobjectTypeName', context.getName(), 'dmlInsert, when the user cannot create records because of FLS and not all fields are switched off, will throw an exception with a context named sobjectTypeName' );
        System.assertEquals( Account.getSObjectType().getDescribe().getName(), context.getValue(), 'dmlInsert, when the user cannot create records because of FLS and not all fields are switched off, will throw an exception with a context named sobjectTypeName set to the name of the SObject' );

        context = contexts.next();
        System.assertEquals( 'fieldsInViolation', context.getName(), 'dmlInsert, when the user cannot create records because of FLS and not all fields are switched off, will throw an exception with a context named fieldsInViolation' );
        System.assertEquals( new Set<String>{ 'Name' }, context.getValue(), 'dmlInsert, when the user cannot create records because of FLS and not all fields are switched off, will throw an exception with a context named fieldsInViolation set to the fields that were in violation minus those switched off' );
    }

    @isTest
    private static void dmlInsert_whenTheUserCannotCreateRecordsDueToFlsAndNullHandler_willStripFields() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1', NumberOfEmployees = 1 ),
            new Account( Name = 'Account2', NumberOfEmployees = 2 )
        };

        List<Account> strippedAccounts = new List<Account>
        {
            new Account(),
            new Account()
        };

        Set<String> accountFieldsBlockedByFls = new Set<String>{ 'Name', 'NumberOfEmployees' };
        Map<String,Set<String>> removedFields = new Map<String,Set<String>>{ 'Account' => accountFieldsBlockedByFls };
        SecureDml.SecurityDecision stripsNumberOfEmployees = new SecureDml.SecurityDecision( removedFields, strippedAccounts );

        Test.startTest();
            SecureDml dml = new TestableSecureDml()
                                    .ignoreFlsFor( Account.sobjectType, Account.NumberOfEmployees )
                                    .setFlsViolationHandler( new SwallowOnFlsViolationHandler() );

            ((TestableSecureDml)dml).stripInaccessibleSecurityDecision = stripsNumberOfEmployees;

            dml.dmlInsert( accounts );
        Test.stopTest();

        System.assertEquals( null, accounts[0].Name, 'dmlInsert, when the user cannot create records because of FLS and handler does not throw exception, will update the records to remove the fields in violation' );
        System.assertEquals( 1, accounts[0].NumberOfEmployees, 'dmlInsert, when the user cannot create records because of FLS and handler does not throw exception, will ensure the supressed fields keep their values' );
    }

    @isTest
    private static void dmlUpdate_whenTheUserCanUpdateTheRecords_willUpdateTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account1' ),
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account2' )
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml();
            dml.dmlUpdate( accounts );

        Test.stopTest();

        List<Account> updatedAccounts = getAccountsUpdated();

        System.assertEquals( 'Account1', updatedAccounts[0].Name, 'dmlUpdate, when the user can update the records, will update the records, setting the fields on the records that are updated (0)' );
        System.assertEquals( 'Account2', updatedAccounts[1].Name, 'dmlUpdate, when the user can update the records, will update the records, setting the fields on the records that are updated (1)' );
    }

    @isTest
    private static void dmlUpdate_whenAskedToUpdateALotOfRecords_willUpdateTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>();
        for ( Integer i=0; i < LOTS_OF_RECORDS; i++ )
        {
            accounts.add( new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account' + i ) );
        }

        Test.startTest();

            SecureDml dml = new TestableSecureDml();
            dml.dmlUpdate( accounts );

        Test.stopTest();

        List<Account> updatedAccounts = getAccountsUpdated();

        System.assertEquals( LOTS_OF_RECORDS, updatedAccounts.size(), 'dmlUpdate, when the user can update the records, will update the records without blowing CPU or Heap size limits' );
    }

    @isTest
    private static void dmlUpdate_whenTheUserCannotUpdateRecords_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account1' ),
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account2' )
        };

        Test.startTest();
            ortoo_Exception thrownException;
            try
            {
                SecureDml dml = new TestableSecureDml();
                ((TestableSecureDml)dml).canUpdate = false;

                dml.dmlUpdate( accounts );
            }
            catch ( SecureDml.SecureDmlException e )
            {
                thrownException = e;
            }
        Test.stopTest();

        System.assertNotEquals( null, thrownException, 'dmlUpdate, when the user cannot update records, will throw an exception' );

        ortoo_Exception.Contexts contexts = thrownException.getContexts();
        ortoo_Exception.Context context;

        context = contexts.next();
        System.assertEquals( 'sobjectTypeName', context.getName(), 'dmlUpdate, when the user cannot update records, will throw an exception with a context named sobjectTypeName' );
        System.assertEquals( Account.getSObjectType().getDescribe().getName(), context.getValue(), 'dmlUpdate, when the user cannot update records, will throw an exception with a context named sobjectTypeName set to the name of the SObject' );

        context = contexts.next();
        System.assertEquals( 'records', context.getName(), 'dmlUpdate, when the user cannot update records, will throw an exception with a context named records' );
        System.assertEquals( accounts, context.getValue(), 'dmlUpdate, when the user cannot update records, will throw an exception with a context named records set to the records that where sent' );

        System.assertEquals( 'dmlUpdate', thrownException.getStackTrace().getInnermostMethodName(), 'dmlUpdate, when the user cannot update records, will throw an exception with the stack trace pointing to the update method' );
    }

    @isTest
    private static void dmlUpdate_whenTheUserCanNotUpdateButCudOff_willUpdateTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account1' ),
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account2' )
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml();

            ((TestableSecureDml)dml).canUpdate = false; // mimics not having write access

            dml.ignoreCudSettings();
            dml.dmlUpdate( accounts );

        Test.stopTest();

        List<Account> updatedAccounts = getAccountsUpdated();

        System.assertEquals( updatedAccounts[0].Id, accounts[0].Id, 'dmlUpdate, when the user cannot update the records but cud switched off, will update the records' );
        System.assertEquals( updatedAccounts[1].Id, accounts[1].Id, 'dmlUpdate, when the user cannot update the records but cud switched off, will update the records' );
    }

    @isTest
    private static void dmlUpdate_whenTheUserCanNotUpdateButCudOffForThatObject_willUpdateTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account1' ),
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account2' )
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml()
                                    .ignoreCudSettingsFor( Account.SobjectType );

            ((TestableSecureDml)dml).canUpdate = false; // mimics not having write access

            dml.dmlUpdate( accounts );

        Test.stopTest();

        List<Account> updatedAccounts = getAccountsUpdated();

        System.assertEquals( accounts[0].Id, updatedAccounts[0].Id, 'dmlUpdate, when the user cannot update the records but cud switched off for that sobject type, will update the records (0)' );
        System.assertEquals( accounts[1].Id, updatedAccounts[1].Id, 'dmlUpdate, when the user cannot update the records but cud switched off for that sobject type, will update the records (1)' );
    }

    @isTest
    private static void dmlUpdate_whenTheUserCanNotUpdateButCudOffForMultipleObjects_willUpdateTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account1' ),
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account2' )
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml()
                                    .ignoreCudSettingsFor( Account.SobjectType )
                                    .ignoreCudSettingsFor( Contact.SobjectType );

            ((TestableSecureDml)dml).canUpdate = false; // mimics not having write access

            dml.dmlUpdate( accounts );

        Test.stopTest();

        List<Account> updatedAccounts = getAccountsUpdated();

        System.assertEquals( accounts[0].Id, updatedAccounts[0].Id, 'dmlUpdate, when the user cannot update the records but cud switched off for multiple sobject types, including that one, will update the records (0)' );
        System.assertEquals( accounts[1].Id, updatedAccounts[1].Id, 'dmlUpdate, when the user cannot update the records but cud switched off for multiple sobject types, including that one, will update the records (1)' );
    }

    @isTest
    private static void dmlUpdate_whenTheUserCannotUpdateRecordsAndCudOfForOtherObjects_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account1' ),
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account2' )
        };

        Test.startTest();
            ortoo_Exception thrownException;
            try
            {
                SecureDml dml = new TestableSecureDml()
                                        .ignoreCudSettingsFor( Contact.sobjectType );

                ((TestableSecureDml)dml).canUpdate = false;

                dml.dmlUpdate( accounts );
            }
            catch ( SecureDml.SecureDmlException e )
            {
                thrownException = e;
            }
        Test.stopTest();

        System.assertNotEquals( null, thrownException, 'dmlUpdate, when the user cannot update records and cud is off for other objects, will still throw an exception' );
    }

    @isTest
    private static void dmlUpdate_whenGivenAnEmptyList_willDoNothing() // NOPMD: Test method name format
    {
        List<Account> emptyList = new List<Account>();

        Test.startTest();

            SecureDml dml = new TestableSecureDml();
            dml.dmlUpdate( emptyList );

        Test.stopTest();

        System.assertEquals( null, getAccountsUpdated(), 'dmlUpdate, when given an empty list, will not issue any DML' );
    }

    @isTest
    private static void dmlUpdate_whenGivenAnEmptyListAndUpdateIsNotAllowed_willDoNothing() // NOPMD: Test method name format
    {
        List<Account> emptyList = new List<Account>();

        Test.startTest();

            SecureDml dml = new TestableSecureDml();

            ((TestableSecureDml)dml).canUpdate = false;

            dml.dmlUpdate( emptyList );

        Test.stopTest();

        System.assertEquals( null, getAccountsUpdated(), 'dmlUpdate, when given an empty list of objects the user cannot update, will not issue any DML or throw an exception' );
    }

    @isTest
    private static void dmlUpdate_whenTheUserCannotUpdateRecordsDueToFls_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account1', NumberOfEmployees = 1 ),
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account2', NumberOfEmployees = 2 )
        };

        List<Account> strippedAccounts = new List<Account>
        {
            new Account( Id = accounts[0].Id, Name = 'Account1' ),
            new Account( Id = accounts[1].Id, Name = 'Account2' )
        };

        Set<String> accountFieldsBlockedByFls = new Set<String>{ 'NumberOfEmployees' };
        Map<String,Set<String>> removedFields = new Map<String,Set<String>>{ 'Account' => accountFieldsBlockedByFls };
        SecureDml.SecurityDecision stripsNumberOfEmployees = new SecureDml.SecurityDecision( removedFields, strippedAccounts );

        Test.startTest();
            ortoo_Exception thrownException;
            try
            {
                SecureDml dml = new TestableSecureDml();
                ((TestableSecureDml)dml).stripInaccessibleSecurityDecision = stripsNumberOfEmployees;

                dml.dmlUpdate( accounts );
            }
            catch ( SecureDml.SecureDmlException e )
            {
                thrownException = e;
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'NumberOfEmployees', thrownException.getMessage(), 'dmlUpdate, when the user cannot update records because of FLS, will throw an exception' );

        ortoo_Exception.Contexts contexts = thrownException.getContexts();
        ortoo_Exception.Context context;

        context = contexts.next();
        System.assertEquals( 'sobjectTypeName', context.getName(), 'dmlUpdate, when the user cannot update records because of FLS, will throw an exception with a context named sobjectTypeName' );
        System.assertEquals( Account.getSObjectType().getDescribe().getName(), context.getValue(), 'dmlUpdate, when the user cannot update records because of FLS, will throw an exception with a context named sobjectTypeName set to the name of the SObject' );

        context = contexts.next();
        System.assertEquals( 'fieldsInViolation', context.getName(), 'dmlUpdate, when the user cannot update records because of FLS, will throw an exception with a context named fieldsInViolation' );
        System.assertEquals( accountFieldsBlockedByFls, context.getValue(), 'dmlUpdate, when the user cannot update records because of FLS, will throw an exception with a context named fieldsInViolation set to the fields that were in violation' );

        System.assertEquals( 'dmlUpdate', thrownException.getStackTrace().getInnermostMethodName(), 'dmlUpdate, when the user cannot update records because of FLS, will throw an exception with the stack trace pointing to the update method' );
    }

    @isTest
    private static void dmlUpdate_whenTheUserCanNotUpdateButFlsCheckOff_willUpdateTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account1', NumberOfEmployees = 1 ),
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account2', NumberOfEmployees = 2 )
        };

        List<Account> strippedAccounts = new List<Account>
        {
            new Account( Id = accounts[0].id, Name = 'Account1' ),
            new Account( Id = accounts[1].id, Name = 'Account2' )
        };

        Set<String> accountFieldsBlockedByFls = new Set<String>{ 'NumberOfEmployees' };
        Map<String,Set<String>> removedFields = new Map<String,Set<String>>{ 'Account' => accountFieldsBlockedByFls };
        SecureDml.SecurityDecision stripsNumberOfEmployees = new SecureDml.SecurityDecision( removedFields, strippedAccounts );

        Test.startTest();

            SecureDml dml = new TestableSecureDml()
                                    .ignoreFls();

            ((TestableSecureDml)dml).stripInaccessibleSecurityDecision = stripsNumberOfEmployees;

            dml.dmlUpdate( accounts );

        Test.stopTest();

        System.assertEquals( 1, accounts[0].NumberOfEmployees, 'dmlUpdate, when the user cannot update the records, but fls switched off, will not strip the value from the record (0)' );

        List<Account> updatedAccounts = getAccountsUpdated();

        System.assertEquals( 1, updatedAccounts[0].NumberOfEmployees, 'dmlUpdate, when the user can update the records, but fls switched off,  will update the records, setting the fields on the records that are updated (0)' );
    }

    @isTest
    private static void dmlUpdate_whenTheUserCanNotUpdateButFlsCheckOffForSobject_willUpdateTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account1', NumberOfEmployees = 1 ),
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account2', NumberOfEmployees = 2 )
        };

        List<Account> strippedAccounts = new List<Account>
        {
            new Account( Id = accounts[0].Id, Name = 'Account1' ),
            new Account( Id = accounts[1].Id, Name = 'Account2' )
        };

        Set<String> accountFieldsBlockedByFls = new Set<String>{ 'NumberOfEmployees' };
        Map<String,Set<String>> removedFields = new Map<String,Set<String>>{ 'Account' => accountFieldsBlockedByFls };
        SecureDml.SecurityDecision stripsNumberOfEmployees = new SecureDml.SecurityDecision( removedFields, strippedAccounts );

        Test.startTest();

            SecureDml dml = new TestableSecureDml()
                                    .ignoreFlsFor( Account.sobjectType );

            ((TestableSecureDml)dml).stripInaccessibleSecurityDecision = stripsNumberOfEmployees;

            dml.dmlUpdate( accounts );

        Test.stopTest();

        System.assertEquals( 1, accounts[0].NumberOfEmployees, 'dmlUpdate, when the user can update the records, but fls switched off for that sobject type,  will update the records, leaving the field set on the original record' );

        List<Account> updatedAccounts = getAccountsUpdated();

        System.assertEquals( 1, updatedAccounts[0].NumberOfEmployees, 'dmlUpdate, when the user can update the records, but fls switched off for that sobject type,  will update the records, setting the fields on the records that are updated (0)' );
    }

    @isTest
    private static void dmlUpdate_whenTheUserCanNotUpdateButFlsCheckOffForSobjectField_willUpdateTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account1', NumberOfEmployees = 1 ),
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account2', NumberOfEmployees = 2 )
        };

        List<Account> strippedAccounts = new List<Account>
        {
            new Account( Id = accounts[0].Id, Name = 'Account1' ),
            new Account( Id = accounts[1].Id, Name = 'Account2' )
        };

        Set<String> accountFieldsBlockedByFls = new Set<String>{ 'NumberOfEmployees' };
        Map<String,Set<String>> removedFields = new Map<String,Set<String>>{ 'Account' => accountFieldsBlockedByFls };
        SecureDml.SecurityDecision stripsNumberOfEmployees = new SecureDml.SecurityDecision( removedFields, strippedAccounts );

        Test.startTest();

            SecureDml dml = new TestableSecureDml()
                                    .ignoreFlsFor( Account.sobjectType, Account.NumberOfEmployees );

            ((TestableSecureDml)dml).stripInaccessibleSecurityDecision = stripsNumberOfEmployees;

            dml.dmlUpdate( accounts );

        Test.stopTest();

        System.assertEquals( 1, accounts[0].NumberOfEmployees, 'dmlUpdate, when the user can update the records, but fls switched off for that field,  will update the records, leaving the field set on the original record' );

        List<Account> updatedAccounts = getAccountsUpdated();

        System.assertEquals( 1, updatedAccounts[0].NumberOfEmployees, 'dmlUpdate, when the user can update the records, but fls switched off for that field,  will update the records, setting the fields on the records that are updated (0)' );
    }

    @isTest
    private static void dmlUpdate_whenTheUserCannotUpdateRecordsDueToFlsAndOtherObjectSwitchedOff_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account1', NumberOfEmployees = 1 ),
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account2', NumberOfEmployees = 2 )
        };

        List<Account> strippedAccounts = new List<Account>
        {
            new Account( Id = accounts[0].id, Name = 'Account1' ),
            new Account( Id = accounts[1].id, Name = 'Account2' )
        };

        Set<String> accountFieldsBlockedByFls = new Set<String>{ 'NumberOfEmployees' };
        Map<String,Set<String>> removedFields = new Map<String,Set<String>>{ 'Account' => accountFieldsBlockedByFls };
        SecureDml.SecurityDecision stripsNumberOfEmployees = new SecureDml.SecurityDecision( removedFields, strippedAccounts );

        Test.startTest();
            ortoo_Exception thrownException;
            try
            {
                SecureDml dml = new TestableSecureDml()
                                        .ignoreFlsFor( Contact.sobjectType );

                ((TestableSecureDml)dml).stripInaccessibleSecurityDecision = stripsNumberOfEmployees;

                dml.dmlUpdate( accounts );
            }
            catch ( SecureDml.SecureDmlException e )
            {
                thrownException = e;
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'NumberOfEmployees', thrownException.getMessage(), 'dmlUpdate, when the user cannot update records because of FLS and FLS switched off for a different object, will throw an exception' );
    }

    @isTest
    private static void dmlUpdate_whenTheUserCannotUpdateRecordsDueToFlsAndOtherFieldSwitchedOff_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account1', NumberOfEmployees = 1 ),
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account2', NumberOfEmployees = 2 )
        };

        List<Account> strippedAccounts = new List<Account>
        {
            new Account( Id = accounts[0].Id, Name = 'Account1' ),
            new Account( Id = accounts[1].Id, Name = 'Account2' )
        };

        Set<String> accountFieldsBlockedByFls = new Set<String>{ 'NumberOfEmployees' };
        Map<String,Set<String>> removedFields = new Map<String,Set<String>>{ 'Account' => accountFieldsBlockedByFls };
        SecureDml.SecurityDecision stripsNumberOfEmployees = new SecureDml.SecurityDecision( removedFields, strippedAccounts );

        Test.startTest();
            ortoo_Exception thrownException;
            try
            {
                SecureDml dml = new TestableSecureDml()
                                        .ignoreFlsFor( Account.sobjectType, Account.Name );

                ((TestableSecureDml)dml).stripInaccessibleSecurityDecision = stripsNumberOfEmployees;

                dml.dmlUpdate( accounts );
            }
            catch ( SecureDml.SecureDmlException e )
            {
                thrownException = e;
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'NumberOfEmployees', thrownException.getMessage(), 'dmlUpdate, when the user cannot update records because of FLS and FLS switched off for a different field, will throw an exception' );
    }

    @isTest
    private static void dmlUpdate_whenTheUserCannotUpdateRecordsDueToFlsAndNotAllFieldsOff_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account1', NumberOfEmployees = 1 ),
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account2', NumberOfEmployees = 2 )
        };

        List<Account> strippedAccounts = new List<Account>
        {
            new Account( Id = accounts[0].Id ),
            new Account( Id = accounts[1].Id )
        };

        Set<String> accountFieldsBlockedByFls = new Set<String>{ 'Name', 'NumberOfEmployees' };
        Map<String,Set<String>> removedFields = new Map<String,Set<String>>{ 'Account' => accountFieldsBlockedByFls };
        SecureDml.SecurityDecision stripsNumberOfEmployees = new SecureDml.SecurityDecision( removedFields, strippedAccounts );

        Test.startTest();
            ortoo_Exception thrownException;
            try
            {
                SecureDml dml = new TestableSecureDml()
                                        .ignoreFlsFor( Account.sobjectType, Account.NumberOfEmployees );

                ((TestableSecureDml)dml).stripInaccessibleSecurityDecision = stripsNumberOfEmployees;

                dml.dmlUpdate( accounts );
            }
            catch ( SecureDml.SecureDmlException e )
            {
                thrownException = e;
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'Name', thrownException.getMessage(), 'dmlUpdate, when the user cannot update records because of FLS and not all fields are switched off, will throw an exception naming the fields in violation' );
        Amoss_Asserts.assertDoesNotContain( 'NumberOfEmployees', thrownException.getMessage(), 'dmlUpdate, when the user cannot update records because of FLS and not all fields are switched off, will throw an exception, not naming the fields that are supressed' );

        ortoo_Exception.Contexts contexts = thrownException.getContexts();
        ortoo_Exception.Context context;

        context = contexts.next();
        System.assertEquals( 'sobjectTypeName', context.getName(), 'dmlUpdate, when the user cannot update records because of FLS and not all fields are switched off, will throw an exception with a context named sobjectTypeName' );
        System.assertEquals( Account.getSObjectType().getDescribe().getName(), context.getValue(), 'dmlUpdate, when the user cannot update records because of FLS and not all fields are switched off, will throw an exception with a context named sobjectTypeName set to the name of the SObject' );

        context = contexts.next();
        System.assertEquals( 'fieldsInViolation', context.getName(), 'dmlUpdate, when the user cannot update records because of FLS and not all fields are switched off, will throw an exception with a context named fieldsInViolation' );
        System.assertEquals( new Set<String>{ 'Name' }, context.getValue(), 'dmlUpdate, when the user cannot update records because of FLS and not all fields are switched off, will throw an exception with a context named fieldsInViolation set to the fields that were in violation minus those switched off' );
    }

    @isTest
    private static void dmlUpdate_whenTheUserCannotUpdateRecordsDueToFlsAndNullHandler_willStripFields() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account1', NumberOfEmployees = 1 ),
            new Account( Id = TestIdUtils.generateId( Account.sobjectType ), Name = 'Account2', NumberOfEmployees = 2 )
        };

        List<Account> strippedAccounts = new List<Account>
        {
            new Account( Id = accounts[0].Id ),
            new Account( Id = accounts[1].Id )
        };

        Set<String> accountFieldsBlockedByFls = new Set<String>{ 'Name', 'NumberOfEmployees' };
        Map<String,Set<String>> removedFields = new Map<String,Set<String>>{ 'Account' => accountFieldsBlockedByFls };
        SecureDml.SecurityDecision stripsNumberOfEmployees = new SecureDml.SecurityDecision( removedFields, strippedAccounts );

        Test.startTest();
            SecureDml dml = new TestableSecureDml()
                                    .ignoreFlsFor( Account.sobjectType, Account.NumberOfEmployees )
                                    .setFlsViolationHandler( new SwallowOnFlsViolationHandler() );

            ((TestableSecureDml)dml).stripInaccessibleSecurityDecision = stripsNumberOfEmployees;

            dml.dmlUpdate( accounts );
        Test.stopTest();

        System.assertEquals( null, accounts[0].Name, 'dmlUpdate, when the user cannot update records because of FLS and handler does not throw exception, will update the records to remove the fields in violation' );
        System.assertEquals( 1, accounts[0].NumberOfEmployees, 'dmlUpdate, when the user cannot update records because of FLS and handler does not throw exception, will ensure the supressed fields keep their values' );
    }

    @isTest
    private static void dmlDelete_whenTheUserCanDeleteTheRecords_willDeleteTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml();
            dml.dmlDelete( accounts );

        Test.stopTest();

        List<Account> deletedAccounts = getAccountsDeleted();

        System.assertEquals( 'Account1', deletedAccounts[0].Name, 'dmlDelete, when the user can delete the records, will delete the records (0)' );
        System.assertEquals( 'Account2', deletedAccounts[1].Name, 'dmlDelete, when the user can delete the records, will delete the records (1)' );
    }

    @isTest
    private static void dmlDelete_whenAskedToDeleteALotOfRecords_willDeleteTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>();
        for ( Integer i=0; i < LOTS_OF_RECORDS; i++ )
        {
            accounts.add( new Account( Name = 'Account' + i ) );
        }

        Test.startTest();

            SecureDml dml = new TestableSecureDml();
            dml.dmlDelete( accounts );

        Test.stopTest();

        List<Account> deletedAccounts = getAccountsDeleted();

        System.assertEquals( LOTS_OF_RECORDS, deletedAccounts.size(), 'dmlDelete, when the user can delete the records, will delete the records without blowing CPU or Heap size limits' );
    }

    @isTest
    private static void dmlDelete_whenTheUserCannotDeleteRecords_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Test.startTest();
            ortoo_Exception thrownException;
            try
            {
                SecureDml dml = new TestableSecureDml();
                ((TestableSecureDml)dml).canDelete = false;

                dml.dmlDelete( accounts );
            }
            catch ( SecureDml.SecureDmlException e )
            {
                thrownException = e;
            }
        Test.stopTest();

        System.assertNotEquals( null, thrownException, 'dmlDelete, when the user cannot delete records, will throw an exception' );

        ortoo_Exception.Contexts contexts = thrownException.getContexts();
        ortoo_Exception.Context context;

        context = contexts.next();
        System.assertEquals( 'sobjectTypeName', context.getName(), 'dmlDelete, when the user cannot delete records, will throw an exception with a context named sobjectTypeName' );
        System.assertEquals( Account.getSObjectType().getDescribe().getName(), context.getValue(), 'dmlDelete, when the user cannot delete records, will throw an exception with a context named sobjectTypeName set to the name of the SObject' );

        context = contexts.next();
        System.assertEquals( 'records', context.getName(), 'dmlDelete, when the user cannot delete records, will throw an exception with a context named records' );
        System.assertEquals( accounts, context.getValue(), 'dmlDelete, when the user cannot delete records, will throw an exception with a context named records set to the records that where sent' );

        System.assertEquals( 'dmlDelete', thrownException.getStackTrace().getInnermostMethodName(), 'dmlDelete, when the user cannot delete records, will throw an exception with the stack trace pointing to the delete method' );
    }

    @isTest
    private static void dmlDelete_whenTheUserCanNotDeleteButCudOff_willDeleteTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml();

            ((TestableSecureDml)dml).canDelete = false; // mimics not having write access

            dml.ignoreCudSettings();
            dml.dmlDelete( accounts );

        Test.stopTest();

        List<Account> deletedAccounts = getAccountsDeleted();

        System.assertEquals( accounts[0], deletedAccounts[0], 'dmlDelete, when the user cannot delete the records but cud switched off, will delete the records - 0' );
        System.assertEquals( accounts[1], deletedAccounts[1], 'dmlDelete, when the user cannot delete the records but cud switched off, will delete the records - 1' );
    }

    @isTest
    private static void dmlDelete_whenTheUserCanNotDeleteButCudOffForThatObject_willDeleteTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml()
                                    .ignoreCudSettingsFor( Account.SobjectType );

            ((TestableSecureDml)dml).canDelete = false; // mimics not having write access

            dml.dmlDelete( accounts );

        Test.stopTest();

        List<Account> deletedAccounts = getAccountsDeleted();

        System.assertEquals( accounts[0], deletedAccounts[0], 'dmlDelete, when the user cannot delete the records but cud switched off for that sobject type, will delete the records (0)' );
        System.assertEquals( accounts[1], deletedAccounts[1], 'dmlDelete, when the user cannot delete the records but cud switched off for that sobject type, will delete the records (1)' );
    }

    @isTest
    private static void dmlDelete_whenTheUserCanNotDeleteButCudOffForMultipleObjects_willDeleteTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml()
                                    .ignoreCudSettingsFor( Account.SobjectType )
                                    .ignoreCudSettingsFor( Contact.SobjectType );

            ((TestableSecureDml)dml).canDelete = false; // mimics not having write access

            dml.dmlDelete( accounts );

        Test.stopTest();

        List<Account> deletedAccounts = getAccountsDeleted();

        System.assertEquals( accounts[0], deletedAccounts[0], 'dmlDelete, when the user cannot delete the records but cud switched off for multiple sobject types, including that one, will delete the records (0)' );
        System.assertEquals( accounts[1], deletedAccounts[1], 'dmlDelete, when the user cannot delete the records but cud switched off for multiple sobject types, including that one, will delete the records (1)' );
    }

    @isTest
    private static void dmlDelete_whenTheUserCannotDeleteRecordsAndCudOfForOtherObjects_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            new Account( Name = 'Account1' ),
            new Account( Name = 'Account2' )
        };

        Test.startTest();
            ortoo_Exception thrownException;
            try
            {
                SecureDml dml = new TestableSecureDml()
                                        .ignoreCudSettingsFor( Contact.sobjectType );

                ((TestableSecureDml)dml).canDelete = false;

                dml.dmlDelete( accounts );
            }
            catch ( SecureDml.SecureDmlException e )
            {
                thrownException = e;
            }
        Test.stopTest();

        System.assertNotEquals( null, thrownException, 'dmlDelete, when the user cannot delete records and cud is off for other objects, will still throw an exception' );
    }

    @isTest
    private static void dmlDelete_whenGivenAnEmptyList_willDoNothing() // NOPMD: Test method name format
    {
        List<Account> emptyList = new List<Account>();

        Test.startTest();

            SecureDml dml = new TestableSecureDml();
            dml.dmlDelete( emptyList );

        Test.stopTest();

        System.assertEquals( null, getAccountsDeleted(), 'dmlDelete, when given an empty list, will not issue any DML' );
    }

    @isTest
    private static void dmlDelete_whenGivenAnEmptyListAndDeleteIsNotAllowed_willDoNothing() // NOPMD: Test method name format
    {
        List<Account> emptyList = new List<Account>();

        Test.startTest();

            SecureDml dml = new TestableSecureDml();

            ((TestableSecureDml)dml).canDelete = false;

            dml.dmlDelete( emptyList );

        Test.stopTest();

        System.assertEquals( null, getAccountsDeleted(), 'dmlDelete, when given an empty list of objects the user cannot delete, will not issue any DML or throw an exception' );
    }

    @isTest
    private static void eventPublish_whenTheUserCanPublishTheEvents_willPublishTheEvents() // NOPMD: Test method name format
    {
        List<Account> fakeEvents = new List<Account> // Events are just SObjects, but no standard ones exist. So we use Accounts as fake events
        {
            new Account( Name = 'Event1' ),
            new Account( Name = 'Event2' )
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml();
            dml.eventPublish( fakeEvents );

        Test.stopTest();

        List<Account> eventsPublished = getEventsPublished();

        System.assertEquals( 'Event1', eventsPublished[0].Name, 'eventPublish, when the user can publish the events, will publish the events (0)' );
        System.assertEquals( 'Event2', eventsPublished[1].Name, 'eventPublish, when the user can publish the events, will publish the events (1)' );
    }

    @isTest
    private static void eventPublish_whenAskedToPublishALotOfEvents_willPublishTheEvents() // NOPMD: Test method name format
    {
        List<Account> fakeEvents = new List<Account>(); // Events are just SObjects, but no standard ones exist. So we use Accounts as fake events
        for ( Integer i=0; i < LOTS_OF_RECORDS; i++ )
        {
            fakeEvents.add( new Account( Name = 'Event' + i ) );
        }

        Test.startTest();

            SecureDml dml = new TestableSecureDml();
            dml.eventPublish( fakeEvents );

        Test.stopTest();

        List<Account> eventsPublished = getEventsPublished();

        System.assertEquals( LOTS_OF_RECORDS, eventsPublished.size(), 'eventPublish, when the user can publish the events, will publish the events without blowing CPU or Heap size limits' );
    }

    @isTest
    private static void eventPublish_whenTheUserCannotPublishEvents_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> fakeEvents = new List<Account> // Events are just SObjects, but no standard ones exist. So we use Accounts as fake events
        {
            new Account( Name = 'Event1' ),
            new Account( Name = 'Event2' )
        };

        Test.startTest();
            ortoo_Exception thrownException;
            try
            {
                SecureDml dml = new TestableSecureDml();
                ((TestableSecureDml)dml).canPublish = false;

                dml.eventPublish( fakeEvents );
            }
            catch ( SecureDml.SecureDmlException e )
            {
                thrownException = e;
            }
        Test.stopTest();

        System.assertNotEquals( null, thrownException, 'eventPublish, when the user cannot publish events, will throw an exception' );

        ortoo_Exception.Contexts contexts = thrownException.getContexts();
        ortoo_Exception.Context context;

        context = contexts.next();
        System.assertEquals( 'sobjectTypeName', context.getName(), 'eventPublish, when the user cannot publish events, will throw an exception with a context named sobjectTypeName' );
        System.assertEquals( Account.getSObjectType().getDescribe().getName(), context.getValue(), 'eventPublish, when the user cannot publish events, will throw an exception with a context named sobjectTypeName set to the name of the SObject' );

        context = contexts.next();
        System.assertEquals( 'records', context.getName(), 'eventPublish, when the user cannot publish events, will throw an exception with a context named records' );
        System.assertEquals( fakeEvents, context.getValue(), 'eventPublish, when the user cannot publish events, will throw an exception with a context named records set to the records that where sent' );

        System.assertEquals( 'eventPublish', thrownException.getStackTrace().getInnermostMethodName(), 'eventPublish, when the user cannot publish events, will throw an exception with the stack trace pointing to the delete method' );
    }

    @isTest
    private static void eventPublish_whenTheUserCanNotPublishButCudOff_willPublishTheEvents() // NOPMD: Test method name format
    {
        List<Account> fakeEvents = new List<Account> // Events are just SObjects, but no standard ones exist. So we use Accounts as fake events
        {
            new Account( Name = 'Event1' ),
            new Account( Name = 'Event2' )
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml();

            ((TestableSecureDml)dml).canPublish = false; // mimics not having publish access

            dml.ignoreCudSettings();
            dml.eventPublish( fakeEvents );

        Test.stopTest();

        List<Account> eventsPublished = getEventsPublished();

        System.assertEquals( fakeEvents[0], eventsPublished[0], 'eventPublish, when the user cannot publish the events but cud switched off, will publish the events - 0' );
        System.assertEquals( fakeEvents[1], eventsPublished[1], 'eventPublish, when the user cannot publish the events but cud switched off, will publish the events - 1' );
    }

    @isTest
    private static void eventPublish_whenTheUserCanNotPublishButCudOffForThatObject_willPublishTheEvents() // NOPMD: Test method name format
    {
        List<Account> fakeEvents = new List<Account> // Events are just SObjects, but no standard ones exist. So we use Accounts as fake events
        {
            new Account( Name = 'Event1' ),
            new Account( Name = 'Event2' )
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml()
                                    .ignoreCudSettingsFor( Account.SobjectType );

            ((TestableSecureDml)dml).canPublish = false; // mimics not having publish access

            dml.eventPublish( fakeEvents );

        Test.stopTest();

        List<Account> eventsPublished = getEventsPublished();

        System.assertEquals( fakeEvents[0], eventsPublished[0], 'eventPublish, when the user cannot publish the events but cud switched off for that sobject type, will publish the events (0)' );
        System.assertEquals( fakeEvents[1], eventsPublished[1], 'eventPublish, when the user cannot publish the events but cud switched off for that sobject type, will publish the events (1)' );
    }

    @isTest
    private static void eventPublish_whenTheUserCanNotPublishButCudOffForMultipleObjects_willPublishTheEvents() // NOPMD: Test method name format
    {
        List<Account> fakeEvents = new List<Account> // Events are just SObjects, but no standard ones exist. So we use Accounts as fake events
        {
            new Account( Name = 'Event1' ),
            new Account( Name = 'Event2' )
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml()
                                    .ignoreCudSettingsFor( Account.SobjectType )
                                    .ignoreCudSettingsFor( Contact.SobjectType );

            ((TestableSecureDml)dml).canPublish = false; // mimics not having publish access

            dml.eventPublish( fakeEvents );

        Test.stopTest();

        List<Account> eventsPublished = getEventsPublished();

        System.assertEquals( fakeEvents[0], eventsPublished[0], 'eventPublish, when the user cannot publish the events but cud switched off for multiple sobject types, including that one, will publish the events (0)' );
        System.assertEquals( fakeEvents[1], eventsPublished[1], 'eventPublish, when the user cannot publish the events but cud switched off for multiple sobject types, including that one, will publish the events (1)' );
    }

    @isTest
    private static void eventPublish_whenTheUserCannotPublishEventsAndCudOfForOtherObjects_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> fakeEvents = new List<Account> // Events are just SObjects, but no standard ones exist. So we use Accounts as fake events
        {
            new Account( Name = 'Event1' ),
            new Account( Name = 'Event2' )
        };

        Test.startTest();
            ortoo_Exception thrownException;
            try
            {
                SecureDml dml = new TestableSecureDml()
                                        .ignoreCudSettingsFor( Contact.sobjectType );

                ((TestableSecureDml)dml).canPublish = false;

                dml.eventPublish( fakeEvents );
            }
            catch ( SecureDml.SecureDmlException e )
            {
                thrownException = e;
            }
        Test.stopTest();

        System.assertNotEquals( null, thrownException, 'eventPublish, when the user cannot publish events and cud is off for other objects, will still throw an exception' );
    }

    @isTest
    private static void eventPublish_whenGivenAnEmptyList_willDoNothing() // NOPMD: Test method name format
    {
        List<Account> emptyList = new List<Account>(); // Events are just SObjects, but no standard ones exist. So we use Accounts as fake events

        Test.startTest();

            SecureDml dml = new TestableSecureDml();
            dml.eventPublish( emptyList );

        Test.stopTest();

        System.assertEquals( null, getEventsPublished(), 'eventPublish, when given an empty list, will not issue any DML' );
    }

    @isTest
    private static void eventPublish_whenGivenAnEmptyListAndPublishIsNotAllowed_willDoNothing() // NOPMD: Test method name format
    {
        List<Account> emptyList = new List<Account>(); // Events are just SObjects, but no standard ones exist. So we use Accounts as fake events

        Test.startTest();

            SecureDml dml = new TestableSecureDml();

            ((TestableSecureDml)dml).canPublish = false;

            dml.eventPublish( emptyList );

        Test.stopTest();

        System.assertEquals( null, getEventsPublished(), 'eventPublish, when given an empty list of objects the user cannot delete, will not issue any DML or throw an exception' );
    }


    private static List<Account> getAccountsInserted()
    {
        return recordsInserted;
    }

    private static List<Account> getAccountsUpdated()
    {
        return recordsUpdated;
    }

    private static List<Account> getAccountsDeleted()
    {
        return recordsDeleted;
    }

    private static List<Account> getEventsPublished()
    {
        return recordsPublished;
    }

    private static List<Sobject> recordsInserted;
    private static List<Sobject> recordsUpdated;
    private static List<Sobject> recordsDeleted;
    private static List<Sobject> recordsPublished;

    // version of SecureDml that allows us to override the checks on whether
    // the current user can create / update / delete as well as the actual DML
    // Overriding the DML allows the tests to run in any environment
    private inherited sharing class TestableSecureDml extends SecureDml
    {
        public Boolean canCreate  = true;
        public Boolean canUpdate  = true;
        public Boolean canDelete  = true;
        public Boolean canPublish = true;

        public SecureDml.SecurityDecision stripInaccessibleSecurityDecision;

        private void assignIds( List<Sobject> records )
        {
            for ( Sobject thisRecord : records )
            {
                thisRecord.put( 'Id', TestIdUtils.generateId( thisRecord.getSObjectType() ) );
            }
        }

        protected override void doInsert( List<Sobject> records )
        {
            assignIds( records );
            recordsInserted = records;
        }

        protected override void doUpdate( List<Sobject> records )
        {
            assignIds( records );
            recordsUpdated = records;
        }

        protected override void doDelete( List<Sobject> records )
        {
            assignIds( records );
            recordsDeleted = records;
        }

        protected override void doPublish( List<Sobject> records )
        {
            assignIds( records );
            recordsPublished = records;
        }

        protected override Boolean userCanCreate( Sobject record )
        {
            return canCreate;
        }

        protected override Boolean userCanPublish( Sobject record )
        {
            return canPublish;
        }

        protected override Boolean userCanUpdate( Sobject record )
        {
            return canUpdate;
        }

        protected override Boolean userCanDelete( Sobject record )
        {
            return canDelete;
        }

        protected override SecureDml.SecurityDecision stripInaccessible( AccessType mode, List<Sobject> objList )
        {
            if ( stripInaccessibleSecurityDecision != null )
            {
                return stripInaccessibleSecurityDecision;
            }
            return new SecureDml.SecurityDecision( new Map<String,Set<String>>(), objList.clone() );
        }
    }

    private inherited sharing class SwallowOnFlsViolationHandler implements SecureDml.FlsViolationHandler
    {
		public void handleInaccessibleFields( AccessType mode, SobjectType sobjectType, Set<String> fieldsInViolation ) {} // NOPMD: intentionally left blank
    }

    private inherited sharing class SwallowOnCudViolationHandler implements SecureDml.CudViolationHandler
    {
		public void handleUnableToInsertRecords( List<SObject> objList ) {} // NOPMD: intentionally left blank
		public void handleUnableToUpdateRecords( List<SObject> objList ) {} // NOPMD: intentionally left blank
		public void handleUnableToDeleteRecords( List<SObject> objList ) {} // NOPMD: intentionally left blank
		public void handleUnableToPublishEvents( List<SObject> objList ) {} // NOPMD: intentionally left blank
    }
}