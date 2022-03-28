const generateRowId = function() {
	const length = 10;
	const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
	const charactersLength = characters.length;

	let result = '';
	for ( let i = 0; i < length; i++ ) {
		result += characters.charAt( Math.floor ( Math.random() * charactersLength ) );
	}

	return result;
}

export default {
    generateRowId : generateRowId
};