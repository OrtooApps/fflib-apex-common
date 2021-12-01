public with sharing class LimitsService {

    public static Integer getAvailableDmlRecordsHeadroom( ortoo_SobjectUnitOfWork uow  ) {
        return service().getAvailableDmlRecordsHeadroom( uow );
    }

    private static ILimitsService service() {
        return (ILimitsService)Application.SERVICE.newInstance( ILimitsService.class );
	}

    public class AbortDueToLimitsReachedException extends Exception {

        List<Sobject> recordsSaved;
        List<Sobject> recordsDiscarded;

        public AbortDueToLimitsReachedException setRecordsSaved( List<Sobject> recordsSaved ) {
            this.recordsSaved = recordsSaved;
            return this;
        }

        public List<Sobject> getRecordsSaved() {
            return recordsSaved;
        }

        public AbortDueToLimitsReachedException setRecordsDiscarded( List<Sobject> recordsDiscarded ) {
            this.recordsDiscarded = recordsDiscarded;
            return this;
        }

        public List<Sobject> getRecordsDiscarded() {
            return recordsDiscarded;
        }
    }
}