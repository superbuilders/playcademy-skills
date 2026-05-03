### Commits

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>
```

**Allowed types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

**Rules:**
- Type and description are required
- Lowercase type, imperative mood description, no trailing period
- Scope is optional but encouraged — use the area of code affected
- Breaking changes: append `!` after type/scope or add `BREAKING CHANGE:` footer
- Subject line under 72 characters

**Examples:**
```
feat(combat): add critical hit multiplier
fix(save): prevent data loss on unexpected disconnect
refactor(ui): extract health bar into reusable component
```
