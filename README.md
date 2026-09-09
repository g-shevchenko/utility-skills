# Utility Skills

Utility skills for AI coding agents: Figma diagrams, free SEO stack, PDF signing,
YouTube transcription, Zoom hosting, remote Mac access, talk decks, n8n cleanup,
and design system reference.

Created from production operating patterns, rewritten as a self-contained public
package. No Workspace dependencies — works in any repo with any agent.

## Verify Before Install

Clone and inspect first:

```bash
git clone https://github.com/g-shevchenko/utility-skills.git
cd utility-skills
bash scripts/doctor.sh
bash scripts/audit-public-surface.sh
```

Then install locally:

```bash
bash scripts/install.sh
```

Fast path after inspection:

```bash
bash scripts/install.sh --target "$HOME/.codex/skills"
```

## What Gets Installed

| Skill | Purpose | Trigger phrase |
|---|---|---|
| `figma-mcp-free` | Figma diagrams on free Starter plan — blocks, microservices, architecture, user flow, UI mockups via Plugin API | `use figma mcp free` |
| `figma-diagram-visualization` | Scientific algorithm for building diagrams/dashboards/visualizations in Figma | `use figma diagram visualization` |
| `free-seo-stack` | Free alternatives to Semrush/Ahrefs/Ubersuggest — Lighthouse, CrUX, GSC, Bing, Yandex, IndexNow, rank audit, backlinks, security | `use free seo stack` |
| `pdf-signing` | Add stamp/seal/signature to PDF — secure local signing assets, visual placement verification | `use pdf signing` |
| `youtube-transcribe` | yt-dlp subs → faster-whisper large-v3 → Groq fallback | `use youtube transcribe` |
| `zoom-host` | Create Zoom meetings on shared Pro host — public join_url, facilitator fetches start_url via Credential Gateway | `use zoom host` |
| `remote-mac-access` | Reverse SSH tunnel via VPN relay — connect to team Mac behind NAT/firewall | `use remote mac access` |
| `talk-deck-builder` | PDF talk deck for presentations — brand-style | `use talk deck builder` |
| `n8n-temp-cleanup` | Discover and delete temp/one-shot n8n workflows | `use n8n temp cleanup` |
| `pantheon-style` | Design system tokens reference (WCAG tables, anti-patterns, motion) | `use pantheon style` |

## Install Targets

Default: `$HOME/.codex/skills`

Other agents:
```bash
# Claude Code
bash scripts/install.sh --target "$HOME/.claude/skills"

# Cursor
bash scripts/install.sh --target "$HOME/.cursor/skills"

# Windsurf
bash scripts/install.sh --target "$HOME/.codeium/windsurf/skills"
```

## External Dependencies

Some skills reference external services or tools. All endpoints are configurable —
no hardcoded internal URLs. See each skill's SKILL.md for setup instructions.

- `figma-mcp-free` — Figma account (free Starter plan)
- `youtube-transcribe` — yt-dlp, faster-whisper, optional Groq API key
- `zoom-host` — Zoom Pro account
- `remote-mac-access` — VPN relay (any provider)
- `n8n-temp-cleanup` — n8n instance

## License

MIT — see [LICENSE](LICENSE).
