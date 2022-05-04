
@isTest
private without sharing class UnsecureDmlTest
{
    @isTest
    private static void constructor_whenCalled_willCreateAnIdmlImplementation() // NOPMD: Test method name format
    {
        Object unsecureDml = new UnsecureDml();

        System.assert( unsecureDml instanceOf fflib_SobjectUnitOfWork.Idml, 'constructor, when called, will create an Idml implementation' );
        System.assert( unsecureDml instanceOf fflib_SobjectUnitOfWork.SimpleDml, 'constructor, when called, will create a SimpleDml implementation' );
    }
}