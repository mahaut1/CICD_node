const mongoose = require('mongoose');
const dotenv = require("dotenv");
const express = require("express");
const cors = require("cors");
const User = require('./model/user');
// const { specs, swaggerUi } = require('./swagger');

dotenv.config();
mongoose.set("strictQuery", false);

// Connexion MongoDB
const mongoDB = process.env.MONGODB_URL;
main().catch((err) => console.log(err));
async function main() {
  await mongoose.connect(mongoDB);
  console.log('Connected to mongo server.');
}

// Initialisation Express
const app = express();
app.use(cors());
app.use(express.json());

// Exemple de route
app.get("/", (req, res) => {
  res.send("Hello from the API");
});

// Export de l'application Express
module.exports = app;
