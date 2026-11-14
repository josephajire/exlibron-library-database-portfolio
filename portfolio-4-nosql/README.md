# Portfolio 4: NoSQL and Advanced Data Models — Exlibron Library

## 1. Overview & Polyglot Persistence Strategy
While **Exlibron Library's** core circulation, inventory, and fine records require strict ACID transactions in MySQL (Portfolios 1–3), its **Digital & Interactive Book Catalogue** contains semi-structured, rapidly evolving attributes (e-book formats, audiobook durations/narrators, dynamic search tags, and nested member reviews). 

Following a **Polyglot Persistence** architecture, this portfolio implements the enriched book catalogue using **MongoDB (Document Data Model)**.

---

## 2. Document Data Model Design (`book_catalogue` Collection)

Instead of splitting book metadata, tags, digital formats, and user reviews across four normalized relational tables, each book is stored as a self-contained **BSON/JSON document**:

```json
{
  "isbn": "9781449373320",
  "title": "Designing Data-Intensive Applications",
  "author": { "name": "Martin Kleppmann", "nationality": "German" },
  "publication_year": 2017,
  "genre": "Database Systems",
  "tags": ["distributed-systems", "replication", "sharding", "nosql"],
  "available_branches": ["Exlibron Central Abuja", "Exlibron Victoria Island"],
  "digital_formats": [
    { "format": "EPUB", "file_size_mb": 18.4, "drm_protected": false }
  ],
  "reviews": [
    {
      "member_id": 1,
      "reviewer_name": "Zainab Bello",
      "rating": 5,
      "comment": "Essential reading for understanding replication and partitioning."
    }
  ]
}
```

### Key Modelling Decisions
* **Embedding over Referencing:** Member `reviews`, `tags`, and `digital_formats` are embedded directly inside the book document because they are always read together when a member views a book's details page.
* **Polymorphic Schema:** E-books store a `digital_formats` array, whereas audiobooks store an `audio_details` object (`narrator`, `duration_minutes`, `bitrate_kbps`) without requiring sparse `NULL` columns or schema migrations.
* **Multikey & Text Indexing:** A multikey index on `tags` (`{ tags: 1 }`) enables fast array element lookups without junction tables.

---

## 3. Relational (MySQL) vs. Document (MongoDB) Justification

| Dimension | Relational Model (MySQL) | Document Model (MongoDB) | Why MongoDB Fits Catalogue Features |
| :--- | :--- | :--- | :--- |
| **Schema Flexibility** | Rigid schema (`ALTER TABLE` needed for new media attributes) | Dynamic/polymorphic schema per document | Easily accommodates print, e-book, and audiobook attributes in one collection. |
| **Read Performance** | Requires multi-table `JOIN`s (`books` + `reviews` + `tags`) | Single-document read (`findOne`) | Eliminates join overhead when loading book details and user reviews. |
| **Write & Transaction Model** | Strict multi-table ACID (`loans` + `fines`) | Atomic single-document updates (`$push`) | Adding a review via `$push` is atomic at the document level. |

---

## 4. Implementation & Query Evidence
* **`01_insert_catalogue.js`**: Inserts polymorphic book documents and builds multikey (`tags`) and text indexes.
* **`02_nosql_queries.js`**: Executes array-filtering queries (`$in`), polymorphic field checks (`$exists`), atomic `$push` review insertions, and an `$avg` rating aggregation pipeline.
* ![MongoDB Implementation Evidence](./nosql_evidence.png)

---

## 5. Academic Integrity & AI Use Declaration
* **AI Tool Used:** Google Gemini
* **Purpose:** Assisted in designing the polymorphic JSON document schema and structuring MongoDB aggregation and `$push` update scripts.
* **Verification:** Executed all MongoDB scripts locally, verified index creation and query outputs, and captured screenshot evidence independently.

