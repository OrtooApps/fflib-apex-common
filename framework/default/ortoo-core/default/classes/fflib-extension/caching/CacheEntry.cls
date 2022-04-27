// TODO: document
// TODO: test
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

	public Boolean isYoungerThanOrEqualTo( Long compareAgeInSeconds )
	{
		Contract.requires( compareAgeInSeconds != null, 'isYoungerThanOrEqualTo called with a null compareAgeInSeconds' );

		return ageInSeconds <= compareAgeInSeconds;
	}

	public Object getValue()
	{
		return this.value;
	}
}