# 🤖 Manus Skill for OpenClaw

Delegate complex tasks to [Manus](https://manus.im), an autonomous AI agent that can browse the web, use tools, and deliver complete work products (reports, code, presentations, etc.).

## What it does

- **Create tasks** - send prompts to Manus and let it work autonomously
- **Poll for status** - track task progress (pending, running, completed, failed)
- **Get deliverables** - download output files (PDFs, slides, code) when tasks complete
- **Multiple profiles** - standard, lite (fast), or max (deep research) agent modes

## Quick start

### Install the skill

```bash
git clone https://github.com/mvanhorn/clawdbot-skill-manus.git ~/.openclaw/skills/manus
```

### Set up your API key

Get a key from [Manus](https://manus.im), then:

```bash
export MANUS_API_KEY="your-key-here"
```

### Example chat usage

- "Use Manus to research the top 10 AI startups in healthcare"
- "Have Manus create a presentation about our Q4 results"
- "Check on my Manus task"
- "What did Manus come up with?"

## How it works

| Feature | Details |
|---------|---------|
| API | `https://api.manus.ai/v1` |
| Auth | `API_KEY` header |
| Agent profiles | `manus-1.6` (default), `manus-1.6-lite` (fast), `manus-1.6-max` (thorough) |
| Task modes | `agent` (file creation), `chat`, `adaptive` |

Tasks typically take 2-10+ minutes for complex work. The skill polls for completion, downloads output files locally, and delivers them directly rather than relying on share links.

## License

MIT
