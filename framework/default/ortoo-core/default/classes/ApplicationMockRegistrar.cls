@isTest
public inherited sharing class ApplicationMockRegistrar
{
	public class InvalidRegisterationException extends Exception {}

	/**
	 * Generates a mock Unit of Work controller and registers its double against the Application
	 * Then returns the controller for the mock so that expectations can be set against it
	 *
	 * @return	Amoss_Instance	The controller for the mock Unit of Work
	 */
	public static Amoss_Instance registerMockUnitOfWork()
	{
		Amoss_Instance mockUowController = new Amoss_Instance( ortoo_SObjectUnitOfWork.class );
		Application.UNIT_OF_WORK.setMock( (ortoo_SObjectUnitOfWork)mockUowController.generateDouble() );
		return mockUowController;
	}

	/**
	 * Generates a mock Service controller and registers its double against the Application
	 * Then returns the controller for the mock so that expectations can be set against it
	 *
	 * @param	Type			The type (interface) for which the mock service should be registered
	 * @return	Amoss_Instance	The controller for the mock Service
	 */
	public static Amoss_Instance registerMockService( Type serviceType )
	{
		Amoss_Instance mockServiceController = new Amoss_Instance( serviceType );
		Application.SERVICE.setMock( serviceType, mockServiceController.generateDouble() );
		return mockServiceController;
	}

	/**
	 * Generates a mock Domain controller and registers its double against the Application for the stated SObject Type
	 * Then returns the controller for the mock so that expectations can be set against it
	 *
	 * Uses the configuration of the Application to determine the correct class to mock.
	 * Will throw an exception if no configuration exists.
	 * In the rare situation that no selector is registered, an alternative version of the method is provided.
	 *
	 * @param	SobjectType		The type for which the mock selector should be registered
	 * @return	Amoss_Instance	The controller for the mock Domain
	 */
	public static Amoss_Instance registerMockDomain( SobjectType sobjectType )
	{
		Type domainType = Application.DOMAIN.getDomainType( sobjectType );

		if ( domainType == null )
		{
			domainType = fflib_ISObjectDomain.class;
		}
		return registerMockDomain( sobjectType, domainType );
	}

	/**
	 * Generates a mock DomainObject controller and registers its double against the Application for the stated SObject Type
	 * Then returns the controller for the mock so that expectations can be set against it
	 *
	 * @param	SobjectType		The type for which the mock domain should be registered
	 * @param	Type			The domain type (class) that the mock should be generated as
	 * @return	Amoss_Instance	The controller for the mock Domain
	 */
	public static Amoss_Instance registerMockDomain( SobjectType sobjectType, Type domainType )
	{
		Amoss_Instance mockDomainController = new Amoss_Instance( domainType );
		mockDomainController
			.when( 'sObjectType' )
			.returns( sobjectType );
		Application.DOMAIN.setMock( (fflib_ISObjectDomain)mockDomainController.generateDouble() );
		return mockDomainController;
	}

	/**
	 * Generates a mock SobjectValidator controller and registers its double against the Application for the stated SObject Type
	 * Then returns the controller for the mock so that expectations can be set against it
	 *
	 * Uses the configuration of the Application to determine the correct class to mock.
	 * Will throw an exception if no configuration exists.
	 *
	 * @param	SobjectType		The type for which the mock validator should be registered
	 * @return	Amoss_Instance	The controller for the mock Validator
	 */
	public static Amoss_Instance registerMockSobjectValidator( SobjectType sobjectType )
	{
		Type validatorType = Application.VALIDATOR.getValidatorType( sobjectType );

		if ( validatorType == null )
		{
			validatorType = ISobjectValidator.class;
		}

		Amoss_Instance mockValidatorController = new Amoss_Instance( validatorType );
		Application.VALIDATOR.setMock( sobjectType, (ISobjectValidator)mockValidatorController.generateDouble() );
		return mockValidatorController;
	}

	/**
	 * Generates a list mock SobjectValidator controllers and registers their doubles against the Application for the stated SObject Type
	 * Then returns the controllers for the mocks so that expectations can be set against them
	 *
	 * Uses the configuration of the Application to determine the correct class to mock.
	 * Will throw an exception if no configuration exists.
	 *
	 * @param	SobjectType				The type for which the mock validator should be registered
	 * @param	Integer					The number of mock validators to register
	 * @return	List<Amoss_Instance>	The controllers for the mock Validators
	 */
	public static List<Amoss_Instance> registerMockSobjectValidators( SobjectType sobjectType, Integer numberOfMocksToRegister )
	{
		Type validatorType = Application.VALIDATOR.getValidatorType( sobjectType );

		if ( validatorType == null )
		{
			validatorType = ISobjectValidator.class;
		}

		List<Amoss_Instance> controllers = new List<Amoss_Instance>();
		List<ISobjectValidator> validators = new List<ISobjectValidator>();

		for ( Integer i=0; i<numberOfMocksToRegister; i++ )
		{
			Amoss_Instance thisController = new Amoss_Instance( validatorType );
			controllers.add( thisController );
			validators.add( (ISobjectValidator)thisController.generateDouble() );
		}
		Application.VALIDATOR.setMock( sobjectType, validators );

		return controllers;
	}

	/**
	 * Generates a mock IMessageRenderer controller and registers its double against the Application for the stated type
	 * Then returns the controller for the mock so that expectations can be set against it
	 *
	 * @param	Type			The type (class) for which the mock domain should be registered
	 * @return	Amoss_Instance	The controller for the mock renderer
	 */
	public static Amoss_Instance registerMockMessageRenderer( Type rendererType )
	{
        Amoss_Instance rendererController = new Amoss_Instance( IMessageRenderer.class );
        Application.MESSAGE_RENDERER.setMock( rendererType, (IMessageRenderer)rendererController.generateDouble() );
		return rendererController;
	}

	/**
	 * Generates a mock ChildRecordFinder controller and registers its double against the Application for the stated type
	 * Then returns the controller for the mock so that expectations can be set against it
	 *
	 * @param	Type			The type (class) for which the mock domain should be registered
	 * @return	Amoss_Instance	The controller for the mock finder
	 */
	public static Amoss_Instance registerMockChildRecordFinder( Type childRecordFinderType )
	{
		Amoss_Instance mockChildRecordFinderController = new Amoss_Instance( IChildRecordFinder.class );
		Application.CHILD_RECORD_FINDER.setMock( childRecordFinderType, (IChildRecordFinder)mockChildRecordFinderController.generateDouble() );
		return mockChildRecordFinderController;
	}

	/**
	 * Generates a mock Selector controller and registers its double against the Application for the stated SObject Type
	 * Then returns the controller for the mock so that expectations can be set against it
	 *
	 * Uses the configuration of the Application to determine the correct class to mock.
	 * Will throw an exception if no configuration exists.
	 * In the rare situation that no selector is registered, an alternative version of the method is provided.
	 *
	 * @param	SobjectType		The type for which the mock selector should be registered
	 * @return	Amoss_Instance	The controller for the mock selector
	 */
	public static Amoss_Instance registerMockSelector( SobjectType sobjectType )
	{
		Type selectorType = Application.SELECTOR.getSelectorType( sobjectType );

		if ( selectorType == null )
		{
			selectorType = fflib_ISObjectSelector.class;
		}
		return registerMockSelector( sobjectType, selectorType );
	}

	/**
	 * Generates a mock Selector controller and registers its double against the Application for the stated SObject Type
	 * Then returns the controller for the mock so that expectations can be set against it
	 * In general, the version without the selectorType parameter should be used.
	 *
	 * @param	SobjectType		The type for which the mock selector should be registered
	 * @param	Type			The selector type (class) that the mock should be generated as
	 * @return	Amoss_Instance	The controller for the mock selector
	 */
	public static Amoss_Instance registerMockSelector( SobjectType sobjectType, Type selectorType )
	{
		Amoss_Instance mockSelectorController = new Amoss_Instance( selectorType );
		mockSelectorController
			.when( 'sObjectType' )
			.returns( sobjectType );
		Application.SELECTOR.setMock( (fflib_ISObjectSelector)mockSelectorController.generateDouble() );
		return mockSelectorController;
	}

	/**
	 * Generates a mock App Logic controller and registers its double against the Application
	 * Then returns the controller for the mock so that expectations can be set against it
	 *
	 * @param	Type			The type (interface) for which the mock app logic class should be registered
	 * @return	Amoss_Instance	The controller for the mock Service
	 */
	public static Amoss_Instance registerMockAppLogic( Type appLogicType )
	{
		Amoss_Instance mockAppLogicController = new Amoss_Instance( appLogicType );
		Application.APP_LOGIC.setMock( appLogicType, mockAppLogicController.generateDouble() );
		return mockAppLogicController;
	}
}