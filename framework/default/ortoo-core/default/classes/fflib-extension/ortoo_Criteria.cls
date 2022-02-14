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

	/**
	 * Checks if the given field has a value in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( 'Account.Type', new Set<Object>{'Customer', 'Competitor', 'Partner'} )
	 *
	 * Evaluates:
	 *      Account.Type IN ('Customer','Competitor','Partner')
	 */
	public ortoo_Criteria inSet( String relatedField, Set<Object> values )
	{
		return inSet( relatedField, new fflib_Objects( new List<Object>( values ) ) );
	}

	/**
	 * Checks if the given field has a DateTime value in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( 'Account.DateTime_Value__c', new Set<DateTime>{ Date.newInstanceGmt( 2020, 01, 02, 11, 20, 00 ), Date.newInstance( 2021, 01, 02, 11, 00, 20 )} )
	 *
	 * Evaluates:
	 *      Account.DateTime_Value__c IN (2021-01-02T11:20:00Z,2021-01-02T11:00:20Z)
	 */
	public ortoo_Criteria inSet( String relatedField, Set<DateTime> values )
	{
		return inSet( relatedField, new fflib_DateTimes( values ) );
	}

	/**
	 * Checks if the given field has a Date value in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( 'Account.Date_Value__c', new Set<Date>{ Date.newInstance( 2020, 01, 02 ), Date.newInstance( 2021, 01, 02 )} )
	 *
	 * Evaluates:
	 *      Account.Date_Value__c IN (2021-01-02,2021-01-02)
	 */
	public ortoo_Criteria inSet( String relatedField, Set<Date> values )
	{
		return inSet( relatedField, new fflib_Dates( values ) );
	}

	/**
	 * Checks if the given field has a Decimal value in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( 'Account.Decimal_Value__c', new Set<Decimal>{1.1,2.2,3.3} )
	 *
	 * Evaluates:
	 *      Account.Decimal_Value__c IN (1.1,2.2,3.3)
	 */
	public ortoo_Criteria inSet( String relatedField, Set<Decimal> values )
	{
		return inSet( relatedField, new fflib_Decimals( values ) );
	}

	/**
	 * Checks if the given field has a Double value in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( 'Account.Double_Value__c', new Set<Double>{1.1,2.2,3.3} )
	 *
	 * Evaluates:
	 *      Account.Double_Value__c IN (1.1,2.2,3.3)
	 */
	public ortoo_Criteria inSet( String relatedField, Set<Double> values )
	{
		return inSet( relatedField, new fflib_Doubles( values ) );
	}

	/**
	 * Checks if the given field has an Id value in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( 'Account.Id', new Set<Id>{'0010t00001bH9q2AAC', '0010t00001bH9q2AAB'} )
	 *
	 * Evaluates:
	 *      Account.Id IN ('0010t00001bH9q2AAC','0010t00001bH9q2AAB')
	 */
	public ortoo_Criteria inSet( String relatedField, Set<Id> values )
	{
		return inSet( relatedField, new fflib_Ids( values ) );
	}

	/**
	 * Checks if the given field has a Integer value in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( 'Account.Integer_Value__c', new Set<Integer>{1,2,3} )
	 *
	 * Evaluates:
	 *      Account.Integer_Value__c IN (1,2,3)
	 */
	public ortoo_Criteria inSet( String relatedField, Set<Integer> values )
	{
		return inSet( relatedField, new fflib_Integers( values ) );
	}

	/**
	 * Checks if the given field has a Long value in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( 'Account.Long_Value__c', new Set<Long>{1,2,3} )
	 *
	 * Evaluates:
	 *      Account.Long_Value__c IN (1,2,3)
	 */
	public ortoo_Criteria inSet( String relatedField, Set<Long> values )
	{
		return inSet( relatedField, new fflib_Longs( values ) );
	}

	/**
	 * Checks if the given field has a String value in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( 'Account.String_Value__c', new Set<String>{'one','two'} )
	 *
	 * Evaluates:
	 *      Account.Long_Value__c IN ('one','two')
	 */
	public ortoo_Criteria inSet( String relatedField, Set<String> values )
	{
		return inSet( relatedField, new fflib_Strings( values ) );
	}

	/**
	 * Checks if the given field has a value that is not in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( 'Account.Type', new Set<Object>{'Customer', 'Competitor', 'Partner'} )
	 *
	 * Evaluates:
	 *      Account.Type NOT IN ('Customer','Competitor','Partner')
	 */
	public ortoo_Criteria notInSet( String relatedField, Set<Object> values )
	{
		return notInSet( relatedField, new fflib_Objects( new List<Object>( values ) ) );
	}

	/**
	 * Checks if the given field has a DateTime value that is not in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( 'Account.DateTime_Value__c', new Set<DateTime>{ Date.newInstanceGmt( 2020, 01, 02, 11, 20, 00 ), Date.newInstance( 2021, 01, 02, 11, 00, 20 )} )
	 *
	 * Evaluates:
	 *      Account.DateTime_Value__c NOT IN (2021-01-02T11:20:00Z,2021-01-02T11:00:20Z)
	 */
	public ortoo_Criteria notInSet( String relatedField, Set<DateTime> values )
	{
		return notInSet( relatedField, new fflib_DateTimes( values ) );
	}

	/**
	 * Checks if the given field has a Date value that is not in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( 'Account.Date_Value__c', new Set<Date>{ Date.newInstance( 2020, 01, 02 ), Date.newInstance( 2021, 01, 02 )} )
	 *
	 * Evaluates:
	 *      Account.Date_Value__c NOT IN (2021-01-02,2021-01-02)
	 */
	public ortoo_Criteria notInSet( String relatedField, Set<Date> values )
	{
		return notInSet( relatedField, new fflib_Dates( values ) );
	}

	/**
	 * Checks if the given field has a Decimal value that is not in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( 'Account.Decimal_Value__c', new Set<Decimal>{1.1,2.2,3.3} )
	 *
	 * Evaluates:
	 *      Account.Decimal_Value__c NOT IN (1.1,2.2,3.3)
	 */
	public ortoo_Criteria notInSet( String relatedField, Set<Decimal> values )
	{
		return notInSet( relatedField, new fflib_Decimals( values ) );
	}

	/**
	 * Checks if the given field has a Double value that is not in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( 'Account.Double_Value__c', new Set<Double>{1.1,2.2,3.3} )
	 *
	 * Evaluates:
	 *      Account.Double_Value__c NOT IN (1.1,2.2,3.3)
	 */
	public ortoo_Criteria notInSet( String relatedField, Set<Double> values )
	{
		return notInSet( relatedField, new fflib_Doubles( values ) );
	}

	/**
	 * Checks if the given field has an Id value that is not in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( 'Account.Id', new Set<Id>{'0010t00001bH9q2AAC', '0010t00001bH9q2AAB'} )
	 *
	 * Evaluates:
	 *      Account.Id NOT IN ('0010t00001bH9q2AAC','0010t00001bH9q2AAB')
	 */
	public ortoo_Criteria notInSet( String relatedField, Set<Id> values )
	{
		return notInSet( relatedField, new fflib_Ids( values ) );
	}

	/**
	 * Checks if the given field has a Integer value that is not in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( 'Account.Integer_Value__c', new Set<Integer>{1,2,3} )
	 *
	 * Evaluates:
	 *      Account.Integer_Value__c NOT IN (1,2,3)
	 */
	public ortoo_Criteria notInSet( String relatedField, Set<Integer> values )
	{
		return notInSet( relatedField, new fflib_Integers( values ) );
	}

	/**
	 * Checks if the given field has a Long value that is not in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( 'Account.Long_Value__c', new Set<Long>{1,2,3} )
	 *
	 * Evaluates:
	 *      Account.Long_Value__c NOT IN (1,2,3)
	 */
	public ortoo_Criteria notInSet( String relatedField, Set<Long> values )
	{
		return notInSet( relatedField, new fflib_Longs( values ) );
	}

	/**
	 * Checks if the given field has a String value that is not in the given set
	 *
	 * @param	field	The field to check the value of
	 * @param	values	The values that resolve to 'true'
	 *
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( 'Account.String_Value__c', new Set<String>{'one','two'} )
	 *
	 * Evaluates:
	 *      Account.Long_Value__c NOT IN ('one','two')
	 */
	public ortoo_Criteria notInSet( String relatedField, Set<String> values )
	{
		return notInSet( relatedField, new fflib_Strings( values ) );
	}

	protected ortoo_Criteria inSet( String relatedField, fflib_Objects values )
	{
		addEvaluator( new RelatedFieldSetEvaluator( relatedField, fflib_Operator.INx, values ) );
		return this;
	}
	protected ortoo_Criteria notInSet( String relatedField, fflib_Objects values )
	{
		addEvaluator( new RelatedFieldSetEvaluator( relatedField, fflib_Operator.NOT_IN, values ) );
		return this;
	}
}