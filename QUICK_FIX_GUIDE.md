# Quick Fix Guide

## Issue 1: Repository in Wrong Location

**Current location:** `/Users/travisheller/Sites/localhost/media-manager-app/media-manager-site/`  
**Should be:** `/Users/travisheller/Sites/localhost/media-manager-site/`

### Fix:
```bash
cd /Users/travisheller/Sites/localhost
mv media-manager-app/media-manager-site .
```

## Issue 2: .pnpm-store in Repository

The `.pnpm-store/` directory (98MB+) was accidentally committed and needs to be removed.

### Fix:
```bash
# Navigate to the repository (after moving it)
cd /Users/travisheller/Sites/localhost/media-manager-site

# Run the fix script
../media-manager-app/marketing-site/FIX_PNPM_STORE_IN_NEW_REPO.sh
```

**Or manually:**
```bash
cd /Users/travisheller/Sites/localhost/media-manager-site

# Remove from git
git rm -r --cached .pnpm-store

# Update .gitignore
echo "" >> .gitignore
echo "# pnpm cache" >> .gitignore
echo ".pnpm-store/" >> .gitignore

# Commit and push
git add .gitignore
git commit -m "chore: remove .pnpm-store from repository"
git push --force-with-lease
```

## Complete Fix Sequence

```bash
# Step 1: Move repository to correct location
cd /Users/travisheller/Sites/localhost
mv media-manager-app/media-manager-site .

# Step 2: Fix .pnpm-store issue
cd media-manager-site
../media-manager-app/marketing-site/FIX_PNPM_STORE_IN_NEW_REPO.sh

# Step 3: Verify everything works
pnpm install
pnpm build
```

## Verify Final Structure

```bash
cd /Users/travisheller/Sites/localhost
ls -la

# Should see:
# - media-manager-app/     (original repo)
# - media-manager-site/    (new repo)
```

Both directories should be at the same level under `localhost/`.
