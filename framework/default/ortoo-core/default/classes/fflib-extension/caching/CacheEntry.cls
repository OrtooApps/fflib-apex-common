/**
 * Represents an entry that exists in the cache.
 *
 * Is dated based on the creation time so that entries can later be checked for their staleness
 *
 * @group Cache
 */
public inherited sharing class CacheEntry
{
	Long   createdOnEpoch;
	Object value;

	private Long ageInSeconds
	{
		get
		{
			return ortoo_DateLiterals.epochTime - this.createdOnEpoch;
		}
	}

	public CacheEntry( Object value )
	{
		this.value = value;
		this.createdOnEpoch = ortoo_DateLiterals.epochTime;
	}

	/**
	 * States if the current entry is younger than or equal to the the stated age in seconds
	 *
	 * @param	Long	The age to compare against, in seconds
	 * @return	Boolean	Is the current entry younger or equal to the given age
	 */
	public Boolean isYoungerThanOrEqualTo( Long compareAgeInSeconds )
	{
		Contract.requires( compareAgeInSeconds != null, 'isYoungerThanOrEqualTo called with a null compareAgeInSeconds' );

		return ageInSeconds <= compareAgeInSeconds;
	}

	/**
	 * Returns the current value of the entry
	 *
	 * @return	Object	The value of the entry
	 */
	public Object getValue()
	{
		return this.value;
	}
}