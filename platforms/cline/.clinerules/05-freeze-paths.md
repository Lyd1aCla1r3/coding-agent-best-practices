# Frozen Path Protection

## Scope and Restore Points
- **Frozen Directories:** Treat paths listed in `.freeze-paths.txt` (defaulting to `published/` and `archive/`) as immutable reference artifacts during active feature or drafting work.
- **No Unapproved Writes:** Do not edit, overwrite, rename, or delete files inside frozen directories unless the user grants explicit written approval for a specific file in the current prompt.
- **Pre-Integration Restore Point:** Record the current `git rev-parse HEAD` commit SHA in `session_checkpoint.md` before modifying shared build scripts or integration entrypoints.
