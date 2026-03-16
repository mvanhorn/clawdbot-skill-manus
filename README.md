# Manus Skill for OpenClaw

Delegate complex tasks to [Manus](https://manus.im), an autonomous AI agent that can browse the web, use tools, and deliver complete work products (reports, code, presentations, scraped data, financial models, mobile apps, etc.).

## What it does

- **Task templates** - research, report generation, code building, data scraping with structured prompts
- **Full task CRUD** - create, list, get, update, and delete tasks
- **Files API** - upload files via presigned S3 URLs, attach to tasks
- **Projects API** - persistent instructions that apply to all tasks in a project
- **Multi-turn conversations** - continue and iterate on previous task results
- **Interactive mode** - let Manus ask follow-up questions for better results
- **Webhooks** - real-time task_created, task_progress, task_stopped events
- **Monitor progress** - poll for task status (pending, running, completed, failed)
- **Cost guidance** - recommends the right agent profile (standard, lite, max) based on task complexity
- **Get deliverables** - download output files (PDFs, slides, code, CSV) when tasks complete
- **Built-in connectors** - Gmail, Notion, Google Calendar, Slack, Similarweb

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
- "Continue the last Manus task and add a pricing section"
- "Create a Manus project for all Q1 research with formal tone"
- "Upload this CSV and have Manus analyze it"
- "Check on my Manus task"
- "Show my Manus task history"

## Agent profiles (Manus 1.6)

| Profile | Speed | Cost | Best for |
|---------|-------|------|----------|
| `manus-1.6` | Standard | Standard | Most tasks (recommended) |
| `manus-1.6-lite` | Fast | ~40% cheaper | Quick lookups, summaries |
| `manus-1.6-max` | Slow | ~2x standard | Deep research, complex analysis (+19.2% satisfaction) |

> Note: `manus-1.5*` profiles are deprecated. Always use `manus-1.6*`.

## Manus 1.6 capabilities

- Mobile development and preview
- Design View for visual layout
- Financial modeling and spreadsheets
- Telegram integration
- Built-in connectors (Gmail, Notion, Google Calendar, Slack, Similarweb)

## How it works

| Feature | Details |
|---------|---------|
| API | `https://api.manus.im/v1` |
| Auth | `API_KEY` header |
| Task modes | `agent` (file creation), `chat`, `adaptive` |
| Multi-turn | Pass `taskId` to continue conversations |
| Attachments | `fromFileId`, `fromUrl`, `fromBase64` |
| Webhooks | `task_created`, `task_progress`, `task_stopped` |

Tasks typically take 2-10+ minutes for complex work. The skill polls for completion, downloads output files locally, and delivers them directly rather than relying on share links.

## CLI helper

```bash
# Tasks
bash scripts/manus.sh create "Research the top AI startups" manus-1.6
bash scripts/manus.sh status <task_id>
bash scripts/manus.sh download <task_id> ./output
bash scripts/manus.sh list [status]
bash scripts/manus.sh update <task_id> "New title"
bash scripts/manus.sh delete <task_id>

# Files
bash scripts/manus.sh upload ./data.csv
bash scripts/manus.sh list-files
bash scripts/manus.sh delete-file <file_id>

# Projects
bash scripts/manus.sh create-project "Q1 Research" "Use formal tone"
bash scripts/manus.sh list-projects

# Webhooks
bash scripts/manus.sh webhook-create https://your-server.com/hook
bash scripts/manus.sh webhook-delete <webhook_id>
```

## License

MIT
