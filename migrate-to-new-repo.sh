#!/bin/bash

# Migration script to move marketing-site to a new repository
# Usage: ./migrate-to-new-repo.sh <new-repo-url>

set -e

NEW_REPO_URL=$1

if [ -z "$NEW_REPO_URL" ]; then
    echo "Error: Please provide the new repository URL"
    echo "Usage: ./migrate-to-new-repo.sh <new-repo-url>"
    echo "Example: ./migrate-to-new-repo.sh git@github.com:username/media-manager-marketing-site.git"
    exit 1
fi

echo "🚀 Starting migration to new repository..."
echo "📦 New repository URL: $NEW_REPO_URL"
echo ""

# Get the current directory (marketing-site)
CURRENT_DIR=$(pwd)
PARENT_DIR=$(dirname "$CURRENT_DIR")
REPO_NAME=$(basename "$NEW_REPO_URL" .git)

echo "📁 Current directory: $CURRENT_DIR"
echo "📁 Parent directory: $PARENT_DIR"
echo "📦 New repo name: $REPO_NAME"
echo ""

# Navigate to parent directory
cd "$PARENT_DIR"

# Check if directory already exists
if [ -d "$REPO_NAME" ]; then
    echo "📁 Directory '$REPO_NAME' already exists"
    
    # Check if it's a git repository
    if [ -d "$REPO_NAME/.git" ]; then
        echo "✅ Existing git repository detected, using it..."
        cd "$REPO_NAME"
        
        # Verify remote is set correctly
        CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
        if [ "$CURRENT_REMOTE" != "$NEW_REPO_URL" ]; then
            echo "⚠️  Warning: Remote URL mismatch"
            echo "   Current: $CURRENT_REMOTE"
            echo "   Expected: $NEW_REPO_URL"
            echo "   Updating remote..."
            git remote set-url origin "$NEW_REPO_URL" || git remote add origin "$NEW_REPO_URL"
        fi
    else
        echo "📥 Initializing git repository..."
        cd "$REPO_NAME"
        git init
        git remote add origin "$NEW_REPO_URL" || git remote set-url origin "$NEW_REPO_URL"
        git branch -M main
    fi
else
    # Clone the new empty repository
    echo "📥 Cloning new repository..."
    git clone "$NEW_REPO_URL" "$REPO_NAME" || {
        echo "❌ Error: Could not clone repository. Make sure:"
        echo "   1. The repository exists on GitHub"
        echo "   2. You have access to it"
        echo "   3. The URL is correct"
        exit 1
    }
    cd "$REPO_NAME"
fi

# Copy all marketing-site files (excluding node_modules and build artifacts)
echo "📋 Copying files from marketing-site..."
echo "   (excluding node_modules and build artifacts)"

# Use rsync if available, otherwise use find + cp
if command -v rsync &> /dev/null; then
    rsync -av --progress \
        --exclude 'node_modules' \
        --exclude '.next' \
        --exclude '.vercel' \
        --exclude 'dist' \
        --exclude 'build' \
        --exclude '.pnpm-store' \
        --exclude '*.log' \
        "$CURRENT_DIR/" .
else
    # Fallback: use find and cp
    find "$CURRENT_DIR" -mindepth 1 -maxdepth 1 \
        ! -name 'node_modules' \
        ! -name '.next' \
        ! -name '.vercel' \
        ! -name 'dist' \
        ! -name 'build' \
        ! -name '.pnpm-store' \
        ! -name '*.log' \
        -exec cp -r {} . \;
fi

# Remove pnpm-workspace.yaml if it exists (not needed for standalone)
if [ -f "pnpm-workspace.yaml" ]; then
    echo "🗑️  Removing pnpm-workspace.yaml (not needed for standalone repo)..."
    rm pnpm-workspace.yaml
fi

# Initialize git and commit
echo "📝 Initializing git repository..."
git add .
git commit -m "Initial commit: Marketing site migrated from monorepo

- Migrated from media-manager-app monorepo
- Standalone Next.js application
- Ready for Vercel deployment"

echo ""
echo "✅ Files copied and committed!"
echo ""
echo "📤 Pushing to remote repository..."
git push -u origin main

echo ""
echo "✅ Migration complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Go to Vercel Dashboard"
echo "   2. Add New Project"
echo "   3. Import repository: $REPO_NAME"
echo "   4. Set Root Directory to: / (root)"
echo "   5. Configure environment variables"
echo "   6. Deploy!"
echo ""
echo "📚 See MIGRATION_TO_SEPARATE_REPO.md for detailed instructions"
