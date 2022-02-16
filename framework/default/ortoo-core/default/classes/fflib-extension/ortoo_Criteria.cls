/**
 * Provides the ability to create selection criteria for use in Domain and Selector classes
 *
 * @group fflib Extension
 */
public inherited sharing virtual class ortoo_Criteria implements ISearchCriteria // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
	fflib_Criteria criteria;

	public ortoo_Criteria()
	{
		criteria = new fflib_Criteria();
	}

	/**
	 * Generates the SOQL equivalent of the configured criteria
	 *
	 * @return String	The "where" part in the SOQL statement
	 */
	public String toSOQL()
	{
		return criteria.toSOQL();
	}

	/**
	 * Evaluates the given object against the configured criteria
	 *
	 * @param	Object	The object to evaluate
	 * @return	Boolean	Statement of whether the record matches the criteria
	 */
	public Boolean evaluate( Object record )
	{
		Contract.requires( record != null, 'evaluate called with a null record' );
		return criteria.evaluate( record );
	}

	/**
	 * Changes the default comparator for each criteria to OR
	 *
	 * @return	ortoo_Criteria	Itself, allowing for a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .orCriteria()
	 *          .equalTo(Account.Name, 'Example')
	 *  		.equalTo(Account.AccountNumber, '1234567')
	 *
	 *  Evaluates:
	 *      Name = 'Example' OR AccountNumber = '1234567'
	 */
	public ortoo_Criteria orCriteria()
	{
		criteria.orCriteria();
		return this;
	}

	/**
	 * Changes the default comparator for each criteria to AND
	 *
	 * @return	ortoo_Criteria	Itself, allowing for a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .andCriteria()
	 *          .equalTo(Account.Name, 'Example')
	 *  		.equalTo(Account.AccountNumber, '1234567')
	 *
	 *  Evaluates:
	 *      Name = 'Example' AND AccountNumber = '1234567'
	 */
	public ortoo_Criteria andCriteria()
	{
		criteria.andCriteria();
		return this;
	}

	/**
	 * Adds a sub-criteria with OR comparator
	 *
	 * @param	ortoo_Criteria	The condition of the sub criteria
	 * @return	ortoo_Criteria	Itself, allowing for a fluent interface
	 *
	 * @example
	 * new ortoo_Criteria()
	 *          .equalTo(Account.Name, 'Example')
	 *          .addOrCriteria(
	 *              new ortoo_Criteria()
	 *              		.equalTo(Account.AccountNumber, '0001')
	 *              		.equalTo(Account.AccountNumber, '0002'))
	 *
	 *  Evaluates:
	 *      Name = 'Example' AND (AccountNumber = '0001' OR AccountNumber = '0002')
	 */
	public ortoo_Criteria addOrCriteria( ortoo_Criteria subCriteria )
	{
		Contract.requires( subCriteria != null, 'addOrCriteria called with a null subCriteria' );
		Contract.requires( subCriteria.criteria != null, 'addOrCriteria called with a subCriteria that has no criteria defined' );

		criteria.addOrCriteria( subCriteria.criteria );
		return this;
	}

	/**
	 * Adds a sub-criteria with AND comparator
	 *
	 * @param	ortoo_Criteria	The condition of the sub criteria
	 * @return	ortoo_Criteria	Itself, allowing for a fluent interface
	 *
	 * @example
	 * new ortoo_Criteria()
	 *          .orCriteria()
	 *          .equalTo(Account.Name, 'Example')
	 *          .addAndCriteria(
	 *              new ortoo_Criteria()
	 *              		.equalTo(Account.AccountNumber, '0001')
	 *              		.equalTo(Account.ShippingCountry, 'USA'))
	 *
	 *  Evaluates:
	 *      Name = 'Example' OR (AccountNumber = '0001' AND ShippingCountry = 'USA')
	 */
	public ortoo_Criteria addAndCriteria( ortoo_Criteria subCriteria )
	{
		Contract.requires( subCriteria != null, 'addAndCriteria called with a null subCriteria' );
		Contract.requires( subCriteria.criteria != null, 'addAndCriteria called with a subCriteria that has no criteria defined' );

		criteria.addAndCriteria( subCriteria.criteria );
		return this;
	}

	/**
	 * Defines a formual within which the specified criteria should be evaluated.
	 *
	 * @param String The formula string using numbers, AND, OR and parenthesis
	 * @return	ortoo_Criteria	Itself, allowing for a fluent interface
	 *
	 * @example
	 * new ortoo_Criteria()
	 *          .formulaCriteria('(1 OR 2) AND 3')
     *     		.equalTo(Account.AccountNumber, '0001')
	 *    		.equalTo(Account.AccountNumber, '0002')
	 *     		.equalTo(Account.ShippingCountry, 'USA')
	 *
	 *  Evaluates:
	 *      (AccountNumber = '0001' OR AccountNumber = '0002') AND ShippingCountry = 'USA'
	 */
	public ortoo_Criteria formulaCriteria( String formula )
	{
		Contract.requires( String.isNotBlank( formula ), 'formulaCriteria called with a blank formula' );

		criteria.formulaCriteria( formula );
		return this;
	}

	/**
	 * Add an equal to criteria comparing a fields value to a given value
	 *
	 * @param	Schema.SObjectField	The sObjectField to evaluate
	 * @param	Object				The value to be compared to the fields value
	 * @return	ortoo_Criteria		Itself, allowing for a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .equalTo(Account.Name, 'Example')
	 *
	 * Evaluates:
	 *      Name = 'Example'
	 */
	public ortoo_Criteria equalTo( Schema.SObjectField field, Object value )
	{
		Contract.requires( field != null, 'equalTo called with a null field' );

		criteria.equalTo( field, value );
		return this;
	}

	/**
	 * Add an equal to criteria comparing a fields value to a given value
	 *
	 * @param	String				The name of the sObjectField to evaluate
	 * @param	Object				The value to be compared to the fields value
	 * @return	ortoo_Criteria		Itself, allowing for a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .equalTo('Account.Name', 'Example')
	 *
	 * Evaluates:
	 *      Account.Name = 'Example'
	 */
	public ortoo_Criteria equalTo( String relatedField, Object value )
	{
		Contract.requires( relatedField != null, 'equalTo called with a null relatedField' );

		criteria.equalTo( relatedField, value );
		return this;
	}

	/**
	 * Add a not equal to criteria comparing a fields value to a given value
	 *
	 * @param	Schema.SObjectField	The sObjectField to evaluate
	 * @param	Object				The value to be compared to the fields value
	 * @return	ortoo_Criteria		Itself, allowing for a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notEqualTo(Account.Name, 'Example')
	 *
	 * Evaluates:
	 *      Name != 'Example'
	 */
	public ortoo_Criteria notEqualTo( Schema.SObjectField field, Object value )
	{
		Contract.requires( field != null, 'notEqualTo called with a null field' );

		criteria.notEqualTo( field, value );
		return this;
	}

	/**
	 * Add a not equal to criteria comparing a fields value to a given value
	 *
	 * @param	String				The name of the sObjectField to evaluate
	 * @param	Object				The value to be compared to the fields value
	 * @return	ortoo_Criteria		Itself, allowing for a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notEqualTo('Account.Name', 'Example')
	 *
	 * Evaluates:
	 *      Account.Name != 'Example'
	 */
	public ortoo_Criteria notEqualTo( String relatedField, Object value )
	{
		Contract.requires( relatedField != null, 'notEqualTo called with a null relatedField' );

		criteria.notEqualTo( relatedField, value );
		return this;
	}

	/**
	 * Add a greater than or equal to criteria comparing a fields value to a given value
	 *
	 * @param	Schema.SObjectField	The sObjectField to evaluate
	 * @param	Object				The value to be compared to the fields value
	 * @return	ortoo_Criteria		Itself, allowing for a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .greaterOrEqualTo(Account.Numeric_Field__c, 10)
	 *
	 * Evaluates:
	 *      Numeric_Field__c >= 10
	 */
	public ortoo_Criteria greaterOrEqualTo( Schema.SObjectField field, Object value )
	{
		Contract.requires( field != null, 'greaterOrEqualTo called with a null field' );

		criteria.greaterOrEqualTo( field, value );
		return this;
	}

	/**
	 * Add a greater than or equal to criteria comparing a fields value to a given value
	 *
	 * @param	String				The name of the sObjectField to evaluate
	 * @param	Object				The value to be compared to the fields value
	 * @return	ortoo_Criteria		Itself, allowing for a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .greaterOrEqualTo('Account.Numeric_Field__c', 10 )
	 *
	 * Evaluates:
	 *      Account.Numeric_Field__c >= 10
	 */
	public ortoo_Criteria greaterOrEqualTo( String relatedField, Object value )
	{
		Contract.requires( relatedField != null, 'greaterOrEqualTo called with a null relatedField' );

		criteria.greaterOrEqualTo( relatedField, value );
		return this;
	}

	/**
	 * Add a greater than criteria comparing a fields value to a given value
	 *
	 * @param	Schema.SObjectField	The sObjectField to evaluate
	 * @param	Object				The value to be compared to the fields value
	 * @return	ortoo_Criteria		Itself, allowing for a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .greaterThan(Account.Numeric_Field__c, 10)
	 *
	 * Evaluates:
	 *      Numeric_Field__c > 10
	 */
	public ortoo_Criteria greaterThan( Schema.SObjectField field, Object value )
	{
		Contract.requires( field != null, 'greaterThan called with a null field' );

		criteria.greaterThan( field, value );
		return this;
	}

	/**
	 * Add a greater than criteria comparing a fields value to a given value
	 *
	 * @param	String				The name of the sObjectField to evaluate
	 * @param	Object				The value to be compared to the fields value
	 * @return	ortoo_Criteria		Itself, allowing for a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .greaterThan('Account.Numeric_Field__c', 10 )
	 *
	 * Evaluates:
	 *      Account.Numeric_Field__c > 10
	 */
	public ortoo_Criteria greaterThan( String relatedField, Object value )
	{
		Contract.requires( relatedField != null, 'greaterThan called with a null relatedField' );

		criteria.greaterThan( relatedField, value );
		return this;
	}

	/**
	 * Add a less than or equal to criteria comparing a fields value to a given value
	 *
	 * @param	Schema.SObjectField	The sObjectField to evaluate
	 * @param	Object				The value to be compared to the fields value
	 * @return	ortoo_Criteria		Itself, allowing for a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .lessOrEqualTo(Account.Name, 10 )
	 *
	 * Evaluates:
	 *      Numeric_Field__c <= 10
	 */
	public ortoo_Criteria lessOrEqualTo( Schema.SObjectField field, Object value )
	{
		Contract.requires( field != null, 'lessOrEqualTo called with a null field' );

		criteria.lessOrEqualTo( field, value );
		return this;
	}

	/**
	 * Add a less than or equal to criteria comparing a fields value to a given value
	 *
	 * @param	String				The name of the sObjectField to evaluate
	 * @param	Object				The value to be compared to the fields value
	 * @return	ortoo_Criteria		Itself, allowing for a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .lessOrEqualTo('Account.Numeric_Field__c', 10 )
	 *
	 * Evaluates:
	 *      Account.Numeric_Field__c <= 10
	 */
	public ortoo_Criteria lessOrEqualTo( String relatedField, Object value )
	{
		Contract.requires( relatedField != null, 'lessOrEqualTo called with a null relatedField' );

		criteria.lessOrEqualTo( relatedField, value );
		return this;
	}

	/**
	 * Add a less than criteria comparing a fields value to a given value
	 *
	 * @param	Schema.SObjectField	The sObjectField to evaluate
	 * @param	Object				The value to be compared to the fields value
	 * @return	ortoo_Criteria		Itself, allowing for a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .lessThan(Account.Numeric_Field__c, 10 )
	 *
	 * Evaluates:
	 *      Numeric_Field__c < 10
	 */
	public ortoo_Criteria lessThan( Schema.SObjectField field, Object value )
	{
		Contract.requires( field != null, 'lessThan called with a null field' );

		criteria.lessThan( field, value );
		return this;
	}

	/**
	 * Add a less than criteria comparing a fields value to a given value
	 *
	 * @param	String				The name of the sObjectField to evaluate
	 * @param	Object				The value to be compared to the fields value
	 * @return	ortoo_Criteria		Itself, allowing for a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .lessThan('Account.Numeric_Field__c', 10 )
	 *
	 * Evaluates:
	 *      Account.Numeric_Field__c < 10
	 */
	public ortoo_Criteria lessThan( String relatedField, Object value )
	{
		Contract.requires( relatedField != null, 'lessThan called with a null relatedField' );

		criteria.lessThan( relatedField, value );
		return this;
	}

	/**
	 * Checks if the given field has a value 'like' that given
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	String				The value that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .likeString( Account.Type, 'Customer%' )
	 *
	 * Evaluates:
	 *      Type LIKE 'Customer%'
	 */
	public ortoo_Criteria likeString( Schema.SObjectField field, String value )
	{
		Contract.requires( field != null, 'likeString called with a null field' );

		if ( ! String.isEmpty( value ) )
		{
			criteria.addEvaluator( new fflib_Criteria.FieldEvaluator( field, fflib_Operator.LIKEx, value ) );
		}
		return this;
	}

	/**
	 * Checks if the given field has a value 'like' that given
	 *
	 * @param	String			The name of the to check the value of
	 * @param	String			The value that resolve to 'true'
	 * @return	ortoo_Criteria	Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .likeString( 'Account.Type', 'Customer%' )
	 *
	 * Evaluates:
	 *      Account.Type LIKE 'Customer%'
	 */
	public ortoo_Criteria likeString( String relatedField, String value )
	{
		Contract.requires( relatedField != null, 'likeString called with a null relatedField' );

		if ( ! String.isEmpty( value ) )
		{
			criteria.addEvaluator( new fflib_Criteria.RelatedFieldEvaluator( relatedField, fflib_Operator.LIKEx, value ) );
		}
		return this;
	}

	/**
	 * Checks if the given field has a value in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<Object>			The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( Account.Type, new Set<Object>{'Customer', 'Competitor', 'Partner'} )
	 *
	 * Evaluates:
	 *      Type IN ('Customer','Competitor','Partner')
	 */
	public ortoo_Criteria inSet( Schema.SObjectField field, Set<Object> values )
	{
		Contract.requires( field != null, 'inSet called with a null field' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		criteria.inSet( field, new fflib_Objects( new List<Object>( values ) ) );
		return this;
	}

	/**
	 * Checks if the given field has a DateTime value in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<DateTime>		The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( Account.DateTime_Value__c, new Set<DateTime>{ Date.newInstanceGmt( 2020, 01, 02, 11, 20, 00 ), Date.newInstance( 2021, 01, 02, 11, 00, 20 )} )
	 *
	 * Evaluates:
	 *      DateTime_Value__c IN (2021-01-02T11:20:00Z,2021-01-02T11:00:20Z)
	 */
	public ortoo_Criteria inSet( Schema.SObjectField field, Set<DateTime> values )
	{
		Contract.requires( field != null, 'inSet called with a null field' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		criteria.inSet( field, new fflib_DateTimes( values ) );
		return this;
	}

	/**
	 * Checks if the given field has a Date value in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<Date>			The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( Account.Date_Value__c, new Set<Date>{ Date.newInstance( 2020, 01, 02 ), Date.newInstance( 2021, 01, 02 )} )
	 *
	 * Evaluates:
	 *      Date_Value__c IN (2021-01-02,2021-01-02)
	 */
	public ortoo_Criteria inSet( Schema.SObjectField field, Set<Date> values )
	{
		Contract.requires( field != null, 'inSet called with a null field' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		criteria.inSet( field, new fflib_Dates( values ) );
		return this;
	}

	/**
	 * Checks if the given field has a Decimal value in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<Decimal>		The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( Account.Decimal_Value__c, new Set<Decimal>{1.1,2.2,3.3} )
	 *
	 * Evaluates:
	 *      Decimal_Value__c IN (1.1,2.2,3.3)
	 */
	public ortoo_Criteria inSet( Schema.SObjectField field, Set<Decimal> values )
	{
		Contract.requires( field != null, 'inSet called with a null field' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		criteria.inSet( field, new fflib_Decimals( values ) );
		return this;
	}

	/**
	 * Checks if the given field has a Double value in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<Double>			The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( Account.Double_Value__c, new Set<Double>{1.1,2.2,3.3} )
	 *
	 * Evaluates:
	 *      Double_Value__c IN (1.1,2.2,3.3)
	 */
	public ortoo_Criteria inSet( Schema.SObjectField field, Set<Double> values )
	{
		Contract.requires( field != null, 'inSet called with a null field' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		criteria.inSet( field, new fflib_Doubles( values ) );
		return this;
	}

	/**
	 * Checks if the given field has an Id value in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<Id>				The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( Account.Id, new Set<Id>{'0010t00001bH9q2AAC', '0010t00001bH9q2AAB'} )
	 *
	 * Evaluates:
	 *      Id IN ('0010t00001bH9q2AAC','0010t00001bH9q2AAB')
	 */
	public ortoo_Criteria inSet( Schema.SObjectField field, Set<Id> values )
	{
		Contract.requires( field != null, 'inSet called with a null field' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		criteria.inSet( field, new fflib_Ids( values ) );
		return this;
	}

	/**
	 * Checks if the given field has a Integer value in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<Integer>		The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( Account.Integer_Value__c, new Set<Integer>{1,2,3} )
	 *
	 * Evaluates:
	 *      Integer_Value__c IN (1,2,3)
	 */
	public ortoo_Criteria inSet( Schema.SObjectField field, Set<Integer> values )
	{
		Contract.requires( field != null, 'inSet called with a null field' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		criteria.inSet( field, new fflib_Integers( values ) );
		return this;
	}

	/**
	 * Checks if the given field has a Long value in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<Long>			The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( Account.Long_Value__c, new Set<Long>{1,2,3} )
	 *
	 * Evaluates:
	 *      Long_Value__c IN (1,2,3)
	 */
	public ortoo_Criteria inSet( Schema.SObjectField field, Set<Long> values )
	{
		Contract.requires( field != null, 'inSet called with a null field' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		criteria.inSet( field, new fflib_Longs( values ) );
		return this;
	}

	/**
	 * Checks if the given field has a String value in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<String>			The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .inSet( Account.String_Value__c, new Set<String>{'one','two'} )
	 *
	 * Evaluates:
	 *      Long_Value__c IN ('one','two')
	 */
	public ortoo_Criteria inSet( Schema.SObjectField field, Set<String> values )
	{
		Contract.requires( field != null, 'inSet called with a null field' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		criteria.inSet( field, new fflib_Strings( values ) );
		return this;
	}

	/**
	 * Checks if the given field has a value in the given set
	 *
	 * @param	String			The name of the field to check the value of
	 * @param	Set<Object>		The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'inSet called with a null relatedField' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		return inSet( relatedField, new fflib_Objects( new List<Object>( values ) ) );
	}

	/**
	 * Checks if the given field has a DateTime value in the given set
	 *
	 * @param	String			The name of the field to check the value of
	 * @param	Set<DateTime>	The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'inSet called with a null relatedField' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		return inSet( relatedField, new fflib_DateTimes( values ) );
	}

	/**
	 * Checks if the given field has a Date value in the given set
	 *
	 * @param	String			The name of the field to check the value of
	 * @param	Set<Date>		The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'inSet called with a null relatedField' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		return inSet( relatedField, new fflib_Dates( values ) );
	}

	/**
	 * Checks if the given field has a Decimal value in the given set
	 *
	 * @param	String			The name of the field to check the value of
	 * @param	Set<Decimal>	The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'inSet called with a null relatedField' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		return inSet( relatedField, new fflib_Decimals( values ) );
	}

	/**
	 * Checks if the given field has a Double value in the given set
	 *
	 * @param	String			The name of the field to check the value of
	 * @param	Set<Double>		The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'inSet called with a null relatedField' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		return inSet( relatedField, new fflib_Doubles( values ) );
	}

	/**
	 * Checks if the given field has an Id value in the given set
	 *
	 * @param	String	The name of the field to check the value of
	 * @param	Set<Id>	The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'inSet called with a null relatedField' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		return inSet( relatedField, new fflib_Ids( values ) );
	}

	/**
	 * Checks if the given field has a Integer value in the given set
	 *
	 * @param	String			The name of the field to check the value of
	 * @param	Set<Integer>	The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'inSet called with a null relatedField' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		return inSet( relatedField, new fflib_Integers( values ) );
	}

	/**
	 * Checks if the given field has a Long value in the given set
	 *
	 * @param	String			The name of the field to check the value of
	 * @param	Set<Long>		The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'inSet called with a null relatedField' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		return inSet( relatedField, new fflib_Longs( values ) );
	}

	/**
	 * Checks if the given field has a String value in the given set
	 *
	 * @param	String			The name of the field to check the value of
	 * @param	Set<String>		The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'inSet called with a null relatedField' );
		Contract.requires( values != null, 'inSet called with a null values' );
		Contract.requires( ! values.isEmpty(), 'inSet called with an empty values' );

		return inSet( relatedField, new fflib_Strings( values ) );
	}

	/**
	 * Checks if the given field has a value that is not in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<Object>			The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( Account.Type, new Set<Object>{'Customer', 'Competitor', 'Partner'} )
	 *
	 * Evaluates:
	 *      Type NOT IN ('Customer','Competitor','Partner')
	 */
	public ortoo_Criteria notInSet( Schema.SobjectField field, Set<Object> values )
	{
		Contract.requires( field != null, 'notInSet called with a null field' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			criteria.notInSet( field, values );
		}
		return this;
	}

	/**
	 * Checks if the given field has a value that is not in the given set
	 *
	 * @param	String			The name of the field to check the value of
	 * @param	Set<Object>		The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'notInSet called with a null relatedField' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			notInSet( relatedField, new fflib_Objects( new List<Object>( values ) ) );
		}
		return this;
	}

	/**
	 * Checks if the given field has a DateTime value that is not in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<DateTime>		The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( Account.DateTime_Value__c, new Set<DateTime>{ Date.newInstanceGmt( 2020, 01, 02, 11, 20, 00 ), Date.newInstance( 2021, 01, 02, 11, 00, 20 )} )
	 *
	 * Evaluates:
	 *      DateTime_Value__c NOT IN (2021-01-02T11:20:00Z,2021-01-02T11:00:20Z)
	 */
	public ortoo_Criteria notInSet( Schema.SobjectField field, Set<DateTime> values )
	{
		Contract.requires( field != null, 'notInSet called with a null field' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			criteria.notInSet( field, values );
		}
		return this;
	}

	/**
	 * Checks if the given field has a DateTime value that is not in the given set
	 *
	 * @param	String			The name of the field to check the value of
	 * @param	Set<DateTime>	The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'notInSet called with a null relatedField' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			notInSet( relatedField, new fflib_DateTimes( values ) );
		}
		return this;
	}

	/**
	 * Checks if the given field has a Date value that is not in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<Date>			The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( Account.Date_Value__c, new Set<Date>{ Date.newInstance( 2020, 01, 02 ), Date.newInstance( 2021, 01, 02 )} )
	 *
	 * Evaluates:
	 *      Date_Value__c NOT IN (2021-01-02,2021-01-02)
	 */
	public ortoo_Criteria notInSet( Schema.SobjectField field, Set<Date> values )
	{
		Contract.requires( field != null, 'notInSet called with a null field' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			criteria.notInSet( field, values );
		}
		return this;
	}

	/**
	 * Checks if the given field has a Date value that is not in the given set
	 *
	 * @param	String			The name of the field to check the value of
	 * @param	Set<Date>		The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'notInSet called with a null relatedField' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			notInSet( relatedField, new fflib_Dates( values ) );
		}
		return this;
	}

	/**
	 * Checks if the given field has a Decimal value that is not in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<Decimal>		The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( Account.Decimal_Value__c, new Set<Decimal>{1.1,2.2,3.3} )
	 *
	 * Evaluates:
	 *      Decimal_Value__c NOT IN (1.1,2.2,3.3)
	 */
	public ortoo_Criteria notInSet( Schema.SobjectField field, Set<Decimal> values )
	{
		Contract.requires( field != null, 'notInSet called with a null field' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			criteria.notInSet( field, values );
		}
		return this;
	}

	/**
	 * Checks if the given field has a Decimal value that is not in the given set
	 *
	 * @param	String			The name of the field to check the value of
	 * @param	Set<Decimal>	The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'notInSet called with a null relatedField' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			notInSet( relatedField, new fflib_Decimals( values ) );
		}
		return this;
	}

	/**
	 * Checks if the given field has a Double value that is not in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<Double>			The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( Account.Double_Value__c, new Set<Double>{1.1,2.2,3.3} )
	 *
	 * Evaluates:
	 *      Double_Value__c NOT IN (1.1,2.2,3.3)
	 */
	public ortoo_Criteria notInSet( Schema.SobjectField field, Set<Double> values )
	{
		Contract.requires( field != null, 'notInSet called with a null field' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			criteria.notInSet( field, values );
		}
		return this;
	}

	/**
	 * Checks if the given field has a Double value that is not in the given set
	 *
	 * @param	String			The name of the field to check the value of
	 * @param	Set<Double>		The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'notInSet called with a null relatedField' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			notInSet( relatedField, new fflib_Doubles( values ) );
		}
		return this;
	}

	/**
	 * Checks if the given field has an Id value that is not in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<Id>				The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( Account.Id, new Set<Id>{'0010t00001bH9q2AAC', '0010t00001bH9q2AAB'} )
	 *
	 * Evaluates:
	 *      Id NOT IN ('0010t00001bH9q2AAC','0010t00001bH9q2AAB')
	 */
	public ortoo_Criteria notInSet( Schema.SobjectField field, Set<Id> values )
	{
		Contract.requires( field != null, 'notInSet called with a null field' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			criteria.notInSet( field, values );
		}
		return this;
	}

	/**
	 * Checks if the given field has an Id value that is not in the given set
	 *
	 * @param	String			The name of the field to check the value of
	 * @param	Set<Id>			The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'notInSet called with a null relatedField' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			notInSet( relatedField, new fflib_Ids( values ) );
		}
		return this;
	}

	/**
	 * Checks if the given field has a Integer value that is not in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<Integer>		The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( Account.Integer_Value__c, new Set<Integer>{1,2,3} )
	 *
	 * Evaluates:
	 *      Integer_Value__c NOT IN (1,2,3)
	 */
	public ortoo_Criteria notInSet( Schema.SobjectField field, Set<Integer> values )
	{
		Contract.requires( field != null, 'notInSet called with a null field' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			criteria.notInSet( field, values );
		}
		return this;
	}

	/**
	 * Checks if the given field has a Integer value that is not in the given set
	 *
	 * @param	String			The name of the field to check the value of
	 * @param	Set<Integer>	The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'notInSet called with a null relatedField' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			notInSet( relatedField, new fflib_Integers( values ) );
		}
		return this;
	}

	/**
	 * Checks if the given field has a Long value that is not in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<Long>			The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( Account.Long_Value__c, new Set<Long>{1,2,3} )
	 *
	 * Evaluates:
	 *      Long_Value__c NOT IN (1,2,3)
	 */
	public ortoo_Criteria notInSet( Schema.SobjectField field, Set<Long> values )
	{
		Contract.requires( field != null, 'notInSet called with a null field' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			criteria.notInSet( field, values );
		}
		return this;
	}

	/**
	 * Checks if the given field has a Long value that is not in the given set
	 *
	 * @param	String			The name of the field to check the value of
	 * @param	Set<Long>		The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'notInSet called with a null relatedField' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			notInSet( relatedField, new fflib_Longs( values ) );
		}
		return this;
	}

	/**
	 * Checks if the given field has a String value that is not in the given set
	 *
	 * @param	Schema.SobjectField	The field to check the value of
	 * @param	Set<String>			The values that resolve to 'true'
	 * @return	ortoo_Criteria		Itself, providing a fluent interface
	 *
	 * @example
	 *  new ortoo_Criteria()
	 *          .notInSet( Account.String_Value__c, new Set<String>{'one','two'} )
	 *
	 * Evaluates:
	 *      Long_Value__c NOT IN ('one','two')
	 */
	public ortoo_Criteria notInSet( Schema.SobjectField field, Set<String> values )
	{
		Contract.requires( field != null, 'notInSet called with a null field' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			criteria.notInSet( field, values );
		}
		return this;
	}

	/**
	 * Checks if the given field has a String value that is not in the given set
	 *
	 * @param	String	The field to check the value of
	 * @param	Set<String>	The values that resolve to 'true'
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
		Contract.requires( relatedField != null, 'notInSet called with a null relatedField' );
		Contract.requires( values != null, 'notInSet called with a null values' );

		if ( !values.isEmpty() )
		{
			notInSet( relatedField, new fflib_Strings( values ) );
		}
		return this;
	}

	protected ortoo_Criteria inSet( String relatedField, fflib_Objects values )
	{
		criteria.addEvaluator( new fflib_Criteria.RelatedFieldSetEvaluator( relatedField, fflib_Operator.INx, values ) );
		return this;
	}

	protected ortoo_Criteria notInSet( String relatedField, fflib_Objects values )
	{
		criteria.addEvaluator( new fflib_Criteria.RelatedFieldSetEvaluator( relatedField, fflib_Operator.NOT_IN, values ) );
		return this;
	}
}