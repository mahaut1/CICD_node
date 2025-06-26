const mongoose = require('mongoose');
const dotenv = require("dotenv");
const express = require("express");
const cors = require("cors");
const User = require('./model/user');
const Book = require('./model/Book');

dotenv.config();
mongoose.set("strictQuery", false);

// Connexion à MongoDB
const mongoDB = process.env.MONGODB_URL;

async function main() {
  try {
    await mongoose.connect(mongoDB);
    console.log('Connected to MongoDB');
  } catch (err) {
    console.error('MongoDB connection error:', err);
  }
}
main();

// Création de l'application Express
const app = express();
app.use(cors());
app.use(express.json());

// Exemple de route
app.get("/", (req, res) => {
  res.send("Bienvenue sur l'API !");
});

// Routes USER
app.get("/users", async (req, res) => {
  const users = await User.find();
  res.json(users);
});

app.post("/users", async (req, res) => {
  const user = new User(req.body);
  await user.save();
  res.status(201).json(user);
});

// Routes BOOK
app.get("/books", async (req, res) => {
  const books = await Book.find();
  res.json(books);
});

app.post("/books", async (req, res) => {
  const book = new Book(req.body);
  await book.save();
  res.status(201).json(book);
});
module.exports = app;
