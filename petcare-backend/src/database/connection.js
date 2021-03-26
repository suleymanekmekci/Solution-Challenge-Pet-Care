const Sequelize = require('sequelize');

//mysql://b938a034b04099:0dc9fab8@eu-cdbr-west-03.cleardb.net/heroku_5a48f8d88face8f?reconnect=true
const sequelize = new Sequelize("heroku_5a48f8d88face8f", "b938a034b04099", '0dc9fab8', {
    host: 'eu-cdbr-west-03.cleardb.net',
    dialect: "mysql",
    define: {
        timestamps: false
    },
});

module.exports = sequelize;

global.sequelize = sequelize;