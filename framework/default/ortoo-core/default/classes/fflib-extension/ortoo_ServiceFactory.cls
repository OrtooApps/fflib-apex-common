/**
 * Provides the ability instantiate Service classes with a mapping for implementations
 * and the capability to register mocks.
 *
 * @group fflib Extension
 */
public inherited sharing class ortoo_ServiceFactory extends fflib_Application.ServiceFactory // NOPMD: specified a mini-namespace to differentiate from fflib versions
{

	Set<String> mockRegisteredImplementations = new Set<String>();

	/**
	 * Constructor, allowing the definition of the Service Interface Type to Service Implementation Type mappings
	 *
	 * @param	Map<Type,Type>	The mapping of Service Interface Type to Service Implementation Type
	 */
	public ortoo_ServiceFactory( Map<Type,Type> serviceInterfaceTypeByServiceImplType )
	{
		super( serviceInterfaceTypeByServiceImplType );
	}

	/**
	 * States if the class with the given name is registered as an implementation for a service
	 *
	 * @param	String	The class to check
	 * @return	Boolean	States if the class is registered as an implementation of a service
	 */
	public Boolean isRegisteredAsAnImplementation( String className )
	{
		Contract.requires( className != null, 'isRegisteredAsAnImplementation called with a null className' );

		if ( mockRegisteredImplementations.contains( className ) )
		{
			return true;
		}

		Type passedType = Type.forName( className );
		return passedType != null && m_serviceInterfaceTypeByServiceImplType.values().contains( passedType );
	}

	/**
	 * Allows tests to be able to register that particular classes are implementations of services.
	 * Does not imply that they can be constructed, but will merely affect the return values of
	 * the method 'isRegisteredAsAnImplementation'
	 *
	 * @param	String					The name of the class to add to the mock register
	 * @return	ortoo_ServiceFactory	Itself, allowing for a fluent interface
	 */
	@testVisible
	private ortoo_ServiceFactory mockRegisterAsImplementation( String className )
	{
		mockRegisteredImplementations.add( className );
		return this;
	}
}