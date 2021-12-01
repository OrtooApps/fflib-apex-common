@isTest
private without sharing class NullDomainTest
{
	@isTest
	private static void constructorClass_buildsANullDomain() // NOPMD: Test method name format
	{
		NullDomain nullDomain = (NullDomain)new NullDomain.Constructor().construct( new List<Contact>{ new Contact() } );
		System.assertNotEquals( null, nullDomain );
	}
}