// TODO: document
// TODO: test
public inherited sharing class CacheEntry
{
	Long   createdOnEpoch;
	Object value;

	private Long age
	{
		get
		{
			return DateTimeUtils.getEpochTime() - this.createdOnEpoch ;
		}
	}

	public CacheEntry( Object value )
	{
		this.value = value;
		this.createdOnEpoch = DateTimeUtils.getEpochTime();
	}

	public Boolean isYoungerThan( Integer compareAgeInSeconds )
	{
		Contract.requires( compareAgeInSeconds != null, 'isOlderThan called with a null compareAgeInSeconds' );
		return age < compareAgeInSeconds;
	}

	public Object getValue()
	{
		return this.value;
	}
}