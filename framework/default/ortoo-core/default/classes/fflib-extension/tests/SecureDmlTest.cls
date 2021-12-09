@isTest
private without sharing class SecureDmlTest
{
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

        System.assertEquals( 0, Limits.getDmlStatements(), 'dmlInsert, when given an empty list, will not issue any DML' );
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

        System.assertEquals( 0, Limits.getDmlStatements(), 'dmlInsert, when given an empty list of objects the user cannot create, will not issue any DML or throw an exception' );
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

// when exception is supressed, will strip the fields
/*
        System.assertEquals( null, accounts[0].Name, 'dmlInsert, when the user cannot create records because of FLS, will update the records to remove the fields in violation' );
        System.assertEquals( 1, accounts[0].NumberOfEmployees, 'dmlInsert, when the user cannot create records because of FLS, will ensure the supressed fields keep their values' );
*/

    private static List<Account> getAccountsInserted()
    {
        return recordsInserted;
    }

    private static List<Sobject> recordsInserted;
    private static List<Sobject> recordsUpdated;
    private static List<Sobject> recordsDeleted;
    private static List<Sobject> recordsPublished;

    // version of SecureDml that allows us to override the checks on whether
    // the current user can create / update / delete
    private inherited sharing class TestableSecureDml extends SecureDml
    {
        public Boolean canCreate = true;
        public Boolean canUpdate = true;
        public Boolean canDelete = true;

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

    private inherited sharing class FAccount extends sfab_FabricatedSobject
    {
        public FAccount()
        {
            super( Account.class );
            name( 'Default Name' );
        }

        public FAccount name( String name )
        {
            set( Account.Name, name );
            return this;
        }

        public FAccount numberOfEmployees( Integer numberOfEmployees )
        {
            set( Account.NumberOfEmployees, numberOfEmployees );
            return this;
        }
    }
}