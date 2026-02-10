---
name: manus
description: Create and manage AI agent tasks via Manus API. Manus is an autonomous AI agent that can browse the web, use tools, and deliver complete work products.
homepage: https://manus.im
metadata: {"clawdbot":{"emoji":"🤖","requires":{"env":["MANUS_API_KEY"]},"primaryEnv":"MANUS_API_KEY"}}
---

# Manus AI Agent

Manus is an autonomous AI agent with its own virtual computer. It can browse the web, create files, install software, and deliver complete work products.

## API Base

`https://api.manus.ai/v1`

## Authentication

Header: `API_KEY: <your-key>`

Set via:
- `MANUS_API_KEY` env var
- Or `skills.manus.apiKey` in clawdbot config

---

## Create a Task

```bash
curl -X POST "https://api.manus.ai/v1/tasks" \
  -H "API_KEY: $MANUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Your task description here",
    "agentProfile": "manus-1.6",
    "taskMode": "agent",
    "createShareableLink": true
  }'
```

Response:
```json
{
  "task_id": "abc123",
  "task_title": "Task Title",
  "task_url": "https://manus.im/app/abc123",
  "share_url": "https://manus.im/share/abc123"
}
```

### Task Parameters

| Param | Type | Description |
|-------|------|-------------|
| `prompt` | string | Task instructions (required) |
| `agentProfile` | enum | `manus-1.6`, `manus-1.6-lite`, `manus-1.6-max` |
| `taskMode` | enum | `chat`, `adaptive`, `agent` |
| `createShareableLink` | bool | Make publicly accessible |
| `projectId` | string | Associate with a project |
| `taskId` | string | Continue existing task (multi-turn) |
| `interactiveMode` | bool | Allow follow-up questions |
| `connectors` | string[] | Connector UUIDs to enable |
| `attachments` | array | Files to attach (see below) |
| `hideInTaskList` | bool | Hide from webapp |

---

## Agent Profiles

| Profile | Description | Use for |
|---------|-------------|---------|
| `manus-1.6` | Standard (default) | Most tasks |
| `manus-1.6-lite` | Faster, lighter | Quick/simple stuff |
| `manus-1.6-max` | Complex, thorough | Deep research/analysis |

---

## Attachments (NEW)

Three ways to attach files:

```json
{
  "attachments": [
    {"fileId": "file_abc123"},
    {"url": "https://example.com/doc.pdf"},
    {"base64": "data:image/png;base64,iVBOR...", "fileName": "image.png"}
  ]
}
```

### Upload Files First

```bash
curl -X POST "https://api.manus.ai/v1/files" \
  -H "API_KEY: $MANUS_API_KEY" \
  -F "file=@document.pdf"
```

Returns `file_id` to use in attachments.

---

## Projects (NEW)

Organize tasks with shared instructions:

```bash
# Create project
curl -X POST "https://api.manus.ai/v1/projects" \
  -H "API_KEY: $MANUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Research Project",
    "instruction": "Always include citations and sources"
  }'

# Use project in task
curl -X POST "https://api.manus.ai/v1/tasks" \
  -H "API_KEY: $MANUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Research AI safety trends",
    "projectId": "proj_abc123"
  }'
```

---

## Connectors (NEW)

Let Manus access your other apps. Set up OAuth at manus.im first.

| Connector | Use for |
|-----------|---------|
| Gmail | Read/send emails |
| Google Calendar | Schedule meetings |
| Notion | Search/update databases |

```json
{
  "prompt": "Check my calendar for tomorrow",
  "connectors": ["connector-uuid-here"]
}
```

---

## Webhooks (NEW)

Get notified when tasks complete:

```bash
# Register webhook
curl -X POST "https://api.manus.ai/v1/webhooks" \
  -H "API_KEY: $MANUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"webhook": {"url": "https://your-endpoint.com/manus"}}'
```

Webhook payload includes task status, output files, and results.

---

## Multi-Turn Conversations (NEW)

Continue an existing task:

```bash
curl -X POST "https://api.manus.ai/v1/tasks" \
  -H "API_KEY: $MANUS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Now add more details to section 3",
    "taskId": "existing-task-id"
  }'
```

---

## Interactive Mode (NEW)

Let Manus ask clarifying questions:

```json
{
  "prompt": "Create a presentation",
  "interactiveMode": true
}
```

Manus will ask follow-up questions if the input is insufficient.

---

## Get Task Status

```bash
curl "https://api.manus.ai/v1/tasks/{task_id}" \
  -H "API_KEY: $MANUS_API_KEY"
```

Status: `pending` → `running` → `completed` / `failed`

### Output Files

When complete, check `output` array for files:
```json
{
  "output": [{
    "content": [{
      "type": "output_file",
      "fileUrl": "https://manuscdn.com/...",
      "fileName": "presentation.pdf"
    }]
  }]
}
```

Download files directly - don't rely on share URLs.

---

## List Tasks

```bash
curl "https://api.manus.ai/v1/tasks" \
  -H "API_KEY: $MANUS_API_KEY"
```

---

## Recommended Workflow

1. **Create task** with `createShareableLink: true`, `taskMode: "agent"`
2. **Poll for completion** using task_id
3. **Download output files** from `fileUrl` directly
4. **Deliver to user** as attachments

Tasks can take 2-10+ minutes for complex work.

---

## Docs

- API Reference: https://open.manus.ai/docs
- Main Docs: https://manus.im/docs
