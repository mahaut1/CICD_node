const mongoose = require('mongoose');
const { Schema } = mongoose;

const bookSchema = new Schema({
  bookid: {
    type: mongoose.Schema.Types.ObjectId,
    default: () => new mongoose.Types.ObjectId()
  },
  title: {
    type: String,
    required: true,
    trim: true
  },
  author: {
    type: String,
    trim: true
  },
  year: {
    type: Number,
    min: 0,
    max: new Date().getFullYear(), // Limite l'année à l'année actuelle
  }
}, {
  timestamps: true // Ajoute automatiquement createdAt et updatedAt
});

module.exports = mongoose.model('Book', bookSchema);