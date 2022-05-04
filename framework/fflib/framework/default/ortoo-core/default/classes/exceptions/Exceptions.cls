/**
 * A library of the standard exceptions that are available within the framework.
 *
 * All custom exceptions within the implemented applications should be either:
 * 		An instance of one of these included classes
 * 		An instance of a sub-class of one of these included classes
 *
 * @group Exceptions
 */
public inherited sharing class Exceptions
{
	/**
	 * An exception that represents an error that has occurred in the Domain layer
	 *
	 * @group Exceptions
	 */
	public inherited sharing virtual class DomainException extends ortoo_Exception
	{
		protected virtual override String resolveErrorCode( String errorCode )
		{
			return 'DOM-' + errorCode;
		}
	}

	/**
	 * An exception that represents an error that has occurred in the Service layer
	 *
	 * @group Exceptions
	 */
	public inherited sharing virtual class ServiceException extends ortoo_Exception
	{
		protected virtual override String resolveErrorCode( String errorCode )
		{
			return 'SRV-' + errorCode;
		}
	}

	/**
	 * An exception that represents an error that has occurred in the Selector layer
	 *
	 * @group Exceptions
	 */
	public inherited sharing virtual class SelectorException extends ortoo_Exception
	{
		protected virtual override String resolveErrorCode( String errorCode )
		{
			return 'SEL-' + errorCode;
		}
	}

	/**
	 * An exception that represents an error that is avoidable in code.
	 * Particularly used in the Factories, when objects are constructed based on SObjects / Interfaces and Class types.
	 *
	 * @group Exceptions
	 */
	public inherited sharing virtual class DeveloperException extends ortoo_Exception
	{
		protected virtual override String resolveErrorCode( String errorCode )
		{
			return 'DEV-' + errorCode;
		}
	}

	/**
	 * An exception that represents an error in the way the product is configured.
	 *
	 * @group Exceptions
	 */
	public inherited sharing virtual class ConfigurationException extends ortoo_Exception
	{
		protected virtual override String resolveErrorCode( String errorCode )
		{
			return 'CONF-' + errorCode;
		}
	}

	/**
	 * An exception that represents a validation error that has occurred when validating an SObject outside of
	 * the trigger context.
	 *
	 * Particularly used by classes that implement ISobjectValidator.
	 *
	 * The message from this exception is intended to be displayed to end users, and so should be populated via Labels.
	 *
	 * @group Exceptions
	 */
	public inherited sharing class ValidationException extends ortoo_Exception
	{
		/**
		 * Constructor - build a validation exception, giving it a list of validation errors that it represents
		 *
		 * @param	List<MessageDetail>	The errors that this exception represents
		 */
		public ValidationException( List<MessageDetail> messageDetails )
		{
			setMessage( Label.ortoo_core_validation_errors_occurred );
			setMessageDetails( messageDetails );
		}
	}
}