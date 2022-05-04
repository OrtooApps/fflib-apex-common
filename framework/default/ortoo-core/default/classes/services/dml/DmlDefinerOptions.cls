/**
 * Defines the options that are applicable for a DmlDefiner
 *
 * @group Services/Dml
 */
public inherited sharing class DmlDefinerOptions
{
	public enum OtherRecordsOption { IGNORE_RECORDS, DELETE_RECORDS }

	OtherRecordsOption  otherRecordsMode;

	/**
	 * Set the mode for what should happen to other children of the records being updated
	 *
	 * @param	OtherRecordsOption	The option to use
	 * @return	DmlDefinerOptions	Itself, allowing for a fluent interface
	 */
	public DmlDefinerOptions setOtherRecordsMode( OtherRecordsOption otherRecordsMode )
	{
		Contract.requires( otherRecordsMode != null, 'setOtherRecordsMode called with a null otherRecordsMode' );

		this.otherRecordsMode = otherRecordsMode;
		return this;
	}

	/**
	 * Get the mode for what should happen to other children of the records being updated
	 *
	 * @return	OtherRecordsOption	The option to use
	 */
	public OtherRecordsOption getOtherRecordsMode()
	{
		return this.otherRecordsMode;
	}

	/**
	 * Creates a defaulted set of options
	 *
	 * @return	DmlDefinerOptions	The default options
	 */
	public static DmlDefinerOptions default()
	{
		return new DmlDefinerOptions()
						.setOtherRecordsMode( OtherRecordsOption.IGNORE_RECORDS );
	}

	/**
	 * States if this definer will instruct to delete other records
	 *
	 * @return	Boolean	Should other records be deleted?
	 */
	public Boolean getWillDeleteOtherRecords()
	{
		return getOtherRecordsMode() == OtherRecordsOption.DELETE_RECORDS;
	}
}