@isTest
public with sharing class AbstractRedirectToLwcTabPageCtrlrTest
{
	@isTest
	private static void hasRecords_whenRecordsAreSelected_returnsTrue() // NOPMD: Test method name format
	{
		List<Contact> context = new List<Contact>{
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ),
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ),
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) )
		};

		ApexPages.StandardSetController standardSetController = new ApexPages.StandardSetController( context );
		standardSetController.setSelected( context );
		TestableRedirectToLwcTabPageController controller = new TestableRedirectToLwcTabPageController( standardSetController );

		Test.startTest();
			Boolean got = controller.hasRecords;
		Test.stopTest();

		System.assertEquals( true, got, 'hasRecords, when records are selected, will return true' );
	}

	@isTest
	private static void hasRecords_whenNoRecordsAreSelected_returnsFalse() // NOPMD: Test method name format
	{
		List<Contact> context = new List<Contact>{
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ),
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ),
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) )
		};

		ApexPages.StandardSetController standardSetController = new ApexPages.StandardSetController( context );
		standardSetController.setSelected( new List<Contact>() );
		TestableRedirectToLwcTabPageController controller = new TestableRedirectToLwcTabPageController( standardSetController );

		Test.startTest();
			Boolean got = controller.hasRecords;
		Test.stopTest();

		System.assertEquals( false, got, 'hasRecords, when no records are selected, will return false' );
	}

	@isTest
	private static void redirectToTabPage_whenCalled_returnsAPageReferenceToTheTabPage() // NOPMD: Test method name format
	{
		List<Contact> context = new List<Contact>{
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ),
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ),
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) )
		};

		String expectedRecordIds = JSON.serialize( new List<Id>{ context[0].Id, context[1].Id, context[2].Id } );

		ApexPages.StandardSetController standardSetController = new ApexPages.StandardSetController( context );
		standardSetController.setSelected( context );
		TestableRedirectToLwcTabPageController controller = new TestableRedirectToLwcTabPageController( standardSetController );

		Test.startTest();
			PageReference got = controller.redirectToTabPage();
		Test.stopTest();

		Amoss_Asserts.assertContains( 'tabpagename', got.getUrl(), 'redirectToTabPage, when called, will retrun a PageReference with the URL pointing to the defined tab page' );

		Map<String,String> parameters = got.getParameters();
		System.assertEquals( 'testscenario', parameters.get( 'c__returnUrl' ), 'redirectToTabPage, when called, will return a PageReference with a return url parameter' );
		System.assertNotEquals( null, parameters.get( 'c__epoch' ), 'redirectToTabPage, when called, will return a PageReference with an epoch parameter' );
		System.assertEquals( expectedRecordIds, parameters.get( 'c__recordIds' ), 'redirectToTabPage, when called, will return a PageReference with a record ids parameter that contains a serialised list of the selected record ids' );
	}

	@isTest
	private static void redirectToTabPage_whenNoRecords_returnsAPageReferenceToTheTabPage() // NOPMD: Test method name format
	{
		List<Contact> context = new List<Contact>{
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ),
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) ),
			new Contact( Id = TestIdUtils.generateId( Contact.sobjectType ) )
		};

		String expectedRecordIds = JSON.serialize( new List<Id>() );

		ApexPages.StandardSetController standardSetController = new ApexPages.StandardSetController( context );
		standardSetController.setSelected( new List<Contact>() );
		TestableRedirectToLwcTabPageController controller = new TestableRedirectToLwcTabPageController( standardSetController );

		Test.startTest();
			PageReference got = controller.redirectToTabPage();
		Test.stopTest();

		Amoss_Asserts.assertContains( 'tabpagename', got.getUrl(), 'redirectToTabPage, when no records are selected, will retrun a PageReference with the URL pointing to the defined tab page' );

		Map<String,String> parameters = got.getParameters();
		System.assertEquals( 'testscenario', parameters.get( 'c__returnUrl' ), 'redirectToTabPage, when no records are selected, will return a PageReference with a return url parameter' );
		System.assertNotEquals( null, parameters.get( 'c__epoch' ), 'redirectToTabPage, when no records are selected, will return a PageReference with an epoch parameter' );
		System.assertEquals( expectedRecordIds, parameters.get( 'c__recordIds' ), 'redirectToTabPage, when no records are selected, will return a PageReference with a record ids parameter that contains a serialised empty list' );
	}

	class TestableRedirectToLwcTabPageController extends AbstractRedirectToLwcTabPageController
	{
		public TestableRedirectToLwcTabPageController( ApexPages.StandardSetController controller )
		{
			super( controller );
			this.tabPageName = 'tabpagename';
		}
	}
}
