public interface IChildRecordFinder
{
    List<Sobject> findRecords( Set<Id> parentIds );
}