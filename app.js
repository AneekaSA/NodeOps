require('dotenv').config();
const express = require('express');
const app = express();

const USERNAME = process.env.USERNAME;
const PASSWORD = process.env.PASSWORD;
const SECRET_MESSAGE = process.env.SECRET_MESSAGE || 'No secret set';

app.get('/', (req, res) => res.send('Hello, world!'));

app.get('/secret', (req, res) => {
  const auth = req.headers['authorization'];
  if (!auth || !auth.startsWith('Basic ')) {
    res.set('WWW-Authenticate', 'Basic realm="Restricted"');
    return res.status(401).send('Authentication required.');
  }

  const credentials = Buffer.from(auth.split(' ')[1], 'base64').toString();
  const [user, pass] = credentials.split(':');

  if (user === USERNAME && pass === PASSWORD) {
    return res.send(SECRET_MESSAGE);
  } else {
    res.set('WWW-Authenticate', 'Basic realm="Restricted"');
    return res.status(401).send('Invalid credentials.');
  }
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Listening on ${port}`));
