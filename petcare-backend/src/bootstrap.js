const { DECIMAL } = require('sequelize');
const sequelize = require('./database/connection');
const Sequelize = require("sequelize");
const Op = Sequelize.Op;
module.exports = async () => {
    const User = require('./models/User')
    const Container = require('./models/Container')


    // let container = ''

    // try {
    //     let latitude = 32.9970857
    //     let longitude = 30.0078805

    //     let date = Date.now()
    //     date += (3 * 60 * 60 * 1000);
    //     data = {
    //         description: "test 3",
    //         foodType: "dogs",
    //         numberOfAnimals: 6,
    //         latitude,
    //         longitude,
    //         lastFeedingDate: date,
    //     }

    //     container = await Container.create(data)
    // } catch (err) {
    //     console.log(err);
    // }

    // let containers = await Container.findAll({ where: { description: "test 1" } })
    // console.log(containers);


    //const users = await User.findAll({ where: { id: "herty" } });
    //const container = await Container.findAll({ where: { id: 1 } })

    let lat = 36.9970857
    let lng = 35.0078805


    // let nears = await Container.findAll({
    //     attributes: ['id', 'description', 'foodType', 'numberOfAnimals', 'latitude', 'longitude', 'lastFeedingDate', [Sequelize.fn('POW', Sequelize.fn('ABS', Sequelize.literal("latitude-" + lat)), 2), 'x1'],
    //         [Sequelize.fn('POW', Sequelize.fn('ABS', Sequelize.literal("longitude-" + lng)), 2), 'x2']],
    //     order: Sequelize.fn('SQRT', Sequelize.literal('x1+x2')),
    //     limit: 10
    // });

    let nears = await Container.findAll({
        attributes: ['id', 'description', 'foodType', 'numberOfAnimals', 'latitude', 'longitude', 'lastFeedingDate', [sequelize.literal("6371 * acos(cos(radians(" + lat + ")) * cos(radians(latitude)) * cos(radians(" + lng + ") - radians(longitude)) + sin(radians(" + lat + ")) * sin(radians(latitude)))"), 'distance']],
        order: sequelize.col('distance'),
        limit: 10
    });
    console.log(nears);
}