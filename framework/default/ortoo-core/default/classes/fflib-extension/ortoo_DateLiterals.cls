/**
 * Class that provides a list of inner classes that can be used as targets for comparisons in ortoo_Criteria.
 *
 * Specifically, the classes represent the different Date Literals that SOQL supports
 *
 * @group fflib Extension
 */
public inherited sharing class ortoo_DateLiterals
{
	// TODO: datetime behaviours too?

	public class NonEvaluatableException extends ortoo_Exception {}

	private interface Literal extends fflib_Criteria.Literal {}
	private interface Evaluatable extends fflib_Comparator.Evaluatable {}
	private interface Comparable extends fflib_Comparator.Comparable {}

	private static Date today = Date.today();

	public static Date tomorrow
	{
		get {
			return today.addDays( 1 );
		}
	}

	public static Date yesterday
	{
		get {
			return today.addDays( -1 );
		}
	}

	public static Date startOfThisWeek
	{
		get {
			return today.toStartOfWeek();
		}
	}

	public static Date endOfThisWeek
	{
		get {
			return startOfThisWeek.addDays( 6 );
		}
	}

	public static Date startOfLastWeek
	{
		get {
			return startOfThisWeek.addDays( -7 );
		}
	}

	public static Date endOfLastWeek
	{
		get {
			return endOfThisWeek.addDays( -7 );
		}
	}

	public static Date startOfNextWeek
	{
		get {
			return startOfThisWeek.addDays( 7 );
		}
	}

	public static Date endOfNextWeek
	{
		get {
			return endOfThisWeek.addDays( 7 );
		}
	}

	public static Date startOfThisMonth
	{
		get {
			return today.toStartOfMonth();
		}
	}

	public static Date endOfThisMonth
	{
		get {
			return startOfThisMonth.addMonths( 1 ).addDays( -1 );
		}
	}

	public static Date startOfNextMonth
	{
		get {
			return startOfThisMonth.addMonths( 1 );
		}
	}

	public static Date endOfNextMonth
	{
		get {
			return startOfThisMonth.addMonths( 1 ).addDays( -1 ); // Note, do not change to endOfThisMonth.addMonths, as this can switch months
		}
	}

	public static Date startOfLastMonth
	{
		get {
			return startOfThisMonth.addMonths( -1 );
		}
	}

	public static Date endOfLastMonth
	{
		get {
			return startOfThisMonth.addDays( -1 ); // Note, do not change to endOfThisMonth.addMonths, as this can switch months
		}
	}

	public class Today implements Literal, Evaluatable
	{
		public String toLiteral()
		{
			return 'TODAY';
		}

		public Date toValue()
		{
			return today;
		}
	}

	public class Yesterday implements Literal, Evaluatable
	{
		public String toLiteral()
		{
			return 'YESTERDAY';
		}

		public Date toValue()
		{
			return yesterday;
		}
	}

	public class Tomorrow implements Literal, Evaluatable
	{
		public String toLiteral()
		{
			return 'TOMORROW';
		}

		public Date toValue()
		{
			return tomorrow;
		}
	}

	public class LastWeek extends DateRangeLiteral implements Literal, Comparable
	{
		public String toLiteral()
		{
			return 'LAST_WEEK';
		}

		protected override Date getStartDate() {
			return startOfLastWeek;
		}

		protected override Date getEndDate() {
			return endOfLastWeek;
		}
	}

	public class ThisWeek extends DateRangeLiteral implements Literal, Comparable
	{
		public String toLiteral()
		{
			return 'THIS_WEEK';
		}

		protected override Date getStartDate() {
			return startOfThisWeek;
		}

		protected override Date getEndDate() {
			return endOfThisWeek;
		}
	}

	public class NextWeek extends DateRangeLiteral implements Literal, Comparable
	{
		public String toLiteral()
		{
			return 'NEXT_WEEK';
		}

		protected override Date getStartDate() {
			return startOfNextWeek;
		}

		protected override Date getEndDate() {
			return endOfNextWeek;
		}
	}

	public class LastMonth extends DateRangeLiteral implements Literal, Comparable
	{
		public String toLiteral()
		{
			return 'LAST_MONTH';
		}

		protected override Date getStartDate() {
			return startOfLastMonth;
		}

		protected override Date getEndDate() {
			return endOfLastMonth;
		}
	}

	public class ThisMonth extends DateRangeLiteral implements Literal, Comparable
	{
		public String toLiteral()
		{
			return 'THIS_MONTH';
		}

		protected override Date getStartDate() {
			return startOfThisMonth;
		}

		protected override Date getEndDate() {
			return endOfThisMonth;
		}
	}

	public class NextMonth extends DateRangeLiteral implements Literal, Comparable
	{
		public String toLiteral()
		{
			return 'NEXT_MONTH';
		}

		protected override Date getStartDate() {
			return startOfNextMonth;
		}

		protected override Date getEndDate() {
			return endOfNextMonth;
		}
	}

	public class Last90Days extends DateRangeLiteral implements Literal, Comparable
	{
		public String toLiteral()
		{
			return 'LAST_90_DAYS';
		}

		protected override Date getStartDate() {
			return today.addDays( -90 );
		}

		protected override Date getEndDate() {
			return today;
		}
	}

	public class Next90Days extends DateRangeLiteral implements Literal, Comparable
	{
		public String toLiteral()
		{
			return 'NEXT_90_DAYS';
		}

		protected override Date getStartDate() {
			return tomorrow;
		}

		protected override Date getEndDate() {
			return today.addDays( 90 ); // TODO: not true
		}
	}

	public class LastNDays extends NumericallyQualifiedLiteral implements Literal, Comparable
	{
		public LastNDays( Integer numberOfThings )
		{
			super( numberOfThings, 'LAST_N_DAYS' );

			Contract.requires( numberOfThings != null, 'LastNDays constructed with a null number of days' );
			Contract.requires( numberOfThings > 0 , 'LastNDays constructed with a negative or zero number of days' );
		}

		protected override Date getStartDate() {
			return today.addDays( numberOfThings * -1 );
		}

		protected override Date getEndDate() {
			return today;
		}
	}

	public class NextNDays extends NumericallyQualifiedLiteral implements Literal, Comparable
	{
		public NextNDays( Integer numberOfThings )
		{
			super( numberOfThings, 'NEXT_N_DAYS' );

			Contract.requires( numberOfThings != null, 'NextNDays constructed with a null number of days' );
			Contract.requires( numberOfThings > 0 , 'NextNDays constructed with a negative or zero number of days' );
		}

		protected override Date getStartDate() {
			return tomorrow;
		}

		protected override Date getEndDate() {
			return today.addDays( numberOfThings );
		}
	}

	public class LastNWeeks extends NumericallyQualifiedLiteral implements Literal, Comparable
	{
		public LastNWeeks( Integer numberOfThings )
		{
			super( numberOfThings, 'LAST_N_WEEKS' );

			Contract.requires( numberOfThings != null, 'LastNWeeks constructed with a null number of days' );
			Contract.requires( numberOfThings > 0 , 'LastNWeeks constructed with a negative or zero number of days' );
		}

		protected override Date getStartDate() {
			return startOfThisWeek.addDays( this.numberOfThings * -7 );
		}

		protected override Date getEndDate() {
			return endOfLastWeek;
		}
	}

	public class NextNWeeks extends NumericallyQualifiedLiteral implements Literal, Comparable
	{
		public NextNWeeks( Integer numberOfThings )
		{
			super( numberOfThings, 'NEXT_N_WEEKS' );
		}

		protected override Date getStartDate() {
			return startOfNextWeek;
		}

		protected override Date getEndDate() {
			return endOfNextWeek.addDays( this.numberOfThings * 7 );
		}
	}

	public class LastNMonths extends NumericallyQualifiedLiteral implements Literal, Comparable
	{
		public LastNMonths( Integer numberOfThings )
		{
			super( numberOfThings, 'LAST_N_MONTHS' );

			Contract.requires( numberOfThings != null, 'LastNMonths constructed with a null number of months' );
			Contract.requires( numberOfThings > 0 , 'LastNMonths constructed with a negative or zero number of months' );
		}

		protected override Date getStartDate() {
			return endOfLastMonth;
		}

		protected override Date getEndDate() {
			return startOfThisMonth.addMonths( numberOfThings * -1 );
		}
	}

	public class NextNMonths extends NumericallyQualifiedLiteral implements Literal, Comparable
	{
		public NextNMonths( Integer numberOfThings )
		{
			super( numberOfThings, 'NEXT_N_MONTHS' );

			Contract.requires( numberOfThings != null, 'NextNMonths constructed with a null number of months' );
			Contract.requires( numberOfThings > 0 , 'NextNMonths constructed with a negative or zero number of months' );

		}

		protected override Date getStartDate() {
			return startOfNextMonth;
		}

		protected override Date getEndDate() {
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

		public String toLiteral()
		{
			return this.baseLiteral + ':' + this.numberOfThings;
		}
	}

	private abstract class DateRangeLiteral implements ortoo_DateLiterals.Comparable
	{
		protected abstract Date getStartDate();
		protected abstract Date getEndDate();

		public Integer compare( Object otherValue )
		{
			return new DateRangeComparer().compare( (Date)otherValue, getStartDate(), getEndDate() );
		}
	}

	private class DateRangeComparer
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