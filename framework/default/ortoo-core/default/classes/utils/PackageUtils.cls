/**
 * Utility class that provides extra capabilities related to Packages
 *
 * @group Utils
 */
public inherited sharing class PackageUtils
{
	/**
	 * Provides cached access to the current package's namespace.  That is, the namespace of THIS class (not the calling class)
	 */
	public static String NAMESPACE_PREFIX  // NOPMD: whilst not being final, want to give the impression that it is - is lazy loaded so cannot be
	{
		get
		{
			if ( NAMESPACE_PREFIX == null )
			{
				NAMESPACE_PREFIX = getNamespace( PackageUtils.class );
			}
			return NAMESPACE_PREFIX;
		}
		private set;
	}

	/**
	 * Returns the namespace that the passed in class is defined within.
	 *
	 * @param	Type	The class type to get the namespace for
	 * @return	String	The namespace for the given class type
	 */
	public static String getNamespace( Type classType )
	{
		Contract.requires( classType != null, 'getNamespace was called with a null classType' );

		String namespacePrefix = '';

		String potentialNamespace = String.valueOf( classType ).substringBefore( '.' );
		String remainingName      = String.valueOf( classType ).substringAfter( '.' );

		if ( ! String.isEmpty( remainingName ) )
		{
			// We test this in case we were passed an inner class and the potentialNamespace
			// is actually the name of the containing class, and there is no namespace
			if ( classType == Type.forName( potentialNamespace, remainingName ) )
			{
				namespacePrefix = potentialNamespace;
			}
		}
		Contract.ensures( namespacePrefix != null, 'getNamespace returned with a null namespacePrefix' );
		return namespacePrefix;
	}
}