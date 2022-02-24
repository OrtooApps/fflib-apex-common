/**
 * Class that provides:
 *
 * 	* Shorthands for specific dates related to today.
 * 		E.g. today, yesterday, tomorrow, startOfLastWeek
 *
 * 	* A list of inner classes that can be used as targets for comparisons in ortoo_Criteria.
 *		Specifically, the classes represent a subset of the Date Literals that SOQL supports
 *
 *  * Note that if the date shorthands are used, then their behaviour can be overridden in tests
 *    by changing the value of 'today'.
 *
 * @group fflib Extension
 */
public inherited sharing class ortoo_DateLiterals
{
	public class NonEvaluatableException extends ortoo_Exception {}

	private interface Literal extends fflib_Criteria.Literal {}
	private interface Comparable extends fflib_Comparator.Comparable {}

	public static Date today = Date.today();

	/**
	 * Dynamic representation of the date 'tomorrow', based on the same class's representation of 'today'
	 */
	public static Date tomorrow
	{
		get
		{
			return today.addDays( 1 );
		}
	}

	/**
	 * Dynamic representation of the date 'yesterday', based on the same class's representation of 'today'
	 */
	public static Date yesterday
	{
		get
		{
			return today.addDays( -1 );
		}
	}

	/**
	 * Dynamic representation of the date 'start of this week', based on the same class's representation of 'today'
	 */
	public static Date startOfThisWeek
	{
		get
		{
			return today.toStartOfWeek();
		}
	}

	/**
	 * Dynamic representation of the date 'end of this week', based on the same class's representation of 'today'
	 */
	public static Date endOfThisWeek
	{
		get
		{
			return startOfThisWeek.addDays( 6 );
		}
	}

	/**
	 * Dynamic representation of the date 'start of last week', based on the same class's representation of 'today'
	 */
	public static Date startOfLastWeek
	{
		get
		{
			return startOfThisWeek.addDays( -7 );
		}
	}

	/**
	 * Dynamic representation of the date 'end of last week', based on the same class's representation of 'today'
	 */
	public static Date endOfLastWeek
	{
		get
		{
			return endOfThisWeek.addDays( -7 );
		}
	}

	/**
	 * Dynamic representation of the date 'start of next week', based on the same class's representation of 'today'
	 */
	public static Date startOfNextWeek
	{
		get
		{
			return startOfThisWeek.addDays( 7 );
		}
	}

	/**
	 * Dynamic representation of the date 'end of next week', based on the same class's representation of 'today'
	 */
	public static Date endOfNextWeek
	{
		get
		{
			return endOfThisWeek.addDays( 7 );
		}
	}

	/**
	 * Dynamic representation of the date 'start of this month', based on the same class's representation of 'today'
	 */
	public static Date startOfThisMonth
	{
		get
		{
			return today.toStartOfMonth();
		}
	}

	/**
	 * Dynamic representation of the date 'end of this month', based on the same class's representation of 'today'
	 */
	public static Date endOfThisMonth
	{
		get
		{
			return startOfThisMonth.addMonths( 1 ).addDays( -1 );
		}
	}

	/**
	 * Dynamic representation of the date 'start of next month', based on the same class's representation of 'today'
	 */
	public static Date startOfNextMonth
	{
		get
		{
			return startOfThisMonth.addMonths( 1 );
		}
	}

	/**
	 * Dynamic representation of the date 'end of next month', based on the same class's representation of 'today'
	 */
	public static Date endOfNextMonth
	{
		get
		{
			return startOfThisMonth.addMonths( 2 ).addDays( -1 ); // Note, do not change to endOfThisMonth.addMonths, as this can switch months
		}
	}

	/**
	 * Dynamic representation of the date 'start of last month', based on the same class's representation of 'today'
	 */
	public static Date startOfLastMonth
	{
		get
		{
			return startOfThisMonth.addMonths( -1 );
		}
	}

	/**
	 * Dynamic representation of the date 'end of last month', based on the same class's representation of 'today'
	 */
	public static Date endOfLastMonth
	{
		get
		{
			return startOfThisMonth.addDays( -1 ); // Note, do not change to endOfThisMonth.addMonths, as this can switch months
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'TODAY'
	 */
	public class Today extends DateRangeLiteral implements Literal, Comparable
	{
		public override String toLiteral()
		{
			return 'TODAY';
		}

		protected override Date getStartDate()
		{
			return today;
		}

		protected override Date getEndDate()
		{
			return today;
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'YESTERDAY'
	 */
	public class Yesterday extends DateRangeLiteral implements Literal, Comparable
	{
		public override String toLiteral()
		{
			return 'YESTERDAY';
		}

		protected override Date getStartDate()
		{
			return yesterday;
		}

		protected override Date getEndDate()
		{
			return yesterday;
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'TOMORROW'
	 */
	public class Tomorrow extends DateRangeLiteral implements Literal, Comparable
	{
		public override String toLiteral()
		{
			return 'TOMORROW';
		}

		protected override Date getStartDate()
		{
			return tomorrow;
		}

		protected override Date getEndDate()
		{
			return tomorrow;
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'LAST_WEEK'
	 */
	public class LastWeek extends DateRangeLiteral implements Literal, Comparable
	{
		public override String toLiteral()
		{
			return 'LAST_WEEK';
		}

		protected override Date getStartDate()
		{
			return startOfLastWeek;
		}

		protected override Date getEndDate()
		{
			return endOfLastWeek;
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'THIS_WEEK'
	 */
	public class ThisWeek extends DateRangeLiteral implements Literal, Comparable
	{
		public override String toLiteral()
		{
			return 'THIS_WEEK';
		}

		protected override Date getStartDate()
		{
			return startOfThisWeek;
		}

		protected override Date getEndDate()
		{
			return endOfThisWeek;
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'NEXT_WEEK'
	 */
	public class NextWeek extends DateRangeLiteral implements Literal, Comparable
	{
		public override String toLiteral()
		{
			return 'NEXT_WEEK';
		}

		protected override Date getStartDate()
		{
			return startOfNextWeek;
		}

		protected override Date getEndDate()
		{
			return endOfNextWeek;
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'LAST_MONTH'
	 */
	public class LastMonth extends DateRangeLiteral implements Literal, Comparable
	{
		public override String toLiteral()
		{
			return 'LAST_MONTH';
		}

		protected override Date getStartDate()
		{
			return startOfLastMonth;
		}

		protected override Date getEndDate()
		{
			return endOfLastMonth;
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'THIS_MONTH'
	 */
	public class ThisMonth extends DateRangeLiteral implements Literal, Comparable
	{
		public override String toLiteral()
		{
			return 'THIS_MONTH';
		}

		protected override Date getStartDate()
		{
			return startOfThisMonth;
		}

		protected override Date getEndDate()
		{
			return endOfThisMonth;
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'NEXT_MONTH'
	 */
	public class NextMonth extends DateRangeLiteral implements Literal, Comparable
	{
		public override String toLiteral()
		{
			return 'NEXT_MONTH';
		}

		protected override Date getStartDate()
		{
			return startOfNextMonth;
		}

		protected override Date getEndDate()
		{
			return endOfNextMonth;
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'LAST_90_DAYS'
	 */
	public class Last90Days extends DateRangeLiteral implements Literal, Comparable
	{
		public override String toLiteral()
		{
			return 'LAST_90_DAYS';
		}

		protected override Date getStartDate()
		{
			return today.addDays( -90 );
		}

		protected override Date getEndDate()
		{
			return today;
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'NEXT_90_DAYS'
	 */
	public class Next90Days extends DateRangeLiteral implements Literal, Comparable
	{
		public override String toLiteral()
		{
			return 'NEXT_90_DAYS';
		}

		protected override Date getStartDate()
		{
			return tomorrow;
		}

		protected override Date getEndDate()
		{
			return today.addDays( 90 );
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'LAST_N_DAYS'
	 */
	public class LastNDays extends NumericallyQualifiedLiteral implements Literal, Comparable
	{
		public LastNDays( Integer numberOfThings )
		{
			super( numberOfThings, 'LAST_N_DAYS' );

			Contract.requires( numberOfThings != null, 'LastNDays constructed with a null number of days' );
			Contract.requires( numberOfThings > 0 , 'LastNDays constructed with a negative or zero number of days' );
		}

		protected override Date getStartDate()
		{
			return today.addDays( numberOfThings * -1 );
		}

		protected override Date getEndDate()
		{
			return today;
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'NEXT_N_DAYS'
	 */
	public class NextNDays extends NumericallyQualifiedLiteral implements Literal, Comparable
	{
		public NextNDays( Integer numberOfThings )
		{
			super( numberOfThings, 'NEXT_N_DAYS' );

			Contract.requires( numberOfThings != null, 'NextNDays constructed with a null number of days' );
			Contract.requires( numberOfThings > 0 , 'NextNDays constructed with a negative or zero number of days' );
		}

		protected override Date getStartDate()
		{
			return tomorrow;
		}

		protected override Date getEndDate()
		{
			return today.addDays( numberOfThings );
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'LAST_N_WEEKS'
	 */
	public class LastNWeeks extends NumericallyQualifiedLiteral implements Literal, Comparable
	{
		public LastNWeeks( Integer numberOfThings )
		{
			super( numberOfThings, 'LAST_N_WEEKS' );

			Contract.requires( numberOfThings != null, 'LastNWeeks constructed with a null number of days' );
			Contract.requires( numberOfThings > 0 , 'LastNWeeks constructed with a negative or zero number of days' );
		}

		protected override Date getStartDate()
		{
			return startOfThisWeek.addDays( this.numberOfThings * -7 );
		}

		protected override Date getEndDate()
		{
			return endOfLastWeek;
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'NEXT_N_WEEKS'
	 */
	public class NextNWeeks extends NumericallyQualifiedLiteral implements Literal, Comparable
	{
		public NextNWeeks( Integer numberOfThings )
		{
			super( numberOfThings, 'NEXT_N_WEEKS' );
		}

		protected override Date getStartDate()
		{
			return startOfNextWeek;
		}

		protected override Date getEndDate()
		{
			return endOfNextWeek.addDays( this.numberOfThings * 7 );
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'LAST_N_MONTHS'
	 */
	public class LastNMonths extends NumericallyQualifiedLiteral implements Literal, Comparable
	{
		public LastNMonths( Integer numberOfThings )
		{
			super( numberOfThings, 'LAST_N_MONTHS' );

			Contract.requires( numberOfThings != null, 'LastNMonths constructed with a null number of months' );
			Contract.requires( numberOfThings > 0 , 'LastNMonths constructed with a negative or zero number of months' );
		}

		protected override Date getStartDate()
		{
			return endOfLastMonth;
		}

		protected override Date getEndDate()
		{
			return startOfThisMonth.addMonths( numberOfThings * -1 );
		}
	}

	/**
	 * ortoo_Criteria compatible literal that represents the SOQL Date Literal 'NEXT_N_MONTHS'
	 */
	public class NextNMonths extends NumericallyQualifiedLiteral implements Literal, Comparable
	{
		public NextNMonths( Integer numberOfThings )
		{
			super( numberOfThings, 'NEXT_N_MONTHS' );

			Contract.requires( numberOfThings != null, 'NextNMonths constructed with a null number of months' );
			Contract.requires( numberOfThings > 0 , 'NextNMonths constructed with a negative or zero number of months' );

		}

		protected override Date getStartDate()
		{
			return startOfNextMonth;
		}

		protected override Date getEndDate()
		{
			return startOfNextMonth.addMonths( numberOfThings ).addDays( -1 );
		}
	}

	private abstract class NumericallyQualifiedLiteral extends DateRangeLiteral implements Literal
	{
		Integer numberOfThings;
		String baseLiteral;

		protected NumericallyQualifiedLiteral( Integer numberOfThings, String baseLiteral )
		{
			Contract.requires( numberOfThings != null, 'constructor called with a null numberOfThings' );
			Contract.requires( baseLiteral != null, 'constructor called with a null baseLiteral' );

			this.numberOfThings = numberOfThings;
			this.baseLiteral = baseLiteral;
		}

		public override String toLiteral()
		{
			return this.baseLiteral + ':' + this.numberOfThings;
		}
	}

	private abstract class DateRangeLiteral implements ortoo_DateLiterals.Comparable
	{
		protected abstract String toLiteral();
		protected abstract Date getStartDate();
		protected abstract Date getEndDate();

		public Integer compare( Object otherValue )
		{
			if ( otherValue instanceOf Date )
			{
				return new DateToDateRangeComparer().compare( (Date)otherValue, getStartDate(), getEndDate() );
			}
			if ( otherValue instanceOf DateTime )
			{
				return new DateTimeToDateRangeComparer().compare( (DateTime)otherValue, getStartDate(), getEndDate() );
			}

			throw new NonEvaluatableException( 'Attempted to compare a non Date / DateTime with a Date Literal' )
						.setErrorCode( FrameworkErrorCodes.NON_EVALUATABLE_CRITERIA )
						.addContext( 'DateLiteral', toLiteral() );
		}
	}

	private class DateTimeToDateRangeComparer
	{
		public Integer compare( DateTime value, Date startDate, Date endDate ) {

			if ( value < DateTime.newInstance( startDate.year(), startDate.month(), startDate.day(), 0, 0, 0 ) )
			{
				return -1;
			}
			if ( value > DateTime.newInstance( endDate.year(), endDate.month(), endDate.day(), 23, 59, 29 ) )
			{
				return 1;
			}
			return 0;
		}
	}

	private class DateToDateRangeComparer
	{
		public Integer compare( Date value, Date startDate, Date endDate ) {
			if ( value < startDate )
			{
				return -1;
			}
			if ( value > endDate )
			{
				return 1;
			}
			return 0;
		}
	}
}