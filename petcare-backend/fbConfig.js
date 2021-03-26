require("firebase/auth");
const firebase = require('firebase')
const admin = require('firebase-admin')
const serviceAccount = require('./pet-care-4f25f-firebase-adminsdk-60zov-e9fb23c6aa.json');


admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://pet-care-4f25f.firebaseio.com",
    apiKey: "AIzaSyAOpltMebzGF8_hhVNghON6s51ac-qCFQk",
    serverKey: "AAAAnwexNso:APA91bHtZUEJK612qqzSXq8Z4mU8BaWrW_WjLlHvpwTfdMo5lRVNX9nW43-iCdiMO7LXWhxNZ10zkoeICREpIWedmgeCisfhzloBHR00xVZ3YgFScDrF5Ig518QPYCZk2pyWywfMH3n8"
});

module.exports = { firebase, admin };

