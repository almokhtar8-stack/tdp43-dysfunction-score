# Rahma's Practice File
## This document will show the commands, errors, and solutions 

First, switch user into rorym (my username)

```bash
wsl -u rorym (replace with your username)
```
Now my terminal is switched to 
(base) rorym@Rahma:/mnt/c/Users/rorym$ 

### Step 1: Check if You Have Git
Start setting up GitHub access
```bash
git --version
git version 2.43.0
```
### Step 2: Install GitHub CLI & Login
```bash
# Install GitHub CLI
brew install gh

# Login to GitHub
gh auth login
```

**I got an error message** 

Command 'brew' not found, did you mean:
  command 'qbrew' from deb qbrew (0.4.1-8build1)
  command 'brec' from deb bplay (0.991-10.2)
Try: sudo apt install <deb name>

**install Homebrew for Linux**
I used the following code:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```


