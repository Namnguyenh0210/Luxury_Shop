#!/bin/bash
# ==============================================================================
# RUN.SH - LUXURY SHOP STARTUP SCRIPT (Backend + Frontend)
# Optimized for macOS/Linux
# ==============================================================================

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  🚀 LUXURY SHOP - Full Stack Startup${NC}"
echo -e "${BLUE}================================================${NC}"

# Variables to store PIDs for cleanup
BACKEND_PID=""
FRONTEND_PID=""
TAIL_PID=""

# Cleanup function to stop all services on Ctrl+C
cleanup() {
    echo -e "\n${YELLOW}🛑 Stopping services...${NC}"
    
    if [ ! -z "$BACKEND_PID" ]; then
        echo -e "${YELLOW}   ⏹  Stopping Backend (PID: $BACKEND_PID)${NC}"
        kill $BACKEND_PID 2>/dev/null || true
    fi
    
    if [ ! -z "$FRONTEND_PID" ]; then
        echo -e "${YELLOW}   ⏹  Stopping Frontend (PID: $FRONTEND_PID)${NC}"
        kill $FRONTEND_PID 2>/dev/null || true
    fi

    if [ ! -z "$TAIL_PID" ]; then
        kill $TAIL_PID 2>/dev/null || true
    fi
    
    echo -e "${GREEN}✅ All services stopped!${NC}"
    exit 0
}

# Trap Ctrl+C signals
trap cleanup SIGINT SIGTERM

# 1. Check Dependencies
echo -e "\n${BLUE}📦 Checking dependencies...${NC}"

# Check Java
if ! command -v java &> /dev/null; then
    echo -e "${RED}❌ Java not found! Please install Java 17+${NC}"
    exit 1
fi
echo -e "${GREEN}   ✓ Java: $(java -version 2>&1 | head -n 1)${NC}"

# Check Maven or Wrapper
if command -v mvn &> /dev/null; then
    MVN_CMD="mvn"
elif [ -f "./mvnw" ]; then
    chmod +x ./mvnw
    MVN_CMD="./mvnw"
else
    echo -e "${RED}❌ Maven not found!${NC}"
    exit 1
fi
echo -e "${GREEN}   ✓ Maven: OK${NC}"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js not found! Please install Node.js 18+${NC}"
    exit 1
fi
echo -e "${GREEN}   ✓ Node.js: $(node -v)${NC}"

# 2. Cleanup Old Processes on Ports
echo -e "\n${BLUE}🧹 Cleaning up old processes...${NC}"

# Release Backend port (8080)
BACKEND_OLD_PIDS=$(lsof -ti:8080 2>/dev/null || true)
if [ ! -z "$BACKEND_OLD_PIDS" ]; then
    echo -e "${YELLOW}   ⏹  Killing processes on port 8080${NC}"
    echo "$BACKEND_OLD_PIDS" | xargs kill -9 2>/dev/null || true
fi

# Release Frontend ports
for port in 5173 5174 5175; do
    FRONTEND_OLD_PIDS=$(lsof -ti:$port 2>/dev/null || true)
    if [ ! -z "$FRONTEND_OLD_PIDS" ]; then
        echo "$FRONTEND_OLD_PIDS" | xargs kill -9 2>/dev/null || true
    fi
done
echo -e "${GREEN}   ✓ Ports are clean${NC}"
sleep 1

# 3. Setup Frontend Dependencies
if [ ! -d "frontend/node_modules" ]; then
    echo -e "\n${BLUE}📥 Installing Frontend dependencies...${NC}"
    cd frontend && npm install && cd ..
    echo -e "${GREEN}✅ Frontend dependencies installed!${NC}"
else
    echo -e "${GREEN}✅ Frontend dependencies already exist${NC}"
fi

# 4. Start Backend (Spring Boot)
echo -e "\n${BLUE}🔧 Starting Backend (Spring Boot)...${NC}"
echo -e "${YELLOW}   Logs: tail -f backend.log${NC}"

# Run backend in background
$MVN_CMD spring-boot:run > backend.log 2>&1 &
BACKEND_PID=$!
echo -e "${GREEN}   ✓ Backend started (PID: $BACKEND_PID)${NC}"

# 5. Start Frontend (Vite/Vue)
echo -e "\n${BLUE}🎨 Starting Frontend (Vite/Vue)...${NC}"
echo -e "${YELLOW}   Logs: tail -f frontend.log${NC}"

cd frontend
npm run dev > ../frontend.log 2>&1 &
FRONTEND_PID=$!
cd ..
echo -e "${GREEN}   ✓ Frontend started (PID: $FRONTEND_PID)${NC}"

# 6. Wait for Backend Readiness
echo -e "\n${YELLOW}⏳ Waiting for Backend to be ready...${NC}"
READY=0
for i in {1..40}; do
    if curl -s http://localhost:8080/actuator/health > /dev/null 2>&1 || \
       curl -s http://localhost:8080 > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Backend is READY!${NC}"
        READY=1
        break
    fi
    sleep 1
done

if [ $READY -eq 0 ]; then
    echo -e "${RED}⚠️  Backend is taking too long or failed to start.${NC}"
    echo -e "${YELLOW}   Check backend.log for errors.${NC}"
fi

# 7. Final Info
echo -e "\n${GREEN}================================================${NC}"
echo -e "${GREEN}  ✨ SYSTEM IS RUNNING!${NC}"
echo -e "${GREEN}================================================${NC}"
echo -e "  🌐 Frontend:  ${BLUE}http://localhost:5173${NC}"
echo -e "  🔧 Backend:   ${BLUE}http://localhost:8080${NC}"
echo -e "  📡 API:       ${BLUE}http://localhost:8080/api${NC}"
echo -e ""
echo -e "${RED}⚠️  Press Ctrl+C to stop all services.${NC}"

# Open browser on macOS
if [[ "$OSTYPE" == "darwin"* ]] && [ $READY -eq 1 ]; then
    sleep 2
    open http://localhost:5173 2>/dev/null || true
fi

# Show logs
tail -f backend.log frontend.log &
TAIL_PID=$!

# Wait for completion
wait $BACKEND_PID $FRONTEND_PID
