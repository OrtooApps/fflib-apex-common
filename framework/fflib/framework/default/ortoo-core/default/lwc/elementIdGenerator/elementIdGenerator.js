const generateId = function( suffix ) {
    return suffix ? this.ortooElemIdPrefix + '-' + suffix : this.ortooElemIdPrefix;;
}

const configureElementIdGenerator = function( bindTo ) {

    if ( ! bindTo.ortooIdConfiguration ) {
        throw 'configureGenerator called against an object with no ortooIdConfiguration member variable - this should contain the mapping of properties to their suffixes: ' + bindTo;
    }

    if ( ! bindTo.ortooElemIdPrefix ) {
        throw new 'configureGenerator called against an object with no ortooElemIdPrefix member variable - this should contain the Id prefix' + bindTo;
    }

    for ( const idName in bindTo.ortooIdConfiguration ) {

        Object.defineProperty( bindTo, idName, {
            get: function() {
                return generateId.call( bindTo, bindTo.ortooIdConfiguration[ idName ] );
            }
        });
    }
}

export default configureElementIdGenerator;