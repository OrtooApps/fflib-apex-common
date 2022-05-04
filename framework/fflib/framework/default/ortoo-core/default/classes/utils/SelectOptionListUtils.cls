/**
 * Utility class that provides extra capabilities related to Lists of SelectOptions
 *
 * @group Utils
 */
public inherited sharing class SelectOptionListUtils
{
	@testVisible
	private static final Integer MANAGEABLE_SELECT_LIST_LENGTH = 1000;

	/**
     * Given a List of SelectOptions, will return a trimmed version, limited to what is regarded as a manageable size for SelectOptions
	 *
     * @param	input	The List to trim
     * @return	The resulting trimmed List
     */
	public static List<SelectOption> trimToManageableLength( List<SelectOption> input )
	{
		Contract.requires( input != null, 'trimToManageableLength called with a null List' );

		List<SelectOption> returnList = (List<SelectOption>)ListUtils.trim( input, MANAGEABLE_SELECT_LIST_LENGTH );

		Contract.ensures( returnList != null, 'trimToManageableLength returned with a null List' );
		return returnList;
	}
}