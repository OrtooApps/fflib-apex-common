@isTest
private without sharing class ExceptionsTest
{
	@isTest
	private static void domainExceptionSetErrorCode_whenCalled_willAddAPrefixToTheCode() // NOPMD: Test method name format
	{
		Exceptions.DomainException e = new Exceptions.DomainException();
		e.setErrorCode( '123' );

		System.assertEquals( 'DOM-123', e.getErrorCode(), 'domainExceptionSetErrorCode, when called, will add a prefix to the code' );
	}

	@isTest
	private static void serviceExceptionSetErrorCode_whenCalled_willAddAPrefixToTheCode() // NOPMD: Test method name format
	{
		Exceptions.ServiceException e = new Exceptions.ServiceException();
		e.setErrorCode( '123' );

		System.assertEquals( 'SRV-123', e.getErrorCode(), 'serviceExceptionSetErrorCode, when called, will add a prefix to the code' );
	}

	@isTest
	private static void selectorExceptionSetErrorCode_whenCalled_willAddAPrefixToTheCode() // NOPMD: Test method name format
	{
		Exceptions.SelectorException e = new Exceptions.SelectorException();
		e.setErrorCode( '123' );

		System.assertEquals( 'SEL-123', e.getErrorCode(), 'SelectorException.setErrorCode, when called, will add a prefix to the code' );
	}

	@isTest
	private static void developerExceptionSetErrorCode_whenCalled_willAddAPrefixToTheCode() // NOPMD: Test method name format
	{
		Exceptions.DeveloperException e = new Exceptions.DeveloperException();
		e.setErrorCode( '123' );

		System.assertEquals( 'DEV-123', e.getErrorCode(), 'DeveloperException.setErrorCode, when called, will add a prefix to the code' );
	}

	@isTest
	private static void configurationExceptionSetErrorCode_whenCalled_willAddAPrefixToTheCode() // NOPMD: Test method name format
	{
		Exceptions.ConfigurationException e = new Exceptions.ConfigurationException();
		e.setErrorCode( '123' );

		System.assertEquals( 'CONF-123', e.getErrorCode(), 'ConfigurationException.setErrorCode, when called, will add a prefix to the code' );
	}
}