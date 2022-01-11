/**
 * Will bind a function that will allow the bound LWC to 'findElement' passing an Ortoo Element Id.
 *
 * Should be bound in the connectedCallback of the LWC.  E.g.
 *
 * connectedCallback() {
 *      configureFindElement( this );
 * }
 *
 * @param bindTo The LWC to bind this function to
 */
const configureFindElement = bindTo => {
    bindTo.findElement = function( ortooElemId ) {
                                return this.template.querySelector( `[data-ortoo-elem-id="${ortooElemId}"]` );
                            }.bind( bindTo );
};

export default configureFindElement;