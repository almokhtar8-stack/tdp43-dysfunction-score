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

**I have got a few instructions to follow after running the previous command**

==> Next steps: 
- Run these commands in your terminal to add Homebrew to your PATH:
    echo >> /home/rorym/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >> /home/rorym/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
- Install Homebrew's dependencies if you have sudo access:
    sudo apt-get install build-essential
  For more information, see:
    https://docs.brew.sh/Homebrew-on-Linux
- We recommend that you install GCC:
    brew install gcc
- Run brew help to get started
- Further documentation:
    https://docs.brew.sh

  **I followed the prompt using the code below**
**Make sure you're on the right path**

It should be similar to this path  
(base) username@name:/mnt/c/Users/username$
``` bash
#Run these commands in your terminal to add Homebrew to your PATH:
    echo >> /home/rorym(chnge to your username)/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >> /home/rorym(change to your username)/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
#Install Homebrew's dependencies if you have sudo access:
    sudo apt-get install build-essential
[sudo] password for rorym (username): (enter your password)

 #We recommend that you install GCC:
    brew install gcc
```
### Step 2: Install GitHub CLI & Login

**Now I can Install Github (AGAIN)**
```bash
brew install gh
```


