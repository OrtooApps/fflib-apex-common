/**
 * Is an extension of the provided fflib version of SobjectSelector.
 *
 * Reverses the default secruity setup for FLS, being that it defaults to enforcing FLS.
 *
 * @group fflib Extension
 */
public abstract inherited sharing class ortoo_SobjectSelector extends fflib_SobjectSelector // NOPMD: specified a mini-namespace to differentiate from fflib versions
{
    public ortoo_SobjectSelector()
    {
        super();
        enforceFLS();
    }

    /**
     * Configure this instance to ignore FLS when selecting data.
     *
     * @return  fflib_SObjectSelector   Itself, allowing for a fluent interface.
     */
    public fflib_SObjectSelector ignoreFls()
    {
        m_enforceFLS = false;
        return this;
    }
}