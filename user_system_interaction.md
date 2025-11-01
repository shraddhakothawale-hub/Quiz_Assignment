# User-System Interaction Document

## JayFly Quiz Generator - RAG Application

**Version:** 1.0  
**Date:** November 2025  
**Document Type:** User-System Interaction Specification

---

## Table of Contents

1. [Overview](#overview)
2. [System Architecture](#system-architecture)
3. [User Roles](#user-roles)
4. [Interaction Flows](#interaction-flows)
5. [Component Interactions](#component-interactions)
6. [Data Flow](#data-flow)
7. [User Interface Specifications](#user-interface-specifications)
8. [API Interactions](#api-interactions)
9. [Error Handling](#error-handling)
10. [Performance Requirements](#performance-requirements)

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

## 7. User Interface Specifications

### 7.1 Playground Interface

**Layout Structure:**
```
┌─────────────────────────────────────────────────────────────┐
│  Header: [Starter Project / New Flow]    [Play] [Share ▼]  │
├─────────────────────────────────────────────────────────────┤
│           │                                                  │
│  Sidebar  │              Canvas Area                        │
│           │                                                  │
│  [Search] │     ┌──────────┐                               │
│           │     │  Text    │                               │
│  Comps:   │     │  Input   │                               │
│  • Input/ │     └────┬─────┘                               │
│    Output │          │                                      │
│  • Agents │          ▼                                      │
│  • Models │     ┌────────────┐        ┌──────────┐        │
│  • Data   │     │  Astra DB  │───────▶│  Chat    │        │
│  • Logic  │     └────────────┘        │  Output  │        │
│           │                            └──────────┘        │
│           │                                                  │
│  [+ New   │    [Code] [Controls] [Tool Mode] [...]         │
│   Custom  │                                                  │
│   Comp]   │                                                  │
└───────────┴──────────────────────────────────────────────────┘
```

**Component Configuration Panel:**
```
┌─────────────────────────────────────┐
│  Astra DB                  [19.22s] │
├─────────────────────────────────────┤
│                                     │
│  Ingest and search documents        │
│  in Astra DB                        │
│                                     │
│  Astra DB Application Token *      │
│  [●●●●●●●●●●●●●●●●●●●●] [👁] [🔗]  │
│                                     │
│  Database *                         │
│  [Quiz_DB                      ▼]  │
│                                     │
│  Collection *                       │
│  [jayfly_quiz                  ▼]  │
│                                     │
│  ▶ Ingest Data                     │
│                                     │
│  Search Query                       │
│  [Receiving input              🔒]  │
│                                     │
│  Reranker                          │
│  [nvidia/llama-3.2-nv-rerank...⊗]  │
│  [Toggle: ON]                      │
│                                     │
│  Lexical Terms                     │
│  [Enter terms to search...     🔍]  │
│                                     │
│  [Search Results ▼]  [⋮]           │
└─────────────────────────────────────┘
```

### 7.2 Chat Output Interface

**Default Session View:**
```
┌─────────────────────────────────────────────────┐
│  Playground                            [×]      │
├─────────────────────────────────────────────────┤
│                                                 │
│  Chat                          [+]             │
│                                                 │
│  ▶ Default Session            [...]            │
│                                                 │
├─────────────────────────────────────────────────┤
│                                                 │
│  🤖 AI    Astra DB                             │
│                                                 │
│  ┌───────────────────────────────────────────┐ │
│  │ json                              [copy]  │ │
│  │ {                                         │ │
│  │   "type": "CompositeElement",            │ │
│  │   "text": "Physical Characteristics..."  │ │
│  │ }                                         │ │
│  └───────────────────────────────────────────┘ │
│                                                 │
│  ┌───────────────────────────────────────────┐ │
│  │ json                              [copy]  │ │
│  │ {                                         │ │
│  │   "type": "CompositeElement",            │ │
│  │   "text": "JayFly\n\nThe JayFly..."      │ │
│  │ }                                         │ │
│  └───────────────────────────────────────────┘ │
│                                                 │
│  ┌───────────────────────────────────────────┐ │
│  │ json                              [copy]  │ │
│  │ {                                         │ │
│  │   "type": "CompositeElement",            │ │
│  │   "text": "Feeding Habits..."            │ │
│  │ }                                         │ │
│  └───────────────────────────────────────────┘ │
│                                                 │
│  [Run Flow]                                    │
│                                                 │
│  Add a Chat Input component to your flow       │
│  to send messages.                             │
└─────────────────────────────────────────────────┘
```

### 7.3 Interactive Elements

**Text Input Component:**
- Input field: Multi-line text area
- Character counter: Live update
- Submit button: "▶" play icon
- Clear button: "×" icon
- Validation indicator: ✓ or ✗
- Placeholder: "Create Quiz for JayFly"

**Astra DB Component:**
- Configuration accordion: Expandable sections
- Token field: Masked with show/hide toggle
- Dropdown selectors: Database and Collection
- Toggle switches: Reranker enable/disable
- Search field: Lexical terms input
- Status indicator: Processing time display

**Chat Output Component:**
- Message bubbles: Rounded corners, shadows
- Code blocks: Syntax highlighted JSON
- Copy buttons: One-click copy functionality
- Timestamp: Hover to see full datetime
- Scroll container: Auto-scroll to latest

---

## 8. API Interactions

### 8.1 Astra DB Vector Search API

**Endpoint:**
```
POST https://{database-id}-{region}.apps.astra.datastax.com/api/json/v1/{keyspace}/{collection}
```

**Request Structure:**
```json
{
  "find": {
    "sort": {
      "$vector": [0.234, -0.567, 0.891, ...]
    },
    "limit": 10,
    "includeSimilarity": true
  }
}
```

**Headers:**
```
Content-Type: application/json
x-cassandra-token: AstraCS:...
```

**Response Structure:**
```json
{
  "data": {
    "documents": [
      {
        "_id": "uuid",
        "text": "Physical Characteristics...",
        "type": "CompositeElement",
        "$similarity": 0.92,
        "metadata": {
          "category": "physical_characteristics",
          "topic": "size_and_structure"
        }
      }
    ],
    "nextPageState": null
  }
}
```

**Error Responses:**
```json
{
  "errors": [
    {
      "message": "Collection not found",
      "errorCode": "COLLECTION_NOT_FOUND"
    }
  ]
}
```

### 8.2 NVIDIA Reranking API

**Endpoint:**
```
POST https://api.nvidia.com/v1/retrieval/nvidia/reranking
```

**Request Structure:**
```json
{
  "model": "nvidia/llama-3.2-nv-rerank",
  "query": {
    "text": "Create Quiz for JayFly"
  },
  "passages": [
    {
      "text": "Physical Characteristics...",
      "metadata": {"category": "physical_characteristics"}
    }
  ],
  "top_n": 5
}
```

**Headers:**
```
Authorization: Bearer nvapi-...
Content-Type: application/json
```

**Response Structure:**
```json
{
  "rankings": [
    {
      "index": 0,
      "relevance_score": 0.95,
      "passage": {"text": "..."}
    }
  ]
}
```

### 8.3 LLM Generation API (OpenAI Example)

**Endpoint:**
```
POST https://api.openai.com/v1/chat/completions
```

**Request Structure:**
```json
{
  "model": "gpt-4",
  "messages": [
    {
      "role": "system",
      "content": "You are a quiz generator..."
    },
    {
      "role": "user",
      "content": "Create a quiz about JayFly based on: [context]"
    }
  ],
  "temperature": 0.7,
  "max_tokens": 1000
}
```

**Response Structure:**
```json
{
  "choices": [
    {
      "message": {
        "role": "assistant",
        "content": "## JayFly Quiz\n\n1. What is..."
      },
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 450,
    "completion_tokens": 200,
    "total_tokens": 650
  }
}
```

---

## 9. Error Handling

### 9.1 Error Classification

| Error Type | Severity | User Action | System Action |
|------------|----------|-------------|---------------|
| Network Timeout | Medium | Retry | Auto-retry 3x |
| Invalid Input | Low | Correct input | Show validation |
| Auth Failure | High | Check credentials | Log error |
| Rate Limit | Medium | Wait | Queue request |
| Database Error | High | Contact support | Fallback mode |
| Empty Results | Low | Rephrase query | Show suggestion |

### 9.2 Error Messages

**User-Facing Messages:**

```javascript
const errorMessages = {
  NETWORK_TIMEOUT: "Connection timed out. Please try again.",
  INVALID_INPUT: "Please enter a valid query (3-500 characters).",
  AUTH_FAILED: "Authentication failed. Please check your API token.",
  RATE_LIMIT: "Too many requests. Please wait 60 seconds.",
  DB_ERROR: "Database temporarily unavailable. Using cached results.",
  NO_RESULTS: "No matching documents found. Try a different query.",
  GENERAL_ERROR: "An unexpected error occurred. Please try again."
};
```

**Error Display Format:**
```
┌─────────────────────────────────────┐
│  ⚠️ Error                           │
│                                     │
│  Connection timed out.              │
│  Please try again.                  │
│                                     │
│  [Retry]  [Cancel]                 │
└─────────────────────────────────────┘
```

### 9.3 Error Recovery Strategies

**Network Errors:**
1. Attempt immediate retry
2. Wait 2 seconds, retry
3. Wait 5 seconds, retry
4. Display error to user
5. Log to monitoring system

**Validation Errors:**
1. Prevent submission
2. Highlight invalid field
3. Show inline error message
4. Provide example input
5. Clear error on correction

**API Errors:**
1. Check response status
2. Parse error message
3. Map to user-friendly text
4. Log technical details
5. Offer alternative actions

---

## 10. Performance Requirements

### 10.1 Response Time Targets

| Operation | Target | Maximum | Notes |
|-----------|--------|---------|-------|
| Input Validation | < 100ms | 200ms | Real-time feedback |
| Vector Search | < 2s | 5s | Database query |
| Reranking | < 1s | 3s | NVIDIA API call |
| LLM Generation | < 5s | 15s | Depends on length |
| Total Flow | < 10s | 20s | End-to-end |

### 10.2 Scalability Metrics

**Concurrent Users:**
- Target: 100 concurrent users
- Maximum: 500 concurrent users
- Load balancing: Required above 200 users

**Request Volume:**
- Target: 1000 requests/hour
- Maximum: 5000 requests/hour
- Rate limiting: 10 requests/minute per user

**Database Performance:**
- Query latency: < 100ms (p95)
- Throughput: 500 queries/second
- Vector index: ANN algorithm for speed

### 10.3 Optimization Strategies

**Caching:**
```javascript
// Cache frequently accessed documents
const cache = {
  ttl: 3600, // 1 hour
  maxSize: 1000, // items
  strategy: 'LRU' // Least Recently Used
};

// Cache search results by query hash
const resultCache = {
  key: hashQuery(userInput),
  value: searchResults,
  expiry: Date.now() + 3600000
};
```

**Connection Pooling:**
```javascript
// Maintain persistent DB connections
const pool = {
  min: 5,
  max: 20,
  idleTimeout: 30000,
  connectionTimeout: 10000
};
```

**Lazy Loading:**
- Load components on-demand
- Stream large result sets
- Paginate chat output
- Defer non-critical operations

---

## Appendices

### Appendix A: Glossary

| Term | Definition |
|------|------------|
| RAG | Retrieval Augmented Generation - combining search with LLM generation |
| Vector Embedding | Numerical representation of text in high-dimensional space |
| Cosine Similarity | Measure of similarity between two vectors |
| Reranking | Re-ordering search results by relevance |
| Flow | Visual programming workflow connecting components |
| Component | Modular building block in the flow system |

### Appendix B: Configuration Examples

**Complete Environment Configuration:**
```bash
# Astra DB
ASTRA_DB_APPLICATION_TOKEN=AstraCS:xxxxxx
ASTRA_DB_API_ENDPOINT=https://xxxxx.apps.astra.datastax.com
ASTRA_DB_DATABASE=Quiz_DB
ASTRA_DB_COLLECTION=jayfly_quiz
ASTRA_DB_KEYSPACE=default_keyspace

# LLM Provider
OPENAI_API_KEY=sk-xxxx
OPENAI_MODEL=gpt-4
OPENAI_MAX_TOKENS=1000

# Reranker
NVIDIA_API_KEY=nvapi-xxxx
RERANKER_MODEL=nvidia/llama-3.2-nv-rerank

# Application
PORT=3000
NODE_ENV=production
LOG_LEVEL=info
ENABLE_CACHING=true
CACHE_TTL=3600

# Rate Limiting
RATE_LIMIT_WINDOW_MS=60000
RATE_LIMIT_MAX_REQUESTS=10
```

### Appendix C: Sample API Calls

**Complete Quiz Generation Flow:**

```bash
# 1. Generate embedding for query
curl -X POST https://api.openai.com/v1/embeddings \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "text-embedding-ada-002",
    "input": "Create Quiz for JayFly"
  }'

# 2. Search Astra DB
curl -X POST https://$DB_ID.apps.astra.datastax.com/api/json/v1/default_keyspace/jayfly_quiz \
  -H "x-cassandra-token: $ASTRA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "find": {
      "sort": {"$vector": [0.234, ...]},
      "limit": 10
    }
  }'

# 3. Rerank results
curl -X POST https://api.nvidia.com/v1/retrieval/nvidia/reranking \
  -H "Authorization: Bearer $NVIDIA_API_KEY" \
  -H "Content-Type: application/json"