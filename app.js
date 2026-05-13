const http = require('http');

const version = process.env.APP_VERSION || 'v1';

http.createServer((req, res) => {
    res.end(`Version: ${version}\nHello, Devops!\n`);
}).listen(3000, () => console.log('Running ${version}'));
