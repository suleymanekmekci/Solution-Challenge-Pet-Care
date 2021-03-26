const Sequelize = require("sequelize");

const sequelize = require('../database/connection');

module.exports = sequelize.define("User", {
    id: {
        allowNull: false,
        primaryKey: true,
        type: Sequelize.STRING(255)
    },

    firstName: Sequelize.STRING(255),
    lastName: Sequelize.STRING(255),
    email: Sequelize.STRING(255),
    createdAt: {
        type: Sequelize.DATE,
        defaultValue: Sequelize.NOW,
        allowNull: false
    }

})