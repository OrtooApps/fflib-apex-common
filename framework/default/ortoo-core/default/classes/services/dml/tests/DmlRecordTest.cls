@isTest
private without sharing class DmlRecordTest
{
    @isTest
    private static void constructor_whenGivenAnSobject_willInitialiseTheDmlRecordWithThatSobject() // NOPMD: Test method name format
    {
        Account recordToDml = new Account();
        Test.startTest();
            DmlRecord dmlRecord = new DmlRecord( recordToDml );
        Test.stopTest();

        System.assertEquals( recordToDml, dmlRecord.getSobject(), 'constructor, when given an SObject, will initialise with that SObject' );
    }

    @isTest
    private static void constructor_whenGivenNull_willThrowAnException() // NOPMD: Test method name format
    {
        Test.startTest();
            String exceptionMessage;
            try
            {
                new DmlRecord( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'DmlRecord constructor called with a null recordToDml', exceptionMessage, 'constructor, when given null, will throw an exception' );
    }

    @isTest
    private static void addChildContect_whenCalled_willInitialiseADefinerForThatType() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        DmlChildContext dmlChildContext = new DmlChildContext( Contact.AccountId, IChildRecordFinder.class );

        Test.startTest();
            dmlRecord.addChildContext( 'Contacts', dmlChildContext );
        Test.stopTest();

        System.assertNotEquals( null, dmlRecord.getChildDefiner( 'Contacts' ), 'addChildContect, when called, will initialise a definer for that child type' );
        System.assertEquals( dmlChildContext, dmlRecord.getChildContext( 'Contacts' ), 'addChildContect, when called, will set the child context for that child type' );
    }

    @isTest
    private static void addChildContext_whenCalledWithANullType_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.addChildContext( null, new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );
            }
            catch ( Exception e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'addChildContext called with a null childRecordType', exceptionMessage, 'addChildContext, when called with a null type, will throw an exception' );
    }

    @isTest
    private static void addChildContext_whenCalledWithANullContext_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.addChildContext( 'Contacts', null );
            }
            catch ( Exception e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'addChildContext called with a null childContext', exceptionMessage, 'addChildContext, when called with a null childContext, will throw an exception' );
    }

    @isTest
    private static void addChild_whenGivenAValidChildType_willAddThatChild() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );

        DmlRecord child = new DmlRecord( new Contact() );

        Test.startTest();
            dmlRecord.addChild( 'Contacts', child );
        Test.stopTest();

        System.assertEquals( 1, dmlRecord.getChildDefiner( 'Contacts' ).getDmlRecords().size(), 'addChild, when given a valid child type, will add that child - checking length' );
        System.assertEquals( child, dmlRecord.getChildDefiner( 'Contacts' ).getDmlRecords()[0], 'addChild, when given a valid child type, will add that child - checking DmlRecord' );
        System.assertEquals( DmlDefinerOptions.OtherRecordsOption.IGNORE_RECORDS, dmlRecord.getChildDefiner( 'Contacts' ).getOptions().getOtherRecordsMode(), 'addChild, when given a valid child type, will set the other records mode to ignore' );
    }

    @isTest
    private static void addChild_whenGivenAChildTypeThatDoesNotExist_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.addChild( 'InvalidType', new DmlRecord( new Contact() ) );
            }
            catch ( Contract.AssertException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'InvalidType', exceptionMessage, 'addChild, when given a child type that does not exist, will throw an exception' );
    }

    @isTest
    private static void addChild_whenGivenANullChildType_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.addChild( null, new DmlRecord( new Contact() ) );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'addChild called with a null childRecordType', exceptionMessage, 'addChild, when given a null child type, will throw an exception' );
    }

    @isTest
    private static void addChild_whenGivenANullChildRecord_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.addChild( 'Contacts', null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'addChild called with a null childRecord', exceptionMessage, 'addChild, when given a null child context, will throw an exception' );
    }

    @isTest
    private static void addChildren_whenGivenAValidChildType_willAddThoseChildren() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );

        List<DmlRecord> children = new List<DmlRecord>
        {
            new DmlRecord( new Contact() ),
            new DmlRecord( new Contact() ),
            new DmlRecord( new Contact() )
        };

        Test.startTest();
            dmlRecord.addChildren( 'Contacts', children );
        Test.stopTest();

        System.assertEquals( children, dmlRecord.getChildDefiner( 'Contacts' ).getDmlRecords(), 'addChildren, when given a valid child type, will add those children' );
        System.assertEquals( DmlDefinerOptions.OtherRecordsOption.IGNORE_RECORDS, dmlRecord.getChildDefiner( 'Contacts' ).getOptions().getOtherRecordsMode(), 'addChildren, when given a valid child type, will set the other records mode to ignore' );
    }

    @isTest
    private static void addChildren_whenGivenAChildTypeThatDoesNotExist_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.addChildren( 'InvalidType', new List<DmlRecord>{ new DmlRecord( new Contact() ) } );
            }
            catch ( Contract.AssertException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'InvalidType', exceptionMessage, 'addChildren, when given a child type that does not exist, will throw an exception' );
    }

    @isTest
    private static void addChildren_whenGivenANullChildType_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.addChildren( null, new List<DmlRecord>{ new DmlRecord( new Contact() ) } );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'addChildren called with a null childRecordType', exceptionMessage, 'addChildren, when given a null child type, will throw an exception' );
    }

    @isTest
    private static void addChildren_whenGivenANullChildRecord_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.addChildren( 'Contacts', null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'addChildren called with a null childRecords', exceptionMessage, 'addChildren, when given a null child context, will throw an exception' );
    }

    @isTest
    private static void setChild_whenGivenAValidChildType_willSetTheChildrenToThatChild() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );

        List<DmlRecord> preExistingChildren = new List<DmlRecord>
        {
            new DmlRecord( new Contact() ),
            new DmlRecord( new Contact() ),
            new DmlRecord( new Contact() )
        };
        dmlRecord.addChildren( 'Contacts', preExistingChildren );

        DmlRecord newChild = new DmlRecord( new Contact() );

        Test.startTest();
            dmlRecord.setChild( 'Contacts', newChild );
        Test.stopTest();

        System.assertEquals( 1, dmlRecord.getChildDefiner( 'Contacts' ).getDmlRecords().size(), 'setChild, when given a valid child type, will set the children to that child - checking size' );
        System.assertEquals( newChild, dmlRecord.getChildDefiner( 'Contacts' ).getDmlRecords()[0], 'setChild, when given a valid child type, will set the children to that child - checking child' );
        System.assertEquals( DmlDefinerOptions.OtherRecordsOption.DELETE_RECORDS, dmlRecord.getChildDefiner( 'Contacts' ).getOptions().getOtherRecordsMode(), 'setChild, when given a valid child type, will set the other records mode to delete' );
    }

    @isTest
    private static void setChild_whenGivenAChildTypeThatDoesNotExist_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.setChild( 'InvalidType', new DmlRecord( new Contact() ) );
            }
            catch ( Contract.AssertException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'InvalidType', exceptionMessage, 'setChild, when given a child type that does not exist, will throw an exception' );
    }

    @isTest
    private static void setChild_whenGivenANullChildType_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.setChild( null, new DmlRecord( new Contact() ) );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'setChild called with a null childRecordType', exceptionMessage, 'setChild, when given a null child type, will throw an exception' );
    }

    @isTest
    private static void setChild_whenGivenANullChildRecord_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.setChild( 'Contacts', null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'setChild called with a null childRecord', exceptionMessage, 'setChild, when given a null child context, will throw an exception' );
    }

    @isTest
    private static void setChildren_whenGivenAValidChildType_willSetThoseChildren() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );

        List<DmlRecord> preExistingChildren = new List<DmlRecord>
        {
            new DmlRecord( new Contact() ),
            new DmlRecord( new Contact() )
        };
        dmlRecord.addChildren( 'Contacts', preExistingChildren );

        List<DmlRecord> newChildren = new List<DmlRecord>
        {
            new DmlRecord( new Contact() ),
            new DmlRecord( new Contact() ),
            new DmlRecord( new Contact() )
        };

        Test.startTest();
            dmlRecord.setChildren( 'Contacts', newChildren );
        Test.stopTest();

        System.assertEquals( newChildren, dmlRecord.getChildDefiner( 'Contacts' ).getDmlRecords(), 'setChildren, when given a valid child type, will set those children' );
        System.assertEquals( DmlDefinerOptions.OtherRecordsOption.DELETE_RECORDS, dmlRecord.getChildDefiner( 'Contacts' ).getOptions().getOtherRecordsMode(), 'setChildren, when given a valid child type, will set the other records mode to delete' );
    }

    @isTest
    private static void setChildren_whenGivenAChildTypeThatDoesNotExist_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.setChildren( 'InvalidType', new List<DmlRecord>{ new DmlRecord( new Contact() ) } );
            }
            catch ( Contract.AssertException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'InvalidType', exceptionMessage, 'setChildren, when given a child type that does not exist, will throw an exception' );
    }

    @isTest
    private static void setChildren_whenGivenANullChildType_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.setChildren( null, new List<DmlRecord>{ new DmlRecord( new Contact() ) } );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'setChildren called with a null childRecordType', exceptionMessage, 'setChildren, when given a null child type, will throw an exception' );
    }

    @isTest
    private static void setChildren_whenGivenANullChildRecord_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );

        List<DmlRecord> nullRecords = null;
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.setChildren( 'Contacts', nullRecords );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'setChildren called with a null childRecords', exceptionMessage, 'setChildren, when given a null child context, will throw an exception' );
    }

    @isTest
    private static void setChildrenDmlDefiner_whenGivenAValidChildType_willSetThoseChildren() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );

        List<DmlRecord> preExistingChildren = new List<DmlRecord>
        {
            new DmlRecord( new Contact() ),
            new DmlRecord( new Contact() )
        };
        dmlRecord.addChildren( 'Contacts', preExistingChildren );

        DmlDefiner newChildren = new DmlDefiner( new List<DmlRecord>
        {
            new DmlRecord( new Contact() ),
            new DmlRecord( new Contact() ),
            new DmlRecord( new Contact() )
        } );

        Test.startTest();
            dmlRecord.setChildren( 'Contacts', newChildren );
        Test.stopTest();

        System.assertEquals( newChildren, dmlRecord.getChildDefiner( 'Contacts' ), 'setChildren (DmlDefiner), when given a valid child type, will set those children' );
        System.assertEquals( DmlDefinerOptions.OtherRecordsOption.DELETE_RECORDS, dmlRecord.getChildDefiner( 'Contacts' ).getOptions().getOtherRecordsMode(), 'setChildren (DmlDefiner), when given a valid child type, will set the other records mode to delete' );
    }

    @isTest
    private static void setChildrenDmlDefiner_whenGivenAChildTypeThatDoesNotExist_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.setChildren( 'InvalidType', new DmlDefiner() );
            }
            catch ( Contract.AssertException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'InvalidType', exceptionMessage, 'setChildren (DmlDefiner), when given a child type that does not exist, will throw an exception' );
    }

    @isTest
    private static void setChildrenDmlDefiner_whenGivenANullChildType_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.setChildren( null, new DmlDefiner() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'setChildren called with a null childRecordType', exceptionMessage, 'setChildren (DmlDefiner), when given a null child type, will throw an exception' );
    }

    @isTest
    private static void setChildrenDmlDefiner_whenGivenANullChildDmlDefiner_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );

        DmlDefiner nullDefiner = null;
        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.setChildren( 'Contacts', nullDefiner );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'setChildren called with a null childRecords', exceptionMessage, 'setChildren (DmlDefiner), when given a null child context, will throw an exception' );
    }

    @isTest
    private static void getChildDefiner_whenGivenAChildTypeThatDoesNotExist_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );

        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.getChildDefiner( 'Invalid' );
            }
            catch ( Contract.AssertException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'Invalid', exceptionMessage, 'getChildDefiner, when given a child type that does not exist, will throw an exception' );
    }

    @isTest
    private static void setChildDmlOptions_whenGivenADmlDefinerOptions_willSetThatOnTheChildDefiner() // NOPMD: Test method name format
    {

        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );

        DmlDefinerOptions options = new DmlDefinerOptions();

        Test.startTest();
            dmlRecord.setChildDmlOptions( 'Contacts', options );
        Test.stopTest();

        System.assertEquals( options, dmlRecord.getChildDefiner( 'Contacts' ).getOptions(), 'setChildDmlOptions, when given a DmlDefinerOptions, will set it on the child definer' );
    }

    @isTest
    private static void setChildDmlOptions_whenGivenAChildTypeThatDoesNotExist_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );

        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.setChildDmlOptions( 'Invalid', new DmlDefinerOptions() );
            }
            catch ( Contract.AssertException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'Invalid', exceptionMessage, 'setChildDmlOptions, when given a child type that does not exist, will throw an exception' );
    }

    @isTest
    private static void setChildDmlOptions_whenGivenANullChildType_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );

        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.setChildDmlOptions( null, new DmlDefinerOptions() );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'setChildDmlOptions called with a null childRecordType', exceptionMessage, 'setChildDmlOptions, when given a null child type, will throw an exception' );
    }

    @isTest
    private static void setChildDmlOptions_whenGivenANullOptions_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );

        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.setChildDmlOptions( 'Contacts', null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'setChildDmlOptions called with a null options', exceptionMessage, 'setChildDmlOptions, when given a null options, will throw an exception' );
    }

    @isTest
    private static void addChildPreSaveAction_whenGivenAValidTypeAndAction_willAddItToThatChildTypeDefiner() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );

        IDmlRecordAction action = (IDmlRecordAction)new Amoss_Instance( IDmlRecordAction.class ).generateDouble();

        Test.startTest();
            dmlRecord.addChildPreSaveAction( 'Contacts', action );
        Test.stopTest();

        System.assertEquals( 1, dmlRecord.getChildDefiner( 'Contacts' ).getPreSaveActions().size(), 'addChildPreSaveAction, when given a valid type and action, will add the action to that child type definer - checking size' );
        System.assertEquals( action, dmlRecord.getChildDefiner( 'Contacts' ).getPreSaveActions()[0], 'addChildPreSaveAction, when given a valid type and action, will add the action to that child type definer - checking size' );
    }

    @isTest
    private static void addChildPreSaveAction_whenGivenAChildTypeThatDoesNotExist_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        IDmlRecordAction action = (IDmlRecordAction)new Amoss_Instance( IDmlRecordAction.class ).generateDouble();

        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.addChildPreSaveAction( 'Invalid', action );
            }
            catch ( Contract.AssertException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'Invalid', exceptionMessage, 'addChildPreSaveAction, when given a child type that does not exist, will throw an exception' );
    }

    @isTest
    private static void addChildPreSaveAction_whenGivenANullChildType_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );

        IDmlRecordAction action = (IDmlRecordAction)new Amoss_Instance( IDmlRecordAction.class ).generateDouble();

        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.addChildPreSaveAction( null, action );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'addChildPreSaveAction called with a null childRecordType', exceptionMessage, 'addChildPreSaveAction, when given a null child type, will throw an exception' );
    }

    @isTest
    private static void addChildPreSaveAction_whenGivenANullAction_willThrowAnException() // NOPMD: Test method name format
    {
        DmlRecord dmlRecord = new DmlRecord( new Account() );
        dmlRecord.addChildContext( 'Contacts', new DmlChildContext( Contact.AccountId, IChildRecordFinder.class ) );

        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.addChildPreSaveAction( 'Contacts', null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'addChildPreSaveAction called with a null action', exceptionMessage, 'addChildPreSaveAction, when given a null action, will throw an exception' );
    }

    @isTest
    private static void saveSobject_onRecordWithNoChildren_whenGivenAUowAndNoChildContext_willSaveTheCurrentRecord() // NOPMD: Test method name format
    {
        Amoss_Instance uowController = new Amoss_Instance( fflib_SobjectUnitOfWork.class );
        fflib_SobjectUnitOfWork uow = (fflib_SobjectUnitOfWork)uowController.generateDouble();

        Account recordToSave = new Account();

        DmlRecord dmlRecord = new DmlRecord( recordToSave );

        // Check that the save of the current record is then registered with the uow
        uowController
            .expects( 'registerUpsert' )
            .withParameter( recordToSave );

        Test.startTest();
            dmlRecord.saveSobject( uow, null );
        Test.stopTest();

        uowController.verify();
    }

    @isTest
    private static void saveSobject_onRecordWithNoChildren_whenGivenAUowAndAChildContext_willSaveTheCurrentRecord() // NOPMD: Test method name format
    {
        Amoss_Instance recordContextController = new Amoss_Instance( DmlChildContext.class );
        DmlChildContext recordContext = (DmlChildContext)recordContextController.generateDouble();

        Amoss_Instance uowController = new Amoss_Instance( fflib_SobjectUnitOfWork.class );
        fflib_SobjectUnitOfWork uow = (fflib_SobjectUnitOfWork)uowController.generateDouble();

        Account recordToSave = new Account();

        DmlRecord dmlRecord = new DmlRecord( recordToSave );

        // Check it will register the relationship between the current record and the passed in child context
        recordContextController
            .expects( 'registerRelationship' )
            .withParameter( uow )
            .thenParameter( recordToSave );

        // Check that the save of the current record is then registered with the uow
        uowController
            .expects( 'registerUpsert' )
            .withParameter( recordToSave );

        Test.startTest();
            dmlRecord.saveSobject( uow, recordContext );
        Test.stopTest();

        recordContextController.verify();
        uowController.verify();
    }

    @isTest
    private static void saveSobject_onRecordWithChildren_whenGivenAUowAndAChildContext_willSaveTheCurrentAndChildRecords() // NOPMD: Test method name format
    {
        Amoss_Instance childContextController = new Amoss_Instance( DmlChildContext.class );
        DmlChildContext childContext = (DmlChildContext)childContextController.generateDouble();

        Amoss_Instance recordContextController = new Amoss_Instance( DmlChildContext.class );
        DmlChildContext recordContext = (DmlChildContext)recordContextController.generateDouble();

        Amoss_Instance uowController = new Amoss_Instance( fflib_SobjectUnitOfWork.class );
        fflib_SobjectUnitOfWork uow = (fflib_SobjectUnitOfWork)uowController.generateDouble();

        Amoss_Instance childDmlRecordController = new Amoss_Instance( DmlRecord.class );
        DmlRecord childRecord = (DmlRecord)childDmlRecordController.generateDouble();

        Account parentRecordToSave = new Account();

        DmlRecord dmlRecord = new DmlRecord( parentRecordToSave );
        dmlRecord.addChildContext( 'Contacts', childContext );
        dmlRecord.addChild( 'Contacts', childRecord );

        // Check it will register the relationship between the current record and the passed in child context
        recordContextController
            .expects( 'registerRelationship' )
            .withParameter( uow )
            .thenParameter( parentRecordToSave );

        // Check that the save of the current record is then registered with the uow
        uowController
            .expects( 'registerUpsert' )
            .withParameter( parentRecordToSave );

        // Check that the current record gets set as the parent on the child context
        childContextController
            .expects( 'setParent' )
            .withParameter( parentRecordToSave )
            .returning( childContext );

        // Check that the child record gets told to save itself, with the context provided
        childDmlRecordController
            .expects( 'saveSobject' )
            .withParameter( uow )
            .thenParameter( childContext );

        Test.startTest();
            dmlRecord.saveSobject( uow, recordContext );
        Test.stopTest();

        recordContextController.verify();
        uowController.verify();
        childContextController.verify();
        childDmlRecordController.verify();
    }

    @isTest
    private static void saveSobject_whenCalledWithANullUow_willThrowAnException() // NOPMD: Test method name format
    {
        Account parentRecordToSave = new Account();
        DmlRecord dmlRecord = new DmlRecord( parentRecordToSave );

        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.saveSobject( null, null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'saveSobject called with a null uow', exceptionMessage, 'saveSobject, when called with a null uow, will throw an exception' );
    }

    @isTest
    private static void registerChildrenToDelete_whenCalledWithoutARecordWithAnId_willNotRecordTheCurrentRecordsAsNotToBeDeleted() // NOPMD: Test method name format
    {
        Amoss_Instance childRegisterController = new Amoss_Instance( DmlChildrenToDeleteRegister.class );
        DmlChildrenToDeleteRegister childRegister = (DmlChildrenToDeleteRegister)childRegisterController.generateDouble();

        Account recordToSave = new Account();
        DmlRecord dmlRecord = new DmlRecord( recordToSave );

        childRegisterController
            .expectsNoCalls();

        Test.startTest();
            dmlRecord.registerChildrenToDelete( childRegister );
        Test.stopTest();

        childRegisterController.verify();
    }

    @isTest
    private static void registerChildrenToDelete_whenCalledWithARecordWithAnId_willRecordTheCurrentRecordsIdAsNotToBeDeleted() // NOPMD: Test method name format
    {
        Amoss_Instance childRegisterController = new Amoss_Instance( DmlChildrenToDeleteRegister.class );
        DmlChildrenToDeleteRegister childRegister = (DmlChildrenToDeleteRegister)childRegisterController.generateDouble();

        Account recordToSave = new Account( Id = TestIdUtils.generateId( Account.SobjectType ) );
        DmlRecord dmlRecord = new DmlRecord( recordToSave );

        childRegisterController
            .expects( 'addRecordToKeep' )
            .withParameter( recordToSave.Id );

        Test.startTest();
            dmlRecord.registerChildrenToDelete( childRegister );
        Test.stopTest();

        childRegisterController.verify();
    }

    @isTest
    private static void registerChildrenToDelete_whenCalledAgainstADmlRecordWithChildren_willTellTheChildrenToRegisterTheirDeletes() // NOPMD: Test method name format
    {
        Amoss_Instance childRegisterController = new Amoss_Instance( DmlChildrenToDeleteRegister.class );
        DmlChildrenToDeleteRegister childRegister = (DmlChildrenToDeleteRegister)childRegisterController.generateDouble();

        Amoss_Instance childContextController = new Amoss_Instance( DmlChildContext.class );
        DmlChildContext childContext = (DmlChildContext)childContextController.generateDouble();

        Amoss_Instance childDefinerController = new Amoss_Instance( DmlDefiner.class );
        DmlDefiner childDefiner = (DmlDefiner)childDefinerController.generateDouble();

        Account recordToSave = new Account();
        DmlRecord dmlRecord = new DmlRecord( recordToSave );
        dmlRecord.addChildContext( 'Contacts', childContext );
        dmlRecord.setChildren( 'Contacts', childDefiner );

        childDefinerController
            .when( 'getOptions')
            .returns( new DmlDefinerOptions() )
        .also()
            .expects( 'registerChildrenToDelete' )
            .withParameter( childRegister );

        Test.startTest();
            dmlRecord.registerChildrenToDelete( childRegister );
        Test.stopTest();

        childDefinerController.verify();
    }

    @isTest
    private static void registerChildrenToDelete_whenOptionsAreSetToDeleteChildren_willTellTheRegisterToDelete() // NOPMD: Test method name format
    {
        Amoss_Instance childRegisterController = new Amoss_Instance( DmlChildrenToDeleteRegister.class );
        DmlChildrenToDeleteRegister childRegister = (DmlChildrenToDeleteRegister)childRegisterController.generateDouble();

        Amoss_Instance childContextController = new Amoss_Instance( DmlChildContext.class );
        DmlChildContext childContext = (DmlChildContext)childContextController.generateDouble();

        Amoss_Instance childDefinerController = new Amoss_Instance( DmlDefiner.class );
        DmlDefiner childDefiner = (DmlDefiner)childDefinerController.generateDouble();

        DmlDefinerOptions childDmlOptions = new DmlDefinerOptions().setOtherRecordsMode( DmlDefinerOptions.OtherRecordsOption.DELETE_RECORDS );

        Account recordToSave = new Account( Id = TestIdUtils.generateId( Account.SobjectType ) );
        DmlRecord dmlRecord = new DmlRecord( recordToSave );
        dmlRecord.addChildContext( 'Contacts', childContext );
        dmlRecord.setChildren( 'Contacts', childDefiner );

        childDefinerController
            .when( 'getOptions' )
            .returns( childDmlOptions );

        childRegisterController
            .allows( 'addRecordToKeep' )
        .also()
            .expects( 'registerChildContextAndParent' )
            .withParameter( childContext )
            .thenParameter( recordToSave.Id );

        Test.startTest();
            dmlRecord.registerChildrenToDelete( childRegister );
        Test.stopTest();

        childDefinerController.verify();
    }

    @isTest
    private static void registerChildrenToDelete_whenOptionsAreSetToIgnoreChildren_willNotTellTheRegisterToDelete() // NOPMD: Test method name format
    {
        Amoss_Instance childRegisterController = new Amoss_Instance( DmlChildrenToDeleteRegister.class );
        DmlChildrenToDeleteRegister childRegister = (DmlChildrenToDeleteRegister)childRegisterController.generateDouble();

        Amoss_Instance childContextController = new Amoss_Instance( DmlChildContext.class );
        DmlChildContext childContext = (DmlChildContext)childContextController.generateDouble();

        Amoss_Instance childDefinerController = new Amoss_Instance( DmlDefiner.class );
        DmlDefiner childDefiner = (DmlDefiner)childDefinerController.generateDouble();

        DmlDefinerOptions childDmlOptions = new DmlDefinerOptions().setOtherRecordsMode( DmlDefinerOptions.OtherRecordsOption.IGNORE_RECORDS );

        Account recordToSave = new Account( Id = TestIdUtils.generateId( Account.SobjectType ) );
        DmlRecord dmlRecord = new DmlRecord( recordToSave );
        dmlRecord.addChildContext( 'Contacts', childContext );
        dmlRecord.setChildren( 'Contacts', childDefiner );

        // Note that we do not expect registerChildContextAndParent to be called
        childRegisterController
            .allows( 'addRecordToKeep' );

        childDefinerController
            .allows( 'getOptions')
            .returns( childDmlOptions )
        .also()
            .allows( 'registerChildrenToDelete' );

        Test.startTest();
            dmlRecord.registerChildrenToDelete( childRegister );
        Test.stopTest();

        childDefinerController.verify();
    }

    @isTest
    private static void registerChildrenToDelete_whenCalledWithANullRegister_willThrowAnException() // NOPMD: Test method name format
    {
        Account parentRecordToSave = new Account();
        DmlRecord dmlRecord = new DmlRecord( parentRecordToSave );

        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlRecord.registerChildrenToDelete( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'registerChildrenToDelete called with a null register', exceptionMessage, 'registerChildrenToDelete, when called with a null register, will throw an exception' );
    }
}