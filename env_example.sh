# Astra DB Configuration
ASTRA_DB_APPLICATION_TOKEN=AstraCS:xxxxxxxxxxxxxxxxxxxxx
ASTRA_DB_API_ENDPOINT=https://your-database-region.apps.astra.datastax.com
ASTRA_DB_DATABASE=Quiz_DB
ASTRA_DB_COLLECTION=jayfly_quiz
ASTRA_DB_KEYSPACE=default_keyspace

# LLM Configuration
OPENAI_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxx
# or
ANTHROPIC_API_KEY=sk-ant-xxxxxxxxxxxxxxxxxxxxx

# Reranker Configuration
NVIDIA_API_KEY=nvapi-xxxxxxxxxxxxxxxxxxxxx
RERANKER_MODEL=nvidia/llama-3.2-nv-rerank

# Application Configuration
PORT=3000
NODE_ENV=development
LOG_LEVEL=info

# Flow Configuration
FLOW_ID=jayfly_quiz_flow
MAX_SEARCH_RESULTS=10
ENABLE_RERANKING=true

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100