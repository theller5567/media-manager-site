# Move Repository to Correct Location

## Problem

The migration script created `media-manager-site` inside `media-manager-app` instead of alongside it.

**Current (wrong) location:**
```
/Users/travisheller/Sites/localhost/media-manager-app/media-manager-site/
```

**Desired (correct) location:**
```
/Users/travisheller/Sites/localhost/media-manager-site/
```

## Solution: Move the Repository

### Option 1: Move Existing Repository (Recommended)

Since the migration already completed, just move it:

```bash
# Navigate to localhost directory
cd /Users/travisheller/Sites/localhost

# Move the repository up one level
mv media-manager-app/media-manager-site .

# Verify it's in the right place
ls -la media-manager-site

# The git remote should still work fine
cd media-manager-site
git remote -v
```

### Option 2: Re-run Migration (If Option 1 Doesn't Work)

If moving doesn't work or you prefer a clean start:

```bash
# Remove the incorrectly placed repo
rm -rf /Users/travisheller/Sites/localhost/media-manager-app/media-manager-site

# Run the fixed migration script
cd /Users/travisheller/Sites/localhost/media-manager-app/marketing-site
./migrate-to-new-repo-fast.sh git@github.com:yourusername/media-manager-site.git
```

## After Moving

1. **Fix .pnpm-store issue:**
   ```bash
   cd /Users/travisheller/Sites/localhost/media-manager-site
   ../media-manager-app/marketing-site/FIX_PNPM_STORE_IN_NEW_REPO.sh
   ```

2. **Verify structure:**
   ```bash
   cd /Users/travisheller/Sites/localhost
   ls -la
   # Should see:
   # - media-manager-app/
   # - media-manager-site/
   ```

3. **Test the new location:**
   ```bash
   cd media-manager-site
   git status
   pnpm install  # Install dependencies
   pnpm build    # Verify build works
   ```

## Directory Structure (After Fix)

```
/Users/travisheller/Sites/localhost/
├── media-manager-app/          # Original monorepo (frontend only)
│   ├── frontend/
│   ├── .gitignore
│   └── pnpm-workspace.yaml
└── media-manager-site/         # New standalone marketing site
    ├── app/
    ├── components/
    ├── package.json
    └── .gitignore
```
