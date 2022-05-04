@isTest
private class sfab_FabricatedSObjectPersistTest {

	@isTest
	private static void persist_whenMultipleLevelsOfObjectsParentToChild_willSave() // NOPMD: Test method name format
	{
		new sfab_FabricatedSobject( Account.class )
			.set( Account.Name, 'New Account' )
			.add( 'Contacts', new sfab_FabricatedSobject( Contact.class )
									.set( Contact.LastName, 'last' )
									.add( 'Notes', new sfab_FabricatedSobject( Note.class )
											.set( Note.Title, 'the title 1' )
											.set( Note.Body, 'the body' )
										)
				)
			.add( 'Contacts', new sfab_FabricatedSobject( Contact.class )
									.set( Contact.LastName, 'last2' )
									.add( 'Notes', new sfab_FabricatedSobject( Note.class )
											.set( Note.Title, 'the title 2' )
											.set( Note.Body, 'the body' )
										)
				);

		Test.startTest();
			ortoo_FabricatedSobjectRegister.persist();
		Test.stopTest();

		List<Account> accounts = getAccounts();
		System.assertEquals( 1, accounts.size(), 'persist, when called, will create the fabricated sobjects that have been instantiated - checking accounts' );
		System.assertEquals( 'New Account', accounts[0].Name, 'persist, when called, will create the fabricated sobjects that have been instantiated - checking account field' );

		List<Contact> contacts = getContacts();
		System.assertEquals( 2, contacts.size(), 'persist, when called, will create the fabricated sobjects that have been instantiated - checking contacts' );

		System.assertEquals( accounts[0].Id, contacts[0].AccountId, 'persist, when called, will create the fabricated sobjects that have been instantiated - checking contacts relationship field 1' );
		System.assertEquals( 'last', contacts[0].LastName, 'persist, when called, will create the fabricated sobjects that have been instantiated - checking contacts field 1' );

		System.assertEquals( accounts[0].Id, contacts[1].AccountId, 'persist, when called, will create the fabricated sobjects that have been instantiated - checking contacts relationship field 2' );
		System.assertEquals( 'last2', contacts[1].LastName, 'persist, when called, will create the fabricated sobjects that have been instantiated - checking contacts field 2' );

		List<Note> notes = getNotes();
		System.assertEquals( 2, notes.size(), 'persist, when called, will create the fabricated sobjects that have been instantiated - checking notes' );

		System.assertEquals( contacts[0].Id, notes[0].ParentId, 'persist, when called, will create the fabricated sobjects that have been instantiated - checking notes relationship field 1' );
		System.assertEquals( 'the title 1', notes[0].title, 'persist, when called, will create the fabricated sobjects that have been instantiated - checking notes field 1' );

		System.assertEquals( contacts[1].Id, notes[1].ParentId, 'persist, when called, will create the fabricated sobjects that have been instantiated - checking notes relationship field 2' );
		System.assertEquals( 'the title 2', notes[1].title, 'persist, when called, will create the fabricated sobjects that have been instantiated - checking notes field 2' );
	}

	@isTest
	private static void persist_whenMultipleLevelsOfObjectsChildToParent_willSave() // NOPMD: Test method name format
	{
		new sfab_FabricatedSobject( Contact.class )
			.set( 'Account', new sfab_FabricatedSobject( Account.class )
									.set( Account.Name, 'New Account' )
				)
			.set( Contact.LastName, 'last' );

		Test.startTest();
			ortoo_FabricatedSobjectRegister.persist();
		Test.stopTest();

		List<Account> accounts = getAccounts();
		System.assertEquals( 1, accounts.size(), 'persist, when called, will create the fabricated sobjects that have been instantiated child to parent - checking accounts' );
		System.assertEquals( 'New Account', accounts[0].Name, 'persist, when called, will create the fabricated sobjects that have been instantiated child to parent - checking account field' );

		List<Contact> contacts = getContacts();
		System.assertEquals( 1, contacts.size(), 'persist, when called, will create the fabricated sobjects that have been instantiated child to parent - checking contacts' );
		System.assertEquals( accounts[0].Id, contacts[0].AccountId, 'persist, when called, will create the fabricated sobjects that have been instantiated child to parent - checking contacts relationship field 1' );
		System.assertEquals( 'last', contacts[0].LastName, 'persist, when called, will create the fabricated sobjects that have been instantiated child to parent - checking contacts field 1' );
	}

	@isTest
	private static void persist_whenMultipleLevelsOfObjectsImpliedParent_willSave() // NOPMD: Test method name format
	{
		new sfab_FabricatedSobject( Contact.class )
			.set( 'Account.Name', 'New Account' )
			.set( Contact.LastName, 'last' );

		Test.startTest();
			ortoo_FabricatedSobjectRegister.persist();
		Test.stopTest();

		List<Account> accounts = getAccounts();
		System.assertEquals( 1, accounts.size(), 'persist, when called, will create the fabricated sobjects that have been instantiated with an implied parent - checking accounts' );
		System.assertEquals( 'New Account', accounts[0].Name, 'persist, when called, will create the fabricated sobjects that have been instantiated with an implied parent - checking account field' );

		List<Contact> contacts = getContacts();
		System.assertEquals( 1, contacts.size(), 'persist, when called, will create the fabricated sobjects that have been instantiated with an implied parent - checking contacts' );
		System.assertEquals( accounts[0].Id, contacts[0].AccountId, 'persist, when called, will create the fabricated sobjects that have been instantiated with an implied parent - checking contacts relationship field 1' );
		System.assertEquals( 'last', contacts[0].LastName, 'persist, when called, will create the fabricated sobjects that have been instantiated with an implied parent - checking contacts field 1' );
	}

	@isTest
	private static void persist_whenMultipleLevelsOfObjectsImpliedParentWithChild_willSave() // NOPMD: Test method name format
	{
		new sfab_FabricatedSobject( Contact.class )
			.set( 'Account.Name', 'New Account' )
			.set( Contact.LastName, 'last' )
			.add( 'Account.Contacts', new sfab_FabricatedSobject( Contact.class )
											.set( Contact.LastName, 'last implied parent child' )
				);

		Test.startTest();
			ortoo_FabricatedSobjectRegister.persist();
		Test.stopTest();

		List<Account> accounts = getAccounts();
		System.assertEquals( 1, accounts.size(), 'persist, when called, will create the fabricated sobjects that have been instantiated with an implied parent with child - checking accounts' );
		System.assertEquals( 'New Account', accounts[0].Name, 'persist, when called, will create the fabricated sobjects that have been instantiated with an implied parent with child - checking account field' );

		List<Contact> contacts = getContacts();
		System.assertEquals( 2, contacts.size(), 'persist, when called, will create the fabricated sobjects that have been instantiated with an implied parent with child - checking contacts' );

		System.assertEquals( accounts[0].Id, contacts[0].AccountId, 'persist, when called, will create the fabricated sobjects that have been instantiated with an implied parent with child - checking contacts relationship field 1' );
		System.assertEquals( 'last', contacts[0].LastName, 'persist, when called, will create the fabricated sobjects that have been instantiated with an implied parent with child - checking contacts field 1' );

		System.assertEquals( accounts[0].Id, contacts[1].AccountId, 'persist, when called, will create the fabricated sobjects that have been instantiated with an implied parent with child - checking contacts relationship field 2' );
		System.assertEquals( 'last implied parent child', contacts[1].LastName, 'persist, when called, will create the fabricated sobjects that have been instantiated with an implied parent with child - checking contacts field 2' );
	}

	@isTest
	private static void persist_whenAnUnsettableFieldIsSet_willSave() // NOPMD: Test method name format
	{
		new sfab_FabricatedSobject( Contact.class )
			.set( Contact.LastName, 'last' )
			.set( Contact.Name, 'unsettable' );

		Test.startTest();
			ortoo_FabricatedSobjectRegister.persist();
		Test.stopTest();

		List<Contact> contacts = getContacts();
		System.assertEquals( 1, contacts.size(), 'persist, when an unsettable field has been set, will still save - checking contacts' );

		System.assertEquals( 'last', contacts[0].LastName, 'persist, when an unsettable field has been set, will still save - checking contacts field 1' );
		System.assertEquals( 'last', contacts[0].Name, 'persist, when an unsettable field has been set, will still save - checking contacts field 2' );
	}
	@isTest
	private static void persist_whenIdIsSet_willSave() // NOPMD: Test method name format
	{
		new sfab_FabricatedSobject( Contact.class )
			.set( Contact.LastName, 'last' )
			.set( Contact.Id, 'a fake Id' );

		Test.startTest();
			ortoo_FabricatedSobjectRegister.persist();
		Test.stopTest();

		List<Contact> contacts = getContacts();
		System.assertEquals( 1, contacts.size(), 'persist, when an Id has been set, will still save, but without the specified Id - checking contacts' );

		System.assertEquals( 'last', contacts[0].LastName, 'persist, when an Id has been set, will still save, but without the specified Id - checking contacts field 1' );
		System.assertNotEquals( 'a fake Id', contacts[0].Id, 'persist, when an Id has been set, will still save, but without the specified Id - checking contacts Id field' );
	}

	private static List<Account> getAccounts()
	{
		return [SELECT Name FROM Account ORDER BY Id];
	}

	private static List<Contact> getContacts()
	{
		return [SELECT AccountId, LastName, Name FROM Contact ORDER BY LastName];
	}

	private static List<Note> getNotes()
	{
		return[ SELECT ParentId, Title FROM Note ORDER BY Title];
	}
}