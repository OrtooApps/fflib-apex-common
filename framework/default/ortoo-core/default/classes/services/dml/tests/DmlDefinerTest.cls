@isTest
private without sharing class DmlDefinerTest
{
	@isTest
    private static void construction_whenNotGivenAnyDmlRecords_willInitialiseWithAnEmptyList() // NOPMD: Test method name format
    {
        DmlDefiner dmlDefiner = new DmlDefiner();
        System.assertEquals( 0, dmlDefiner.recordsToDml.size(), 'construction, when not given any DmlRecords, will initialise with an empty list' );
        System.assertNotEquals( null, dmlDefiner.getOptions(), 'construction, when not given any DmlRecords, will default the DML Options' );
    }

    @isTest
    private static void construction_whenGivenASingleDmlRecord_willInitialiseWithThatInTheList() // NOPMD: Test method name format
    {
        Amoss_Instance dmlRecordController = new Amoss_Instance( DmlRecord.class );
        DmlRecord dmlRecord = (DmlRecord)dmlRecordController.generateDouble();

        Test.startTest();
            DmlDefiner dmlDefiner = new DmlDefiner( dmlRecord );
        Test.stopTest();

        System.assertEquals( 1, dmlDefiner.recordsToDml.size(), 'construction, when given a single DmlRecord, will initialise a list with 1 record in it' );
        System.assertEquals( dmlRecord, dmlDefiner.recordsToDml[0], 'construction, when given a single DmlRecord, will initialise a list with the passed record in it' );
        System.assertNotEquals( null, dmlDefiner.getOptions(), 'construction, when given a single DmlRecord, will default the DML Options' );
    }

    @isTest
    private static void construction_whenGivenAListOfDmlRecords_willInitialiseWithThatList() // NOPMD: Test method name format
    {
        Amoss_Instance dmlRecordController = new Amoss_Instance( DmlRecord.class );
        List<DmlRecord> dmlRecords = new List<DmlRecord>
        {
            (DmlRecord)dmlRecordController.generateDouble(),
            (DmlRecord)dmlRecordController.generateDouble(),
            (DmlRecord)dmlRecordController.generateDouble()
        };

        Test.startTest();
            DmlDefiner dmlDefiner = new DmlDefiner( dmlRecords );
        Test.stopTest();

        System.assertEquals( dmlRecords, dmlDefiner.recordsToDml, 'construction, when given a list of DmlRecords, will initialise with that list' );
        System.assertNotEquals( null, dmlDefiner.getOptions(), 'construction, when given a list of DmlRecords, will default the DML Options' );
    }

    @isTest
    private static void addRecord_whenGivenADmlRecord_willAddThatRecordToTheExistingList() // NOPMD: Test method name format
    {
        Amoss_Instance dmlRecordController = new Amoss_Instance( DmlRecord.class );
        List<DmlRecord> dmlRecords = new List<DmlRecord>
        {
            (DmlRecord)dmlRecordController.generateDouble(),
            (DmlRecord)dmlRecordController.generateDouble(),
            (DmlRecord)dmlRecordController.generateDouble()
        };

        DmlRecord newDmlRecord = (DmlRecord)dmlRecordController.generateDouble();

        DmlDefiner dmlDefiner = new DmlDefiner( dmlRecords );
        Test.startTest();
            dmlDefiner.addRecord( newDmlRecord );
        Test.stopTest();

        System.assertEquals( 4, dmlDefiner.recordsToDml.size(), 'addRecord, when given a DmlRecord, will add it to the existing list (checking the size)' );
        System.assertEquals( newDmlRecord, dmlDefiner.recordsToDml[3], 'addRecord, when given a DmlRecord, will add it to the existing list (checking the record)' );
    }

    @isTest
    private static void addRecord_whenGivenNull_willThrowAnException() // NOPMD: Test method name format
    {
        DmlDefiner dmlDefiner = new DmlDefiner();

        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlDefiner.addRecord( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'addRecord called with a null record', exceptionMessage, 'addRecord, when given null, will throw an exception' );
    }

    @isTest
    private static void addRecords_whenGivenAListOfRecords_willAddThoseRecordsToTheExistingList() // NOPMD: Test method name format
    {
        Amoss_Instance dmlRecordController = new Amoss_Instance( DmlRecord.class );
        List<DmlRecord> dmlRecords = new List<DmlRecord>
        {
            (DmlRecord)dmlRecordController.generateDouble(),
            (DmlRecord)dmlRecordController.generateDouble(),
            (DmlRecord)dmlRecordController.generateDouble()
        };

        List<DmlRecord> newDmlRecords = new List<DmlRecord>
        {
            (DmlRecord)dmlRecordController.generateDouble(),
            (DmlRecord)dmlRecordController.generateDouble()
        };

        DmlDefiner dmlDefiner = new DmlDefiner( dmlRecords );
        Test.startTest();
            dmlDefiner.addRecords( newDmlRecords );
        Test.stopTest();

        System.assertEquals( 5, dmlDefiner.recordsToDml.size(), 'addRecords, when given a list of records, will add those records to the existing list, checking size' );
        System.assertEquals( newDmlRecords[0], dmlDefiner.recordsToDml[3], 'addRecords, when given a list of records, will add those records to the existing list, checking record 0' );
        System.assertEquals( newDmlRecords[1], dmlDefiner.recordsToDml[4], 'addRecords, when given a list of records, will add those records to the existing list, checking record 1' );
    }

    @isTest
    private static void addRecords_whenGivenNull_willThrowAnException() // NOPMD: Test method name format
    {
        DmlDefiner dmlDefiner = new DmlDefiner();

        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlDefiner.addRecords( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'addRecords called with a null list', exceptionMessage, 'addRecords, when given null, will throw an exception' );
    }

    @isTest
    private static void setOptions_whenGivenAnOptions_willSetTheOptions() // NOPMD: Test method name format
    {
        DmlDefiner dmlDefiner = new DmlDefiner();

        DmlDefinerOptions newOptions = new DmlDefinerOptions();

        Test.startTest();
            dmlDefiner.setOptions( newOptions );
        Test.stopTest();

        System.assertEquals( newOptions, dmlDefiner.getOptions(), 'setOptions, when given an options, will set the options' );
    }

    @isTest
    private static void setOptions_whenGivenNull_willThrowAnException() // NOPMD: Test method name format
    {
        DmlDefiner dmlDefiner = new DmlDefiner();

        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlDefiner.setOptions( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'setOptions called with a null options', exceptionMessage, 'setOptions, when given null, will throw an exception' );
    }

    @isTest
    private static void getSobjects_whenTheDmlDefinerHasAListDefined_willReturnTheSobjectsOnThoseDmlRecords() // NOPMD: Test method name format
    {
        List<Sobject> sobjectsToReturn = new List<Sobject>
        {
            new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ) ),
            new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ) ),
            new Contact( Id = TestIdUtils.generateId( Contact.SobjectType ) )
        };

        List<Amoss_Instance> dmlRecordControllers = new List<Amoss_Instance>
        {
            new Amoss_Instance( DmlRecord.class ),
            new Amoss_Instance( DmlRecord.class ),
            new Amoss_Instance( DmlRecord.class )
        };

        // Set up each of the DmlRecord mocks to expect a single call to getSobject and to return one of the contacts
        for ( Integer i=0; i<dmlRecordControllers.size(); i++ )
        {
            dmlRecordControllers[ i ]
                .expects( 'getSobject' )
                .returning( sobjectsToReturn[ i ] );
        }

        DmlDefiner dmlDefiner = new DmlDefiner();
        for( Amoss_Instance thisDmlRecordController : dmlRecordControllers ) {
            dmlDefiner.addRecord( (DmlRecord)thisDmlRecordController.generateDouble() );
        }

        Test.startTest();
            List<Sobject> returnedSobjects = dmlDefiner.getSobjects();
        Test.stopTest();

        System.assertEquals( sobjectsToReturn, returnedSobjects, 'getSobjects, when the DmlDefiner has a list of DmlRecords defiend, will return the SObjects on those DmlRecords' );

        // Check that each of the mock DmlRecords were called correctly
        for( Amoss_Instance thisDmlRecordContoller : dmlRecordControllers )
        {
            thisDmlRecordContoller.verify();
        }
    }

    @isTest
    private static void registerChildrenToDelete_whenDmlRecordsAreConfigured_willAskThemToRegisterChildrenToDelete() // NOPMD: Test method name format
    {
        DmlChildrenToDeleteRegister childrenToDeleteRegister = new DmlChildrenToDeleteRegister();

        List<Amoss_Instance> dmlRecordControllers = new List<Amoss_Instance>
        {
            new Amoss_Instance( DmlRecord.class ),
            new Amoss_Instance( DmlRecord.class ),
            new Amoss_Instance( DmlRecord.class )
        };

        // Setup mock DmlRecords that will expect to have registerChildrenToDelete to be called against them
        List<DmlRecord> dmlRecords = new List<DmlRecord>();
        for ( Amoss_Instance thisDmlRecordContoller : dmlRecordControllers )
        {
            dmlRecords.add( (DmlRecord)thisDmlRecordContoller.generateDouble() );

            thisDmlRecordContoller
                .expects( 'registerChildrenToDelete' )
                .withParameterNamed( 'register' ).setTo( childrenToDeleteRegister );
        }

        DmlDefiner dmlDefiner = new DmlDefiner( dmlRecords );

        Test.startTest();
            dmlDefiner.registerChildrenToDelete( childrenToDeleteRegister );
        Test.stopTest();

        // Check that the mock DmlRecords had the register called against them
        for ( Amoss_Instance thisDmlRecordContoller : dmlRecordControllers )
        {
            thisDmlRecordContoller.verify();
        }
    }

    @isTest
    private static void addPreSaveAction_whenGivenAnAction_willResultInThatActionBeingCalledPriorToASave() // NOPMD: Test method name format
    {
        Amoss_Instance dmlRecordController = new Amoss_Instance( DmlRecord.class );
        List<DmlRecord> dmlRecords = new List<DmlRecord>
        {
            (DmlRecord)dmlRecordController.generateDouble(),
            (DmlRecord)dmlRecordController.generateDouble(),
            (DmlRecord)dmlRecordController.generateDouble()
        };

        Amoss_Instance uowController = new Amoss_Instance( fflib_SobjectUnitOfWork.class );
        fflib_SobjectUnitOfWork uow = (fflib_SobjectUnitOfWork)uowController.generateDouble();

        Amoss_Instance actionController  = new Amoss_Instance( IDmlRecordAction.class );
        actionController
            .expects( 'actUpon' )
            .withParameter( dmlRecords[0] )
        .then()
            .expects( 'actUpon' )
            .withParameter( dmlRecords[1] )
        .then()
            .expects( 'actUpon' )
            .withParameter( dmlRecords[2] );

        Amoss_Instance actionController2 = new Amoss_Instance( IDmlRecordAction.class );
        actionController2
            .expects( 'actUpon' )
            .withParameter( dmlRecords[0] )
        .then()
            .expects( 'actUpon' )
            .withParameter( dmlRecords[1] )
        .then()
            .expects( 'actUpon' )
            .withParameter( dmlRecords[2] );

        DmlDefiner dmlDefiner = new DmlDefiner( dmlRecords );
        Test.startTest();
            dmlDefiner.addPreSaveAction( (IDmlRecordAction)actionController.generateDouble() );
            dmlDefiner.addPreSaveAction( (IDmlRecordAction)actionController2.generateDouble() );
            dmlDefiner.saveSobjects( uow );
        Test.stopTest();

        actionController.verify();
        actionController2.verify();
    }

    @isTest
    private static void addPreSaveAction_whenGivenNull_willThrowAnException() // NOPMD: Test method name format
    {
        DmlDefiner dmlDefiner = new DmlDefiner();

        Test.startTest();
            String exceptionMessage;
            try
            {
                dmlDefiner.addPreSaveAction( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        Amoss_Asserts.assertContains( 'addPreSaveAction called with a null action', exceptionMessage, 'addPreSaveAction, when given null, will throw an exception' );
    }
}