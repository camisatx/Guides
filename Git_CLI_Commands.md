# Git Command Line Interface Commands

This file covers many of the common commands used with Git. Since Git is not platform specific, these commands are applicable to GitHub, GitLab, BitBucket, etc.

The purpose of this file is to help make using Git via command line less intimidating. There will always be a place for SourceTree and VCS within PyCharm, but using Git with the command line has very high efficiency for certain tasks.


# Basic Git Operations

Initialize a git repository in the current folder

```bash
git init .
```

Add all folders within current folder to be staged for commit to git

```bash
git add .
```

Commit the staged files

```bash
git commit
```

Add a remote git server to store the repository on

```bash
git remote add origin <remote repo url/ssh>
```

Push the committed files to the remote repo's master branch

```bash
git push origin master
```

View the status of all files within the current folder with respect to git (new, unstaged, changed, etc.)

```bash
git status
```

View the specific line changes in files not staged for commit

```bash
git diff
```


# Git Commit

Commit the staged files

```bash
git commit
```

Commit the staged files using the attached commit message

```bash
git commit -m "<commit message>"
```

Commit all of the modified files (excluding any files yet to be 'add'ed) using the attached commit message

```bash
git commit -am "<commit message>"
```


# Git File Management

Move a file (with git recognizing the change)

```bash
git mv <old file> <new file>
```


# Git Remote Repo

Set a new remote repository (GitHub, GitLab, etc.)

```bash
git remote add origin <repo url/ssh>
```

Change the existing remote repository (i.e. GitHub from HTTPS to SSH)

```bash
git remote set-url origin git@github.com:<username>/<repo name>.git
```

Verify the remote url/ssh

```bash
git remote -v
```

Push the local committed changes to the remote repo

```bash
git push origin master
```


# Git Staging

Stage all folders within the current folder

```bash
git add .
```

Unstage a file

```bash
git rm --cached <file>
```

Add a .pyc exclusion to a .gitignore file (creates if it doesn't exist)

```bash
echo "*.pyc" >> .gitignore
```


# Git Tags

Create a repo tag based on the current branch checked out

```bash
git tag <tag name>
```

Push the tag to the remote repo

```bash
git push origin <tag name>
```


# Git View Changes

View the status of all files within the current folder with respect to git (new, unstaged, changed, etc.)

```bash
git status
```

View the specific line changes in files not staged for commit

```bash
git diff
```

View the specific line changes in files that are staged for commit

```bash
git diff --staged
```

View the specific line changes in files that are staged for commit, detecting any files that were moved locations

```bash
git diff --staged -M
```

View a complete repo history (very verbose without --oneline argument on the end)

```bash
git log
#
# Arguments:
#   --decorate: Show the head and branch each commit was on at time of commit
#   --graph: Show a commit tree
#   --oneline: Fit each commit on one line, showing the commit hash and commit message
```
