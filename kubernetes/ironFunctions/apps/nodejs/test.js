fs = require('fs');
//Just to verify that we can add packages
request = require('request');

function sortNumber(a,b) {
    return a - b;
}

obj = JSON.parse(fs.readFileSync('/dev/stdin').toString())
for (i = 0; i < obj.Loops; i++) {
    obj.Result = obj.Items.concat().sort(sortNumber)
}
obj.Type = 'nodejs'

console.log(JSON.stringify(obj));
