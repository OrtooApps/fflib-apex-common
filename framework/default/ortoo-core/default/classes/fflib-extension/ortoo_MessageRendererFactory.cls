/**
 * Provides the ability instantiate Message Renderer classes with a mapping for implementations
 * and the capability to register mocks.
 *
 * @group fflib Extension
 */
public inherited sharing class ortoo_MessageRendererFactory    // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
    ortoo_SimpleObjectFactory factory;

    /**
	 * Construct an instance without any type to implementation mappings.
     *
     * This means that all calls to newInstance will return an instance of the requested type.
	 */
    public ortoo_MessageRendererFactory()
    {
        this( new Map<Type,Type>() );
    }

	/**
	 * Construct an instance using the given type to implementation mapping
	 *
	 * @param	Map<Type,Type>	The Type to Implementation mapping
	 */
    public ortoo_MessageRendererFactory( Map<Type,Type> implementationPerType )
    {
        Contract.requires( implementationPerType != null, 'ortoo_MessageRendererFactory instantiated with a null implementationPerType' );
        factory = new ortoo_SimpleObjectFactory( implementationPerType )
                        .setTypeName( 'Message Renderer' )
                        .setErrorOnUnmappedType( false );
    }

    /**
	 * Construct an instance of the requested type, taking into account any mappings or mock registrations
	 * @param   Type	The Type to get the implementation instance for
	 * @return  Object	The constructed instance
	 */
    public MessageRendererEngine newInstance( Type requestedType,
                                                IRenderableMessageHeader message )
    {
        Contract.requires( requestedType != null, 'newInstance called with a null requestedType' );
        Contract.requires( message != null, 'newInstance called with a null message' );

        Object rawRenderer = factory.newInstance( requestedType );

        IMessageRenderer renderer;
        try {
            renderer = (IMessageRenderer)rawRenderer;
        }
        catch ( TypeException e )
        {
            throw new Exceptions.DeveloperException( 'Implementation registered for Message Renderer ' + requestedType + ' does not implement MessageRendererEngine.IMessageRenderer', e )
                                                            .setErrorCode( FrameworkErrorCodes.MR_IMPLEMENTATION_IS_NOT_MR )
                                                            .addContext( 'requestedType', requestedType );
        }

        return new MessageRendererEngine().setRenderer( renderer ).setMessage( message );
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
    private void setMock( Type rendererType, Object rendererEngineObject )
    {
        factory.setMock( rendererType, rendererEngineObject );
    }
}