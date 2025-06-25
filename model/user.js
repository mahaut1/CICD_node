const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const { Schema } = mongoose;

const userSchema = new Schema({
  _id: {
    type: mongoose.Schema.Types.ObjectId,
    default: () => new mongoose.Types.ObjectId()
  },
  username: {
    type: String,
    required: true,
    minlength: 2,
    maxlength: 20
  },
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true,
    match: [/^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/, 'Veuillez entrer un email valide']
  }
  // password: {
  //   type: String,
  //   required: true,
  //   minlength: 6
  // }
}, {
  timestamps: true // Ajoute automatiquement createdAt et updatedAt
});



module.exports = mongoose.model('User', userSchema);