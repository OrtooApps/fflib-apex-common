// If there is any risk that this test would stop working in a given App implementation, then it should be rewritten or removed.
// It is written in a way that assumes that Accounts and Contacts are configured to allow for the most trivial records to be created
@isTest
private without sharing class SecureDmlTest
{
    @isTest
    private static void dmlInsert_whenTheUserCanCreateTheRecords_willInsertTheRecords() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            (Account)new FAccount().name( 'Account1' ).toPersistableSobject(),
            (Account)new FAccount().name( 'Account2' ).toPersistableSobject()
        };

        Test.startTest();

            SecureDml dml = new TestableSecureDml();
            dml.dmlInsert( accounts );

        Test.stopTest();

        System.assertNotEquals( null, accounts[0].Id, 'dmlInsert, when the user can create the records, will insert the records, setting the Id on them (0)' );
        System.assertNotEquals( null, accounts[1].Id, 'dmlInsert, when the user can create the records, will insert the records, setting the Id on them (1)' );

        List<Account> createdAccounts = getAccounts();

        System.assertEquals( 'Account1', accounts[0].Name, 'dmlInsert, when the user can create the records, will insert the records, setting the fields on the records that are created (0)' );
        System.assertEquals( 'Account2', accounts[1].Name, 'dmlInsert, when the user can create the records, will insert the records, setting the fields on the records that are created (1)' );
    }

    @isTest
    private static void dmlInsert_whenTheUserCannotCreateRecords_willThrowAnException() // NOPMD: Test method name format
    {
        List<Account> accounts = new List<Account>
        {
            (Account)new FAccount().name( 'Account1' ).toPersistableSobject(),
            (Account)new FAccount().name( 'Account2' ).toPersistableSobject()
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
            (Account)new FAccount().name( 'Account1' ).toPersistableSobject(),
            (Account)new FAccount().name( 'Account2' ).toPersistableSobject()
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
            (Account)new FAccount().name( 'Account1' ).toPersistableSobject(),
            (Account)new FAccount().name( 'Account2' ).toPersistableSobject()
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
            (Account)new FAccount().name( 'Account1' ).toPersistableSobject(),
            (Account)new FAccount().name( 'Account2' ).toPersistableSobject()
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
            (Account)new FAccount().name( 'Account1' ).toPersistableSobject(),
            (Account)new FAccount().name( 'Account2' ).toPersistableSobject()
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

    private static List<Account> getAccounts()
    {
        return [SELECT Name FROM Account ORDER BY Name];
    }

    // version of SecureDml that allows us to override the checks on whether
    // the current user can create / update / delete
    private inherited sharing class TestableSecureDml extends SecureDml
    {
        public Boolean canCreate = true;
        public Boolean canUpdate = true;
        public Boolean canDelete = true;

        public SecureDml.SecurityDecision stripInaccessibleSecurityDecision;

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
    }
}