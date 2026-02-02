# How to Run the Script Correctly

## The Issue

You tried: `migrate-to-new-repo-fast.sh`  
**Error:** `zsh: command not found`

## The Fix

You need to use `./` before the script name to run it from the current directory:

```bash
./migrate-to-new-repo-fast.sh git@github.com:theller5567/media-manager-site.git
```

## Complete Command

```bash
# Make sure you're in the marketing-site directory
cd /Users/travisheller/Sites/localhost/media-manager-app/marketing-site

# Run the script with ./ prefix
./migrate-to-new-repo-fast.sh git@github.com:theller5567/media-manager-site.git
```

## Why `./` is Needed

- `migrate-to-new-repo-fast.sh` - Shell looks for command in PATH (not found)
- `./migrate-to-new-repo-fast.sh` - Shell runs script from current directory (correct)

## Verify Script Exists

Before running, verify the script is there:

```bash
ls -la migrate-to-new-repo-fast.sh
```

You should see it listed with execute permissions (`-rwxr-xr-x`).
