# Migration Troubleshooting

## Script Appears Stuck

### Problem: Script hangs at "Copying files from marketing-site..."

**Cause**: The script is trying to copy `node_modules/` which is 865MB+ and takes a very long time.

**Solution**: 

1. **Cancel the current script** (Press `Ctrl+C`)

2. **Use the fast migration script instead**:
   ```bash
   cd marketing-site
   ./migrate-to-new-repo-fast.sh git@github.com:yourusername/media-manager-marketing-site.git
   ```

   This script uses `git archive` to copy only tracked files (no node_modules).

3. **Or manually copy only source files**:
   ```bash
   # Navigate to parent directory
   cd /Users/travisheller/Sites/localhost
   
   # Clone new repo
   git clone git@github.com:yourusername/media-manager-marketing-site.git
   cd media-manager-marketing-site
   
   # Copy only source files (exclude node_modules, .next, etc.)
   rsync -av --progress \
     --exclude 'node_modules' \
     --exclude '.next' \
     --exclude '.vercel' \
     --exclude 'dist' \
     --exclude 'build' \
     --exclude '.pnpm-store' \
     --exclude '*.log' \
     ../media-manager-app/marketing-site/ .
   
   # Remove pnpm-workspace.yaml
   rm -f pnpm-workspace.yaml
   
   # Commit and push
   git add .
   git commit -m "Initial commit: Marketing site migrated from monorepo"
   git push -u origin main
   ```

## Alternative: Manual Migration (Recommended)

If scripts continue to have issues, manually migrate:

### Step 1: Create New Repo on GitHub
- Go to GitHub and create empty repository
- Don't initialize with any files

### Step 2: Clone and Copy Files
```bash
cd /Users/travisheller/Sites/localhost
git clone git@github.com:yourusername/media-manager-marketing-site.git
cd media-manager-marketing-site
```

### Step 3: Copy Source Files Only
```bash
# Copy everything except node_modules and build artifacts
rsync -av --progress \
  --exclude 'node_modules' \
  --exclude '.next' \
  --exclude '.vercel' \
  --exclude 'dist' \
  --exclude 'build' \
  --exclude '.pnpm-store' \
  --exclude '*.log' \
  ../media-manager-app/marketing-site/ .

# Or if rsync not available, use find:
find ../media-manager-app/marketing-site -type f \
  ! -path '*/node_modules/*' \
  ! -path '*/.next/*' \
  ! -path '*/.vercel/*' \
  ! -path '*/dist/*' \
  ! -path '*/build/*' \
  ! -name '*.log' \
  -exec cp --parents {} . \;
```

### Step 4: Clean Up and Commit
```bash
# Remove pnpm-workspace.yaml
rm -f pnpm-workspace.yaml

# Verify important files are present
ls -la app/ package.json next.config.ts

# Commit
git add .
git commit -m "Initial commit: Marketing site migrated from monorepo"
git push -u origin main
```

### Step 5: Install Dependencies in New Repo
```bash
cd /Users/travisheller/Sites/localhost/media-manager-marketing-site
pnpm install
```

## Files That Should Be Copied

✅ **Copy these:**
- `app/` - All source code
- `components/` - React components
- `public/` - Static assets
- `lib/` - Utility functions
- `package.json` - Dependencies
- `next.config.ts` - Next.js config
- `tsconfig.json` - TypeScript config
- `.gitignore` - Git ignore rules
- `README.md` - Documentation
- `*.md` - All markdown files

❌ **Don't copy these:**
- `node_modules/` - Will be installed with `pnpm install`
- `.next/` - Build output
- `.vercel/` - Vercel config (will be regenerated)
- `dist/` - Build output
- `build/` - Build output
- `.pnpm-store/` - pnpm cache
- `*.log` - Log files
- `pnpm-lock.yaml` - Can be regenerated (but fine to copy)

## Verify Migration

After migration, verify:

```bash
cd /Users/travisheller/Sites/localhost/media-manager-marketing-site

# Check structure
ls -la

# Install dependencies
pnpm install

# Build to verify
pnpm build

# Should see successful build with all routes
```

## Common Issues

### Issue: "Command not found: rsync"
**Solution**: Use the `find` command alternative or install rsync:
```bash
brew install rsync  # macOS
```

### Issue: "Permission denied"
**Solution**: Make sure you have write permissions:
```bash
chmod -R u+w /Users/travisheller/Sites/localhost/media-manager-marketing-site
```

### Issue: "Repository not found"
**Solution**: 
- Verify repository URL is correct
- Check you have access to the repository
- Ensure SSH keys are set up: `ssh -T git@github.com`

### Issue: "Files missing after migration"
**Solution**: 
- Check `.gitignore` - some files might be ignored
- Verify files exist in original location
- Use `git ls-files` to see what's tracked in original repo
