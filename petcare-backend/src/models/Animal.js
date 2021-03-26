const Sequelize = require("sequelize");
const sequelize = require('../database/connection');

module.exports = sequelize.define("Animal", {

    id: {
        type: Sequelize.INTEGER(11),
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
    },
    description: Sequelize.STRING(150),

    animalBreed: Sequelize.TINYINT(10),


    latitude: Sequelize.DECIMAL(9, 7),
    longitude: Sequelize.DECIMAL(9, 7),


    photoUrl: Sequelize.TEXT(),


})
