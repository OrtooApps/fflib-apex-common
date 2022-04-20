/**
 * Provides the ability to create object factories that perform a simple Type to Type mapping with no constructor or configuration required.
 *
 * Can be defined using either Type to Type or TypeName to TypeName (Strings)
 *
 * Should not be referenced directly in code, but instead wrapped in another factory that defines the type name and whether the factory
 * should error when an unmapped type is passed in.
 *
 * Allows mock objects to be registered for a given type via the setMock method.
 *
 * @group fflib Extension
 */
public inherited sharing class ortoo_SimpleObjectFactory    // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
	private Map<Type,Type> implementationByType;
	private Map<String,String> implementationNameByTypeName;
	private Map<Type,Object> mockByType;

	private String typeName = 'Unknown';
	private Boolean errorOnUnmappedType = true;

	/**
	 * Construct an instance using the given type ame to implementation name mapping
	 *
	 * @param	Map<String,String>	The Type name to Implementation name mapping
	 */
	public ortoo_SimpleObjectFactory( Map<String,String> implementationNameByTypeName )
	{
		Contract.requires( implementationNameByTypeName != null, 'ortoo_SimpleObjectFactory instantiated with a null implementationNameByTypeName' );

		this.implementationNameByTypeName = implementationNameByTypeName;
		this.implementationByType = new Map<Type,Type>();
		this.mockByType = new Map<Type,Object>();
	}

	/**
	 * Construct an instance using the given type to implementation mapping
	 *
	 * @param	Map<Type,Type>	The Type to Implementation mapping
	 */
	public ortoo_SimpleObjectFactory( Map<Type,Type> implementationByType )
	{
		Contract.requires( implementationByType != null, 'ortoo_SimpleObjectFactory instantiated with a null implementationByType' );

		this.implementationNameByTypeName = new Map<String,String>();
		this.implementationByType = implementationByType;
		this.mockByType = new Map<Type,Object>();
	}

	/**
	 * Set the name of the Type of thing that this factory creates, for putting into error messages
	 *
	 * @param   String						The Type Name
	 * @return  ortoo_SimpleObjectFactory	Itself, allowing for a fluent interface
	 */
	public ortoo_SimpleObjectFactory setTypeName( String typeName )
	{
		Contract.requires( typeName != null, 'setTypeName called with a null typeName' );

		this.typeName = typeName;
		return this;
	}

	/**
	 * Set whether the object should throw an exception when given a type that does not have a mapping.
	 *
	 * If set to false, will attempt to instantiate an instance of the requested type instead
	 *
	 * @param   Boolean						Should an error be thrown
	 * @return  ortoo_SimpleObjectFactory	Itself, allowing for a fluent interface
	 */
	public ortoo_SimpleObjectFactory setErrorOnUnmappedType( Boolean errorOnUnmappedType )
	{
		Contract.requires( errorOnUnmappedType != null, 'setErrorOnUnmappedType called with a null errorOnUnmappedType' );

		this.errorOnUnmappedType = errorOnUnmappedType;
		return this;
	}

	/**
	 * Requests a new instance of the given type be constructed, checking for registered mocks before
	 * using the configured mapping to find the correct implementation to use.
	 *
	 * @param   Type	The Type to get the implementation instance for
	 * @return  Object	The constructed instance
	 */
	public Object newInstance( Type requestedType )
	{
		Contract.requires( requestedType != null, 'newInstance called with a null requestedType' );

		if ( mockByType.containsKey( requestedType ) )
		{
			return mockByType.get( requestedType );
		}

		String requestedTypeName = requestedType.getName();

		if ( errorOnUnmappedType && ! implementationByType.containsKey( requestedType ) && ! implementationNameByTypeName.containsKey( requestedTypeName ) )
		{
			throw new Exceptions.DeveloperException( 'No implementation registered for ' + typeName + ' ' + requestedType )
						.setErrorCode( FrameworkErrorCodes.FACTORY_NO_IMPLEMENTATION_REGISTERED )
						.addContext( 'typeName', typeName )
						.addContext( 'requestedType', requestedType );
		}

		Type typeToConstruct = requestedType;
		if ( implementationByType.containsKey( requestedType ) )
		{
			typeToConstruct = implementationByType.get( requestedType );
		}
		else if ( implementationNameByTypeName.containsKey( requestedTypeName ) )
		{
			typeToConstruct = Type.forName( implementationNameByTypeName.get( requestedTypeName ) );
			if ( typeToConstruct == null )
			{
				throw new Exceptions.DeveloperException( 'Invalid implementation registered for ' + typeName + ' ' + requestedTypeName + ': The class does not exist, or is not visible' )
					.setErrorCode( FrameworkErrorCodes.FACTORY_INVALID_IMPLEMENTATION_REGISTERED )
					.addContext( 'typeName', typeName )
					.addContext( 'requestedType', requestedType );
			}
			implementationByType.put( requestedType, typeToConstruct );
		}

		Object constructedObject;
		try
		{
			constructedObject = typeToConstruct.newInstance();
		}
		catch ( Exception e )
		{
			throw new Exceptions.DeveloperException( 'Implementation registered for ' + typeName + ' ' + requestedType + ':' + typeToConstruct + ' does not have parameterless constructor', e )
							.setErrorCode( FrameworkErrorCodes.FACTORY_NO_PARAMETERLESS_CONSTRUCTOR )
							.addContext( 'typeName', typeName )
							.addContext( 'requestedType', requestedType )
							.addContext( 'typeToConstruct', typeToConstruct );
		}

		return constructedObject;
	}

	/**
	 * Configures that requesting an instance of the given type should
	 * result in the given mock implementation being returned.
	 *
	 * Should only be referenced in tests.
	 *
	 * @param   Type	The Type to set the mock implementation for
	 * @return  Object	The Mock instance
	 */
	public void setMock( Type objectType, Object mockObject )
	{
		mockByType.put( objectType, mockObject );
	}
}