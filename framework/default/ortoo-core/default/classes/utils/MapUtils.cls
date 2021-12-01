/**
 * Utility class that provides extra capabilities related to Maps
 *
 * @group Utils
 */
public inherited sharing class MapUtils
{
	/**
	 * Given a Map of SObjects referenced by their Ids and a Set of Ids to remove, will remove the
	 * SObjects with the given Ids from the original map.
	 * @param	sobjectsById	The map from which to remove the specified SObjects
	 * @param	idsToRemove		The Set of Ids to remove
	 */
	public static void remove( Map<Id,Sobject> sobjectsById, Set<Id> idsToRemove )
	{
		Contract.requires( sobjectsById != null, 'remove called with a null sobjectsById' );

		if ( idsToRemove == null )
		{
			return;
		}

		for ( Id thisIdToRemove : idsToRemove ) {
			sobjectsById.remove( thisIdToRemove );
		}
	}
}