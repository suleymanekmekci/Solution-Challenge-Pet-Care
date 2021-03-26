const { admin } = require('../fbConfig');

module.exports = async function (req, res, next) {
    let idToken = req.headers.authorization
    if (!idToken) return res.status(401).send('Access Denied');
    // check token, if doesn't exist, return access denied.
    try {
        idToken = idToken.replace("Bearer ", "")

        admin.auth().verifyIdToken(idToken)
            .then(function (decodedToken) {
                // if token matches, returns uid of the owner of token
                let uid = decodedToken.uid;
                req.uid = uid
                next();

            }).catch(function (error) {
                res.status(400).send('An error occured' + error.message)
            });


    } catch (err) {
        console.log(err.message)
        res.status(400).send('Invalid Token ' + err)
    }
}