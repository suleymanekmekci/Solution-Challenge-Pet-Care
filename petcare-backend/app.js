const express = require('express');
const app = express();
const user = require('./routes/user');
const container = require('./routes/container');
const animal = require('./routes/animal');

app.use(express.json());
//DB Connection
require('./src/database/connection')

app.use('/api/user', user);
app.use('/api/container', container);
app.use('/api/animal', animal)

//require('./src/bootstrap')()


const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log('Listening ' + PORT));