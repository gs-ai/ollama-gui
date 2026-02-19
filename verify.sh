#!/bin/bash
# Installation verification script

echo "🔍 Verifying Ollama GUI Command Center Installation"
echo "=================================================="
echo ""

ERRORS=0

# Check Python
echo -n "Checking Python 3.8+... "
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version | awk '{print $2}')
    echo "✅ Found Python $PYTHON_VERSION"
else
    echo "❌ Python 3 not found"
    ERRORS=$((ERRORS + 1))
fi

# Check Node.js
echo -n "Checking Node.js 16+... "
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "✅ Found Node.js $NODE_VERSION"
else
    echo "❌ Node.js not found"
    ERRORS=$((ERRORS + 1))
fi

# Check npm
echo -n "Checking npm... "
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo "✅ Found npm $NPM_VERSION"
else
    echo "❌ npm not found"
    ERRORS=$((ERRORS + 1))
fi

# Check Ollama
echo -n "Checking Ollama... "
if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo "✅ Ollama is running on localhost:11434"
else
    echo "⚠️  Ollama is not running (optional for development)"
fi

# Check Python modules syntax
echo -n "Checking Python modules... "
if python3 -m py_compile backend/main.py agents/investigative_agent.py graph/entity_extractor.py graph/graph_builder.py ingestion/file_processor.py telemetry/system_monitor.py 2>&1 > /dev/null; then
    echo "✅ All Python modules OK"
else
    echo "❌ Python syntax errors found"
    ERRORS=$((ERRORS + 1))
fi

# Check JavaScript files
echo -n "Checking JavaScript files... "
if node -c frontend/app.js 2>&1 > /dev/null && node -c frontend/main.js 2>&1 > /dev/null; then
    echo "✅ All JavaScript files OK"
else
    echo "❌ JavaScript syntax errors found"
    ERRORS=$((ERRORS + 1))
fi

# Check required files
echo -n "Checking required files... "
REQUIRED_FILES=(
    "backend/main.py"
    "frontend/index.html"
    "frontend/app.js"
    "frontend/styles.css"
    "frontend/main.js"
    "requirements.txt"
    "package.json"
    "run.sh"
    "run.bat"
)

MISSING=0
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Missing: $file"
        MISSING=$((MISSING + 1))
    fi
done

if [ $MISSING -eq 0 ]; then
    echo "✅ All required files present"
else
    ERRORS=$((ERRORS + 1))
fi

# Check directory structure
echo -n "Checking directory structure... "
REQUIRED_DIRS=(
    "backend"
    "frontend"
    "agents"
    "ingestion"
    "graph"
    "telemetry"
)

MISSING_DIRS=0
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "❌ Missing directory: $dir"
        MISSING_DIRS=$((MISSING_DIRS + 1))
    fi
done

if [ $MISSING_DIRS -eq 0 ]; then
    echo "✅ All required directories present"
else
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "=================================================="
if [ $ERRORS -eq 0 ]; then
    echo "✅ Installation verified successfully!"
    echo ""
    echo "Next steps:"
    echo "  1. Ensure Ollama is running: ollama serve"
    echo "  2. Start the application: ./run.sh (or run.bat on Windows)"
    echo ""
    exit 0
else
    echo "❌ Found $ERRORS error(s)"
    echo ""
    echo "Please fix the errors above before running the application."
    echo ""
    exit 1
fi
