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

}