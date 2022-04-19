@isTest
private with sharing class LicensingServiceImplTest
{
    @isTest
    private static void productIsLicensed_whenNoLicenceDetailsExistInAProductionOrg_willReturnFalse() // NOPMD: test method format
    {
        Amoss_Instance mockOrganizationServiceController = ApplicationMockRegistrar.registerMockService( IOrganizationService.class );
        Amoss_Instance mockLicenseSelectorController = ApplicationMockRegistrar.registerMockSelector( PackageLicense.sobjectType );

        mockLicenseSelectorController
            .when( 'selectSingleRow' )
            .returns( null );

        mockOrganizationServiceController
            .when( 'inDevOrg' )
            .returns( false )
        .also()
            .when( 'inSandbox' )
            .returns( false );

        Test.startTest();
            Boolean productIsLicensed = LicensingService.productIsLicensed();
        Test.stopTest();

        System.assert( ! productIsLicensed, 'productIsLicensed, when no license details exist in a production org, will return false' );
    }

    @isTest
    private static void productIsLicensed_whenLicenceDetailsExistInAProductionOrg_willReturnTrue() // NOPMD: test method format
    {
        Amoss_Instance mockOrganizationServiceController = ApplicationMockRegistrar.registerMockService( IOrganizationService.class );
        Amoss_Instance mockLicenseSelectorController = ApplicationMockRegistrar.registerMockSelector( PackageLicense.sobjectType );

        mockLicenseSelectorController
            .when( 'selectSingleRow' )
            .returns( new PackageLicense() );

        mockOrganizationServiceController
            .when( 'inDevOrg' )
            .returns( false )
        .also()
            .when( 'inSandbox' )
            .returns( false );

        Test.startTest();
            Boolean productIsLicensed = LicensingService.productIsLicensed();
        Test.stopTest();

        System.assert( productIsLicensed, 'productIsLicensed, when license details exist in a production org, will return true' );
    }

    @isTest
    private static void productIsLicensed_whenNoLicenceDetailsExistInADevOrg_willReturnTrue() // NOPMD: test method format
    {
        Amoss_Instance mockOrganizationServiceController = ApplicationMockRegistrar.registerMockService( IOrganizationService.class );
        Amoss_Instance mockLicenseSelectorController = ApplicationMockRegistrar.registerMockSelector( PackageLicense.sobjectType );

        mockLicenseSelectorController
            .when( 'selectSingleRow' )
            .returns( null );

        mockOrganizationServiceController
            .when( 'inDevOrg' )
            .returns( true )
        .also()
            .when( 'inSandbox' )
            .returns( false );

        Test.startTest();
            Boolean productIsLicensed = LicensingService.productIsLicensed();
        Test.stopTest();

        System.assert( productIsLicensed, 'productIsLicensed, when no license details exist in a dev org, will return true' );
    }

    @isTest
    private static void productIsLicensed_whenNoLicenceDetailsExistInASandbox_willReturnTrue() // NOPMD: test method format
    {
        Amoss_Instance mockOrganizationServiceController = ApplicationMockRegistrar.registerMockService( IOrganizationService.class );
        Amoss_Instance mockLicenseSelectorController = ApplicationMockRegistrar.registerMockSelector( PackageLicense.sobjectType );

        mockLicenseSelectorController
            .when( 'selectSingleRow' )
            .returns( null );

        mockOrganizationServiceController
            .when( 'inDevOrg' )
            .returns( false )
        .also()
            .when( 'inSandbox' )
            .returns( true );

        Test.startTest();
            Boolean productIsLicensed = LicensingService.productIsLicensed();
        Test.stopTest();

        System.assert( productIsLicensed, 'productIsLicensed, when no license details exist in a sandbox, will return true' );
    }

	@isTest
	private static void productIsLicensed_whenAServiceThrowsAnException_logsAndRethrowsIt() // NOPMD: Test method name format
	{
		TestLoggerService logger = TestLoggerUtils.registerTestLoggerService();
		TestLoggerUtils.switchLoggingToErrorOnly();

        Amoss_Instance mockOrganizationServiceController = ApplicationMockRegistrar.registerMockService( IOrganizationService.class );
        Amoss_Instance mockLicenseSelectorController = ApplicationMockRegistrar.registerMockSelector( PackageLicense.sobjectType );

		Exception expected = new Exceptions.DeveloperException( 'An exception' );

        mockLicenseSelectorController
            .when( 'selectSingleRow' )
            .throws( expected );

		Test.startTest();
			Boolean productIsLicensed;
			Exception got;
			try
			{
				productIsLicensed = LicensingService.productIsLicensed();
			}
			catch( Exception e )
			{
				got = e;
			}
		Test.stopTest();

		logger.assertNumberOfLogCalls( 1, 'productIsLicensed, when a called service throws an exception, will log it' );
		logger.assertExceptionWasLogged( 0, expected, 'productIsLicensed, when a called service throws an exception, will log it' );
		ortoo_Asserts.assertEquals( expected, got, 'productIsLicensed, when a called service throws an exception, will rethrow it' );
	}
}