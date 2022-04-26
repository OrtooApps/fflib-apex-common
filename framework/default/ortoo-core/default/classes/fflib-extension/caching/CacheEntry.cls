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
			return DateTimeUtils.getEpochTime() - this.createdOnEpoch;
		}
	}

	public CacheEntry( Object value )
	{
		this.value = value;
		this.createdOnEpoch = DateTimeUtils.getEpochTime();
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