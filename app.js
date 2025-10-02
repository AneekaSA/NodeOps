require('dotenv').config();
const express = require('express');
const app = express();

const PORT = process.env.PORT || 3000;
const SECRET_MESSAGE = process.env.SECRET_MESSAGE;
const USERNAME = process.env.USERNAME;
const PASSWORD = process.env.PASSWORD;

// Root route
app.get('/', (req, res) => {
  res.send('Hello, world!');
});

// Basic Auth middleware
function basicAuth(req, res, next) {
  const auth = req.headers['authorization'];
  if (!auth) {
    res.set('WWW-Authenticate', 'Basic realm="Restricted Area"');
    return res.status(401).send('Authentication required.');
  }

  const [scheme, encoded] = auth.split(' ');
  if (scheme !== 'Basic' || !encoded) {
    return res.status(400).send('Bad Authorization header.');
  }

  const decoded = Buffer.from(encoded, 'base64').toString();
  const [user, pass] = decoded.split(':');

  if (user === USERNAME && pass === PASSWORD) {
    return next();
  } else {
    res.set('WWW-Authenticate', 'Basic realm="Restricted Area"');
    return res.status(401).send('Invalid credentials.');
  }
}

// Secret route
app.get('/secret', basicAuth, (req, res) => {
  res.send(SECRET_MESSAGE);
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});

