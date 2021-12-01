/**
 * Abstract implementation of ISobjectValidator that includes the ability to get and set
 * the Sobject that is being validated.
 */
public abstract inherited sharing class SobjectValidator implements ISobjectValidator
{
	protected Sobject sobjectToValidate;

	/**
	 * Sets the SObject that this validator will validate
	 *
	 * @param	Sobject				The SObject to validate
	 * @return	SobjectValidator	Itself, allowing for a fluent interface
	 */
	public SobjectValidator setSobject( Sobject sobjectToValidate )
	{
		Contract.requires( sobjectToValidate != null, 'setSobject called with a null sobjectToValidate' );

		this.sobjectToValidate = sobjectToValidate;
		return this;
	}

	/**
	 * Returns the SObject that is to be validated
	 *
	 * @return	Sobject	The SObject to be validated
	 */
	@testVisible
	protected Sobject getSobject()
	{
		return this.sobjectToValidate;
	}
}