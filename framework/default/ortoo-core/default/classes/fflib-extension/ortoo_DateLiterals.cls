/**
 * Class that provides a list of inner classes that can be used as targets for comparisons in ortoo_Criteria.
 *
 * Specifically, the classes represent the different Date Literals that SOQL supports
 *
 * @group fflib Extension
 */
public inherited sharing class ortoo_DateLiterals
{
	public class NonEvaluatableException extends ortoo_Exception {}

	// TODO: consider 'compare' - how do we do that?
	private interface Literal extends fflib_Criteria.Literal {}
	private interface Evaluatable extends fflib_Criteria.Evaluatable {}

	public class Today implements Literal, Evaluatable
	{
		public String toLiteral()
		{
			return 'TODAY';
		}

		public Date toValue()
		{
			return Date.today();
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
			return Date.today().addDays(-1);
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
			return Date.today().addDays(+1);
		}
	}

	public class LastWeek extends NonEvaluatableLiteral implements Literal
	{
		public String toLiteral()
		{
			return 'LAST_WEEK';
		}
	}

	public class ThisWeek implements Literal
	{
		public String toLiteral()
		{
			return 'THIS_WEEK';
		}
	}

	public class NextWeek implements Literal
	{
		public String toLiteral()
		{
			return 'NEXT_WEEK';
		}
	}

	public class LastMonth implements Literal
	{
		public String toLiteral()
		{
			return 'LAST_MONTH';
		}
	}

	public class ThisMonth implements Literal
	{
		public String toLiteral()
		{
			return 'THIS_MONTH';
		}
	}

	public class NextMonth implements Literal
	{
		public String toLiteral()
		{
			return 'NEXT_MONTH';
		}
	}

	public class Last90Days implements Literal
	{
		public String toLiteral()
		{
			return 'LAST_90_DAYS';
		}
	}

	public class Next90Days implements Literal
	{
		public String toLiteral()
		{
			return 'NEXT_90_DAYS';
		}
	}

	public class LastNDays extends NumericallyQualifiedLiteral
	{
		public LastNDays( Integer numberOfThings )
		{
			super( numberOfThings, 'LAST_N_DAYS' );
		}
	}

	public class NextNDays extends NumericallyQualifiedLiteral
	{
		public NextNDays( Integer numberOfThings )
		{
			super( numberOfThings, 'NEXT_N_DAYS' );
		}
	}

	public class LastNWeeks extends NumericallyQualifiedLiteral
	{
		public LastNWeeks( Integer numberOfThings )
		{
			super( numberOfThings, 'LAST_N_WEEKS' );
		}
	}

	public class NextNWeeks extends NumericallyQualifiedLiteral
	{
		public NextNWeeks( Integer numberOfThings )
		{
			super( numberOfThings, 'NEXT_N_WEEKS' );
		}
	}

	public class LastNMonths extends NumericallyQualifiedLiteral
	{
		public LastNMonths( Integer numberOfThings )
		{
			super( numberOfThings, 'LAST_N_MONTHS' );
		}
	}

	public class NextNMonths extends NumericallyQualifiedLiteral
	{
		public NextNMonths( Integer numberOfThings )
		{
			super( numberOfThings, 'NEXT_N_MONTHS' );
		}
	}

	private abstract class NumericallyQualifiedLiteral implements Literal
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

	private abstract class NonEvaluatableLiteral implements Evaluatable
	{
		public Object toValue()
		{
			throw new NonEvaluatableException( 'Literals of type ' + ObjectUtils.getClassName( this ) + ' cannot be evaluated in-memory' )
						.setErrorCode( FrameworkErrorCodes.NON_EVALUATABLE_CRITERIA )
						.addContext( 'ClassName', ObjectUtils.getClassName( this ) );
		}
	}
}