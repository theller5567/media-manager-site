# Fix .pnpm-store in New Repository

## Problem

The migration included `.pnpm-store/` directory which contains large cache files (98MB+) that shouldn't be in git.

## Solution

Run these commands in the new repository:

```bash
cd /Users/travisheller/Sites/localhost/media-manager-site

# Remove .pnpm-store from git tracking
git rm -r --cached .pnpm-store

# Ensure .gitignore excludes it
echo "" >> .gitignore
echo "# pnpm cache" >> .gitignore
echo ".pnpm-store/" >> .gitignore

# Commit the fix
git add .gitignore
git commit -m "chore: remove .pnpm-store from repository

- .pnpm-store is a cache directory and shouldn't be committed
- Added to .gitignore to prevent future commits"

# Force push to update remote (since we're removing large files)
git push --force-with-lease
```

## Why This Happened

The `git archive` command includes all tracked files, and `.pnpm-store/` was likely tracked in the original monorepo. The `.gitignore` should have excluded it, but it may not have been properly configured.

## Prevention

After fixing, verify `.gitignore` includes:
```
.pnpm-store/
node_modules/
.next/
.vercel/
dist/
build/
*.log
```
