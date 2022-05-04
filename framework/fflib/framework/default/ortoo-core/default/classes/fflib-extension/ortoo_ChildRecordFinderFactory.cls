/**
 * Provides the ability instantiate App Logic classes with a mapping for implementations
 * and the capability to register mocks.
 *
 * @group fflib Extension
 */
public inherited sharing class ortoo_ChildRecordFinderFactory    // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
	ortoo_SimpleObjectFactory factory;

	/**
	 * Construct an instance without any type to implementation mappings.
	 *
	 * This means that all calls to newInstance will return an instance of the requested type.
	 */
	public ortoo_ChildRecordFinderFactory()
	{
		this( new Map<String,String>() );
	}

	/**
	 * Construct an instance using the given type to implementation mapping
	 *
	 * @param	Map<String,String>	The Type to Implementation mapping
	 */
	public ortoo_ChildRecordFinderFactory( Map<String,String> childRecordFinderPerType )
	{
		Contract.requires( childRecordFinderPerType != null, 'ortoo_ChildRecordFinderFactory instantiated with a null childRecordFinderPerType' );

		factory = new ortoo_SimpleObjectFactory( childRecordFinderPerType )
						.setTypeName( 'Child Finder' )
						.setErrorOnUnmappedType( false );
	}

    /**
	 * Construct an instance of the requested type, taking into account any mappings or mock registrations
	 * @param   Type				The Type to get the implementation instance for
	 * @return  IChildRecordFinder	The constructed instance
	 */
	public IChildRecordFinder newInstance( Type requestedType )
	{
		Contract.requires( requestedType != null, 'newInstance called with a null requestedType' );

		IChildRecordFinder childRecordFinderObject;
		Object rawChildRecordFinderObject = factory.newInstance( requestedType );
		try
		{
			childRecordFinderObject = (IChildRecordFinder)rawChildRecordFinderObject;
		}
		catch ( TypeException e )
		{
			throw new Exceptions.DeveloperException( 'Implementation registered for Child Finder ' + requestedType + ' does not implement IChildRecordFinder', e )
						.setErrorCode( FrameworkErrorCodes.CRF_IMPLEMENTATION_IS_NOT_CRF )
						.addContext( 'requestedType', requestedType );
		}
		return childRecordFinderObject;
	}

	/**
	 * Configures that requesting an instance of the given type should
	 * result in the given mock implementation being returned.
	 *
	 * Should only be referenced in tests.
	 *
	 * @param   Type				The Type to set the mock implementation for
	 * @return  IChildRecordFinder	The Mock instance
	 */
	@testVisible
	private void setMock( Type childRecordFinderType, IChildRecordFinder childRecordFinderObject )
	{
		factory.setMock( childRecordFinderType, childRecordFinderObject );
	}
}