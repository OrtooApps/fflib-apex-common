@isTest
private without sharing class NullDomainTest
{
	private final static List<Contact> LIST_OF_SOBJECTS = new List<Contact>{ new Contact() };

	@isTest
	private static void constructorClass_buildsANullDomain() // NOPMD: Test method name format
	{
		NullDomain nullDomain = (NullDomain)new NullDomain.Constructor().construct( LIST_OF_SOBJECTS );
		System.assertNotEquals( null, nullDomain );
	}

	@isTest
	private static void onBeforeInsert_whenCalled_willBeRecordedAsAMethodCalled() // NOPMD: Test method name format
	{
		new NullDomain( LIST_OF_SOBJECTS ).onBeforeInsert();
		System.assertEquals( new Set<String>{ 'onBeforeInsert' }, NullDomain.methodsCalled, 'onBeforeInsert, when called, will be recorded as a method called' );
	}

	@isTest
	private static void onBeforeUpdate_whenCalled_willBeRecordedAsAMethodCalled() // NOPMD: Test method name format
	{
		new NullDomain( LIST_OF_SOBJECTS ).onBeforeUpdate( null );
		System.assertEquals( new Set<String>{ 'onBeforeUpdate' }, NullDomain.methodsCalled, 'onBeforeUpdate, when called, will be recorded as a method called' );
	}

	@isTest
	private static void onBeforeDelete_whenCalled_willBeRecordedAsAMethodCalled() // NOPMD: Test method name format
	{
		new NullDomain( LIST_OF_SOBJECTS ).onBeforeDelete();
		System.assertEquals( new Set<String>{ 'onBeforeDelete' }, NullDomain.methodsCalled, 'onBeforeDelete, when called, will be recorded as a method called' );
	}

	@isTest
	private static void onAfterInsert_whenCalled_willBeRecordedAsAMethodCalled() // NOPMD: Test method name format
	{
		new NullDomain( LIST_OF_SOBJECTS ).onAfterInsert();
		System.assertEquals( new Set<String>{ 'onAfterInsert' }, NullDomain.methodsCalled, 'onAfterInsert, when called, will be recorded as a method called' );
	}

	@isTest
	private static void onAfterUpdate_whenCalled_willBeRecordedAsAMethodCalled() // NOPMD: Test method name format
	{
		new NullDomain( LIST_OF_SOBJECTS ).onAfterUpdate( null );
		System.assertEquals( new Set<String>{ 'onAfterUpdate' }, NullDomain.methodsCalled, 'onAfterUpdate, when called, will be recorded as a method called' );
	}

	@isTest
	private static void onAfterDelete_whenCalled_willBeRecordedAsAMethodCalled() // NOPMD: Test method name format
	{
		new NullDomain( LIST_OF_SOBJECTS ).onAfterDelete();
		System.assertEquals( new Set<String>{ 'onAfterDelete' }, NullDomain.methodsCalled, 'onAfterDelete, when called, will be recorded as a method called' );
	}

	@isTest
	private static void onAfterUndelete_whenCalled_willBeRecordedAsAMethodCalled() // NOPMD: Test method name format
	{
		new NullDomain( LIST_OF_SOBJECTS ).onAfterUndelete();
		System.assertEquals( new Set<String>{ 'onAfterUndelete' }, NullDomain.methodsCalled, 'onAfterUndelete, when called, will be recorded as a method called' );
	}

	@isTest
	private static void whenMultiplMethodsCalled_willAllBeRecordedAsAMethodCalled() // NOPMD: Test method name format
	{
		NullDomain domain = new NullDomain( LIST_OF_SOBJECTS );
		domain.onAfterUndelete();
		domain.onBeforeInsert();
		domain.onAfterInsert();
		System.assertEquals( new Set<String>{ 'onAfterUndelete', 'onBeforeInsert', 'onAfterInsert' }, NullDomain.methodsCalled, 'when multiple methods called, will all be recorded as a method called' );
	}
}