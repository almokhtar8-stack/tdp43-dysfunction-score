# Git Commands Cheat Sheet - Quick Reference

**For:** TDP-43 Project Team

---

## 🔄 DAILY WORKFLOW

**Every time you work:**
```bash
# 1. Navigate to project
cd ~/tdp43-dysfunction-score

# 2. Get latest changes from team
git pull origin main

# 3. Do your work (create/edit files)

# 4. Check what changed
git status

# 5. Add your changes
git add .

# 6. Save with message
git commit -m "describe what you did"

# 7. Upload to GitHub
git push origin main
```

---

## 📋 ESSENTIAL COMMANDS

| Command | What It Does |
|---------|--------------|
| `git pull origin main` | Download latest changes from GitHub |
| `git status` | See what files you changed |
| `git add .` | Mark all changes to be saved |
| `git add filename` | Mark specific file to be saved |
| `git commit -m "message"` | Save changes with description |
| `git push origin main` | Upload changes to GitHub |
| `pwd` | Show current location |
| `cd path` | Navigate to folder |

---

## ✍️ COMMIT MESSAGE EXAMPLES

### ✅ GOOD:
```bash
git commit -m "add genome-wide DESeq2 analysis script"
git commit -m "fix normalization bug in plotting"
git commit -m "update methods section with new approach"
git commit -m "add volcano plot for 247 DEGs"
```

### ❌ BAD:
```bash
git commit -m "update"
git commit -m "fix"
git commit -m "work"
git commit -m "changes"
```

---

## 🆘 TROUBLESHOOTING

### Problem: "Permission denied"
```bash
# Re-authenticate
gh auth login
```

### Problem: "Your branch is behind"
```bash
# Get latest changes first
git pull origin main
# Then try push again
git push origin main
```

### Problem: "Nothing to commit"
```bash
# Check what changed
git status
# Make sure you saved your file!
```

---

## 🎯 QUICK REFERENCE
```
┌─────────────────────────────────────┐
│  BEFORE WORK:                       │
│  git pull origin main               │
│                                     │
│  AFTER WORK:                        │
│  git add .                          │
│  git commit -m "message"            │
│  git push origin main               │
└─────────────────────────────────────┘
```

---

**Questions? Ask in WhatsApp group!**

**Last Updated:** February 11, 2026
