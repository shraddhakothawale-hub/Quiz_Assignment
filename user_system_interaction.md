# User-System Interaction Document

## JayFly Quiz Generator - RAG Application

 
**Document Type:** User-System Interaction Specification

---

## Table of Contents

1. [Overview](#overview)
2. [System Architecture](#system-architecture)
3. [User Roles](#user-roles)
4. [Interaction Flows](#interaction-flows)
5. [Component Interactions](#component-interactions)
6. [Data Flow](#data-flow)


---

## 1. Overview

### 1.1 Purpose
This document describes the user-system interactions for the JayFly Quiz Generator, a Retrieval Augmented Generation (RAG) application that creates educational quizzes using Astra DB vector database and AI language models.

### 1.2 Scope
The document covers:
- User interaction patterns
- System component communications
- Data flow between modules
- API integrations
- Error handling mechanisms

### 1.3 System Summary
The JayFly Quiz Generator is a flow-based application that:
1. Accepts user text input
2. Searches a vector database for relevant information
3. Uses AI to generate contextual quiz questions
4. Displays results in a chat interface

---

## 2. System Architecture

### 2.1 High-Level Architecture

```
┌─────────────┐
│    User     │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────────────┐
│         Flow Interface Layer            │
│  ┌───────────┐  ┌──────────────────┐   │
│  │   Text    │  │   Chat Output    │   │
│  │   Input   │  │   Component      │   │
│  └─────┬─────┘  └────────▲─────────┘   │
│        │                 │              │
└────────┼─────────────────┼──────────────┘
         │                 │
         ▼                 │
┌─────────────────────────────────────────┐
│       Processing Layer                  │
│  ┌──────────────────────────────────┐   │
│  │   Astra DB Component             │   │
│  │   - Vector Search                │   │
│  │   - Reranking (NVIDIA)          │   │
│  │   - Context Retrieval            │   │
│  └────────────┬─────────────────────┘   │
│               │                          │
└───────────────┼──────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────┐
│       External Services                 │
│  ┌──────────┐  ┌──────────────────┐    │
│  │ Astra DB │  │  LLM Provider    │    │
│  │ Vector   │  │  (OpenAI/etc)    │    │
│  │ Database │  │                  │    │
│  └──────────┘  └──────────────────┘    │
└─────────────────────────────────────────┘
```

### 2.2 Component Overview

| Component | Type | Purpose |
|-----------|------|---------|
| Text Input | Input | Captures user queries |
| Astra DB | Processing | Vector search and retrieval |
| NVIDIA Reranker | Processing | Result optimization |
| Chat Output | Output | Display results |
| Flow Engine | Orchestration | Manages component execution |

---

## 3. User Roles

### 3.1 End User
**Responsibilities:**
- Enter queries to generate quizzes
- Review generated quiz content
- Interact with the chat interface

**Permissions:**
- Submit text queries
- View quiz results
- Run the flow pipeline

**Typical Interactions:**
1. Opens playground interface
2. Enters query: "Create Quiz for JayFly"
3. Clicks "Run Flow"
4. Reviews generated quiz in chat output

### 3.2 Administrator
**Responsibilities:**
- Configure Astra DB connection
- Manage document ingestion
- Monitor system performance
- Update flow configurations

**Permissions:**
- Access to environment variables
- Database management
- Flow editing capabilities
- System logs access

### 3.3 Developer
**Responsibilities:**
- Extend flow components
- Add new quiz types
- Integrate additional data sources
- Maintain codebase

**Permissions:**
- Full code access
- API key management
- Component development
- Testing and deployment

---

## 4. Interaction Flows

### 4.1 Primary Flow: Quiz Generation

```
User Action                 System Response
───────────                 ───────────────

1. Enter Query
   "Create Quiz for JayFly"
                         ──▶ Validate input
                            ├─ Check length
                            └─ Sanitize text

2. Click "Run Flow"
                         ──▶ Initialize pipeline
                            └─ Set status: "Processing"

3. [System Processing]
                         ──▶ Text Input Component
                            ├─ Extract query text
                            └─ Pass to Astra DB

4. [Vector Search]
                         ──▶ Astra DB Component
                            ├─ Generate embeddings
                            ├─ Search collection
                            ├─ Apply reranking
                            └─ Return top results

5. [Context Assembly]
                         ──▶ Assemble retrieved docs
                            └─ Format context

6. [LLM Generation]
                         ──▶ Generate quiz questions
                            ├─ Use retrieved context
                            └─ Format as quiz

7. [Display Results]
                         ──▶ Chat Output Component
                            ├─ Format JSON
                            └─ Display in UI

8. View Quiz
   [User reviews content]
                         ──▶ Render complete
                            └─ Ready for new query
```

### 4.2 Document Ingestion Flow

```
Admin Action               System Response
────────────               ───────────────

1. Prepare Documents
   - Format as JSON
   - Include metadata
                         ──▶ Validate format
                            └─ Check schema

2. Run Ingestion Script
   $ npm run ingest
                         ──▶ Load documents
                            ├─ Parse JSON
                            └─ Chunk if needed

3. [Processing]
                         ──▶ Generate embeddings
                            └─ For each document

4. [Storage]
                         ──▶ Store in Astra DB
                            ├─ Insert vectors
                            ├─ Add metadata
                            └─ Create indices

5. Confirmation
                         ──▶ Return status
                            └─ "X documents ingested"
```

### 4.3 Error Recovery Flow

```
Error Condition           System Response           User Action
───────────────          ───────────────           ───────────

1. Network Timeout
                         ──▶ Retry logic (3x)
                            ├─ Wait intervals
                            └─ Log attempts
                                                   ──▶ Displayed error
                                                      User can retry

2. Invalid Query
                         ──▶ Input validation
                            └─ Return clear message
                                                   ──▶ Correct input
                                                      Resubmit

3. Rate Limit Hit
                         ──▶ Queue request
                            └─ Return wait time
                                                   ──▶ Wait or cancel
                                                      Monitor status

4. Database Error
                         ──▶ Fallback mode
                            ├─ Use cached results
                            └─ Alert admin
                                                   ──▶ View partial results
                                                      Retry later
```

---

## 5. Component Interactions

### 5.1 Text Input Component

**Purpose:** Capture and validate user input

**Interactions:**

| Interaction | Direction | Data Format | Trigger |
|-------------|-----------|-------------|---------|
| User → Text Input | Input | String (plain text) | User types |
| Text Input → Astra DB | Output | `{query: string}` | Flow execution |
| Text Input → Validation | Internal | String | On input change |

**State Management:**
- Input text (string)
- Validation status (boolean)
- Character count (number)
- Focus state (boolean)

**User Actions:**
1. Click input field
2. Type query text
3. View character count
4. Submit via button or Enter key

**System Responses:**
1. Activate input field
2. Update character counter
3. Validate in real-time
4. Enable/disable submit button

### 5.2 Astra DB Component

**Purpose:** Retrieve relevant documents from vector database

**Interactions:**

| Interaction | Direction | Data Format | Trigger |
|-------------|-----------|-------------|---------|
| Text Input → Astra DB | Input | Query string | Flow start |
| Astra DB → Vector DB | API Call | Embedding vector | Search request |
| Vector DB → Astra DB | API Response | Document array | Search complete |
| Astra DB → Reranker | Processing | Results + query | Pre-output |
| Astra DB → Chat Output | Output | Formatted JSON | Flow end |

**Configuration Parameters:**
```javascript
{
  token: "AstraCS:...",
  database: "Quiz_DB",
  collection: "jayfly_quiz",
  searchQuery: "{user_input}",
  reranker: "nvidia/llama-3.2-nv-rerank",
  limit: 10,
  includeMetadata: true
}
```

**Processing Steps:**
1. Receive query text
2. Generate query embedding
3. Execute vector similarity search
4. Retrieve top K documents
5. Apply reranking algorithm
6. Format results with metadata
7. Pass to output component

**Error Conditions:**
- Connection timeout (30s)
- Invalid credentials
- Collection not found
- Rate limit exceeded
- Empty result set

### 5.3 Chat Output Component

**Purpose:** Display quiz results in conversational format

**Interactions:**

| Interaction | Direction | Data Format | Trigger |
|-------------|-----------|-------------|---------|
| Astra DB → Chat Output | Input | JSON array | Search complete |
| Chat Output → User | Display | Formatted HTML | Render cycle |
| User → Chat Output | Interaction | Scroll/Copy | User action |

**Display Format:**
```json
{
  "type": "CompositeElement",
  "text": "Quiz content...",
  "metadata": {
    "timestamp": "2025-11-01T10:00:00Z",
    "source": "jayfly_encyclopedia"
  }
}
```

**Rendering Logic:**
1. Receive result array
2. Parse JSON structure
3. Extract text and metadata
4. Apply formatting rules
5. Render in chat bubble
6. Enable copy functionality
7. Auto-scroll to latest

**User Actions:**
- Scroll through results
- Copy text content
- Click copy button
- Expand/collapse sections

---

## 6. Data Flow

### 6.1 Request Flow Diagram

```
┌──────────┐
│   User   │
│  Input   │
└────┬─────┘
     │ "Create Quiz for JayFly"
     ▼
┌─────────────┐
│ Text Input  │
│ Component   │
└────┬────────┘
     │ query: "Create Quiz for JayFly"
     ▼
┌──────────────────────────────┐
│   Astra DB Component         │
│                              │
│  1. Embedding Generation     │
│     [0.234, -0.567, ...]    │
│                              │
│  2. Vector Search            │
│     Collection: jayfly_quiz  │
│     Limit: 10                │
│                              │
│  3. Retrieved Documents      │
│     [{text, metadata}, ...]  │
│                              │
│  4. Reranking (NVIDIA)      │
│     Relevance scores         │
│                              │
│  5. Top Results              │
│     [doc1, doc2, doc3]      │
└────┬─────────────────────────┘
     │ [{type, text, metadata}, ...]
     ▼
┌──────────────┐
│ Chat Output  │
│ Component    │
│              │
│ ┌──────────┐ │
│ │ Result 1 │ │
│ └──────────┘ │
│ ┌──────────┐ │
│ │ Result 2 │ │
│ └──────────┘ │
│ ┌──────────┐ │
│ │ Result 3 │ │
│ └──────────┘ │
└──────────────┘
```

### 6.2 Data Transformation Pipeline

**Stage 1: Input Capture**
```
User Input: "Create Quiz for JayFly"
  ↓
Validation: ✓ Length OK, ✓ No special chars
  ↓
Sanitization: Trimmed, lowercased for search
  ↓
Output: "create quiz for jayfly"
```

**Stage 2: Embedding Generation**
```
Input Text: "create quiz for jayfly"
  ↓
Tokenization: ["create", "quiz", "for", "jayfly"]
  ↓
Embedding Model: text-embedding-ada-002
  ↓
Vector: [0.234, -0.567, 0.891, ..., 0.345] (1536 dimensions)
```

**Stage 3: Vector Search**
```
Query Vector: [0.234, -0.567, ...]
  ↓
Similarity Search: Cosine similarity
  ↓
Database: Astra DB Collection "jayfly_quiz"
  ↓
Results: [
  {score: 0.92, doc: {...}},
  {score: 0.88, doc: {...}},
  {score: 0.85, doc: {...}}
]
```

**Stage 4: Reranking**
```
Initial Results: 10 documents
  ↓
Reranker: nvidia/llama-3.2-nv-rerank
  ↓
Context: Original query + retrieved docs
  ↓
Rescored Results: [
  {score: 0.95, doc: {...}},
  {score: 0.91, doc: {...}},
  {score: 0.87, doc: {...}}
]
```

**Stage 5: Output Formatting**
```
Reranked Documents
  ↓
Extract: {type, text, metadata}
  ↓
Format as JSON: CompositeElement structure
  ↓
Render in UI: Chat bubble format
```

### 6.3 Database Schema

**Astra DB Collection: jayfly_quiz**

```javascript
{
  "_id": "uuid-v4",
  "text": "Physical Characteristics...",
  "type": "CompositeElement",
  "$vector": [0.234, -0.567, ...], // 1536-dim embedding
  "metadata": {
    "category": "physical_characteristics",
    "topic": "size_and_structure",
    "source": "jayfly_encyclopedia",
    "timestamp": "2025-11-01T10:00:00Z",
    "ingest_version": "1.0"
  }
}
```

**Index Configuration:**
- Vector index: Approximate Nearest Neighbor (ANN)
- Algorithm: HNSW (Hierarchical Navigable Small World)
- Distance metric: Cosine similarity
- Secondary indexes: category, topic, source

---

