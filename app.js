const mongoose = require('mongoose');
const dotenv = require("dotenv");
const express = require("express");
const cors = require("cors");
const User = require('./model/user')
const { specs, swaggerUi } = require('./swagger');
dotenv.config();

mongoose.set("strictQuery", false);

// Define the database URL to connect to.
const mongoDB = process.env.MONGODB_URL;

// Wait for database to connect, logging an error if there is a problem
main().catch((err) => console.log(err));
async function main() {
  await mongoose.connect(mongoDB);

  console.log('Connected to mongo server.');
}