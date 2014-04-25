/**
 * Parses mixed type values into booleans. This is the same function as filter_var in PHP using boolean validation
 * @param  {Mixed}        value 
 * @param  {Boolean}      nullOnFailure = false
 * @return {Boolean|Null}
 */
var parse = function(value){
	switch(value){
		case true:
		case 'true':
		case 1:
		case '1':
		case 'on':
		case 'yes':
			value = true;
			break;
		case false:
		case 'false':
		case 0:
		case '0':
		case 'off':
		case 'no':
			value = false;
			break;
		default:
            value = "string is not in cases"
			break;
	}
	return value;
};
