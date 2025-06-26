import React, { useEffect, useState } from "react";

function BookList() {
  const [books, setBooks] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch("http://localhost:8000/books")  // ou l'URL de ton backend déployé
      .then((res) => res.json())
      .then((data) => {
        setBooks(data);
        setLoading(false);
      })
      .catch((err) => {
        console.error("Erreur fetch books:", err);
        setLoading(false);
      });
  }, []);

  if (loading) return <div>Chargement...</div>;

  return (
    <div>
      <h2>Liste des livres</h2>
      <ul>
        {books.map((book) => (
          <li key={book._id}>
            <strong>{book.title}</strong> par {book.author} ({book.year})
          </li>
        ))}
      </ul>
    </div>
  );
}

export default BookList;
