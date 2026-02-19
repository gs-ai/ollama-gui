# Installation & Quick Start Guide

## 🚀 5-Minute Quick Start

### Step 1: Prerequisites Check

Before starting, ensure you have:

✅ **Python 3.8+**
```bash
python3 --version
```

✅ **Node.js 16+**
```bash
node --version
```

✅ **Ollama installed and running**
```bash
# Check Ollama is running
curl http://localhost:11434/api/tags

# If not running, start Ollama
ollama serve
```

✅ **At least one Ollama model downloaded**
```bash
# List models
ollama list

# If empty, pull a model
ollama pull llama2:7b
```

### Step 2: Installation

**macOS / Linux:**
```bash
# Clone repository
git clone https://github.com/gs-ai/ollama-gui.git
cd ollama-gui

# Run installation verification
chmod +x verify.sh
./verify.sh

# If verification passes, start the application
chmod +x run.sh
./run.sh
```

**Windows:**
```cmd
# Clone repository
git clone https://github.com/gs-ai/ollama-gui.git
cd ollama-gui

# Start the application
run.bat
```

### Step 3: First Launch

1. **Backend starts** on `http://localhost:8000`
2. **Electron window opens** automatically
3. **Models load** in the left panel
4. **Telemetry starts** monitoring system resources

### Step 4: Your First Query

1. **Select a model** from the left panel (click to select)
2. **Enter a prompt** in the text area:
   ```
   Explain the concept of artificial intelligence in simple terms
   ```
3. **Click EXECUTE** button
4. **Watch live streaming** in the OUTPUT STREAM tab

🎉 **That's it!** You're now running the Ollama Command Center.

## 📖 Next Steps

### Explore Features

1. **Multi-Model Mode**
   - Switch to PARALLEL or CHAIN mode
   - Select multiple models
   - Execute and compare outputs

2. **File Ingestion**
   - Drag & drop a PDF, image, or text file
   - View extracted text and entities
   - Use in prompts

3. **Graph Visualization**
   - Execute a few queries
   - Switch to GRAPH VIEW tab
   - Click "Build Graph" to see entity relationships

4. **Agents**
   - Select "Investigation" agent type
   - Enter a research task
   - Launch agent and view multi-step execution

5. **Workspaces**
   - Create a new workspace
   - Save your current session
   - Load it later to continue

### Keyboard Shortcuts

- `Ctrl/Cmd + Enter` - Execute prompt (when focused)
- `Esc` - Clear current output
- `Tab` - Switch between tabs

## 🔧 Configuration

### Ollama URL

If Ollama is running on a different host/port, edit `frontend/app.js`:

```javascript
const API_BASE = 'http://localhost:8000';  // Backend URL
// Backend connects to Ollama at localhost:11434 (configured in backend/main.py)
```

### Backend Configuration

Edit `backend/main.py`:

```python
OLLAMA_BASE_URL = "http://localhost:11434"  # Change if needed
```

Restart backend after changes:
```bash
cd backend
python main.py
```

### Port Configuration

Backend port is configured in `backend/main.py`:

```python
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,  # Change port here
        reload=True
    )
```

## 🐛 Common Issues

### Issue: "Connection refused" or "Cannot connect to backend"

**Solution:**
1. Check backend is running: `curl http://localhost:8000`
2. Check port 8000 is not in use: `lsof -i :8000` (macOS/Linux)
3. Restart backend: `cd backend && python main.py`

### Issue: "No models available"

**Solution:**
1. Verify Ollama is running: `curl http://localhost:11434/api/tags`
2. Check models are installed: `ollama list`
3. Pull a model: `ollama pull llama2:7b`
4. Refresh the application

### Issue: "Module not found" errors

**Solution:**
```bash
# Activate virtual environment
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows

# Reinstall dependencies
pip install -r requirements.txt
```

### Issue: "OCR not working"

**Solution:**
Install Tesseract OCR:

```bash
# macOS
brew install tesseract

# Ubuntu/Debian
sudo apt-get install tesseract-ocr

# Windows
# Download from: https://github.com/UB-Mannheim/tesseract/wiki
```

Then restart the backend.

### Issue: "GPU metrics not available"

**Solution:**
GPU monitoring requires NVIDIA GPU and GPUtil:

```bash
pip install GPUtil
```

Note: CPU and RAM metrics work without GPU.

### Issue: Electron won't start

**Solution:**
```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install

# Try starting manually
npm start
```

## 📊 System Requirements

### Minimum Requirements
- **CPU:** 4 cores
- **RAM:** 8 GB
- **Disk:** 5 GB free space
- **OS:** macOS 10.14+, Windows 10+, Linux (Ubuntu 20.04+)

### Recommended Requirements
- **CPU:** 8+ cores
- **RAM:** 16+ GB
- **GPU:** NVIDIA GPU with 8+ GB VRAM (for faster models)
- **Disk:** 20+ GB SSD
- **OS:** macOS 12+, Windows 11, Linux (Ubuntu 22.04+)

## 🔐 Security Notes

- **100% Local:** All data stays on your machine
- **No Telemetry:** No external analytics or tracking
- **No Cloud:** No external API calls
- **Private:** Workspaces stored locally in `./workspaces/`

## 📞 Getting Help

1. **Documentation:**
   - [README.md](README.md) - Overview and quick start
   - [USAGE.md](USAGE.md) - Comprehensive user guide
   - [API.md](API.md) - API reference
   - [DEVELOPMENT.md](DEVELOPMENT.md) - Developer guide

2. **Common Questions:**
   - Check troubleshooting section above
   - Review Ollama documentation
   - Check GitHub issues

3. **Report Issues:**
   - GitHub: https://github.com/gs-ai/ollama-gui/issues
   - Include: OS, Python version, Node version, error messages

## 🎯 Tips for Best Experience

1. **Start Small:** Begin with smaller models (7B) for faster responses
2. **Use Workspaces:** Organize investigations into workspaces
3. **Save Sessions:** Regularly save your work
4. **Monitor Resources:** Keep an eye on telemetry to avoid overload
5. **Chain Wisely:** Use chain mode when output needs refinement
6. **Parallel Power:** Use parallel mode for comparing different perspectives

## 📚 Learning Path

**Beginner:**
1. Basic prompt execution
2. Single model usage
3. File upload and text extraction

**Intermediate:**
4. Multi-model parallel execution
5. Model chaining
6. Basic agent usage

**Advanced:**
7. Graph visualization and analysis
8. Complex agent orchestration
9. Workspace management
10. Custom agent development

## 🎨 Interface Overview

```
┌─────────────────────────────────────────────────────────────┐
│  ⬢ OLLAMA COMMAND CENTER              🟢 ONLINE    📊 📁    │
├──────────┬──────────────────────────────────┬───────────────┤
│ MODELS   │  PROMPT & OUTPUT                 │  TELEMETRY    │
│          │                                  │               │
│ □ llama2 │  ┌──────────────────────────┐   │  CPU: 45%     │
│ ☑ mistral│  │ Enter prompt here...     │   │  ▓▓▓▓▓░░░░░   │
│ □ codellama  │                          │   │               │
│          │  └──────────────────────────┘   │  RAM: 60%     │
│ MODE:    │  [EXECUTE]  [Clear]              │  ▓▓▓▓▓▓░░░░   │
│ ●SINGLE  │                                  │               │
│ ○PARALLEL│  [OUTPUT] [GRAPH] [LOGS]         │  VRAM: 75%    │
│ ○CHAIN   │                                  │  ▓▓▓▓▓▓▓░░░   │
│          │  ┌─────────────────────────┐    │               │
│ FILES    │  │ Model: llama2            │    │  WORKSPACES   │
│ 📄 Drop  │  │ Streaming...             │    │  □ Case_001   │
│   here   │  │ Token output here...     │    │  ☑ Case_002   │
│          │  └─────────────────────────┘    │  □ Case_003   │
│ AGENTS   │                                  │               │
│ Research │                                  │  [Save]       │
└──────────┴──────────────────────────────────┴───────────────┘
```

---

**Happy investigating! 🕵️‍♂️🔍**
