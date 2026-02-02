#!/bin/bash

# Script to fix .pnpm-store issue in the new repository
# 
# Usage:
#   Option 1: Run from inside media-manager-site directory:
#     cd /Users/travisheller/Sites/localhost/media-manager-site
#     ./FIX_PNPM_STORE_IN_NEW_REPO.sh
#
#   Option 2: Run from anywhere, provide path:
#     ./FIX_PNPM_STORE_IN_NEW_REPO.sh /Users/travisheller/Sites/localhost/media-manager-site

set -e

# Allow passing directory as argument
REPO_DIR=${1:-$(pwd)}

# Navigate to repository directory
if [ -n "$1" ]; then
    cd "$REPO_DIR"
fi

echo "🔧 Fixing .pnpm-store issue in repository..."
echo "📁 Repository directory: $(pwd)"
echo ""

# Check if we're in the right directory
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository"
    echo ""
    echo "Please run this script from the media-manager-site directory:"
    echo "  cd /Users/travisheller/Sites/localhost/media-manager-site"
    echo "  ./FIX_PNPM_STORE_IN_NEW_REPO.sh"
    echo ""
    echo "Or provide the path as an argument:"
    echo "  ./FIX_PNPM_STORE_IN_NEW_REPO.sh /path/to/media-manager-site"
    exit 1
fi

# Remove .pnpm-store from git tracking (but keep local files)
echo "🗑️  Removing .pnpm-store from git tracking..."
git rm -r --cached .pnpm-store 2>/dev/null || echo "   .pnpm-store not tracked (already removed)"

# Ensure .gitignore includes .pnpm-store
if ! grep -q "\.pnpm-store" .gitignore 2>/dev/null; then
    echo "📝 Updating .gitignore to exclude .pnpm-store..."
    echo "" >> .gitignore
    echo "# pnpm cache" >> .gitignore
    echo ".pnpm-store/" >> .gitignore
fi

# Stage the changes
echo "📝 Staging changes..."
git add .gitignore

# Commit the fix
echo "💾 Committing fix..."
git commit -m "chore: remove .pnpm-store from repository

- .pnpm-store is a cache directory and shouldn't be committed
- Added to .gitignore to prevent future commits
- Fixes GitHub warning about large files"

echo ""
echo "📤 Pushing fix to remote..."
git push --force-with-lease

echo ""
echo "✅ Fix complete!"
echo ""
echo "📋 Summary:"
echo "   - Removed .pnpm-store from git tracking"
echo "   - Updated .gitignore to exclude .pnpm-store"
echo "   - Committed and pushed changes"
echo ""
echo "💡 The .pnpm-store directory will remain locally but won't be tracked by git"
