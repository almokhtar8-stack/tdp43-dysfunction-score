# Rahma's Practice File
# Set up Code

## This document will show the commands, errors, and solutions 

### First, switch user into rorym (my username)
PS C:\Users\rorym> wsl -u rorym
(base) rorym@Rahma:/mnt/c/Users/rorym$ git --version
git version 2.43.0
(base) rorym@Rahma:/mnt/c/Users/rorym$ # Install GitHub CLI
brew install gh
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
