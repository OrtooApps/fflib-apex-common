/**
 * Provides the ability instantiate Selector classes with a mapping for implementations
 * and the capability to register mocks.
 *
 * Is an extension of the provided fflib version in order to allow for the retrieval of
 * the selector type for a given Sobject type.  This is useful for the generic registration
 * of mocks.
 *
 * In addition, this implementation does not require that the types be setup fully prior to
 * the request of the instance.  This improves the startup performance of the framework
 * where lots of Selectors are defined and few are used for a given request.
 *
 * @group fflib Extension
 */
public inherited sharing class ortoo_SelectorFactory extends fflib_Application.SelectorFactory // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
	Map<String,String> selectorNameBySobjectName = new Map<String,String>();

	/**
	 * Constructor, allowing the definition of the Sobject to Domain Type mappings based on their names
	 *
	 * @param	Map<String,String>	The mapping of Sobject Name to Domain Type Name
	 */
	public ortoo_SelectorFactory( Map<String,String> selectorNameBySobjectName )
	{
		// Construct an FFLIB Selector Factory with no initial configuration
		super( new Map<SObjectType,Type>() );
		this.selectorNameBySobjectName = selectorNameBySobjectName;
	}

	public virtual override fflib_ISObjectSelector newInstance( SObjectType sObjectType )
	{
		// Attempt to let the FFLIB Selector Factory build the instance.
		// If it can't, then it may be because the configuration for the selector hasn't been loaded yet
		try
		{
			return super.newInstance( sobjectType );
		}
		catch ( fflib_Application.DeveloperException e )
		{
			String sobjectTypeName = SobjectUtils.getSobjectLocalName( sobjectType );
			// if the base factory didn't manage to get a type, then try to build a new one from *our* config
			String selectorClassName = selectorNameBySobjectName.get( sobjectTypeName );

			if ( selectorClassName == null )
			{
				throw e;
			}

			Type selectorClass = Type.forName( selectorClassName );
			if ( selectorClass == null )
			{
				throw new fflib_Application.DeveloperException( 'Invalid selector class defined for SObjectType ' + sObjectType + ' - ' + selectorClassName );
			}

			//
			// Put the config into the FFLIB Selector Factory so that we don't have to do this again for this selector type
			m_sObjectBySelectorType.put( sObjectType, selectorClass );
			return (fflib_ISObjectSelector)selectorClass.newInstance();
		}
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

		String typeName = selectorNameBySobjectName.get( SobjectUtils.getSobjectLocalName( sObjectType ) );
		if ( typeName == null )
		{
			return null;
		}
		return Type.forName( typeName );
	}
}