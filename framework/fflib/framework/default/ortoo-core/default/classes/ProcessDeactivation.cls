/**
 * Provides the ability to check if given things are deactivated via configuration
 */
public class ProcessDeactivation
{
    @testVisible
    private static Process_Deactivation__c processDeactivationSetting
    {
        get
        {
            if ( processDeactivationSetting == null )
            {
                processDeactivationSetting = Process_Deactivation__c.getInstance();
            }
            return processDeactivationSetting;
        }
        set;
    }

    /**
     * Clears the currently cached setting so it is reloaded on the next reference
     */
    public static void clearSetting()
    {
        processDeactivationSetting = null;
    }

    /**
     * States if the given trigger's domain type is deactivated.
     *
     * @param   Type    The domain type to check (e.g. Actions.class)
     * @return  Boolean States if the domain type is active, when considered for triggers
     */
    public static Boolean triggersDeactivated( Type domainType )
    {
        Contract.requires( domainType != null, 'triggersDeactivated called with a null domainType' );

        if ( processDeactivationSetting.Disable_Triggers__c )
        {
            return true;
        }

        List<String> deactivatedDomains = StringUtils.convertDelimitedStringToList( processDeactivationSetting.Disable_Triggers_By_Domain__c );
        return ( deactivatedDomains.contains( domainType.toString() ) );
    }
}