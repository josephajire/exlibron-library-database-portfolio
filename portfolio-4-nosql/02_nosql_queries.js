// ============================================================================
// MIT 8103: Advanced Database Systems - Portfolio 4
// Script 2: MongoDB Queries, Atomic Array Updates & Aggregation Pipelines
// ============================================================================

use("exlibron_nosql");

// 1. Query by Multikey Tag & Branch Availability (No JOINs required)
print("--- 1. Books tagged 'concurrency' or 'distributed-systems' in Abuja ---");
printjson(
  db.book_catalogue.find(
    {
      tags: { $in: ["concurrency", "distributed-systems"] },
      available_branches: "Exlibron Central Abuja"
    },
    { _id: 0, isbn: 1, title: 1, tags: 1, available_branches: 1 }
  ).toArray()
);

// 2. Query Polymorphic Schema (Find all titles that have Audiobook editions)
print("--- 2. Books with Audiobook editions ---");
printjson(
  db.book_catalogue.find(
    { audio_details: { $exists: true } },
    { _id: 0, title: 1, author: 1, audio_details: 1 }
  ).toArray()
);

// 3. Atomic Embedded Document Update ($push a new member review)
print("--- 3. Adding a new review to 'The Go Programming Language' ---");
db.book_catalogue.updateOne(
  { isbn: "9780134190440" },
  {
    $push: {
      reviews: {
        member_id: 1,
        reviewer_name: "Zainab Bello",
        rating: 4,
        comment: "Great examples on goroutines and channels.",
        created_at: new Date()
      }
    }
  }
);

// 4. Aggregation Pipeline: Calculate Average Rating & Review Count per Book
print("--- 4. Average Rating & Review Count per Book ---");
printjson(
  db.book_catalogue.aggregate([
    {
      $project: {
        _id: 0,
        isbn: 1,
        title: 1,
        genre: 1,
        total_reviews: { $size: "$reviews" },
        average_rating: { $avg: "$reviews.rating" }
      }
    },
    { $sort: { average_rating: -1 } }
  ]).toArray()
);
