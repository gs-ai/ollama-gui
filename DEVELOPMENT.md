# Development Guide

This guide provides instructions for developers who want to contribute to or customize the Ollama GUI Command Center.

## Development Setup

### Prerequisites

1. **Python 3.8+** with pip
2. **Node.js 16+** with npm
3. **Ollama** installed and running
4. **Git** for version control

### Initial Setup

```bash
# Clone the repository
git clone https://github.com/gs-ai/ollama-gui.git
cd ollama-gui

# Create Python virtual environment
python3 -m venv venv

# Activate virtual environment
# On macOS/Linux:
source venv/bin/activate
# On Windows:
venv\Scripts\activate

# Install Python dependencies
pip install -r requirements.txt

# Install Node.js dependencies
npm install

# Verify installation
./verify.sh
```

## Development Workflow

### Running in Development Mode

**Terminal 1 - Backend:**
```bash
cd backend
python main.py
```

The backend will start on `http://localhost:8000` with auto-reload enabled.

**Terminal 2 - Frontend:**
```bash
npm run dev
```

This will launch Electron with DevTools open.

### Project Structure

```
ollama-gui/
├── backend/
│   ├── __init__.py
│   └── main.py              # FastAPI application
├── frontend/
│   ├── index.html           # Main UI structure
│   ├── styles.css           # Cyberpunk styling
│   ├── app.js               # Application logic
│   └── main.js              # Electron main process
├── agents/
│   ├── __init__.py
│   └── investigative_agent.py  # Agent framework
├── graph/
│   ├── __init__.py
│   ├── entity_extractor.py     # Entity extraction
│   └── graph_builder.py        # Graph generation
├── ingestion/
│   ├── __init__.py
│   └── file_processor.py       # File processing
├── telemetry/
│   ├── __init__.py
│   └── system_monitor.py       # System monitoring
├── workspaces/              # Runtime workspaces (gitignored)
├── requirements.txt         # Python dependencies
├── package.json            # Node.js dependencies
└── run.sh / run.bat        # Production scripts
```

## Backend Development

### Adding New API Endpoints

Edit `backend/main.py`:

```python
@app.post("/api/my-endpoint")
async def my_endpoint(data: MyModel):
    """Your endpoint description"""
    try:
        result = process_data(data)
        return {"result": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```

### Adding New Agent Types

Edit `agents/investigative_agent.py`:

```python
async def _custom_agent(self, task: str, parameters: Dict) -> str:
    """Custom agent implementation"""
    self._log_step("Starting custom agent")
    
    # Your agent logic here
    result = f"Custom agent result for: {task}"
    
    self._log_step("Custom agent completed")
    return result
```

Then update the execute method to handle the new type:

```python
if self.agent_type == "custom":
    output = await self._custom_agent(task, parameters)
```

### Adding File Format Support

Edit `ingestion/file_processor.py`:

```python
# Add to supported_types dict
self.supported_types['.xyz'] = self._process_xyz

# Implement processing method
async def _process_xyz(self, file_path: Path) -> Dict:
    """Process XYZ files"""
    try:
        # Your processing logic
        return {
            "text": extracted_text,
            "method": "xyz_extraction"
        }
    except Exception as e:
        return {"error": str(e), "text": ""}
```

## Frontend Development

### Modifying the UI

**HTML Structure** (`frontend/index.html`):
- Header, main container, and panels
- Tab system for different views
- Model selection, file upload, and controls

**Styling** (`frontend/styles.css`):
- CSS variables for theming
- Component-specific styles
- Responsive layouts

**Application Logic** (`frontend/app.js`):
- WebSocket connections
- API communication
- UI updates and interactions

### Adding New Features

1. **Add HTML structure** in `index.html`
2. **Style the component** in `styles.css`
3. **Implement logic** in `app.js`

Example - Adding a new panel:

```html
<!-- index.html -->
<div class="panel-section">
    <h2 class="panel-title">MY FEATURE</h2>
    <div id="myFeature" class="my-feature">
        <!-- Feature content -->
    </div>
</div>
```

```css
/* styles.css */
.my-feature {
    padding: 1rem;
    background: var(--bg-tertiary);
    border: 1px solid var(--border-color);
    border-radius: 4px;
}
```

```javascript
// app.js
function initializeMyFeature() {
    const container = document.getElementById('myFeature');
    // Feature initialization
}
```

### Customizing the Theme

Edit CSS variables in `frontend/styles.css`:

```css
:root {
    --bg-primary: #1a1d23;      /* Main background */
    --bg-secondary: #252930;     /* Panel background */
    --bg-tertiary: #2d3139;      /* Component background */
    --border-color: #3d4149;     /* Border color */
    --accent-primary: #ff9500;   /* Primary accent (orange) */
    --accent-secondary: #ffb84d; /* Secondary accent */
    --text-primary: #e0e0e0;     /* Primary text */
    --text-secondary: #a0a0a0;   /* Secondary text */
}
```

## Testing

### Backend Testing

```bash
# Install pytest
pip install pytest pytest-asyncio

# Run tests
pytest tests/
```

### Frontend Testing

Manual testing checklist:
- [ ] Model selection and execution
- [ ] File upload and processing
- [ ] Graph visualization
- [ ] Telemetry updates
- [ ] Workspace management
- [ ] Agent execution

## Code Style

### Python

Follow PEP 8 style guide:

```bash
# Install formatters
pip install black isort

# Format code
black backend/ agents/ graph/ ingestion/ telemetry/
isort backend/ agents/ graph/ ingestion/ telemetry/
```

### JavaScript

Use consistent formatting:

```bash
# Install prettier
npm install -g prettier

# Format code
prettier --write frontend/*.js frontend/*.html frontend/*.css
```

## Common Development Tasks

### Adding a New Model Parameter

1. Update `ModelRequest` in `backend/main.py`
2. Update frontend form in `index.html`
3. Update JavaScript to send parameter in `app.js`

### Extending Entity Extraction

Edit `graph/entity_extractor.py`:

```python
# Add new pattern
self.patterns['custom'] = r'your-regex-pattern'

# Or implement advanced extraction
def extract_custom_entities(self, text: str) -> List[Dict]:
    # Advanced NLP or rule-based extraction
    return entities
```

### Adding Telemetry Metrics

Edit `telemetry/system_monitor.py`:

```python
def _get_custom_stats(self) -> Dict:
    """Get custom metrics"""
    return {
        "metric_name": value,
        "another_metric": another_value
    }
```

Update `get_current_stats()` to include new metrics.

## Debugging

### Backend Debugging

Add debug logging:

```python
import logging
logging.basicConfig(level=logging.DEBUG)

# In your code
logging.debug(f"Debug message: {variable}")
```

Run with verbose output:
```bash
uvicorn backend.main:app --reload --log-level debug
```

### Frontend Debugging

Open Electron DevTools (automatically opens in dev mode):
- Console tab for JavaScript logs
- Network tab for API requests
- Application tab for storage inspection

Add console logging:
```javascript
console.log('Debug:', variable);
console.error('Error:', error);
```

## Performance Optimization

### Backend

- Use async/await for I/O operations
- Implement caching for repeated requests
- Use connection pooling for database operations
- Profile with `cProfile` for bottlenecks

### Frontend

- Debounce user input
- Virtualize long lists
- Lazy load images and components
- Use requestAnimationFrame for animations

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes
4. Test thoroughly
5. Commit with clear messages: `git commit -m "Add: feature description"`
6. Push to your fork: `git push origin feature/my-feature`
7. Create a Pull Request

### Commit Message Format

```
Type: Brief description

Detailed explanation if needed

Types:
- Add: New feature
- Fix: Bug fix
- Update: Modification to existing feature
- Remove: Removed feature/code
- Docs: Documentation changes
- Style: Code style changes
- Refactor: Code refactoring
- Test: Test additions/changes
```

## Troubleshooting

### Port Already in Use

```bash
# Find process on port 8000
lsof -i :8000  # macOS/Linux
netstat -ano | findstr :8000  # Windows

# Kill the process
kill -9 <PID>  # macOS/Linux
taskkill /PID <PID> /F  # Windows
```

### Python Import Errors

```bash
# Reinstall dependencies
pip install -r requirements.txt --force-reinstall
```

### Electron Build Issues

```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install
```

## Resources

- **FastAPI Docs:** https://fastapi.tiangolo.com/
- **Electron Docs:** https://www.electronjs.org/docs
- **Cytoscape.js:** https://js.cytoscape.org/
- **Ollama API:** https://github.com/ollama/ollama/blob/main/docs/api.md

## License

MIT License - See LICENSE file for details.
