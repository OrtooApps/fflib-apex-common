@isTest
private without sharing class SobjectValidatorTest
{
    @isTest
    private static void getSobject_whenSobjectWasSet_willReturnTheSobject() // NOPMD: Test method name format
    {
        Sobject obj = new Contact();
        SobjectValidator validator = new TestableSobjectValidator();

        Test.startTest();
            validator.setSobject( obj );
            Sobject returnedObj = validator.getSobject();
        Test.stopTest();

        System.assertEquals( obj, returnedObj, 'getSobject, when sobject was set, will return the sobject' );
    }

    @isTest
    private static void setSobject_whenPassedNull_willThrowAnException() // NOPMD: Test method name format
    {
        SobjectValidator validator = new TestableSobjectValidator();

        Test.startTest();
            String exceptionMessage;
            try
            {
                validator.setSobject( null );
            }
            catch ( Contract.RequiresException e )
            {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        ortoo_Asserts.assertContains( 'setSobject called with a null sobjectToValidate', exceptionMessage, 'setSobject, when passed null, will throw an exception' );
    }

    private without sharing class TestableSobjectValidator extends SobjectValidator
    {
        public void validate() {} // NOPMD: empty implementation as not needed for the test
    }
}