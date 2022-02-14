/**
 * Provides the ability to create selection criteria for use in Domain and Selector classes
 *
 * @group fflib Extension
 */
public inherited sharing virtual class ortoo_Criteria extends fflib_Criteria implements ISearchCriteria // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
	public virtual ortoo_Criteria likeString( Schema.SObjectField field, Object value )
	{
		addEvaluator( new FieldEvaluator( field, fflib_Operator.LIKEx, value ) );
		return this;
	}

	public virtual ortoo_Criteria likeString( String relatedField, Object value )
	{
		addEvaluator( new RelatedFieldEvaluator( relatedField, fflib_Operator.LIKEx, value ) );
		return this;
	}

	public ortoo_Criteria inSet( String relatedField, Set<Object> values )
	{
		return inSet( relatedField, new fflib_Objects( new List<Object>( values ) ) );
	}

	public ortoo_Criteria inSet( String relatedField, Set<DateTime> values )
	{
		return inSet( relatedField, new fflib_DateTimes( values ) );
	}

	public ortoo_Criteria inSet( String relatedField, Set<Date> values )
	{
		return inSet( relatedField, new fflib_Dates( values ) );
	}

	public ortoo_Criteria inSet( String relatedField, Set<Decimal> values )
	{
		return inSet( relatedField, new fflib_Decimals( values ) );
	}

	public ortoo_Criteria inSet( String relatedField, Set<Double> values )
	{
		return inSet( relatedField, new fflib_Doubles( values ) );
	}

	public ortoo_Criteria inSet( String relatedField, Set<Id> values )
	{
		return inSet( relatedField, new fflib_Ids( values ) );
	}

	public ortoo_Criteria inSet( String relatedField, Set<Integer> values )
	{
		return inSet( relatedField, new fflib_Integers( values ) );
	}

	public ortoo_Criteria inSet( String relatedField, Set<Long> values )
	{
		return inSet( relatedField, new fflib_Longs( values ) );
	}

	public ortoo_Criteria inSet( String relatedField, Set<String> values )
	{
		return inSet( relatedField, new fflib_Strings( values ) );
	}

	protected ortoo_Criteria inSet( String relatedField, fflib_Objects values )
	{
		addEvaluator( new RelatedFieldSetEvaluator( relatedField, fflib_Operator.INx, values ) );
		return this;
	}
}