public with sharing class LimitsServiceImpl implements ILimitsService {

    private static final Integer DML_ROWS_PERCENTAGE_LIMIT = 90;

    public static Integer getAvailableDmlRecordsHeadroom( ortoo_SobjectUnitOfWork uow  )
	{
		Contract.requires( uow != null, 'getAvailableDmlRecordsHeadroom called with a null uow' );

		Integer headroom = 0;

		try
		{
			Integer futureDmlRows  = uow.getNumberOfPendingDmlRows();
			Integer currentDmlRows = Limits.getDmlRows();

			Integer dmlRowsLimit   = getEffectiveDmlRowsLimit();

			headroom = dmlRowsLimit - ( currentDmlRows + futureDmlRows );
		}
		catch ( Exception e )
		{
			ServiceUtils.logAndRethrow( e );
		}

		return headroom;
    }

    private static Integer getEffectiveDmlRowsLimit()
	{
		return Integer.valueOf( Limits.getLimitDmlRows() * DML_ROWS_PERCENTAGE_LIMIT / 100 );
    }
}