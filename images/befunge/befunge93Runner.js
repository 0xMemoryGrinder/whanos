const befunge = require('befunge93')
const fs = require('fs')
let Befunge = new befunge();

let toRead = null

if (process.argv.length === 2)
    toRead = process.stdin.fd;
else if (process.argv.length === 3)
    toRead = process.argv[2];
else
    process.exit(1);

Befunge.onInput = (message) => {
	process.stdout.write(message);
	return fs.readFileSync(process.stdin.fd).toString();
};

Befunge.onOutput = (output) => {
    process.stdout.write(output);
};

Befunge.run(fs.readFileSync(toRead).toString());