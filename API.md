# API Documentation

## Base URLs

- **REST API:** `http://localhost:8000`
- **WebSocket:** `ws://localhost:8000`

## REST Endpoints

### Health Check

#### `GET /`
Returns service status and version information.

**Response:**
```json
{
  "status": "online",
  "service": "Ollama GUI Command Center",
  "version": "1.0.0",
  "timestamp": "2024-01-01T00:00:00.000000"
}
```

---

### Models

#### `GET /api/models`
List all available Ollama models.

**Response:**
```json
{
  "models": [
    {
      "name": "llama2:7b",
      "size": 3826793677,
      "modified_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

---

### Text Generation

#### `POST /api/generate`
Generate text from a single model (non-streaming).

**Request:**
```json
{
  "model": "llama2:7b",
  "prompt": "What is the capital of France?",
  "stream": false,
  "options": {
    "temperature": 0.7
  }
}
```

**Response:**
```json
{
  "model": "llama2:7b",
  "response": "The capital of France is Paris.",
  "timestamp": "2024-01-01T00:00:00.000000"
}
```

---

### Model Chaining

#### `POST /api/chain`
Execute multiple models in sequence or parallel.

**Request (Sequential):**
```json
{
  "models": ["llama2:7b", "mistral:7b"],
  "prompt": "Explain quantum computing",
  "chain_type": "sequential"
}
```

**Request (Parallel):**
```json
{
  "models": ["llama2:7b", "mistral:7b", "codellama:7b"],
  "prompt": "What is machine learning?",
  "chain_type": "parallel"
}
```

**Response:**
```json
{
  "chain_type": "sequential",
  "results": [
    {
      "model": "llama2:7b",
      "input": "Explain quantum computing",
      "output": "Quantum computing uses quantum bits...",
      "timestamp": "2024-01-01T00:00:00.000000"
    },
    {
      "model": "mistral:7b",
      "input": "Quantum computing uses quantum bits...",
      "output": "Building on that, quantum computers...",
      "timestamp": "2024-01-01T00:00:01.000000"
    }
  ]
}
```

---

### File Ingestion

#### `POST /api/ingest/file`
Upload and process a file.

**Request:** `multipart/form-data`
- `file`: The file to upload

**Supported formats:** PDF, PNG, JPG, JPEG, GIF, BMP, TXT, MD, DOCX

**Response:**
```json
{
  "success": true,
  "filename": "document.pdf",
  "file_type": ".pdf",
  "text": "Extracted text content...",
  "pages": 5,
  "method": "pdf_extraction",
  "entities": [
    {
      "id": "entity_0",
      "type": "email",
      "value": "user@example.com",
      "start": 42,
      "end": 59
    }
  ]
}
```

---

### Graph Building

#### `POST /api/graph/build`
Build a graph from text data.

**Request:**
```json
{
  "texts": [
    "John works at Acme Corp in New York.",
    "Jane Smith contacted john@acme.com yesterday."
  ],
  "sources": ["model1", "model2"]
}
```

**Response:**
```json
{
  "nodes": [
    {
      "id": "entity_0",
      "label": "John",
      "type": "named_entity",
      "source": "model1",
      "data": {}
    },
    {
      "id": "entity_1",
      "label": "john@acme.com",
      "type": "email",
      "source": "model2",
      "data": {}
    }
  ],
  "edges": [
    {
      "id": "entity_0_entity_1",
      "source": "entity_0",
      "target": "entity_1",
      "type": "related",
      "weight": 1
    }
  ],
  "stats": {
    "node_count": 2,
    "edge_count": 1
  }
}
```

---

### Agent Execution

#### `POST /api/agent/execute`
Execute an investigative agent.

**Request:**
```json
{
  "agent_type": "investigation",
  "task": "Analyze the security implications of quantum computing",
  "models": ["llama2:7b", "mistral:7b"],
  "parameters": {
    "depth": "comprehensive"
  }
}
```

**Agent types:**
- `research` - Information gathering
- `analysis` - Data analysis
- `summary` - Content summarization
- `investigation` - Multi-step investigation

**Response:**
```json
{
  "agent_type": "investigation",
  "task": "Analyze the security implications...",
  "models": ["llama2:7b", "mistral:7b"],
  "status": "completed",
  "start_time": "2024-01-01T00:00:00.000000",
  "end_time": "2024-01-01T00:01:30.000000",
  "duration_seconds": 90.5,
  "output": "INVESTIGATION REPORT\n====================\n...",
  "execution_log": [
    {
      "timestamp": "2024-01-01T00:00:00.000000",
      "message": "Starting investigation agent"
    }
  ]
}
```

---

### System Telemetry

#### `GET /api/telemetry/system`
Get current system telemetry snapshot.

**Response:**
```json
{
  "timestamp": "2024-01-01T00:00:00.000000",
  "cpu": {
    "usage_percent": 45.2,
    "core_count": 8,
    "frequency_mhz": 3200.0,
    "per_cpu": [42.1, 48.3, 43.5, 46.8, 44.2, 45.9, 46.1, 43.7]
  },
  "memory": {
    "total_gb": 16.0,
    "available_gb": 8.5,
    "used_gb": 7.5,
    "usage_percent": 46.9,
    "free_gb": 8.5
  },
  "disk": {
    "total_gb": 500.0,
    "used_gb": 250.0,
    "free_gb": 250.0,
    "usage_percent": 50.0
  },
  "gpu": {
    "available": true,
    "count": 1,
    "gpus": [
      {
        "id": 0,
        "name": "NVIDIA GeForce RTX 3080",
        "load_percent": 65.5,
        "memory_used_mb": 8192.0,
        "memory_total_mb": 10240.0,
        "memory_free_mb": 2048.0,
        "memory_usage_percent": 80.0,
        "temperature_c": 72
      }
    ]
  }
}
```

---

### Workspace Management

#### `POST /api/workspace/create`
Create a new workspace.

**Request:**
```json
{
  "name": "investigation_2024",
  "description": "Q1 2024 investigation files"
}
```

**Response:**
```json
{
  "status": "created",
  "workspace": "investigation_2024",
  "path": "/path/to/workspaces/investigation_2024"
}
```

#### `GET /api/workspace/list`
List all workspaces.

**Response:**
```json
{
  "workspaces": [
    {
      "name": "investigation_2024",
      "description": "Q1 2024 investigation files",
      "created_at": "2024-01-01T00:00:00.000000",
      "files": [],
      "sessions": []
    }
  ]
}
```

#### `POST /api/workspace/{workspace_name}/save_session`
Save a session to a workspace.

**Request:**
```json
{
  "session_id": "session_1704067200",
  "timestamp": "2024-01-01T00:00:00.000000",
  "selectedModels": ["llama2:7b"],
  "executionMode": "single",
  "outputs": [
    {
      "model": "llama2:7b",
      "content": "Model output text..."
    }
  ]
}
```

**Response:**
```json
{
  "status": "saved",
  "session_id": "session_1704067200"
}
```

#### `GET /api/workspace/{workspace_name}/sessions`
Get all sessions from a workspace.

**Response:**
```json
{
  "sessions": [
    {
      "session_id": "session_1704067200",
      "timestamp": "2024-01-01T00:00:00.000000",
      "selectedModels": ["llama2:7b"],
      "executionMode": "single",
      "outputs": []
    }
  ]
}
```

---

## WebSocket Endpoints

### Token Streaming

#### `ws://localhost:8000/ws/stream`
Real-time token streaming from Ollama models.

**Send:**
```json
{
  "model": "llama2:7b",
  "prompt": "Write a story about a robot",
  "options": {
    "temperature": 0.8
  }
}
```

**Receive (streaming):**
```json
{
  "model": "llama2:7b",
  "chunk": {
    "response": "Once upon a time",
    "done": false
  },
  "timestamp": 1704067200.123
}
```

**Final message:**
```json
{
  "model": "llama2:7b",
  "chunk": {
    "response": ".",
    "done": true,
    "total_duration": 5000000000,
    "load_duration": 100000000
  },
  "timestamp": 1704067205.456
}
```

---

### Live Telemetry

#### `ws://localhost:8000/ws/telemetry`
Real-time system telemetry updates.

**Receive (every 1 second):**
```json
{
  "timestamp": "2024-01-01T00:00:00.000000",
  "cpu": {
    "usage_percent": 45.2
  },
  "memory": {
    "usage_percent": 46.9
  },
  "gpu": {
    "available": true,
    "gpus": [
      {
        "memory_usage_percent": 80.0,
        "temperature_c": 72
      }
    ]
  }
}
```

---

## Error Responses

All endpoints may return error responses:

```json
{
  "detail": "Error message describing what went wrong"
}
```

**Common status codes:**
- `200` - Success
- `400` - Bad Request (invalid input)
- `404` - Not Found (resource doesn't exist)
- `500` - Internal Server Error

---

## Interactive Documentation

FastAPI provides interactive API documentation:

- **Swagger UI:** http://localhost:8000/docs
- **ReDoc:** http://localhost:8000/redoc

These provide an interactive interface to test all endpoints.
