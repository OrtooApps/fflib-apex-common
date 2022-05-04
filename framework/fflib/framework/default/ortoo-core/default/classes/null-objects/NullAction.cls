/**
 * Provides the ability to perform no action in a Process Builder built process
 */
public inherited sharing class NullAction
{
    /**
    * Allows a Process Builder or Flow action to 'Do Nothing'
    */
    @InvocableMethod( label='Do Nothing' description='Does nothing' )
    public static void doNothing() // NOPMD: Method is intentionally blank, so it does nothing
	{
    }
}