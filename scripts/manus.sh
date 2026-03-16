#!/bin/bash
# Manus API helper script (v3.0.0 - Manus 1.6)
# Usage: manus.sh <action> [args]

API_BASE="https://api.manus.im/v1"

if [ -z "$MANUS_API_KEY" ]; then
  echo "Error: MANUS_API_KEY not set" >&2
  exit 1
fi

action="$1"
shift

case "$action" in
  create)
    # Create a task: manus.sh create "your prompt here" [profile]
    prompt="$1"
    profile="${2:-manus-1.6}"
    curl -s -X POST "$API_BASE/tasks" \
      -H "API_KEY: $MANUS_API_KEY" \
      -H "Content-Type: application/json" \
      -d "{\"prompt\": $(echo "$prompt" | jq -Rs .), \"agentProfile\": \"$profile\", \"taskMode\": \"agent\", \"createShareableLink\": true}"
    ;;

  get)
    # Get task: manus.sh get <task_id>
    task_id="$1"
    curl -s "$API_BASE/tasks/$task_id" \
      -H "API_KEY: $MANUS_API_KEY"
    ;;

  status)
    # Get task status only: manus.sh status <task_id>
    task_id="$1"
    curl -s "$API_BASE/tasks/$task_id" \
      -H "API_KEY: $MANUS_API_KEY" | jq -r '.status // "unknown"'
    ;;

  wait)
    # Wait for task completion: manus.sh wait <task_id> [timeout_seconds]
    task_id="$1"
    timeout="${2:-600}"
    elapsed=0
    interval=10

    while [ $elapsed -lt $timeout ]; do
      status=$(curl -s "$API_BASE/tasks/$task_id" -H "API_KEY: $MANUS_API_KEY" | jq -r '.status // "unknown"')

      if [ "$status" = "completed" ]; then
        echo "completed"
        exit 0
      elif [ "$status" = "failed" ]; then
        echo "failed"
        exit 1
      fi

      sleep $interval
      elapsed=$((elapsed + interval))
      echo "waiting... ($elapsed/$timeout sec, status: $status)" >&2
    done

    echo "timeout"
    exit 1
    ;;

  files)
    # List output files: manus.sh files <task_id>
    task_id="$1"
    curl -s "$API_BASE/tasks/$task_id" \
      -H "API_KEY: $MANUS_API_KEY" | jq -r '.output[]?.content[]? | select(.type == "output_file") | "\(.fileName)\t\(.fileUrl)"'
    ;;

  download)
    # Download output files: manus.sh download <task_id> [output_dir]
    task_id="$1"
    output_dir="${2:-.}"
    mkdir -p "$output_dir"

    curl -s "$API_BASE/tasks/$task_id" \
      -H "API_KEY: $MANUS_API_KEY" | jq -r '.output[]?.content[]? | select(.type == "output_file") | "\(.fileName)\t\(.fileUrl)"' | \
    while IFS=$'\t' read -r filename url; do
      if [ -n "$filename" ] && [ -n "$url" ]; then
        # Sanitize filename
        safe_name=$(echo "$filename" | tr -cd '[:alnum:]._-' | head -c 100)
        [ -z "$safe_name" ] && safe_name="output_file"
        echo "Downloading: $safe_name" >&2
        curl -sL "$url" -o "$output_dir/$safe_name"
        echo "$output_dir/$safe_name"
      fi
    done
    ;;

  list)
    # List tasks: manus.sh list [status]
    filter_status="$1"
    if [ -n "$filter_status" ]; then
      curl -s "$API_BASE/tasks?status=$filter_status" \
        -H "API_KEY: $MANUS_API_KEY"
    else
      curl -s "$API_BASE/tasks" \
        -H "API_KEY: $MANUS_API_KEY"
    fi
    ;;

  update)
    # Update task metadata: manus.sh update <task_id> "new title"
    task_id="$1"
    new_title="$2"
    curl -s -X PUT "$API_BASE/tasks/$task_id" \
      -H "API_KEY: $MANUS_API_KEY" \
      -H "Content-Type: application/json" \
      -d "{\"title\": $(echo "$new_title" | jq -Rs .)}"
    ;;

  delete)
    # Delete a task: manus.sh delete <task_id>
    task_id="$1"
    curl -s -X DELETE "$API_BASE/tasks/$task_id" \
      -H "API_KEY: $MANUS_API_KEY"
    ;;

  upload)
    # Upload a file: manus.sh upload <filepath>
    filepath="$1"
    filename=$(basename "$filepath")
    mimetype=$(file --mime-type -b "$filepath" 2>/dev/null || echo "application/octet-stream")

    # Step 1: Create file record and get presigned URL
    response=$(curl -s -X POST "$API_BASE/files" \
      -H "API_KEY: $MANUS_API_KEY" \
      -H "Content-Type: application/json" \
      -d "{\"fileName\": $(echo "$filename" | jq -Rs .), \"mimeType\": \"$mimetype\"}")

    file_id=$(echo "$response" | jq -r '.file_id // empty')
    upload_url=$(echo "$response" | jq -r '.upload_url // empty')

    if [ -z "$file_id" ] || [ -z "$upload_url" ]; then
      echo "Error: Failed to create file record" >&2
      echo "$response" >&2
      exit 1
    fi

    # Step 2: Upload to presigned S3 URL
    curl -s -X PUT "$upload_url" \
      -H "Content-Type: $mimetype" \
      --data-binary "@$filepath" >/dev/null

    echo "$file_id"
    ;;

  list-files)
    # List recent files: manus.sh list-files
    curl -s "$API_BASE/files" \
      -H "API_KEY: $MANUS_API_KEY"
    ;;

  delete-file)
    # Delete a file: manus.sh delete-file <file_id>
    file_id="$1"
    curl -s -X DELETE "$API_BASE/files/$file_id" \
      -H "API_KEY: $MANUS_API_KEY"
    ;;

  create-project)
    # Create a project: manus.sh create-project "name" "instructions"
    name="$1"
    instructions="$2"
    curl -s -X POST "$API_BASE/projects" \
      -H "API_KEY: $MANUS_API_KEY" \
      -H "Content-Type: application/json" \
      -d "{\"name\": $(echo "$name" | jq -Rs .), \"instructions\": $(echo "$instructions" | jq -Rs .)}"
    ;;

  list-projects)
    # List projects: manus.sh list-projects
    curl -s "$API_BASE/projects" \
      -H "API_KEY: $MANUS_API_KEY"
    ;;

  webhook-create)
    # Create a webhook: manus.sh webhook-create <url> [events]
    webhook_url="$1"
    events="${2:-task_created,task_progress,task_stopped}"
    events_json=$(echo "$events" | jq -Rc 'split(",")')
    curl -s -X POST "$API_BASE/webhooks" \
      -H "API_KEY: $MANUS_API_KEY" \
      -H "Content-Type: application/json" \
      -d "{\"url\": $(echo "$webhook_url" | jq -Rs .), \"events\": $events_json}"
    ;;

  webhook-delete)
    # Delete a webhook: manus.sh webhook-delete <webhook_id>
    webhook_id="$1"
    curl -s -X DELETE "$API_BASE/webhooks/$webhook_id" \
      -H "API_KEY: $MANUS_API_KEY"
    ;;

  *)
    echo "Usage: manus.sh <command> [args]"
    echo ""
    echo "Task commands:"
    echo "  create \"prompt\" [profile]       - Create a new task (default: manus-1.6)"
    echo "  get <task_id>                   - Get full task details"
    echo "  status <task_id>               - Get task status"
    echo "  wait <task_id> [timeout]        - Wait for completion (default: 600s)"
    echo "  files <task_id>                 - List output files"
    echo "  download <task_id> [dir]        - Download all output files"
    echo "  list [status]                   - List tasks (optional status filter)"
    echo "  update <task_id> \"title\"        - Update task title"
    echo "  delete <task_id>               - Delete a task"
    echo ""
    echo "File commands:"
    echo "  upload <filepath>               - Upload a file, returns file_id"
    echo "  list-files                      - List recent uploaded files"
    echo "  delete-file <file_id>           - Delete an uploaded file"
    echo ""
    echo "Project commands:"
    echo "  create-project \"name\" \"instructions\" - Create a project"
    echo "  list-projects                   - List projects"
    echo ""
    echo "Webhook commands:"
    echo "  webhook-create <url> [events]   - Create a webhook"
    echo "  webhook-delete <webhook_id>     - Delete a webhook"
    echo ""
    echo "Profiles: manus-1.6 (default), manus-1.6-lite, manus-1.6-max"
    exit 1
    ;;
esac
