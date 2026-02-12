# Rahma's Practice File
## This document will show the commands, errors, and solutions 

First, switch user into rorym (my username)

```bash
wsl -u rorym (replace with your username)
```
Now my terminal is switched to 
(base) username@name:/mnt/c/Users/username$ 

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

**Then Login into GitHub**
```bash
gh auth login
```
Answer the following questions: 
? Where do you use GitHub? GitHub.com

? What is your preferred protocol for Git operations on this host? HTTPS

? Authenticate Git with your GitHub credentials? Yes

? How would you like to authenticate GitHub CLI? Login with a web browser

**! First copy your one-time code: CFEF-A1D5 (yours will be different)**

**I got an error**

! Failed opening a web browser at https://github.com/login/device
  exit status 3
  Please try entering the URL in your browser manually

ttps://github.com/login/device

**I then copied and pasted the URL in my browser manually and I was asked to write the one-time code**
**The message I got after entering the one-time code**

✓ Authentication complete.

- gh config set -h github.com git_protocol https

✓ Configured git protocol

! Authentication credentials saved in plain text

✓ Logged in as rmabufoor-sketch (it will be your username)


### Step 3: Configure Git (Tell it who you are)
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Step 4: Clone the Project
```bash
# Go to Desktop
cd ~/Desktop

# Download the project
git clone https://github.com/almokhtar8-stack/tdp43-dysfunction-score.git

# Enter the folder
cd tdp43-dysfunction-score

# Check you're in the right place
pwd
```

**Should show:** `/home/[yourname]/Desktop/tdp43-dysfunction-score` or similar

**I didn't get any error here**

### Step 5: Test Your Access
```bash
# Make a small test
echo "- Your Name (tested successfully!)" >> CONTRIBUTORS.md

# Add it
git add CONTRIBUTORS.md

# Commit
git commit -m "test: add my name to contributors"

# Push
git push origin main
```

**I got an error here because I did not accept the envite to be a contributor** 
remote: Permission to almokhtar8-stack/tdp43-dysfunction-score.git denied to rmabufoor-sketch.

fatal: unable to access 'https://github.com/almokhtar8-stack/tdp43-dysfunction-score.git/': The requested URL returned error: 403


**Check your email and accept the invite then run step 5 again**

### Errors I got after running step 5,

I ran this code to check if the file exixts
```bash
#Verify the file exists:
ls CONTRIBUTORS.md
```
**Error

ls: cannot access 'CONTRIBUTORS.md': No such file or directory

I ran another code:
```bash
# list all files
ls -F
```
**The output:

README.md*  TEAM_GITHUB_GUIDE.md*  data/  docs/  requirements.txt*  scripts/
The file CONTRIBUTORS.md does not exist
```bash
# file does not exist
  echo "# Contributors" > CONTRIBUTORS.md
  echo "- Rahma (tested successfully!)" >> CONTRIBUTORS.md
```
**Error 

-bash: !: event not found

**Changed the double quotes to single ones**

```bash # use single quotes (') instead of double quotes
  echo '- Rahma (yourname) (tested successfully!)' >> CONTRIBUTORS.md
  # Verify it looks right
  cat CONTRIBUTORS.md
```
**The output**

-Contributors

-Rahma (tested successfully!)

**Submit the changes**
```bash
#Submit the changes:
git add CONTRIBUTORS.md
git commit -m "docs: add Rahma (your name) to contributors"
git push origin main
```

### Create a testing file, change my name to your name
``` bash
echo "# Rahma's Practice File" > RAHMA_TEST.md
cat RAHMA_TEST.md
```
### Add file to GitHub
```bash
git add RAHMA_TEST.md
# commit to command
git commit -m "add Rahma's practice file"
```
**The Output**
[main 3286cbf] add Rahma's practice file
 1 file changed, 1 insertion(+)
 create mode 100644 RAHMA_TEST.md

### Make sure the changes are saved and uploaded to the GitHub website

```bash
git push origin main
```

### BEFORE You Start Working
```bash
# 1. Navigate to project folder
cd ~/Desktop/tdp43-dysfunction-score

# 2. Get latest changes from team
git pull origin main
```

**This downloads any work your teammates pushed.**

#### I chose Option B: Create New File
```bash
# Create new script, in the file (01_quality_control), file name (Rahma_script), it's an R file
nano  nano scripts/01_quality_control/Rahma_script.R
# add the file to github
git add scripts/01_quality_control/Rahma_script.R
#commit the change
git commit -m "feat: add quality control script for Rahma"
# push to github
git push origin main


# Write your code
# Press Ctrl+O to save
# Press Enter
# Press Ctrl+X to exit
```

### Teseting the file

 ``` bash
# Testing the file
nano scripts/01_quality_control/Rahma_script.R

# Stage the new edits:
git add scripts/01_quality_control/Rahma_script.R

# Snapshot the changes:
git commit -m "Update Rahma script with new analysis steps"

# Upload to GitHub:
git push origin main

# show what's in my file
cat scripts/01_quality_control/Rahma_script.R

# The output
# Testing the file
# In this file, I will write the script (quality control script)
```
**I then started the Environment Setup**

### A few reminders:

**Navigation, make sure you're on the right path**
(genomics) username@name:/mnt/c/Users/rorym/tdp43-dysfunction-score$

```bash
cd /mnt/c/Users/username/tdp43-dysfunction-score    # Go to project
pwd                                                 # Where am I?
ls                                                  # List files
ls -la                                              # List all (including hidden)
```

**Git Basics**
```bash
git status                              # What changed?
git pull origin main                    # Get latest from team
git add .                               # Add all changes
git add path/to/file.R                  # Add specific file
git commit -m "message"                 # Save changes locally
git push origin main                    # Upload to GitHub
```

