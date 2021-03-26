'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable("containers", {

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
  },

  down: async (queryInterface, Sequelize) => {
    /**
     * Add reverting commands here.
     *
     * Example:
     * await queryInterface.dropTable('users');
     */
  }
};
