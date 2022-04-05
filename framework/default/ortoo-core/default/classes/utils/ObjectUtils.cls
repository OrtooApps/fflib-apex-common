/**
 * Utility class that provides extra capabilities related to Classes
 *
 * @group Utils
 */
public inherited sharing class ObjectUtils
{
	public inherited sharing class UnableToDetermineTypeException extends Exceptions.DeveloperException {}
	/**
	 * Given an object, will get the class name from it.
	 *
	 * @param	Object	The object to get the class name for
	 * @return	String	The fully qualified name of the class
	 */
	public static String getClassName( Object obj )
	{
		Contract.requires( obj != null, 'getClassName called with a null obj' );

		String result = 'DateTime';
		try
		{
			System.debug( 'If "System.TypeException: Invalid conversion ... to DateTime" is seen in the logs, this may be due to an attempt to find the class name of an object' );
			DateTime typeCheck = (DateTime)obj;
		}
		catch ( System.TypeException te )
		{
			String message = te.getMessage().substringAfter( 'Invalid conversion from runtime type ' );
			result = message.substringBefore( ' to Datetime' );
		}

		Contract.ensures( result != null, 'getClassName returned with a null result' );
		return result;
	}

	/**
	 * Given an object, will get the class type that represents it.
	 *
	 * Note that, due to the limitations of 'Type.forName', this cannot return the types of:
	 * 		* Private classes
	 * 		* Private inner classes
	 *
	 * However, it does return the type for:
	 * 		* Public classes
	 * 		* Public inner classes of Public parent classes
	 * 		* Public inner classes of Private parent classes
	 *
	 * @param	Object	The object to get the class name for
	 * @return	Type	The Type that represents this Object's class
	 */
	public static Type getClassType( Object obj )
	{
		Contract.requires( obj != null, 'getClassType called with a null obj' );

		Type returnType = Type.forName( getClassName( obj ) );

		if ( returnType == null )
		{
			throw new UnableToDetermineTypeException( 'getClassType was unable to determine the type for the object.  Most likely it is private.' )
						.setErrorCode( FrameworkErrorCodes.OBJECT_UTILS_GET_CLASS_TYPE_UNABLE )
						.addContext( 'object', obj );
		}

		Contract.ensures( returnType != null, 'getClassType returned with a null Type' );
		return returnType;
	}

	/**
	 * Given a Type that represents an inner class, will return a type
	 * that represents the containing (parent) class, assuming that both a public
	 *
	 * @param	Type	The inner class type to get the parent for
	 * @return	Type	The parent class type
	 */
	public static Type getParentClassType( Type innerClassType )
	{
		Contract.requires( innerClassType != null, 'getParentClassType called with a null innerClassType' );
		String innerClassTypeName = String.valueOf( innerClassType );

		Type returnType;
		if ( innerclassTypeName.contains( '.' ) )
		{
			returnType = Type.forName( innerClassTypeName.substringBeforeLast( '.' ) );
		}

		Contract.assert( returnType != null, 'getParentClassType called with a type that does not represent an inner class in a publically accessible class' );

		return returnType;
	}
}