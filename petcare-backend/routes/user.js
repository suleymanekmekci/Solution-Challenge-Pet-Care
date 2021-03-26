const router = require('express').Router();
const { admin } = require('../fbConfig');
const User = require('../src/models/User')
const verify = require('../application/verifyToken');
const sequelize = require('../src/database/connection');
const Sequelize = require("sequelize");


// register
router.post('/register', verify, async (req, res) => {

    admin.auth().getUser(req.uid)
        .then(async function (userRecord) {

            let nameArray = req.body.fullName.split(" ")
            let firstName = nameArray.slice(0, nameArray.length - 1).join(' ')
            let lastName = nameArray[nameArray.length - 1]

            const user = await User.create({
                id: req.uid,
                firstName: firstName,
                lastName: lastName,
                email: userRecord.email,
            })


            // create user
            res.status(200).send(user);
        })
        .catch(function (error) {
            res.status(400).send(error);
            console.log('Error fetching user data:', error);
        });
});

router.get('/getUser', verify, async (req, res) => {
    try {

        const user = await User.findAll({ where: { id: req.uid } })

        res.status(200).send(user[0].dataValues);
    }
    catch (err) {
        console.log(err);


        res.status(400).send(err)


    }
})




module.exports = (router);