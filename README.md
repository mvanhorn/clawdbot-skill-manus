# 🤖 Manus Skill for OpenClaw

Delegate complex tasks to [Manus](https://manus.im), an autonomous AI agent that can browse the web, use tools, and deliver complete work products (reports, code, presentations, scraped data, etc.).

## What it does

- **Task templates** - research, report generation, code building, data scraping with structured prompts
- **Create tasks** - send prompts to Manus and let it work autonomously
- **Monitor progress** - poll for task status (pending, running, completed, failed)
- **Cost guidance** - recommends the right agent profile (standard, lite, max) based on task complexity
- **Get deliverables** - download output files (PDFs, slides, code, CSV) when tasks complete
- **Task history** - view recent tasks with status, duration, and results

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
- "Scrape Product Hunt for this week's top 50 products, output as CSV"
- "Build a Python Flask API that summarizes web pages"
- "Check on my Manus task"
- "Show my Manus task history"
- "What did Manus come up with?"

## Agent profiles

| Profile | Speed | Cost | Best for |
|---------|-------|------|----------|
| `manus-1.5` | Standard | Standard | Most tasks |
| `manus-1.5-lite` | Fast | ~40% cheaper | Quick lookups, summaries |
| `manus-1.5-max` | Slow | ~2x standard | Deep research, complex analysis |

## How it works

| Feature | Details |
|---------|---------|
| API | `https://api.manus.im/v1` |
| Auth | `API_KEY` header |
| Task modes | `agent` (file creation), `chat`, `adaptive` |

Tasks typically take 2-10+ minutes for complex work. The skill polls for completion, downloads output files locally, and delivers them directly rather than relying on share links.

## CLI helper

```bash
bash scripts/manus.sh create "Research the top AI startups" manus-1.5
bash scripts/manus.sh status <task_id>
bash scripts/manus.sh download <task_id> ./output
bash scripts/manus.sh list
```

## License

MIT
