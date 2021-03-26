const Sequelize = require("sequelize");
const sequelize = require('../database/connection');

module.exports = sequelize.define("Container", {

    id: {
        type: Sequelize.INTEGER(11),
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
    },
    description: Sequelize.STRING(150),

    foodType: {
        type: Sequelize.ENUM('cats', 'dogs', 'catsanddogs', 'water'),
    },

    numberOfAnimals: Sequelize.TINYINT(10),


    latitude: Sequelize.DECIMAL(9, 7),
    longitude: Sequelize.DECIMAL(9, 7),


    lastFeedingDate: {
        type: Sequelize.DATE
    }


})

// location https://stackoverflow.com/questions/44675630/geospatial-distance-calculator-using-sequelize-mysql
// sequelize migration:create --name create_containers_table
// after writing attributes, call the upper command and add these features to the up function of the migration
// sequelize db:migrate
// sequelize db:migrate:undo:all

// heroku run sequelize db:migrate --env production --app streetanimals 