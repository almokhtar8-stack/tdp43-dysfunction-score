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

** I got an error message 
Command 'brew' not found, did you mean:
  command 'qbrew' from deb qbrew (0.4.1-8build1)
  command 'brec' from deb bplay (0.991-10.2)
Try: sudo apt install <deb name>
(base) rorym@Rahma:/mnt/c/Users/rorym$ ^C
(base) rorym@Rahma:/mnt/c/Users/rorym$ # Install GitHub CLI
brew install gh

# Login to GitHub
gh auth login
Command 'brew' not found, did you mean:
  command 'brec' from deb bplay (0.991-10.2)
  command 'qbrew' from deb qbrew (0.4.1-8build1)
Try: sudo apt install <deb name>
Command 'gh' not found, but can be installed with:
sudo snap install gh  # version 2.74.0-19-gea8fc856e, or
sudo apt  install gh  # version 2.45.0-1ubuntu0.3
See 'snap info gh' for additional versions.
(base) rorym@Rahma:/mnt/c/Users/rorym$ #install Homebrew for Linux
(base) rorym@Rahma:/mnt/c/Users/rorym$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
