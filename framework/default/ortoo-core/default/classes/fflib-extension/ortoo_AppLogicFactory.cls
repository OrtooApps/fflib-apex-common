/**
 * Provides the ability instantiate App Logic classes with a mapping for implementations
 * and the capability to register mocks.
 *
 * @group fflib Extension
 */
public inherited sharing class ortoo_AppLogicFactory    // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
    ortoo_SimpleObjectFactory factory;

    /**
	 * Construct an instance without any type to implementation mappings.
     *
     * This means that all calls to newInstance will return an instance of the requested type.
	 */
    public ortoo_AppLogicFactory()
    {
        this( new Map<String,String>() );
    }

	/**
	 * Construct an instance using the given type to implementation mapping
	 *
	 * @param	Map<String,String>	The Type to Implementation mapping
	 */
    public ortoo_AppLogicFactory( Map<String,String> appLogicPerType )
    {
        Contract.requires( appLogicPerType != null, 'ortoo_AppLogicFactory instantiated with a null appLogicPerType' );

		factory = new ortoo_SimpleObjectFactory( appLogicPerType )
                        .setTypeName( 'App Logic' )
                        .setErrorOnUnmappedType( false );
    }

    /**
	 * Construct an instance of the requested type, taking into account any mappings or mock registrations
	 * @param   Type	The Type to get the implementation instance for
	 * @return  Object	The constructed instance
	 */
    public Object newInstance( Type requestedType )
    {
        Contract.requires( requestedType != null, 'newInstance called with a null requestedType' );
        return factory.newInstance( requestedType );
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
    @testVisible
    private void setMock( Type appLogicType, Object appLogicObject )
    {
        factory.setMock( appLogicType, appLogicObject );
    }
}