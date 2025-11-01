# Quiz_Assignment
# JayFly Quiz Generator

A RAG (Retrieval Augmented Generation) application that creates quizzes about the JayFly creature using Astra DB for document storage and semantic search.

## Features

- 📚 Document ingestion into Astra DB vector database
- 🔍 Semantic search with reranking capabilities
- 🤖 AI-powered quiz generation using LLM
- 🎯 Visual flow-based interface
- 💬 Interactive chat output

## Architecture

The application uses a flow-based architecture with the following components:

1. **Text Input**: Accepts user queries (e.g., "Create Quiz for JayFly")
2. **Astra DB Integration**: 
   - Vector database for document storage
   - Semantic search with lexical terms support
   - Reranking with nvidia/llama-3.2-nv-rerank model
3. **Chat Output**: Displays generated quiz results

## Prerequisites

- Node.js 16+ or Python 3.8+
- Astra DB account and database
- Astra DB Application Token
- API keys for LLM provider

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/jayfly-quiz-generator.git
cd jayfly-quiz-generator
```

### 2. Install dependencies

```bash
npm install
# or
pip install -r requirements.txt
```

### 3. Configure environment variables

Create a `.env` file in the root directory:

```env
ASTRA_DB_APPLICATION_TOKEN=your_token_here
ASTRA_DB_DATABASE=Quiz_DB
ASTRA_DB_COLLECTION=jayfly_quiz
ASTRA_DB_API_ENDPOINT=your_endpoint_here
```

### 4. Ingest documents

Run the ingestion script to populate your Astra DB collection:

```bash
npm run ingest
# or
python ingest_data.py
```

## Usage

### Running the Flow

1. Start the application:
```bash
npm start
# or
python app.py
```

2. Open the Playground interface
3. Enter a query like "Create Quiz for JayFly"
4. Click "Run Flow"
5. View the generated quiz in the Chat Output

### Sample Data

The application includes sample data about the JayFly creature:

- **Physical Characteristics**: 15-20 cm length measurements
- **Species Information**: Fictional avian-insectoid hybrid
- **Feeding Habits**: Dual nature diet
- **Anatomical Features**: Compound eye structure

## Flow Components

### Input Components
- **Text Input**: User query input field

### Astra DB Component
- **Database**: Quiz_DB
- **Collection**: jayfly_quiz
- **Search Query**: Receives input from Text Input
- **Reranker**: nvidia/llama-3.2-nv-rerank
- **Lexical Terms**: Enhanced search capabilities

### Output Components
- **Chat Output**: Displays formatted quiz results

## Project Structure

```
jayfly-quiz-generator/
├── README.md
├── .env.example
├── .gitignore
├── package.json / requirements.txt
├── src/
│   ├── flows/
│   │   └── quiz-flow.json
│   ├── components/
│   │   ├── TextInput.js
│   │   ├── AstraDB.js
│   │   └── ChatOutput.js
│   ├── utils/
│   │   └── astradb.js
│   └── data/
│       └── jayfly_data.json
├── scripts/
│   └── ingest.js
└── docs/
    └── architecture.md
```

## API Reference

### Astra DB Configuration

```javascript
{
  token: process.env.ASTRA_DB_APPLICATION_TOKEN,
  database: 'Quiz_DB',
  collection: 'jayfly_quiz',
  reranker: 'nvidia/llama-3.2-nv-rerank'
}
```

### Search Query Structure

```json
{
  "query": "user input text",
  "limit": 10,
  "rerank": true
}
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


