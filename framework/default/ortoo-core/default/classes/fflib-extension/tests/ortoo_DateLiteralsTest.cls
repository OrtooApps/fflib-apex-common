
@isTest
private without sharing class  ortoo_DateLiteralsTest
{
    // TODO: start of and end of this, on the day that is already start or end

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

        ortoo_Asserts.assertBetweenInclusive( expectedEarliest, expectedLatest, got, 'endOfThisWeek, when referenced, is set to the end of this week, based on the configured "today" and the current user locale' );
    }

    @isTest
    private static void startOfLastWeek_whenReferenced_returnsStartOfLastWeekBasedOnTheConfiguredTodayAndLocale() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfLastWeek;
        Test.stopTest();

        Date expectedEarliest = Date.newInstance( 2024, 02, 18 );
        Date expectedLatest   = Date.newInstance( 2024, 02, 19 );

        ortoo_Asserts.assertBetweenInclusive( expectedEarliest, expectedLatest, got, 'startOfLastWeek, when referenced, is set to the start of last week, based on the configured "today" and the current user locale' );
    }

    @isTest
    private static void endOfLastWeek_whenReferenced_returnsEndOfLastWeekBasedOnTheConfiguredTodayAndLocale() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfLastWeek;
        Test.stopTest();

        Date expectedEarliest = Date.newInstance( 2024, 02, 24 );
        Date expectedLatest   = Date.newInstance( 2024, 02, 25 );

        ortoo_Asserts.assertBetweenInclusive( expectedEarliest, expectedLatest, got, 'endOfLastWeek, when referenced, is set to the end of last week, based on the configured "today" and the current user locale' );
    }

    @isTest
    private static void endOfLastWeek_whenReferenced_returnsTheDayBeforeTheStartOfThisWeek() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfLastWeek;
        Test.stopTest();

        System.assertEquals( ortoo_DateLiterals.startOfThisWeek.addDays( -1 ), got, 'endOfLastWeek, is set to the day before startOfThisWeek' );
    }


    @isTest
    private static void startOfNextWeek_whenReferenced_returnsStartOfNextWeekBasedOnTheConfiguredTodayAndLocale() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfNextWeek;
        Test.stopTest();

        Date expectedEarliest = Date.newInstance( 2024, 03, 03 );
        Date expectedLatest   = Date.newInstance( 2024, 03, 04 );

        ortoo_Asserts.assertBetweenInclusive( expectedEarliest, expectedLatest, got, 'startOfNextWeek, when referenced, is set to the start of next week, based on the configured "today" and the current user locale' );
    }

    @isTest
    private static void endOfNextWeek_whenReferenced_returnsEndOfNextWeekBasedOnTheConfiguredTodayAndLocale() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfNextWeek;
        Test.stopTest();

        Date expectedEarliest = Date.newInstance( 2024, 03, 09 );
        Date expectedLatest   = Date.newInstance( 2024, 03, 10 );

        ortoo_Asserts.assertBetweenInclusive( expectedEarliest, expectedLatest, got, 'endOfNextWeek, when referenced, is set to the end of next week, based on the configured "today" and the current user locale' );
    }

    @isTest
    private static void startOfNextWeek_whenReferenced_returnsTheDayAfterTheEndOfThisWeek() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfNextWeek;
        Test.stopTest();

        System.assertEquals( ortoo_DateLiterals.endOfThisWeek.addDays( 1 ), got, 'startOfNextWeek, is set to the day after endOfThisWeek' );
    }

    @isTest
    private static void startOfThisMonth_whenReferenced_returnsStartOfThisMonthBasedOnTheConfiguredToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfThisMonth;
        Test.stopTest();

        System.assertEquals( Date.newInstance( 2024, 02, 01 ), got, 'startOfThisMonth, is set to the start of this month, based on the configured today' );
    }

    @isTest
    private static void endOfThisMonth_whenReferenced_returnsEndOfThisMonthBasedOnTheConfiguredToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 10 );

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfThisMonth;
        Test.stopTest();

        System.assertEquals( Date.newInstance( 2024, 02, 29 ), got, 'endOfThisMonth, is set to the end of this month' );
    }

    @isTest
    private static void startOfLastMonth_whenReferenced_returnsStartOfLastMonthBasedOnTheConfiguredToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 03, 30 );

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfLastMonth;
        Test.stopTest();

        System.assertEquals( Date.newInstance( 2024, 02, 01 ), got, 'startOfLastMonth, is set to the start of last month' );
    }

    @isTest
    private static void endOfLastMonth_whenReferenced_returnsEndOfLastMonthBasedOnTheConfiguredToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 03, 30 );

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfLastMonth;
        Test.stopTest();

        System.assertEquals( Date.newInstance( 2024, 02, 29 ), got, 'endOfLastMonth, is set to the end of last month' );
    }

    @isTest
    private static void endOfLastMonth_whenReferenced_returnsTheDayBeforeTheStartOfThisMonth() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 03, 05 );

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfLastMonth;
        Test.stopTest();

        System.assertEquals( ortoo_DateLiterals.startOfThisMonth.addDays( -1 ), got, 'endOfLastMonth, is set to the day before startOfThisMonth' );
    }


    @isTest
    private static void startOfNextMonth_whenReferenced_returnsStartOfNextMonthBasedOnTheConfiguredToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 01, 30 );

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfNextMonth;
        Test.stopTest();

        System.assertEquals( Date.newInstance( 2024, 02, 01 ), got, 'endOfLastMonth, is set to the end of next month' );
    }

    @isTest
    private static void endOfNextMonth_whenReferenced_returnsEndOfNextMonthBasedOnTheConfiguredToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 01, 30 );

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfNextMonth;
        Test.stopTest();

        System.assertEquals( Date.newInstance( 2024, 02, 29 ), got, 'endOfLastMonth, is set to the end of next month' );
    }

    @isTest
    private static void startOfNextMonth_whenReferenced_returnsTheDayAfterTheEndOfThisMonth() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfNextMonth;
        Test.stopTest();

        System.assertEquals( ortoo_DateLiterals.endOfThisMonth.addDays( 1 ), got, 'startOfNextMonth, is set to the day after endOfThisMonth' );
    }
}