/**
 * Base Visualforce Controller extension that provides the required controller methods for building
 * a Visualforce page that:
 *      Can be used on a List Button
 *      Redirects the screen to a Lightning Tab
 *      Passes a serialised version of the record Ids
 *      Includes a timestamp (Epoch time in seconds) for the generation of the URL
 *      Includes a return URL
 */
public virtual with sharing class AbstractRedirectToLwcTabPageController
{
	protected String tabPageName;

	/**
	 * States if the controller currently has records assigned to it
	 */
	public Boolean hasRecords
	{
		get
		{
			return recordIds?.size() > 0;
		}
	}

	/**
	 * States the URL that the page should return to on completion or cancellation
	 */
	public String returnUrl
	{
		get
		{
			if ( Test.isRunningTest() ) {
				return 'testscenario'; // Don't know how to set up the page so that ApexPages.Action does not throw a null pointer exception
			}
			String returnUrl = new ApexPages.Action('{!cancel}').invoke().getUrl();
			//
			// There's an issue that means the cancel URL sometimes forgets where it's come from.
			// In that situation, it reverts to the SObject's 'home'
			// When this happens we want to load the most recently loaded list for the current SObject type instead.
			//
			if ( returnUrl.endsWith( '/home' ) )
			{
				returnUrl = new ApexPages.Action('{!list}').invoke().getUrl();
			}
			return returnUrl;
		}
	}

	/**
	 * Is a representation of the current recordIds in a serialised form
	 */
	private String serializedRecordIds
	{
		get
		{
			return JSON.serialize( recordIds );
		}
	}

	/**
	 * The current Epoch Time in seconds, as a String
	 */
	private String epochTime
	{
		get
		{
			return String.valueOf( DateTimeUtils.getEpochTime() );
		}
	}

	/**
	 * The currently recordIds that are currently assigned to this controller
	 */
	private List<Id> recordIds;

	/**
	 * Standard controller extension constructor, utilising the standard set controller.
	 * Retrieves the currently selected records from the controller.
	 *
	 * @param	ApexPages.StandardSetController	The set controller that contains the context for this controller
	 */
	public AbstractRedirectToLwcTabPageController( ApexPages.StandardSetController controller )
	{
		recordIds = new List<Id>();
		List<Sobject> selectedSobjects = controller.getSelected();

		for( Sobject thisSobject : selectedSobjects )
		{
			recordIds.add( (Id)thisSobject.get( 'Id' ) );
		}
	}

	/**
	 * Controller method that performs the re-direction of the browser page to the specified Tab Page.
	 *
	 * Includes parameters for defining the return Url, the Epoch time (for checking the timely usage of the link)
	 * and the record Ids that are to be processed.
	 */
	public PageReference redirectToTabPage()
	{
		Contract.requires( this.tabPageName != null, 'redirectToTabPage called with a null this.tabPageName.  Ensure that the controller extension ('+ObjectUtils.getClassName( this )+') sets "this.tabPageName" in the constructor' );

		PageReference appPage = new PageReference( '/lightning/n/' + this.tabPageName );
		appPage.getParameters().put( 'c__returnUrl', returnUrl );
		appPage.getParameters().put( 'c__epoch', epochTime );
		appPage.getParameters().put( 'c__recordIds', serializedRecordIds );
		appPage.setRedirect( true );
		return appPage;
	}
}