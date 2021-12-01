/**
 * Provides the ability instantiate Domain classes with a mapping for implementations
 * and the capability to register mocks.
 *
 * Is an extension of the provided fflib version in order to allow for the retrieval of
 * the domain type for a given Sobject type.  This is useful for the generic registration
 * of mocks.
 *
 * @group fflib Extension
 */
public inherited sharing class ortoo_DomainFactory extends fflib_Application.DomainFactory // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
	/**
	 * Constructor, allowing the definition of the Sobject to Domain Type mappings
	 *
	 * @param	Map<SObjectType,Type>	The mapping of Sobject to Domain Type
	 */
	public ortoo_DomainFactory( ortoo_SelectorFactory selectorFactory, Map<SObjectType,Type> sObjectByDomainConstructorType )
	{
		super( selectorFactory, sObjectByDomainConstructorType );
	}

	/**
	 * For a given Sobject Type, will return the Class type for the appropriate Domain
	 *
	 * Note that it will strip the '.Constructor' inner class from the type ensuring that
	 * the domain object type is returned, rather than its constructor class.
	 *
	 * @param	SObjectType	The SobjectType for which to get the domain object type
	 * @return	Type		The configured Selector type
	 */
	@testVisible
	private Type getDomainType( SobjectType sobjectType )
	{
		Contract.requires( sobjectType != null, 'getDomainType called with a null sobjectType' );

		Type domainConstructorType = constructorTypeByObject.get( sObjectType );

		if ( domainConstructorType == null )
		{
			return null;
		}

		return typeIsAnInnerConstructor( domainConstructorType )
				? ObjectUtils.getParentClassType( domainConstructorType )
				: domainConstructorType;
	}

	private Boolean typeIsAnInnerConstructor( Type typeToTest )
	{
		return String.valueOf( typeToTest ).toLowerCase().endsWith( '.constructor' );
	}
}