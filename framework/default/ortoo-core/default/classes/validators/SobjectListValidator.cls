/**
 * Provides the capability to validate a list of SObjects.
 *
 * Uses the Application factories in order to determine the correct validator
 * and message renderer to use.
 *
 * Primarily used by Domain objects in order to tie their validate methods
 * to the more complex SobjectValidator classes.
 */
public inherited sharing class SobjectListValidator
{
	List<Sobject> records;

	/**
	 * Constructor, defining the records that this validator will validate
	 *
	 * @param	List<Sobject>	The records to validate
	 */
	public SobjectListValidator( List<Sobject> records )
	{
		Contract.requires( records != null, 'SobjectListValidator instantiated with a null records' );

		this.records = records;
	}

	/**
	 * Validate the given records, using the appropriate validators.
	 *
	 * Will add any exceptions to the appropraite objects using the configured message renderer.
	 */
	public void validate()
	{
		Contract.requires( records != null, 'validate called before the records were configured' );

		List<ISobjectValidator> validators = Application.VALIDATOR.newInstance( records );

		for ( ISobjectValidator thisValidator : validators )
		{
			try
			{
				thisValidator.validate();
			}
			catch ( ortoo_Exception e )
			{
				Application.MESSAGE_RENDERER.newInstance( MessageRendererEngine.SobjectMessageAdder.class, e )
					.render();
			}
		}
	}
}