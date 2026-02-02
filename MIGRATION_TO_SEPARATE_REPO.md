# Migration Guide: Marketing Site to Separate Repository

## Overview

This guide documents the migration of `marketing-site` from the monorepo (`media-manager-app`) to its own standalone repository.

## Migration Steps

### 1. Create New GitHub Repository

1. Go to GitHub and create a new repository:
   - Name: `media-manager-marketing-site` (or your preferred name)
   - Description: "Marketing website for Media Manager App"
   - Visibility: Private or Public (your choice)
   - **Do NOT** initialize with README, .gitignore, or license (we're bringing our own)

### 2. Initialize New Repository Locally

```bash
# Navigate to parent directory
cd /Users/travisheller/Sites/localhost

# Clone the new empty repo (replace with your actual repo URL)
git clone git@github.com:yourusername/media-manager-marketing-site.git
cd media-manager-marketing-site

# Copy marketing-site files from monorepo
cp -r ../media-manager-app/marketing-site/* .
cp -r ../media-manager-app/marketing-site/.* . 2>/dev/null || true

# Remove pnpm-workspace.yaml (not needed for standalone repo)
rm pnpm-workspace.yaml

# Initialize git and commit
git add .
git commit -m "Initial commit: Marketing site migrated from monorepo"
git push -u origin main
```

### 3. Update Original Repository

The original `media-manager-app` repository will be updated to:
- Remove `marketing-site/` directory
- Update `pnpm-workspace.yaml` to remove marketing-site
- Update `.gitignore` if needed

### 4. Set Up Vercel for New Repository

1. Go to Vercel Dashboard
2. Add New Project
3. Import the new `media-manager-marketing-site` repository
4. Configure:
   - **Root Directory**: `/` (root, since it's now standalone)
   - **Framework**: Next.js (auto-detected)
   - **Build Command**: `pnpm build`
   - **Output Directory**: `.next`
   - **Install Command**: `pnpm install`
5. Set environment variables:
   - `NEXT_PUBLIC_APP_URL` = Your Vercel URL
   - Optional: `NEXT_PUBLIC_GOOGLE_ANALYTICS_ID`
   - Optional: `SENDGRID_API_KEY`

## Files Changed

### Files Removed from Marketing Site:
- `pnpm-workspace.yaml` (not needed for standalone repo)

### Files Updated in Original Repo:
- `pnpm-workspace.yaml` (removed marketing-site entry)
- `.gitignore` (marketing-site already removed)

## Benefits of Separation

✅ **Clear Ownership**: Marketing site has its own repository
✅ **Independent Versioning**: Separate release cycles
✅ **Simpler CI/CD**: Dedicated pipelines
✅ **Easier Onboarding**: Clear project boundaries
✅ **Better Organization**: No confusion about what belongs where

## Post-Migration Checklist

- [ ] New repository created on GitHub
- [ ] Marketing site code pushed to new repo
- [ ] Original repo updated (marketing-site removed)
- [ ] Vercel project created for new repo
- [ ] Environment variables set in new Vercel project
- [ ] Site deploys successfully
- [ ] All pages work correctly
- [ ] Forms submit successfully
- [ ] Old Vercel project archived/removed (if desired)

## Notes

- The marketing site is now completely independent
- No shared dependencies with the frontend app
- Can be developed and deployed independently
- Easier to maintain and scale
