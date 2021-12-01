/**
 * Provides the ability to create Validators in an indirect way, based on defined mappings from an SObject type to a Validator class type.
 *
 * Will always cast the resulting type to an ISobjectValidator and will throw exceptions if the mapped types are not castable.
 *
 * @group fflib Extension
 */
public inherited sharing class ortoo_SobjectValidatorFactory // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
	protected Map<SobjectType,Type>                    validatorBySobjectType;
	protected Map<SobjectType,ISobjectValidator>       mockValidatorBySobjectType;
	protected Map<SobjectType,List<ISobjectValidator>> mockListOfValidatorsBySobjectType;

	/**
	 * Constructor, defining the mapping of Sobject to Validator type
	 *
	 * @param	Map<SobjectType,Type>	The mapping of Sobject Type to Validator Type.  Every type should implement ISobjectValidator
	 */
	public ortoo_SobjectValidatorFactory( Map<SobjectType,Type> validatorBySobjectType )
	{
		Contract.requires( validatorBySobjectType != null, 'ortoo_SobjectValidatorFactory instantiated with a null validatorBySobjectType' );

		this.validatorBySobjectType            = validatorBySobjectType;
		this.mockValidatorBySobjectType        = new Map<SobjectType,ISobjectValidator>();
		this.mockListOfValidatorsBySobjectType = new Map<SobjectType,List<ISobjectValidator>>();
	}

	/**
	 * Instantiates the configured Validator Type for the specified SObject, being the validator that should be used
	 * to validate that SObject.
	 *
	 * @param	SObject				The SObject for which to instantiate the Validator
	 * @return	ISobjectValidator	The validator, configured with the passed in SObject
	 */
	public ISobjectValidator newInstance( Sobject sobjectToValidate )
	{
		Contract.requires( sobjectToValidate != null, 'newInstance called with a null sobjectToValidate' );

		SobjectType sObjectType = sobjectToValidate.getSObjectType();

		Type validatorType = getValidatorType( sObjectType );

		if ( mockValidatorBySobjectType.containsKey( sObjectType ) )
		{
			return mockValidatorBySobjectType.get( sObjectType );
		}

		if ( validatorType == null )
		{
			String sobjectName = SobjectUtils.getSobjectName( sobjectToValidate );
			throw new Exceptions.DeveloperException( 'No implementation registered for validator ' + sobjectName )
							.setErrorCode( FrameworkErrorCodes.VALIDATOR_NO_IMPLEMENTATION_REGISTERED_FOR_SINGLE )
							.addContext( 'sobjectName', sobjectName );
		}

		return constructValidator( validatorType, sobjectToValidate );
	}

	/**
	 * Instantiates the configured Validator Type for the specified SObjects, assuming that all SObjects in the list are of the same type.
	 *
	 * @param	SObject					The SObjects for which to instantiate the Validators
	 * @return	List<ISobjectValidator>	The validators, each configured with a passed in SObject
	 */
	public List<ISobjectValidator> newInstance( List<Sobject> sobjectsToValidate )
	{
		Contract.requires( sobjectsToValidate != null, 'newInstance called with a null sobjectsToValidate' );

		SobjectType sObjectType = sobjectsToValidate[0].getSObjectType();

		if ( mockListOfValidatorsBySobjectType.containsKey( sObjectType ) )
		{
			return mockListOfValidatorsBySobjectType.get( sObjectType );
		}

		Type validatorType = validatorBySobjectType.get( sObjectType );
		if ( validatorType == null )
		{
			String sobjectName = SobjectUtils.getSobjectName( sobjectsToValidate[0] );
			throw new Exceptions.DeveloperException( 'No implementation registered for validator ' + sobjectName )
							.setErrorCode( FrameworkErrorCodes.VALIDATOR_NO_IMPLEMENTATION_REGISTERED_FOR_LIST )
							.addContext( 'sobjectName', sobjectName );
		}

		List<ISobjectValidator> validators = new List<ISobjectValidator>();
		for( Sobject thisSobjectToValidate : sobjectsToValidate )
		{
			validators.add( constructValidator( validatorType, thisSobjectToValidate ) );
		}

		return validators;
	}

	private ISobjectValidator constructValidator( Type validatorType, Sobject sobjectToValidate )
	{
		Object rawValidator;

		String sobjectName = SobjectUtils.getSobjectName( sobjectToValidate );

		try
		{
			rawValidator = validatorType.newInstance();
		}
		catch( TypeException e )
		{
			throw new Exceptions.DeveloperException( 'Implementation registered for validator ' + sobjectName + ':' + validatorType + ' does not have parameterless constructor', e )
						.setErrorCode( FrameworkErrorCodes.VALIDATOR_NO_PARAMETERLESS_CONSTRUCTOR )
						.addContext( 'validatorType', validatorType )
						.addContext( 'sobjectName', sobjectName );
		}

		ISobjectValidator validator;
		try
		{
			validator = ( (ISobjectValidator)rawValidator ).setSobject( sobjectToValidate );
		}
		catch( TypeException e )
		{
			throw new Exceptions.DeveloperException( 'Implementation registered for validator ' + sobjectName + ':' + validatorType + ' is not an implementation of ISobjectValidator', e )
						.setErrorCode( FrameworkErrorCodes.VALIDATOR_IMPLEMENTATION_IS_NOT_VALIDATOR )
						.addContext( 'validatorType', validatorType )
						.addContext( 'sobjectName', sobjectName );
		}

		return validator;
	}

	/**
	 * Configures the factory to return the specified mock whenever an SObject of the given type is passed in
	 *
	 * @param	SObjectType			The SObject Type for which to configure the mock
	 * @param	ISobjectValidator	The mock instance to return for the specified SObject
	 */
	@TestVisible
	private void setMock( SobjectType validatorType, ISobjectValidator validator )
	{
		mockValidatorBySobjectType.put( validatorType, validator );
	}

	/**
	 * Configures the factory to return the specified list of mocks whenever an SObject of the given type is passed in
	 *
	 * @param	SObjectType				The SObject Type for which to configure the mocks
	 * @param	List<ISobjectValidator>	The mock instances to return for the specified SObject Type
	 */
	@TestVisible
	private void setMock( SobjectType validatorType, List<ISobjectValidator> validators )
	{
		mockListOfValidatorsBySobjectType.put( validatorType, validators );
	}

	/**
	 * For a given Sobject Type, will return the Class type for the appropriate Validator
	 *
	 * @param	SObjectType	The SobjectType for which to get the validator type
	 * @return	Type		The configured Validator type
	 */
	@TestVisible
	private Type getValidatorType( SobjectType sObjectType ) {
		return validatorBySobjectType.get( sObjectType );
	}
}