
@isTest
private without sharing class  ortoo_DateLiteralsTest
{
    @isTest
    private static void today_returnsTodaysDate() // NOPMD: Test method name format
    {
        Date got = ortoo_DateLiterals.today;
        System.assertEquals( Date.today(), got, 'today is set to today' );
    }

    @isTest
    private static void yesterday_returnYesterdayBasedOnTheConfiguredToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 03, 01 );

        Test.startTest();
            Date got = ortoo_DateLiterals.yesterday;
        Test.stopTest();

        System.assertEquals( Date.newInstance( 2024, 02, 29 ), got, 'yesterday is set to yesterday, based on the configured "today"' );
    }

    @isTest
    private static void tomorrow_returnTomorrowBasedOnTheConfiguredToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.tomorrow;
        Test.stopTest();

        System.assertEquals( Date.newInstance( 2024, 03, 01 ), got, 'tomorrow is set to tomorrow, based on the configured "today"' );
    }

    @isTest
    private static void startOfThisWeek_returnsStartOfThisWeekBasedOnTheConfiguredTodayAndLocale() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfThisWeek;
        Test.stopTest();

        Date expectedEarliest = Date.newInstance( 2024, 02, 25 );
        Date expectedLatest   = Date.newInstance( 2024, 02, 26 );

        ortoo_Asserts.assertBetweenInclusive( expectedEarliest, expectedLatest, got, 'startOfThisWeek is set to the start of this week, based on the configured "today" and the current user locale' );
    }

    @isTest
    private static void startOfThisWeek_whenItIsTheStartOfTheWeek_returnsToday() // NOPMD: Test method name format
    {
        Date startOfThisWeek =  ortoo_DateLiterals.startOfThisWeek;
        ortoo_DateLiterals.today = startOfThisWeek;

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfThisWeek;
        Test.stopTest();

        System.assertEquals( startOfThisWeek, got, 'startOfThisWeek, when today is the start of the week, will return today' );
    }

    @isTest
    private static void endOfThisWeek_returnsEndOfThisWeekBasedOnTheConfiguredTodayAndLocale() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfThisWeek;
        Test.stopTest();

        Date expectedEarliest = Date.newInstance( 2024, 03, 02 );
        Date expectedLatest   = Date.newInstance( 2024, 03, 03 );

        ortoo_Asserts.assertBetweenInclusive( expectedEarliest, expectedLatest, got, 'endOfThisWeek is set to the end of this week, based on the configured "today" and the current user locale' );
    }

    @isTest
    private static void endOfThisWeek_whenItIsTheStartOfTheWeek_returnsToday() // NOPMD: Test method name format
    {
        Date endOfThisWeek =  ortoo_DateLiterals.endOfThisWeek;
        ortoo_DateLiterals.today = endOfThisWeek;

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfThisWeek;
        Test.stopTest();

        System.assertEquals( endOfThisWeek, got, 'endOfThisWeek, when today is the end of the week, will return today' );
    }

    @isTest
    private static void startOfLastWeek_returnsStartOfLastWeekBasedOnTheConfiguredTodayAndLocale() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfLastWeek;
        Test.stopTest();

        Date expectedEarliest = Date.newInstance( 2024, 02, 18 );
        Date expectedLatest   = Date.newInstance( 2024, 02, 19 );

        ortoo_Asserts.assertBetweenInclusive( expectedEarliest, expectedLatest, got, 'startOfLastWeek is set to the start of last week, based on the configured "today" and the current user locale' );
    }

    @isTest
    private static void endOfLastWeek_returnsEndOfLastWeekBasedOnTheConfiguredTodayAndLocale() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfLastWeek;
        Test.stopTest();

        Date expectedEarliest = Date.newInstance( 2024, 02, 24 );
        Date expectedLatest   = Date.newInstance( 2024, 02, 25 );

        ortoo_Asserts.assertBetweenInclusive( expectedEarliest, expectedLatest, got, 'endOfLastWeek is set to the end of last week, based on the configured "today" and the current user locale' );
    }

    @isTest
    private static void endOfLastWeek_returnsTheDayBeforeTheStartOfThisWeek() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfLastWeek;
        Test.stopTest();

        System.assertEquals( ortoo_DateLiterals.startOfThisWeek.addDays( -1 ), got, 'endOfLastWeek, is set to the day before startOfThisWeek' );
    }


    @isTest
    private static void startOfNextWeek_returnsStartOfNextWeekBasedOnTheConfiguredTodayAndLocale() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfNextWeek;
        Test.stopTest();

        Date expectedEarliest = Date.newInstance( 2024, 03, 03 );
        Date expectedLatest   = Date.newInstance( 2024, 03, 04 );

        ortoo_Asserts.assertBetweenInclusive( expectedEarliest, expectedLatest, got, 'startOfNextWeek is set to the start of next week, based on the configured "today" and the current user locale' );
    }

    @isTest
    private static void endOfNextWeek_returnsEndOfNextWeekBasedOnTheConfiguredTodayAndLocale() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfNextWeek;
        Test.stopTest();

        Date expectedEarliest = Date.newInstance( 2024, 03, 09 );
        Date expectedLatest   = Date.newInstance( 2024, 03, 10 );

        ortoo_Asserts.assertBetweenInclusive( expectedEarliest, expectedLatest, got, 'endOfNextWeek is set to the end of next week, based on the configured "today" and the current user locale' );
    }

    @isTest
    private static void startOfNextWeek_returnsTheDayAfterTheEndOfThisWeek() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfNextWeek;
        Test.stopTest();

        System.assertEquals( ortoo_DateLiterals.endOfThisWeek.addDays( 1 ), got, 'startOfNextWeek, is set to the day after endOfThisWeek' );
    }

    @isTest
    private static void startOfThisMonth_returnsStartOfThisMonthBasedOnTheConfiguredToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfThisMonth;
        Test.stopTest();

        System.assertEquals( Date.newInstance( 2024, 02, 01 ), got, 'startOfThisMonth, is set to the start of this month, based on the configured today' );
    }

    @isTest
    private static void startOfThisMonth_whenItIsTheStartOfTheMonth_returnsToday() // NOPMD: Test method name format
    {
        Date startOfThisMonth =  ortoo_DateLiterals.startOfThisMonth;
        ortoo_DateLiterals.today = startOfThisMonth;

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfThisMonth;
        Test.stopTest();

        System.assertEquals( startOfThisMonth, got, 'startOfThisMonth, when today is the start of the month, will return today' );
    }

    @isTest
    private static void endOfThisMonth_returnsEndOfThisMonthBasedOnTheConfiguredToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 10 );

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfThisMonth;
        Test.stopTest();

        System.assertEquals( Date.newInstance( 2024, 02, 29 ), got, 'endOfThisMonth, is set to the end of this month' );
    }

    @isTest
    private static void endOfThisMonth_whenItIsTheStartOfTheMonth_returnsToday() // NOPMD: Test method name format
    {
        Date endOfThisMonth =  ortoo_DateLiterals.endOfThisMonth;
        ortoo_DateLiterals.today = endOfThisMonth;

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfThisMonth;
        Test.stopTest();

        System.assertEquals( endOfThisMonth, got, 'endOfThisMonth, when today is the end of the month, will return today' );
    }

    @isTest
    private static void startOfLastMonth_returnsStartOfLastMonthBasedOnTheConfiguredToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 03, 30 );

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfLastMonth;
        Test.stopTest();

        System.assertEquals( Date.newInstance( 2024, 02, 01 ), got, 'startOfLastMonth, is set to the start of last month' );
    }

    @isTest
    private static void endOfLastMonth_returnsEndOfLastMonthBasedOnTheConfiguredToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 03, 30 );

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfLastMonth;
        Test.stopTest();

        System.assertEquals( Date.newInstance( 2024, 02, 29 ), got, 'endOfLastMonth, is set to the end of last month' );
    }

    @isTest
    private static void endOfLastMonth_returnsTheDayBeforeTheStartOfThisMonth() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 03, 05 );

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfLastMonth;
        Test.stopTest();

        System.assertEquals( ortoo_DateLiterals.startOfThisMonth.addDays( -1 ), got, 'endOfLastMonth, is set to the day before startOfThisMonth' );
    }


    @isTest
    private static void startOfNextMonth_returnsStartOfNextMonthBasedOnTheConfiguredToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 01, 30 );

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfNextMonth;
        Test.stopTest();

        System.assertEquals( Date.newInstance( 2024, 02, 01 ), got, 'endOfLastMonth, is set to the end of next month' );
    }

    @isTest
    private static void endOfNextMonth_returnsEndOfNextMonthBasedOnTheConfiguredToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 01, 30 );

        Test.startTest();
            Date got = ortoo_DateLiterals.endOfNextMonth;
        Test.stopTest();

        System.assertEquals( Date.newInstance( 2024, 02, 29 ), got, 'endOfLastMonth, is set to the end of next month' );
    }

    @isTest
    private static void startOfNextMonth_returnsTheDayAfterTheEndOfThisMonth() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        Test.startTest();
            Date got = ortoo_DateLiterals.startOfNextMonth;
        Test.stopTest();

        System.assertEquals( ortoo_DateLiterals.endOfThisMonth.addDays( 1 ), got, 'startOfNextMonth, is set to the day after endOfThisMonth' );
    }

    @isTest
    private static void Today_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.Today().toLiteral();
        System.assertEquals( 'TODAY', got, 'Today.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void Today_getStartDateGetEndDate_returnToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.Today();

        System.assertEquals( Date.newInstance( 2024, 02, 29 ), literal.getStartDate(), 'Today_getStartDate, will return today' );
        System.assertEquals( Date.newInstance( 2024, 02, 29 ), literal.getEndDate(), 'Today_getEndDate, will return today' );
    }

    @isTest
    private static void Yesterday_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.Yesterday().toLiteral();
        System.assertEquals( 'YESTERDAY', got, 'Yesterday.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void Yesterday_getStartDateGetEndDate_returnToday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.Yesterday();

        System.assertEquals( Date.newInstance( 2024, 02, 28 ), literal.getStartDate(), 'Yesterday_getStartDate, will return yesterday' );
        System.assertEquals( Date.newInstance( 2024, 02, 28 ), literal.getEndDate(), 'Yesterday_getEndDate, will return yesterday' );
    }
}