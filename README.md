# osu! skinhub-basic

osu! skinhub-basic is a minimal, repository-based index for osu! skins.

## Skins directory

All skin archive files must be placed directly under the `skins/` directory:

- Use `.osk` or `.zip` archives only.
- Place files at the top level of `skins/` (no nested folders).
- Do not commit placeholder or non-skin binaries.

## Skins index

The canonical, auto-generated index of available skins is [`skins.md`](skins.md). This file is maintained by CI and must not be edited manually.

## Contribution guidelines

To add or update skins:

1. Add your `.osk` or `.zip` file directly under `skins/` with a clean, descriptive filename.
2. Do not modify `skins.md` directly; it will be regenerated automatically by GitHub Actions.
3. Open a Pull Request with your changes.
4. Ensure CI passes; if the index is out of date, the workflow will indicate that `skins.md` must be regenerated.