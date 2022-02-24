
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
    private static void Today_getStartDateGetEndDate_returnsToday() // NOPMD: Test method name format
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
    private static void Yesterday_getStartDateGetEndDate_returnsYesterday() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.Yesterday();

        System.assertEquals( Date.newInstance( 2024, 02, 28 ), literal.getStartDate(), 'Yesterday_getStartDate, will return yesterday' );
        System.assertEquals( Date.newInstance( 2024, 02, 28 ), literal.getEndDate(), 'Yesterday_getEndDate, will return yesterday' );
    }

    @isTest
    private static void Tomorrow_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.Tomorrow().toLiteral();
        System.assertEquals( 'TOMORROW', got, 'Tomorrow.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void Tomorrow_getStartDateGetEndDate_returnsTomorrow() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.Tomorrow();

        System.assertEquals( Date.newInstance( 2024, 03, 01 ), literal.getStartDate(), 'Tomorrow_getStartDate, will return tomorrow' );
        System.assertEquals( Date.newInstance( 2024, 03, 01 ), literal.getEndDate(), 'Tomorrow_getEndDate, will return tomorrow' );
    }

    @isTest
    private static void LastWeek_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.LastWeek().toLiteral();
        System.assertEquals( 'LAST_WEEK', got, 'LastWeek.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void LastWeek_getStartDateGetEndDate_returnsRange() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.LastWeek();

        System.assertEquals( ortoo_DateLiterals.startOfLastWeek, literal.getStartDate(), 'LastWeek_getStartDate, will return the start of last week' );
        System.assertEquals( ortoo_DateLiterals.endOfLastWeek, literal.getEndDate(), 'LastWeek_getEndDate, will return the end of last week' );
    }

    @isTest
    private static void ThisWeek_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.ThisWeek().toLiteral();
        System.assertEquals( 'THIS_WEEK', got, 'ThisWeek.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void ThisWeek_getStartDateGetEndDate_returnsRange() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.ThisWeek();

        System.assertEquals( ortoo_DateLiterals.startOfThisWeek, literal.getStartDate(), 'ThisWeek_getStartDate, will return the start of last week' );
        System.assertEquals( ortoo_DateLiterals.endOfThisWeek, literal.getEndDate(), 'ThisWeek_getEndDate, will return the end of last week' );
    }

    @isTest
    private static void NextWeek_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.NextWeek().toLiteral();
        System.assertEquals( 'NEXT_WEEK', got, 'NextWeek.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void NextWeek_getStartDateGetEndDate_returnsRange() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.NextWeek();

        System.assertEquals( ortoo_DateLiterals.startOfNextWeek, literal.getStartDate(), 'NextWeek_getStartDate, will return the start of last week' );
        System.assertEquals( ortoo_DateLiterals.endOfNextWeek, literal.getEndDate(), 'NextWeek_getEndDate, will return the end of last week' );
    }

    @isTest
    private static void LastMonth_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.LastMonth().toLiteral();
        System.assertEquals( 'LAST_MONTH', got, 'LastMonth.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void LastMonth_getStartDateGetEndDate_returnsRange() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.LastMonth();

        System.assertEquals( Date.newInstance( 2024, 01, 01 ), literal.getStartDate(), 'LastMonth_getStartDate, will return the start of last month' );
        System.assertEquals( Date.newInstance( 2024, 01, 31 ), literal.getEndDate(), 'LastMonth_getEndDate, will return the end of last month' );
    }

    @isTest
    private static void ThisMonth_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.ThisMonth().toLiteral();
        System.assertEquals( 'THIS_MONTH', got, 'ThisMonth.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void ThisMonth_getStartDateGetEndDate_returnsRange() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.ThisMonth();

        System.assertEquals( Date.newInstance( 2024, 02, 01 ), literal.getStartDate(), 'ThisMonth_getStartDate, will return the start of last month' );
        System.assertEquals( Date.newInstance( 2024, 02, 29 ), literal.getEndDate(), 'ThisMonth_getEndDate, will return the end of last month' );
    }

    @isTest
    private static void NextMonth_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.NextMonth().toLiteral();
        System.assertEquals( 'NEXT_MONTH', got, 'NextMonth.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void NextMonth_getStartDateGetEndDate_returnsRange() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.NextMonth();

        System.assertEquals( Date.newInstance( 2024, 03, 01 ), literal.getStartDate(), 'NextMonth_getStartDate, will return the start of last month' );
        System.assertEquals( Date.newInstance( 2024, 03, 31 ), literal.getEndDate(), 'NextMonth_getEndDate, will return the end of last month' );
    }

    @isTest
    private static void Last90Days_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.Last90Days().toLiteral();
        System.assertEquals( 'LAST_90_DAYS', got, 'Last90Days.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void Last90Days_getStartDateGetEndDate_returnsRange() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.Last90Days();

        System.assertEquals( Date.newInstance( 2023, 12, 01 ), literal.getStartDate(), 'Last90Days_getStartDate, will return 90 days ago' );
        System.assertEquals( Date.newInstance( 2024, 02, 29 ), literal.getEndDate(), 'Last90Days_getEndDate, will return today' );
    }

    @isTest
    private static void Next90Days_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.Next90Days().toLiteral();
        System.assertEquals( 'NEXT_90_DAYS', got, 'Next90Days.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void Next90Days_getStartDateGetEndDate_returnsRange() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.Next90Days();

        System.assertEquals( Date.newInstance( 2024, 03, 01 ), literal.getStartDate(), 'Next90Days_getStartDate, will return tomorrow' );
        System.assertEquals( Date.newInstance( 2024, 05, 29 ), literal.getEndDate(), 'Next90Days_getEndDate, will return 90 days in the future' );
    }

    @isTest
    private static void LastNDays_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.LastNDays( 5 ).toLiteral();
        System.assertEquals( 'LAST_N_DAYS:5', got, 'LastNDays.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void LastNDays_getStartDateGetEndDate_returnsRange() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.LastNDays( 5 );

        System.assertEquals( Date.newInstance( 2024, 02, 24 ), literal.getStartDate(), 'LastNDays_getStartDate, will return n days ago' );
        System.assertEquals( Date.newInstance( 2024, 02, 29 ), literal.getEndDate(), 'LastNDays_getEndDate, will return today' );
    }

    @isTest
    private static void NextNDays_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.NextNDays( 5 ).toLiteral();
        System.assertEquals( 'NEXT_N_DAYS:5', got, 'NextNDays.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void NextNDays_getStartDateGetEndDate_returnsRange() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.NextNDays( 5 );

        System.assertEquals( Date.newInstance( 2024, 03, 01 ), literal.getStartDate(), 'NextNDays_getStartDate, will return tomorrow' );
        System.assertEquals( Date.newInstance( 2024, 03, 05 ), literal.getEndDate(), 'NextNDays_getEndDate, will return n days in the future' );
    }

    @isTest
    private static void LastNWeeks_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.LastNWeeks( 2 ).toLiteral();
        System.assertEquals( 'LAST_N_WEEKS:2', got, 'LastNWeeks.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void LastNWeeks_getStartDateGetEndDate_returnsRange() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.LastNWeeks( 2 );

        System.assertEquals( ortoo_DateLiterals.startOfLastWeek.addDays( -7 ), literal.getStartDate(), 'LastNWeeks_getStartDate, will return the start of last week minus the specified number of weeks' );
        System.assertEquals( ortoo_DateLiterals.endOfLastWeek, literal.getEndDate(), 'LastNWeeks_getEndDate, will return the end of last week' );
    }

    @isTest
    private static void NextNWeeks_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.NextNWeeks( 2 ).toLiteral();
        System.assertEquals( 'NEXT_N_WEEKS:2', got, 'NextNWeeks.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void NextNWeeks_getStartDateGetEndDate_returnsRange() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.NextNWeeks( 2 );

        System.assertEquals( ortoo_DateLiterals.startOfNextWeek, literal.getStartDate(), 'NextNWeeks_getStartDate, will return the first day of next week' );
        System.assertEquals( ortoo_DateLiterals.endOfNextWeek.addDays( 14 ), literal.getEndDate(), 'NextNWeeks_getEndDate, will the end of next week plus the specified number of weeks' );
    }

    @isTest
    private static void LastNMonths_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.LastNMonths( 5 ).toLiteral();
        System.assertEquals( 'LAST_N_MONTHS:5', got, 'LastNMonths.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void LastNMonths_getStartDateGetEndDate_returnsRange() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 29 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.LastNMonths( 5 );

        System.assertEquals( Date.newInstance( 2023, 09, 01 ), literal.getStartDate(), 'LastNMonths_getStartDate, will return the first day of the month, n months ago' );
        System.assertEquals( Date.newInstance( 2024, 01, 31 ), literal.getEndDate(), 'LastNMonths_getEndDate, will return the end of last month' );
    }

    @isTest
    private static void NextNMonths_toLiteral_returnsTheSoqlDateLiteral() // NOPMD: Test method name format
    {
        String got = new ortoo_DateLiterals.NextNMonths( 5 ).toLiteral();
        System.assertEquals( 'NEXT_N_MONTHS:5', got, 'NextNMonths.toLiteral, will return the SOQL Date Literal' );
    }

    @isTest
    private static void NextNMonths_getStartDateGetEndDate_returnsRange() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 23 );

        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.NextNMonths( 5 );

        System.assertEquals( Date.newInstance( 2024, 03, 01 ), literal.getStartDate(), 'NextNMonths_getStartDate, will return the start of next month' );
        System.assertEquals( Date.newInstance( 2024, 07, 31 ), literal.getEndDate(), 'NextNMonths_getEndDate, will return the end of the month, n months in the future' );
    }

    @isTest
    private static void compare_whenGivenADateBeforeTheRange_returnsMinus1() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 23 );
        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.LastNDays( 1 );

        Test.startTest();
            Integer got = literal.compare( Date.newInstance( 2024, 02, 21 ) );
        Test.stopTest();

        System.assertEquals( -1, got, 'compare, when given a date before the range, will return minus 1' );
    }

    @isTest
    private static void compare_whenGivenADateInsideTheRange_returnsZero() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 23 );
        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.LastNDays( 1 );

        Test.startTest();
            Integer got = literal.compare( Date.newInstance( 2024, 02, 23 ) );
        Test.stopTest();

        System.assertEquals( 0, got, 'compare, when given a date inside the range, will return zero' );
    }

    @isTest
    private static void compare_whenGivenADateAfterTheRange_returns1() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 23 );
        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.LastNDays( 1 );

        Test.startTest();
            Integer got = literal.compare( Date.newInstance( 2024, 02, 24 ) );
        Test.stopTest();

        System.assertEquals( 1, got, 'compare, when given a date after the range, will return one' );
    }

    @isTest
    private static void compare_whenGivenADateTimeJustBeforeTheRange_returnsMinus1() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 23 );
        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.LastNDays( 1 );

        Test.startTest();
            Integer got = literal.compare( DateTime.newInstance( 2024, 02, 21, 23, 59, 59 ) );
        Test.stopTest();

        System.assertEquals( -1, got, 'compare, when given a datetime just before the range, will return minus 1' );
    }

    @isTest
    private static void compare_whenGivenADateTimeJustAtStartOfTheRange_returnsZero() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 23 );
        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.LastNDays( 1 );

        Test.startTest();
            Integer got = literal.compare( DateTime.newInstance( 2024, 02, 22, 0, 0, 1 ) );
        Test.stopTest();

        System.assertEquals( 0, got, 'compare, when given a datetime just at the start of the range, will return 0' );
    }

    @isTest
    private static void compare_whenGivenADateTimeInTheMiddleOfTheRange_returnsZero() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 23 );
        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.LastNDays( 1 );

        Test.startTest();
            Integer got = literal.compare( DateTime.newInstance( 2024, 02, 22, 12, 0, 0 ) );
        Test.stopTest();

        System.assertEquals( 0, got, 'compare, when given a datetime in the middle of the range, will return 0' );
    }

    @isTest
    private static void compare_whenGivenADateTimeJustAtEndOfTheRange_returnsZero() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 23 );
        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.LastNDays( 1 );

        Test.startTest();
            Integer got = literal.compare( DateTime.newInstance( 2024, 02, 23, 23, 59, 59 ) );
        Test.stopTest();

        System.assertEquals( 0, got, 'compare, when given a datetime just at the end of the range, will return 0' );
    }

    @isTest
    private static void compare_whenGivenADateTimeJustAfterTheRange_returns1() // NOPMD: Test method name format
    {
        ortoo_DateLiterals.today = Date.newInstance( 2024, 02, 23 );
        ortoo_DateLiterals.DateRangeLiteral literal = new ortoo_DateLiterals.LastNDays( 1 );

        Test.startTest();
            Integer got = literal.compare( DateTime.newInstance( 2024, 02, 24, 0, 0, 0 ) );
        Test.stopTest();

        System.assertEquals( 1, got, 'compare, when given a datetime just after the range, will return 1' );
    }
}