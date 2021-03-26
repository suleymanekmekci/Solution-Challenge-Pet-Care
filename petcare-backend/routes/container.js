const router = require('express').Router();
const { admin } = require('../fbConfig');
const User = require('../src/models/User')
const Container = require('../src/models/Container')
const verify = require('../application/verifyToken');
const sequelize = require('../src/database/connection');
const Sequelize = require("sequelize");

router.post('/addContainer', verify, async (req, res) => {
    const latitude = req.body.latitude
    const longitude = req.body.longitude
    const description = req.body.description
    const foodType = req.body.foodType
    const numberOfAnimals = parseInt(req.body.numberOfAnimals)

    try {
        let date = Date.now()
        date += (3 * 60 * 60 * 1000)

        data = {
            description,
            foodType,
            numberOfAnimals,
            latitude,
            longitude,
            lastFeedingDate: date,
        }

        const container = await Container.create(data)

        res.status(200).send(container.dataValues);
    }
    catch (err) {
        console.log(err);

        res.status(400).send(err)
    }
})

router.get('/getNearContainers', verify, async (req, res) => {

    try {
        const lat = req.headers.latitude;
        const lng = req.headers.longitude;

        const nearContainers = await Container.findAll({
            attributes: ['id', 'description', 'foodType', 'numberOfAnimals', 'latitude', 'longitude', 'lastFeedingDate', [sequelize.literal("6371 * acos(cos(radians(" + lat + ")) * cos(radians(latitude)) * cos(radians(" + lng + ") - radians(longitude)) + sin(radians(" + lat + ")) * sin(radians(latitude)))"), 'distance']],
            order: sequelize.col('distance'),
            limit: 20
        });
        res.status(200).send(nearContainers);

    }
    catch (err) {
        console.log(err);
        res.status(400).send(err);
    }
})

router.patch('/fillContainer/:containerID', verify, async (req, res) => {

    try {

        const id = req.params.containerID;

        let date = Date.now()
        date += (3 * 60 * 60 * 1000);

        let container = await Container.update(
            {
                lastFeedingDate: date
            },

            {
                where: {
                    id
                }
            });

        res.status(200).send(container);

    }
    catch (err) {
        console.log(err);
        res.status(400).send(err);
    }
})

module.exports = (router);