// Are executed inside a loop, so should NEVER include any SOQL
// Potentially we will want to re-shape this so that the actions are performed en-masse.
public interface IDmlRecordAction
{
    IDmlRecordAction actUpon( DmlRecord recordToActUpon );
}