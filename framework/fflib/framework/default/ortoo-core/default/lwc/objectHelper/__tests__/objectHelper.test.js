import ObjectHelper from 'c/objectHelper';

describe( 'generateId', () => {

    it( 'returns an alpha numeric string that is 10 characters long', () => {

		const got = ObjectHelper.generateId();
        expect( got ).toHaveLength( 10 );
    });

    it( 'does not return the same string when called multiple times', () => {

		let previousIds = [];
		for ( let i=0; i<100; i++ ) {
			const got = ObjectHelper.generateId();
			expect( previousIds ).not.toContain( got );
			previousIds.push( got );
		}
    });
});