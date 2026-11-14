// ============================================================================
// MIT 8103: Advanced Database Systems - Portfolio 4
// Script 1: MongoDB Document Model & Catalogue Seed Data
// Database: exlibron_nosql | Collection: book_catalogue
// ============================================================================

use("exlibron_nosql");

// Drop collection if re-running for clean state
db.book_catalogue.drop();

// Insert polymorphic documents (Print, E-Book, and Audiobook metadata)
db.book_catalogue.insertMany([
  {
    isbn: "9781449373320",
    title: "Designing Data-Intensive Applications",
    author: {
      name: "Martin Kleppmann",
      nationality: "German"
    },
    publication_year: 2017,
    genre: "Database Systems",
    tags: ["distributed-systems", "replication", "sharding", "nosql", "transactions"],
    available_branches: ["Exlibron Central Abuja", "Exlibron Victoria Island"],
    digital_formats: [
      { format: "EPUB", file_size_mb: 18.4, drm_protected: false },
      { format: "PDF", file_size_mb: 24.1, drm_protected: true }
    ],
    reviews: [
      {
        member_id: 1,
        reviewer_name: "Zainab Bello",
        rating: 5,
        comment: "Essential reading for understanding replication and partitioning.",
        created_at: new Date("2026-10-12T10:30:00Z")
      },
      {
        member_id: 2,
        reviewer_name: "Tunde Adeyemi",
        rating: 5,
        comment: "Clear explanation of ACID vs BASE trade-offs.",
        created_at: new Date("2026-11-02T14:15:00Z")
      }
    ]
  },
  {
    isbn: "9780385474542",
    title: "Things Fall Apart",
    author: {
      name: "Chinua Achebe",
      nationality: "Nigerian"
    },
    publication_year: 1994,
    genre: "African Literature",
    tags: ["classics", "nigerian-literature", "history", "culture"],
    available_branches: ["Exlibron Central Abuja", "Exlibron GRA Port Harcourt"],
    audio_details: {
      narrator: "Peter Francis James",
      duration_minutes: 392,
      bitrate_kbps: 128
    },
    reviews: [
      {
        member_id: 3,
        reviewer_name: "Ngozi Eze",
        rating: 5,
        comment: "A timeless masterpiece. The audiobook narration is superb.",
        created_at: new Date("2026-09-28T09:00:00Z")
      }
    ]
  },
  {
    isbn: "9780134190440",
    title: "The Go Programming Language",
    author: {
      name: "Alan A. A. Donovan",
      nationality: "American"
    },
    publication_year: 2015,
    genre: "Computer Science",
    tags: ["golang", "concurrency", "backend", "systems-programming"],
    available_branches: ["Exlibron Victoria Island"],
    digital_formats: [
      { format: "PDF", file_size_mb: 12.7, drm_protected: false }
    ],
    reviews: []
  }
]);

// Create a Multikey Index on tags and a Text Index on title/genre for fast search
db.book_catalogue.createIndex({ tags: 1 });
db.book_catalogue.createIndex({ title: "text", genre: "text" });

print("Inserted documents count: " + db.book_catalogue.countDocuments());
