public with sharing class LimitsServiceImpl implements ILimitsService {

    private static final Integer DML_ROWS_PERCENTAGE_LIMIT = 90;

    public static Integer getAvailableDmlRecordsHeadroom( ortoo_SobjectUnitOfWork uow  ) {

        Integer futureDmlRows  = uow.getNumberOfPendingDmlRows();
        Integer currentDmlRows = Limits.getDmlRows();

        Integer dmlRowsLimit   = getEffectiveDmlRowsLimit();

        return dmlRowsLimit - ( currentDmlRows + futureDmlRows );
    }

    private static Integer getEffectiveDmlRowsLimit() {
        return Integer.valueOf( Limits.getLimitDmlRows() * DML_ROWS_PERCENTAGE_LIMIT / 100 );
    }
}