#!/bin/bash

# Fast migration script - copies only tracked files (no node_modules)
# Usage: ./migrate-to-new-repo-fast.sh <new-repo-url>

set -e

NEW_REPO_URL=$1

if [ -z "$NEW_REPO_URL" ]; then
    echo "Error: Please provide the new repository URL"
    echo "Usage: ./migrate-to-new-repo-fast.sh <new-repo-url>"
    echo "Example: ./migrate-to-new-repo-fast.sh git@github.com:username/media-manager-marketing-site.git"
    exit 1
fi

echo "🚀 Starting fast migration to new repository..."
echo "📦 New repository URL: $NEW_REPO_URL"
echo ""

# Get the current directory (marketing-site)
CURRENT_DIR=$(pwd)
# Go up two levels: marketing-site -> media-manager-app -> localhost
PARENT_DIR=$(dirname "$(dirname "$CURRENT_DIR")")
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

# Check if target directory already has files
cd "$PARENT_DIR/$REPO_NAME"
EXISTING_FILES=$(find . -maxdepth 1 -not -name '.' -not -name '.git' -not -name '.DS_Store' 2>/dev/null | wc -l | tr -d ' ')

if [ "$EXISTING_FILES" -gt "0" ]; then
    echo "⚠️  Warning: Directory already contains files ($EXISTING_FILES items)"
    echo "   Files will be copied/overwritten"
    read -p "   Continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Aborted by user"
        exit 1
    fi
fi

# Copy only tracked files using git archive (much faster!)
echo "📋 Copying source files (excluding node_modules and build artifacts)..."
cd "$CURRENT_DIR"

# Check if we're in a git repo (we should be, but handle edge case)
if [ ! -d ".git" ]; then
    echo "⚠️  Warning: Not in a git repository. Using alternative copy method..."
    # Fallback: use rsync or find to copy files
    if command -v rsync &> /dev/null; then
        rsync -av --progress \
            --exclude 'node_modules' \
            --exclude '.next' \
            --exclude '.vercel' \
            --exclude 'dist' \
            --exclude 'build' \
            --exclude '.pnpm-store' \
            --exclude '*.log' \
            --exclude '.git' \
            "$CURRENT_DIR/" "$PARENT_DIR/$REPO_NAME/"
    else
        echo "❌ Error: Need git repository or rsync. Please run from git repo or install rsync."
        exit 1
    fi
else
    # Use git archive (fastest method - only tracked files)
    echo "   Using git archive to copy only tracked files..."
    git archive HEAD --prefix=marketing-site/ | (cd "$PARENT_DIR/$REPO_NAME" && tar -xf - --strip-components=1)
fi

# Copy .gitignore and other important files that might not be tracked
cd "$PARENT_DIR/$REPO_NAME"

# Ensure .gitignore exists
if [ ! -f ".gitignore" ]; then
    cp "$CURRENT_DIR/.gitignore" . 2>/dev/null || echo "# Dependencies and build artifacts" > .gitignore
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
echo "✅ Files copied!"

# Check if we need to set upstream
BRANCH_NAME=$(git branch --show-current 2>/dev/null || echo "main")
if [ -z "$(git config --get branch.$BRANCH_NAME.remote)" ]; then
    echo "📤 Pushing to remote repository (setting upstream)..."
    git push -u origin "$BRANCH_NAME" || git push -u origin main
else
    echo "📤 Pushing to remote repository..."
    git push
fi

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
echo "💡 After deployment, run 'pnpm install' in the new repo to install dependencies"
