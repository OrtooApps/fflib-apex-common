/**
 * Provides the ability instantiate Selector classes with a mapping for implementations
 * and the capability to register mocks.
 *
 * Is an extension of the provided fflib version in order to allow for the retrieval of
 * the selector type for a given Sobject type.  This is useful for the generic registration
 * of mocks.
 *
 * @group fflib Extension
 */
public inherited sharing class ortoo_SelectorFactory extends fflib_Application.SelectorFactory // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
	/**
	 * Constructor, allowing the definition of the Sobject to Selector Type mappings
	 *
	 * @param	Map<SObjectType,Type>	The mapping of Sobject to Selector Type
	 */
	public ortoo_SelectorFactory( Map<SObjectType,Type> sObjectBySelectorType )
	{
		super( sObjectBySelectorType );
	}

	/**
	 * For a given Sobject Type, will return the Class type for the appropriate Selector
	 *
	 * @param	SObjectType	The SobjectType for which to get the selector type
	 * @return	Type		The configured Selector type
	 */
	@testVisible
	private Type getSelectorType( SobjectType sobjectType )
	{
		Contract.requires( sobjectType != null, 'getSelectorType called with a null sobjectType' );

		return m_sObjectBySelectorType.get( sObjectType );
	}
}