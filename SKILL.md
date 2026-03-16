---
name: manus
version: "3.0.0"
description: Delegate complex tasks to Manus AI - web research, report generation, code building, data scraping, file management, multi-turn conversations, project instructions. Full CRUD, Files, Projects, and Webhook APIs.
author: mvanhorn
license: MIT
repository: https://github.com/mvanhorn/clawdbot-skill-manus
homepage: https://manus.im
metadata:
  openclaw:
    emoji: "🤖"
    requires:
      env:
        - MANUS_API_KEY
    primaryEnv: MANUS_API_KEY
    tags:
      - agent
      - automation
      - manus
      - web-browsing
      - research
      - reports
      - scraping
      - code-generation
      - data-extraction
      - task-delegation
      - autonomous
      - ai-agent
      - cost-tracking
      - multi-turn
      - files
      - projects
      - webhooks
      - mobile-dev
      - financial-modeling
    triggers:
      - manus
      - delegate
      - autonomous task
      - have manus
      - ask manus
      - send to manus
      - manus research
      - manus report
      - manus scrape
      - manus build
      - check manus
      - manus status
      - manus history
      - manus cost
      - manus files
      - manus project
      - manus continue
---

# Manus AI Agent

Delegate complex tasks to Manus - an autonomous AI agent that browses the web, writes code, generates reports, scrapes data, builds mobile apps, creates financial models, and delivers complete work products.

## API Configuration

**Base URL:** `https://api.manus.im/v1`

**Authentication Header:** `API_KEY: <your-key>`

Set via:
- `MANUS_API_KEY` environment variable
- Or `skills.manus.apiKey` in OpenClaw config

## Agent Profiles and Pricing (Manus 1.6)

> **IMPORTANT:** The `manus-1.5`, `manus-1.5-lite`, and `manus-1.5-max` profiles are DEPRECATED and will stop working. Always use the 1.6 profiles below.

| Profile | Speed | Depth | Best for | Relative cost |
|---------|-------|-------|----------|---------------|
| `manus-1.6` | Standard | Full | Most tasks, file creation, reports | Standard (recommended default) |
| `manus-1.6-lite` | Fast | Light | Quick lookups, simple questions, summaries | ~40% cheaper |
| `manus-1.6-max` | Slow | Deep | Complex multi-step research, thorough analysis (+19.2% satisfaction vs standard) | ~2x standard |

**Default:** Always use `manus-1.6` unless the user explicitly asks for lite or max.

**Wide Research:** All Wide Research sub-agents automatically use `manus-1.6-max` for maximum depth.

### Cost estimation guidance

Before creating a task, inform the user of the expected profile:
- **Simple/quick tasks** (summaries, single-page lookups): recommend `manus-1.6-lite`
- **Standard tasks** (reports, presentations, code projects): use `manus-1.6`
- **Complex tasks** (multi-source research, competitive analysis, deep dives): suggest `manus-1.6-max`

Users can override with "use lite", "use max", or "use the cheap one" / "use the thorough one".

## Manus 1.6 Capabilities

Manus 1.6 adds these capabilities over 1.5:
- **Mobile development** - build and preview mobile apps
- **Design View** - visual design and layout capabilities
- **Financial modeling** - spreadsheets, projections, financial analysis
- **Telegram integration** - interact via Telegram bot
- **Built-in connectors** - Gmail, Notion, Google Calendar, Slack, Similarweb

## Task Modes

| Mode | Description | When to use |
|------|-------------|-------------|
| `agent` | Full autonomous agent with tool use | File creation, web browsing, code writing (recommended default) |
| `chat` | Conversational back-and-forth | Simple Q&A, brainstorming |
| `adaptive` | Auto-selects best approach | When unsure which mode fits |

**Default:** Always use `agent` mode for tasks that produce deliverables.

---

## Task Templates

Use these templates to create well-structured tasks. Always include `createShareableLink: true`.

### Research Template

For market research, competitive analysis, topic deep-dives.

```bash
curl -s -X POST "https://api.manus.im/v1/tasks" \
  -H "API_KEY: $MANUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Research [TOPIC]. Find the top [N] [entities] by [criteria]. For each, provide: name, description, key metrics, recent news. Compile into a structured report with sections, tables, and citations. Include a summary with key takeaways.",
    "agentProfile": "manus-1.6",
    "taskMode": "agent",
    "createShareableLink": true
  }'
```

**Example prompts:**
- "Research the top 10 AI startups in healthcare by funding raised in 2025. For each provide founding year, total funding, key product, and notable customers."
- "Do a competitive analysis of project management tools: Asana, Monday, Linear, Jira, ClickUp. Compare pricing, features, integrations, and user reviews."
- "Research the current state of autonomous vehicle regulations in the US, EU, and China. Summarize key differences and recent changes."

### Report Generation Template

For creating formatted documents, presentations, executive summaries.

```bash
curl -s -X POST "https://api.manus.im/v1/tasks" \
  -H "API_KEY: $MANUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Create a [FORMAT] about [TOPIC]. Include: [SECTIONS]. Use professional formatting with headers, bullet points, and data tables where appropriate. Export as [FILE_TYPE].",
    "agentProfile": "manus-1.6",
    "taskMode": "agent",
    "createShareableLink": true
  }'
```

**Example prompts:**
- "Create a 10-slide presentation about our company's AI strategy for the board meeting. Include market overview, our position, roadmap, and investment ask."
- "Write an executive summary report on the state of remote work in 2025. Include statistics, trends, and recommendations. Export as PDF."
- "Generate a one-page brief comparing AWS, GCP, and Azure for a startup choosing a cloud provider."

### Code Building Template

For generating code projects, scripts, prototypes.

```bash
curl -s -X POST "https://api.manus.im/v1/tasks" \
  -H "API_KEY: $MANUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Build a [LANGUAGE/FRAMEWORK] [PROJECT_TYPE] that [FUNCTIONALITY]. Include: [REQUIREMENTS]. Follow best practices for [LANGUAGE]. Include a README with setup instructions.",
    "agentProfile": "manus-1.6",
    "taskMode": "agent",
    "createShareableLink": true
  }'
```

**Example prompts:**
- "Build a Python Flask API that takes a URL and returns a summary of the page content using BeautifulSoup for scraping. Include error handling, rate limiting, and a Dockerfile."
- "Create a React dashboard component that displays real-time metrics from a WebSocket connection. Include TypeScript types and unit tests."
- "Write a bash script that audits an AWS account for security misconfigurations: open S3 buckets, overly permissive IAM policies, unencrypted volumes."

### Data Scraping Template

For extracting structured data from websites.

```bash
curl -s -X POST "https://api.manus.im/v1/tasks" \
  -H "API_KEY: $MANUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Scrape [WEBSITE/SOURCE] and extract [DATA_FIELDS] for [ENTITIES]. Output as [FORMAT: CSV/JSON/table]. Include [N] results. Handle pagination if needed.",
    "agentProfile": "manus-1.6",
    "taskMode": "agent",
    "createShareableLink": true
  }'
```

**Example prompts:**
- "Scrape the top 50 products from Product Hunt this week. Extract: name, tagline, upvote count, maker name, and URL. Output as CSV."
- "Go to news.ycombinator.com and collect the top 30 stories. Extract title, URL, points, and comment count. Output as JSON."
- "Find the top 20 open source AI projects on GitHub by stars in the last month. Extract repo name, description, stars, language, and last commit date."

---

## Core API Operations

### Create a Task

```bash
curl -s -X POST "https://api.manus.im/v1/tasks" \
  -H "API_KEY: $MANUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Your task description here",
    "agentProfile": "manus-1.6",
    "taskMode": "agent",
    "createShareableLink": true
  }'
```

**Full parameter reference:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `prompt` | string | (required) | The task description |
| `agentProfile` | string | `manus-1.6` | Agent profile: `manus-1.6`, `manus-1.6-lite`, `manus-1.6-max` |
| `taskMode` | string | `agent` | Task mode: `agent`, `chat`, `adaptive` |
| `createShareableLink` | boolean | `false` | Generate a public share URL |
| `interactiveMode` | boolean | `false` | Allow Manus to ask follow-up questions (task pauses with `stop_reason: ask`) |
| `projectId` | string | - | Associate with a project's persistent instructions |
| `taskId` | string | - | Continue an existing conversation (multi-turn) |
| `locale` | string | - | Language locale (e.g., `"zh-CN"`, `"ja"`, `"es"`) |
| `attachments` | array | - | Files to attach (see Attachment types below) |

**Attachment types:**

```json
// From an uploaded file ID (see Files API)
{ "type": "fromFileId", "fileId": "file_abc123" }

// From a URL (Manus downloads it)
{ "type": "fromUrl", "url": "https://example.com/data.csv" }

// Inline base64 content
{ "type": "fromBase64", "data": "base64-encoded-content", "fileName": "image.png", "mimeType": "image/png" }
```

**Response:**
```json
{
  "task_id": "abc123",
  "task_title": "Task Title",
  "task_url": "https://manus.im/app/abc123",
  "status": "pending"
}
```

After creating a task, immediately tell the user:
1. The task has been submitted
2. The task ID for reference
3. Expected duration (2-10+ minutes depending on complexity)
4. That you will monitor it for completion

### Multi-Turn Conversations

To continue a previous task as a conversation, pass the original `taskId`:

```bash
curl -s -X POST "https://api.manus.im/v1/tasks" \
  -H "API_KEY: $MANUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Now add a section about pricing trends",
    "agentProfile": "manus-1.6",
    "taskMode": "agent",
    "taskId": "PREVIOUS_TASK_ID",
    "createShareableLink": true
  }'
```

This preserves all context from the previous task. Use this when:
- The user says "also...", "now add...", "refine the previous..."
- A task completed with `interactiveMode` and Manus asked a question (`stop_reason: ask`)
- The user wants to iterate on Manus output

### Get Task Details

```bash
curl -s "https://api.manus.im/v1/tasks/{task_id}" \
  -H "API_KEY: $MANUS_API_KEY"
```

**Status values:**
| Status | Meaning | Action |
|--------|---------|--------|
| `pending` | Queued, not yet started | Wait and poll again in 15-30 seconds |
| `running` | Actively working | Wait and poll again in 15-30 seconds |
| `completed` | Finished successfully | Retrieve and deliver results |
| `failed` | Task errored out | Report error, suggest retry |

### Update Task Metadata

```bash
curl -s -X PUT "https://api.manus.im/v1/tasks/{task_id}" \
  -H "API_KEY: $MANUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "New title for this task"
  }'
```

### Delete a Task

```bash
curl -s -X DELETE "https://api.manus.im/v1/tasks/{task_id}" \
  -H "API_KEY: $MANUS_API_KEY"
```

### List Tasks (Paginated)

```bash
curl -s "https://api.manus.im/v1/tasks?status=completed&page=1&limit=20" \
  -H "API_KEY: $MANUS_API_KEY"
```

**Query parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `status` | string | - | Filter by status: `pending`, `running`, `completed`, `failed` |
| `page` | integer | `1` | Page number |
| `limit` | integer | `20` | Results per page |

When showing task history to the user, format it as a table:
```
| Task ID | Title | Status | Profile | Created |
|---------|-------|--------|---------|---------|
| abc123 | Market Research | completed | manus-1.6 | 2 hours ago |
| def456 | Code Review | running | manus-1.6-lite | 5 min ago |
```

### Poll for Completion

After creating a task, poll for completion. Use the helper script or curl directly.

**With the helper script:**
```bash
bash scripts/manus.sh wait <task_id> 600
```

**With curl (manual polling):**
```bash
# Poll every 15 seconds until completed or failed
task_id="YOUR_TASK_ID"
status="pending"
while [ "$status" != "completed" ] && [ "$status" != "failed" ]; do
  sleep 15
  status=$(curl -s "https://api.manus.im/v1/tasks/$task_id" \
    -H "API_KEY: $MANUS_API_KEY" | jq -r '.status // "unknown"')
done
```

When polling, give the user periodic updates:
- After 30 seconds: "Still working on it..."
- After 2 minutes: "Manus is still processing. Complex tasks can take 5-10 minutes."
- After 5 minutes: "This is taking longer than usual. The task is still running."

### Retrieve Results

When a task completes, the response contains output content and files:

```bash
curl -s "https://api.manus.im/v1/tasks/{task_id}" \
  -H "API_KEY: $MANUS_API_KEY"
```

**Response structure:**
```json
{
  "task_id": "abc123",
  "status": "completed",
  "task_title": "Research Report",
  "output": [
    {
      "content": [
        {
          "type": "text",
          "text": "Here is the research summary..."
        },
        {
          "type": "output_file",
          "fileUrl": "https://private-us-east-1.manuscdn.com/...",
          "fileName": "research_report.pdf"
        }
      ]
    }
  ]
}
```

**Always do these steps when a task completes:**
1. Extract text content and present it to the user
2. List all output files with their names
3. Download files locally using curl
4. Deliver files to the user directly (do not rely on manus.im share links - they can be unreliable)

### Download Output Files

```bash
# List files from a completed task
bash scripts/manus.sh files <task_id>

# Download all output files to a directory
bash scripts/manus.sh download <task_id> ./manus-output
```

**Manual download:**
```bash
curl -sL "https://private-us-east-1.manuscdn.com/path/to/file" -o "output_filename.pdf"
```

---

## Files API

Manage file uploads for use as task attachments.

### Create a File (Get Upload URL)

```bash
curl -s -X POST "https://api.manus.im/v1/files" \
  -H "API_KEY: $MANUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "fileName": "data.csv",
    "mimeType": "text/csv"
  }'
```

**Response:**
```json
{
  "file_id": "file_abc123",
  "upload_url": "https://s3.amazonaws.com/manus-uploads/...",
  "expires_at": "2026-03-16T00:00:00Z"
}
```

Then upload the file content to the presigned S3 URL:
```bash
curl -s -X PUT "$UPLOAD_URL" \
  -H "Content-Type: text/csv" \
  --data-binary @data.csv
```

After uploading, use `fromFileId` attachment type when creating a task:
```json
{ "attachments": [{ "type": "fromFileId", "fileId": "file_abc123" }] }
```

### List Recent Files

```bash
curl -s "https://api.manus.im/v1/files" \
  -H "API_KEY: $MANUS_API_KEY"
```

Returns the 10 most recent files.

### Get File Details

```bash
curl -s "https://api.manus.im/v1/files/{file_id}" \
  -H "API_KEY: $MANUS_API_KEY"
```

### Delete a File

```bash
curl -s -X DELETE "https://api.manus.im/v1/files/{file_id}" \
  -H "API_KEY: $MANUS_API_KEY"
```

---

## Projects API

Projects let you set persistent instructions that apply to all tasks in a project. Useful for brand guidelines, output format preferences, or domain context.

### Create a Project

```bash
curl -s -X POST "https://api.manus.im/v1/projects" \
  -H "API_KEY: $MANUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Q1 Market Research",
    "instructions": "Always format output as markdown tables. Use formal tone. Include source URLs for all claims. Target audience: C-suite executives."
  }'
```

**Response:**
```json
{
  "project_id": "proj_abc123",
  "name": "Q1 Market Research"
}
```

Then pass `projectId` when creating tasks:
```json
{ "prompt": "Research competitor pricing", "projectId": "proj_abc123" }
```

### List Projects

```bash
curl -s "https://api.manus.im/v1/projects" \
  -H "API_KEY: $MANUS_API_KEY"
```

---

## Webhooks

Instead of polling, you can register a webhook URL to receive real-time task updates.

### Create a Webhook

```bash
curl -s -X POST "https://api.manus.im/v1/webhooks" \
  -H "API_KEY: $MANUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://your-server.com/manus-webhook",
    "events": ["task_created", "task_progress", "task_stopped"]
  }'
```

### Delete a Webhook

```bash
curl -s -X DELETE "https://api.manus.im/v1/webhooks/{webhook_id}" \
  -H "API_KEY: $MANUS_API_KEY"
```

### Webhook Event Types

**`task_created`** - Fires when a task starts:
```json
{
  "event": "task_created",
  "task_id": "abc123",
  "title": "Market Research Report",
  "url": "https://manus.im/app/abc123"
}
```

**`task_progress`** - Fires during task execution:
```json
{
  "event": "task_progress",
  "task_id": "abc123",
  "progress_type": "step",
  "message": "Browsing competitor websites..."
}
```

**`task_stopped`** - Fires when a task finishes or pauses:
```json
{
  "event": "task_stopped",
  "task_id": "abc123",
  "stop_reason": "finish",
  "attachments": [
    { "fileName": "report.pdf", "fileUrl": "https://private-us-east-1.manuscdn.com/..." }
  ]
}
```

`stop_reason` values:
- `finish` - Task completed normally
- `ask` - Task paused, Manus is asking a follow-up question (use multi-turn to reply)

---

## Built-in Connectors

Manus 1.6 can connect to external services during task execution. The user must authorize connectors in their Manus dashboard first.

| Connector | What Manus can do |
|-----------|-------------------|
| **Gmail** | Read, search, send emails |
| **Notion** | Read/write pages and databases |
| **Google Calendar** | View/create calendar events |
| **Slack** | Read channels, send messages |
| **Similarweb** | Pull website traffic and analytics data |

When creating tasks that involve these services, mention the connector in the prompt:
- "Check my Gmail for unread emails from investors and summarize them"
- "Create a Notion page with the research findings"
- "Look up traffic data for competitor.com using Similarweb"

---

## Recommended Workflow

When the user asks you to delegate a task to Manus:

1. **Understand the request** - determine which template fits (research, report, code, scrape)
2. **Estimate cost** - recommend the appropriate agent profile based on complexity
3. **Create the task** - use the matching template with `createShareableLink: true`
4. **Report submission** - tell the user the task ID and expected wait time
5. **Poll for completion** - check status every 15-30 seconds
6. **Retrieve results** - extract text content and download output files
7. **Deliver to user** - present findings and attach any files directly

### Important guidelines

- **Always poll for completion** before telling the user the task is done
- **Download output files locally** instead of giving manus.im links (they can be unreliable)
- **Use `agent` mode** for tasks that create files or documents
- **Set expectations** - Manus tasks take 2-10+ minutes for complex work
- **Include `createShareableLink: true`** in every task creation request
- **Sanitize filenames** when downloading (strip special characters)
- **Use multi-turn** when the user wants to iterate on previous results
- **Use projects** when the user has consistent style/format preferences across tasks

---

## Error Recovery

### API key invalid or missing

```
HTTP 401 or 403
```

Tell the user:
- "Your Manus API key appears to be invalid or missing."
- "Set it with: `export MANUS_API_KEY='your-key-here'`"
- "Get a key at https://manus.im"

### Task creation failed

```
HTTP 400 or 500
```

- Check that the prompt is not empty
- Verify the agent profile is valid (`manus-1.6`, `manus-1.6-lite`, `manus-1.6-max`)
- Verify the task mode is valid (`agent`, `chat`, `adaptive`)
- Retry once after a 5-second wait
- If it fails again, report the error to the user

### Task failed during execution

When status is `failed`:
- Report the failure to the user
- Check the response for an error message or reason
- Suggest simplifying the prompt or breaking it into smaller tasks
- Offer to retry with a different agent profile

### Rate limiting

```
HTTP 429
```

- Wait 30 seconds before retrying
- Inform the user: "Manus rate limit reached. Waiting before retry."
- After 3 failed retries, stop and tell the user to try again later

### Network or timeout errors

- Retry the request once after 5 seconds
- If polling times out (no completion after 10 minutes), inform the user the task is still running on Manus servers and give them the task ID to check later

---

## Helper Script Reference

The included `scripts/manus.sh` provides CLI shortcuts:

```
manus.sh create "prompt" [profile]       - Create a new task
manus.sh get <task_id>                   - Get full task details
manus.sh status <task_id>               - Get status (pending/running/completed/failed)
manus.sh wait <task_id> [timeout]        - Wait for completion (default: 600s)
manus.sh files <task_id>                 - List output files
manus.sh download <task_id> [dir]        - Download all output files
manus.sh list [status]                   - List tasks (optionally filter by status)
manus.sh update <task_id> "new title"    - Update task title
manus.sh delete <task_id>               - Delete a task
manus.sh upload <filepath>               - Upload a file, returns file_id
manus.sh list-files                      - List recent uploaded files
manus.sh delete-file <file_id>           - Delete an uploaded file
manus.sh create-project "name" "instructions" - Create a project
manus.sh list-projects                   - List projects
manus.sh webhook-create <url> [events]   - Create a webhook
manus.sh webhook-delete <webhook_id>     - Delete a webhook
```

Profiles: `manus-1.6` (default), `manus-1.6-lite`, `manus-1.6-max`

---

## Cross-Skill Integration

- **Need real-time web search?** Use `/parallel` for fast multi-engine web searches that return immediately - good for gathering context before creating a Manus task.
- **Need social media / trend research?** Use `/last30days` for Twitter/X, Reddit, and news monitoring with sentiment analysis.
- **Need to read a specific webpage?** Use your built-in WebFetch tool rather than sending a full Manus task for a single page.

Manus is best for tasks that require **autonomous multi-step work** - browsing multiple sites, compiling findings, generating formatted deliverables. For quick lookups, other tools are faster and cheaper.

---

## API Reference

- API Docs: https://open.manus.ai/docs
- Main Site: https://manus.im
- Dashboard: https://manus.im/app
