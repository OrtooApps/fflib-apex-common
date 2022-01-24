/**
 * Represents a definition of a window of data (though not the data itself), defined by the properties:
 *      * offset - the offset from the start of a result set that window starts from, zero indexed
 *      * length - the maximum size of the window in number of records that a results set windown contains
 *
 * In the case of Offset, zero is represented by a null, implying that zero is the same as 'this property is not set.'
 */
public inherited sharing class SearchWindow
{
    public Integer offset {get; private set;}
    public Integer length {get; private set;}

    /**
	 * Configures the current instance with the given properties, defining the window
	 *
	 * @param	Map<String,Object> The properties of the window.  Should contain 'offset' and 'length' properties as Integers
	 */
    public SearchWindow configure( Map<String,Object> properties )
    {
        Contract.requires( properties != null, 'configure called with a null properties' );

        Integer offset = deriveInteger( properties, 'offset' );
        Contract.requires( offset >= 0 || offset == null, 'configure called with a negative offset' );

        Integer length = deriveInteger( properties, 'length' );
        Contract.requires( length > 0 || length == null, 'configure called with a negative or zero length' );

        this.offset = offset > 0 ? offset : null;
        this.length = length;

        return this;
    }

    private Integer deriveInteger( Map<String,Object> properties, String propertyName )
    {
        Object rawValue = properties.get( propertyName );

        Integer returnValue;

        if ( ! String.isBlank( String.valueOf( rawValue ) ) )
        {
            try
            {
                returnValue = Integer.valueOf( rawValue );
            }
            catch( Exception e )
            {
                Contract.requires( false, 'configure called with '+propertyName+' that could not be cast into an Integer' );
            }
        }
        return returnValue;
    }
}