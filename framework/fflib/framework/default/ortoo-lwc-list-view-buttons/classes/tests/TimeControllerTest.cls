@isTest
public with sharing class TimeControllerTest
{
    @isTest
    private static void getEpochTime_whenCalled_returnsEpochInSeconds() // NOPMD: Test method name format
    {
        Test.startTest();
            Long got = TimeController.getEpochTime();
        Test.stopTest();

        Integer e9  = Integer.valueOf( got / 1000000000 ); // if you divide the epoch seconds by 10^9, you should get 1 if the date is later than 9th September 2001
        Integer e10 = Integer.valueOf( ( got / 1000000000 ) / 10 ); // if you divide the epoch seconds by 10^10, you should get < 1 if the date is earlier than 20th November 2286
                                                                    // need to do it in two steps becayse 10^10 is not a valid integer

        System.assert( e9 > 0, 'getEpochTime, when called, will return the epoch time in seconds - being greater than 10^9' );
        System.assertEquals( 0, e10, 'getEpochTime, when called, will return the epoch time in seconds - being less than 10^10' );
    }
}
