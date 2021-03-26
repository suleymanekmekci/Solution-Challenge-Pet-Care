const router = require('express').Router();
const { admin } = require('../fbConfig');
const Animal = require('../src/models/Animal')
const verify = require('../application/verifyToken');
const sequelize = require('../src/database/connection');
const Sequelize = require("sequelize");


router.post('/addAnimal', verify, async (req, res) => {


    const latitude = req.body.latitude
    const longitude = req.body.longitude
    const description = req.body.description

    const animalBreed = req.body.animalBreed
    const photoUrl = "";


    try {
        let date = Date.now()
        date += (3 * 60 * 60 * 1000)

        data = {
            description,
            animalBreed,
            photoUrl,
            latitude,
            longitude,

        }

        const animal = await Animal.create(data);

        res.status(200).send(animal.dataValues);


    }
    catch (err) {
        console.log(err);
        res.status(400).send(err)


    }
})

router.delete('/deleteAnimal/:animalID', verify, async (req, res) => {
    
    const id = req.params.animalID;

    try {
        const animal = await Animal.destroy({
                where: {
                    id
                }
            });
        console.log(animal);
        res.status(200).send(animal.toString());


    }
    catch (error) {
        console.log(error);
        res.status(400).send(error)
    }
})

router.patch('/addPhoto/:animalID', verify, async (req, res) => {
    const photoUrl = req.body.photoUrl
    const id = req.params.animalID;

    try {
        const animal = await Animal.update(
            {
                photoUrl: photoUrl
            },

            {
                where: {
                    id
                }
            });

        res.status(200).send(animal);


    }
    catch (error) {
        console.log(error);
        res.status(400).send(error)
    }
})

router.get('/getNearAnimals', verify, async (req, res) => {
    try {

        const lat = req.headers.latitude;
        const lng = req.headers.longitude;

        const nearAnimals = await Animal.findAll({
            attributes: ['id', 'description', 'animalBreed', 'latitude', 'longitude', 'photoUrl', [sequelize.literal("6371 * acos(cos(radians(" + lat + ")) * cos(radians(latitude)) * cos(radians(" + lng + ") - radians(longitude)) + sin(radians(" + lat + ")) * sin(radians(latitude)))"), 'distance']],
            order: sequelize.col('distance'),
            limit: 20
        });
        res.status(200).send(nearAnimals);
    }
    catch (err) {
        console.log(err);
        res.status(400).send(err)


    }
})


module.exports = (router);