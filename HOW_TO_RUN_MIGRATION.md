# How to Run the Migration Script

## The Script

**Script name:** `migrate-to-new-repo-fast.sh`  
**Location:** `/Users/travisheller/Sites/localhost/media-manager-app/marketing-site/`

## Where to Run It

Run the script from **inside the `marketing-site` directory**:

```bash
cd /Users/travisheller/Sites/localhost/media-manager-app/marketing-site
./migrate-to-new-repo-fast.sh git@github.com:yourusername/media-manager-site.git
```

**Replace `yourusername/media-manager-site.git` with your actual GitHub repository URL.**

## What It Does

1. Detects the existing empty `media-manager-site` directory at `/Users/travisheller/Sites/localhost/media-manager-site/`
2. Uses that existing git repository
3. Copies only source files (no node_modules) from `marketing-site/` into `media-manager-site/`
4. Commits and pushes to GitHub

## Complete Command

```bash
# Step 1: Navigate to marketing-site directory
cd /Users/travisheller/Sites/localhost/media-manager-app/marketing-site

# Step 2: Run the script (replace with your actual repo URL)
./migrate-to-new-repo-fast.sh git@github.com:theller5567/media-manager-site.git
```

## After Migration

After the script completes, fix the `.pnpm-store` issue:

```bash
# Navigate to the new repository
cd /Users/travisheller/Sites/localhost/media-manager-site

# Run the fix script
../media-manager-app/marketing-site/FIX_PNPM_STORE_IN_NEW_REPO.sh
```

## Summary

- **Script:** `migrate-to-new-repo-fast.sh`
- **Run from:** `marketing-site/` directory
- **Target:** Existing empty `media-manager-site/` directory (will be populated)
