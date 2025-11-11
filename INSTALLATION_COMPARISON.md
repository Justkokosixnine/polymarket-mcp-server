# 🔧 Installation Method Comparison

Quick reference guide to choose the best installation method for your needs.

---

## Comparison Table

| Feature | GUI Wizard | Auto Script | Docker | Manual |
|---------|-----------|-------------|--------|--------|
| **Time Required** | 5 min | 3 min | 2 min | 10 min |
| **Difficulty** | ⭐ Easy | ⭐ Easy | ⭐⭐ Medium | ⭐⭐⭐ Advanced |
| **Prerequisites** | Python 3.10+ | Python 3.10+ | Docker | Python 3.10+ |
| **User Interface** | Visual GUI | Terminal | Terminal | Terminal |
| **Auto-Config** | ✅ Yes | ✅ Yes | ⚠️ Manual .env | ❌ No |
| **Claude Setup** | ✅ Automatic | ✅ Automatic | ⚠️ Manual | ❌ Manual |
| **Validation** | ✅ Built-in | ✅ Built-in | ⚠️ Basic | ❌ None |
| **Best For** | Beginners | Terminal users | Docker users | Customization |
| **Platform** | All | macOS/Linux | All | All |

---

## Detailed Breakdown

### 🎨 GUI Setup Wizard

**Pros:**
- Visual interface with step-by-step guidance
- Real-time input validation
- Automatic Claude Desktop configuration
- Preset safety limit templates
- Built-in testing
- Best error messages

**Cons:**
- Requires display (no headless)
- Slightly slower than automation
- Python tkinter dependency

**Best For:**
- First-time users
- Visual learners
- Windows users
- Those unfamiliar with terminal

**Launch:**
```bash
python setup_wizard.py
```

---

### ⚡ Automated Script

**Pros:**
- Fast installation (3 minutes)
- Automatic dependency management
- Smart environment detection
- Claude Desktop auto-configuration
- One-command setup
- Script can be reviewed before running

**Cons:**
- Terminal only
- Less guidance than GUI
- Windows requires different script

**Best For:**
- Developers
- Terminal-comfortable users
- Automated deployments
- CI/CD pipelines

**Launch:**
```bash
# macOS/Linux
./install.sh

# Windows
install.ps1
```

---

### 🐳 Docker

**Pros:**
- Fastest setup (2 minutes)
- Isolated environment
- Consistent across platforms
- Easy to remove/reinstall
- No Python version conflicts
- Production-ready

**Cons:**
- Requires Docker knowledge
- Manual .env configuration
- Manual Claude Desktop setup
- Additional Docker overhead
- Harder to debug

**Best For:**
- Docker users
- Production deployments
- Multiple instances
- Isolated testing

**Launch:**
```bash
docker-compose up -d
```

---

### 🔧 Manual Installation

**Pros:**
- Full control
- Custom configurations
- Understand each step
- No automation black box
- Easy to customize
- Good for learning

**Cons:**
- Time-consuming (10 minutes)
- Error-prone
- No automatic validation
- Manual Claude configuration
- Requires technical knowledge

**Best For:**
- Advanced users
- Custom setups
- Development
- Troubleshooting
- Learning the system

**Steps:**
1. Clone repository
2. Create virtual environment
3. Install dependencies
4. Configure .env
5. Set up Claude Desktop
6. Test manually

---

## Decision Tree

```
Start Here
    │
    ▼
Are you comfortable with terminal?
    │
    ├─ No ──────────► GUI Wizard
    │                 (python setup_wizard.py)
    │
    └─ Yes
        │
        ▼
    Do you use Docker?
        │
        ├─ Yes ─────► Docker
        │             (docker-compose up -d)
        │
        └─ No
            │
            ▼
        Need customization?
            │
            ├─ No ──► Auto Script
            │         (./install.sh)
            │
            └─ Yes ─► Manual
                      (Step-by-step)
```

---

## Platform-Specific Recommendations

### macOS
1. **Best**: GUI Wizard or Auto Script
2. **Alternative**: Docker
3. **Advanced**: Manual

### Windows
1. **Best**: GUI Wizard
2. **Alternative**: Auto Script (PowerShell)
3. **Advanced**: Manual or Docker

### Linux
1. **Best**: Auto Script
2. **Alternative**: Docker
3. **Visual**: GUI Wizard
4. **Advanced**: Manual

---

## Setup Time Comparison

```
┌─────────────────────────────────────────────────┐
│         Installation Time Breakdown             │
├─────────────────────────────────────────────────┤
│                                                 │
│  GUI Wizard:     ████████ 5 min                │
│                  ├─ Setup: 3 min                │
│                  └─ Config: 2 min               │
│                                                 │
│  Auto Script:    ██████ 3 min                  │
│                  ├─ Setup: 2 min                │
│                  └─ Config: 1 min               │
│                                                 │
│  Docker:         ████ 2 min                    │
│                  ├─ Pull: 1 min                 │
│                  └─ Start: 1 min                │
│                                                 │
│  Manual:         ████████████ 10 min           │
│                  ├─ Setup: 5 min                │
│                  ├─ Config: 3 min               │
│                  └─ Test: 2 min                 │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## Feature Matrix

| Feature | GUI | Script | Docker | Manual |
|---------|-----|--------|--------|--------|
| Installation Type Selection | ✅ | ✅ | ⚠️ | ⚠️ |
| Wallet Validation | ✅ | ✅ | ❌ | ❌ |
| Safety Limit Presets | ✅ | ⚠️ | ❌ | ❌ |
| Claude Auto-Config | ✅ | ✅ | ❌ | ❌ |
| Visual Feedback | ✅ | ⚠️ | ❌ | ❌ |
| Error Recovery | ✅ | ✅ | ⚠️ | ❌ |
| Rollback on Failure | ✅ | ✅ | ✅ | ❌ |
| Config Preview | ✅ | ⚠️ | ❌ | ❌ |
| Test Execution | ✅ | ✅ | ⚠️ | ❌ |
| Unattended Install | ❌ | ✅ | ✅ | ❌ |

Legend:
- ✅ Full support
- ⚠️ Partial support
- ❌ Not available

---

## Upgrade Paths

### From Demo to Full

**GUI Wizard:**
```bash
python setup_wizard.py
# Select "Full Installation" in step 2
```

**Auto Script:**
```bash
./install.sh --upgrade-to-full
```

**Docker:**
```bash
# Edit .env to add wallet credentials
docker-compose restart
```

**Manual:**
```bash
# Edit .env
nano .env
# Add POLYGON_PRIVATE_KEY and POLYGON_ADDRESS
```

---

## Common Installation Issues

### GUI Wizard
- **Issue**: "tkinter not found"
  - **Fix**: `pip install tk` or use Auto Script

### Auto Script
- **Issue**: "Permission denied"
  - **Fix**: `chmod +x install.sh`

### Docker
- **Issue**: "Container won't start"
  - **Fix**: Check `docker logs polymarket-mcp`

### Manual
- **Issue**: Various errors
  - **Fix**: See [VISUAL_INSTALL_GUIDE.md](VISUAL_INSTALL_GUIDE.md)

---

## Recommendations by Use Case

### For Learning
- **Best**: GUI Wizard (visual feedback)
- **Alternative**: Manual (understand each step)

### For Production
- **Best**: Docker (isolated, consistent)
- **Alternative**: Auto Script (tested, reliable)

### For Development
- **Best**: Manual (full control)
- **Alternative**: Auto Script (fast iteration)

### For Testing
- **Best**: Docker (easy cleanup)
- **Alternative**: GUI Wizard (quick setup)

### For Automation
- **Best**: Auto Script (scriptable)
- **Alternative**: Docker (containerized)

---

## Post-Installation

All methods require:
1. **Restart Claude Desktop**
2. **Test the connection**
3. **Verify tools are available**

Test command in Claude:
```
"Show me trending markets on Polymarket"
```

---

**Choose your method and get started!** 🚀

See [VISUAL_INSTALL_GUIDE.md](VISUAL_INSTALL_GUIDE.md) for detailed installation instructions for each method.
