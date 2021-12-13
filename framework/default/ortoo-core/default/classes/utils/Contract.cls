/**
 * Implementation of a Code Contract, allowing the definition of pre, post and invariant conditions.
 *
 * @group Utils
 */
public class Contract
{
	public abstract class ContractException extends ortoo_Exception {}
	public class RequiresException extends ContractException {}
	public class EnsuresException extends ContractException {}
	public class AssertException extends ContractException {}

	/**
	 * Defines that the given condition must be true, otherwise an exception is thrown.
	 *
	 * Is used for defining Contractual pre-conditions in methods.
	 *
	 * @param	Boolean	The condition that must be true
	 * @param	String	The message to emit when the condition is not true
	 */
	public static void requires( Boolean condition, String message )
	{
		if ( !condition )
		{
			throw new RequiresException( 'Contract.requires failed: ' + message );
		}
	}

	/**
	 * Defines that the given condition must be true, otherwise an exception is thrown.
	 *
	 * Is used for defining conditions that must be true during the operation of a method.
	 *
	 * @param	Boolean	The condition that must be true
	 * @param	String	The message to emit when the condition is not true
	 */
	public static void assert( Boolean condition, String message )
	{
		if ( !condition )
		{
			throw new AssertException( 'Contract.assert failed: ' + message );
		}
	}

	/**
	 * Defines that the given condition must be true, otherwise an exception is thrown.
	 *
	 * Is used for defining Contractual post-conditions in methods.
	 * That is, given the the pre-conditions are true, I will ensure that these post-conditions are also true.
	 *
	 * @param	Boolean	The condition that must be true
	 * @param	String	The message to emit when the condition is not true
	 */
	public static void ensures( Boolean condition, String message )
	{
		if ( !condition )
		{
			throw new EnsuresException( 'Contract.ensures failed: ' + message );
		}
	}
}