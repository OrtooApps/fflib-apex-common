@isTest
private without sharing class  ortoo_DateLiteralsTest
{
    @isTest
    private static void today_whenReferenced_returnsTodaysDate() // NOPMD: Test method name format
    {
        Date got = ortoo_DateLiterals.today;
        System.assertEquals( Date.today(), got, 'today, when referenced, is set to today' );
    }

    @isTest
    private static void yesterday_whenReferenced_returnYesterdayBasedOnTheConfiguredToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 03, 01 );

        Test.startTest();
            Date got = ortoo_DateLiterals.yesterday;
        Test.stopTest();

        System.assertEquals( Date.newInstance( 2024, 02, 29 ), got, 'yesterday, when referenced, is set to yesterday, based on the configured "today"' );
    }

    @isTest
    private static void tomorrow_whenReferenced_returnTomorrowBasedOnTheConfiguredToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.tomorrow;
        Test.stopTest();

        System.assertEquals( Date.newInstance( 2024, 03, 01 ), got, 'tomorrow, when referenced, is set to tomorrow, based on the configured "today"' );
    }

    @isTest
    private static void startOfThisWeek_whenReferenced_returnsStartOfThisWeekBasedOnTheConfiguredTodayAndLocale() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfThisWeek;
        Test.stopTest();

        Date expectedEarliest = Date.newInstance( 2024, 02, 25 );
        Date expectedLatest   = Date.newInstance( 2024, 02, 26 );

        ortoo_Asserts.assertBetweenInclusive( expectedEarliest, expectedLatest, got, 'startOfThisWeek, when referenced, is set to the start of this week, based on the configured "today" and the current user locale' );
    }

    @isTest
    private static void endOfThisWeek_whenReferenced_returnsEndOfThisWeekBasedOnTheConfiguredTodayAndLocale() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfThisWeek;
        Test.stopTest();

        Date expectedEarliest = Date.newInstance( 2024, 03, 02 );
        Date expectedLatest   = Date.newInstance( 2024, 03, 03 );

        ortoo_Asserts.assertBetweenInclusive( expectedEarliest, expectedLatest, got, 'endOfThisWeek, when referenced, is set to the stendart of this week, based on the configured "today" and the current user locale' );
    }




}