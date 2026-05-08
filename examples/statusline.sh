#!/bin/bash

json_input=$(cat)
cwd=$(echo "$json_input" | jq -r '.workspace.current_dir // "?"')
model=$(echo "$json_input" | jq -r '.model.display_name // "?"')
pct=$(echo "$json_input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Git 資訊（含快取 5 秒）
GIT_CACHE="/tmp/claude-git-cache"
GIT_CACHE_AGE=5

git_cache_stale() {
  [ ! -f "$GIT_CACHE" ] || \
  [ $(( $(date +%s) - $(stat -f %m "$GIT_CACHE" 2>/dev/null || stat -c %Y "$GIT_CACHE" 2>/dev/null || echo 0) )) -gt $GIT_CACHE_AGE ]
}

git_branch=""
git_staged=0
git_modified=0
git_untracked=0

if git_cache_stale; then
  if cd "$cwd" 2>/dev/null && git rev-parse --git-dir > /dev/null 2>&1; then
    b=$(git branch --show-current 2>/dev/null)
    s=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    m=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    u=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
    echo "$b|$s|$m|$u" > "$GIT_CACHE"
  else
    echo "|||" > "$GIT_CACHE"
  fi
fi

if [ -f "$GIT_CACHE" ]; then
  IFS='|' read -r git_branch git_staged git_modified git_untracked < "$GIT_CACHE"
fi

# Session & Weekly 重置時間（快取 60 秒）
CACHE_FILE="/tmp/claude-reset-cache.json"
CACHE_MAX_AGE=60

cache_is_stale() {
  [ ! -f "$CACHE_FILE" ] || \
  [ $(( $(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0) )) -gt $CACHE_MAX_AGE ]
}

session_pct=0
session_reset="--:--"
weekly_pct=0
weekly_reset="--"

if cache_is_stale; then
  CREDS=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
  [ -z "$CREDS" ] && CREDS=$(cat ~/.claude/.credentials.json 2>/dev/null)
  if [ -n "$CREDS" ]; then
    TOKEN=$(echo "$CREDS" | jq -r '.claudeAiOauth.accessToken // empty')
    if [ -n "$TOKEN" ]; then
      USAGE=$(curl -sf \
        -H "Authorization: Bearer $TOKEN" \
        -H "anthropic-beta: oauth-2025-04-20" \
        -H "Content-Type: application/json" \
        "https://api.anthropic.com/api/oauth/usage")
      [ -n "$USAGE" ] && echo "$USAGE" > "$CACHE_FILE"
    fi
  fi
fi

# UTC 轉台北時間（+8小時）
parse_reset_time() {
  local ts="$1" fmt="$2" result epoch dt
  dt=$(echo "$ts" | sed 's/\.[0-9]*//' | sed 's/[+-][0-9][0-9]:[0-9][0-9]$//')
  epoch=$(date -jf "%Y-%m-%dT%H:%M:%S" "$dt" "+%s" 2>/dev/null)
  if [ -n "$epoch" ]; then
    epoch=$(( epoch + 28800 ))
    result=$(date -r "$epoch" "$fmt" 2>/dev/null)
  fi
  [ -z "$result" ] && result=$(date -d "$ts +8 hours" "$fmt" 2>/dev/null)
  echo "${result:---}"
}

if [ -f "$CACHE_FILE" ]; then
  s_resets_at=$(jq -r '.five_hour.resets_at // empty' "$CACHE_FILE")
  session_pct=$(jq -r '.five_hour.utilization // 0' "$CACHE_FILE" | cut -d. -f1)
  [ -n "$s_resets_at" ] && session_reset=$(parse_reset_time "$s_resets_at" "+%H:%M")

  w_resets_at=$(jq -r '.seven_day.resets_at // empty' "$CACHE_FILE")
  weekly_pct=$(jq -r '.seven_day.utilization // 0' "$CACHE_FILE" | cut -d. -f1)
  [ -n "$w_resets_at" ] && weekly_reset=$(parse_reset_time "$w_resets_at" "+%m/%d %H:%M")
fi

# 顏色
BLUE='\033[34m'
GREEN='\033[32m'
CYAN='\033[36m'
GRAY='\033[90m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

pct_color() {
  local p=$1
  if [ "$p" -ge 80 ] 2>/dev/null; then echo "$RED"
  elif [ "$p" -ge 50 ] 2>/dev/null; then echo "$YELLOW"
  else echo "$GREEN"
  fi
}

# Context 進度條（已用量）
BAR_WIDTH=10
filled=$(( pct * BAR_WIDTH / 100 ))
empty=$(( BAR_WIDTH - filled ))
bar=""
for ((i=0; i<filled; i++)); do bar+="▓"; done
for ((i=0; i<empty; i++)); do bar+="░"; done
BAR_COLOR=$(pct_color "$pct")
SESSION_COLOR=$(pct_color "$session_pct")
WEEKLY_COLOR=$(pct_color "$weekly_pct")

# 建構狀態列
output="📁 ${BLUE}${cwd##*/}${RESET}"

if [ -n "$git_branch" ]; then
  changes=""
  [ "${git_staged:-0}" -gt 0 ] 2>/dev/null && changes+=" ${GREEN}+${git_staged}${RESET}"
  [ "${git_modified:-0}" -gt 0 ] 2>/dev/null && changes+=" ${YELLOW}~${git_modified}${RESET}"
  [ "${git_untracked:-0}" -gt 0 ] 2>/dev/null && changes+=" ${GRAY}?${git_untracked}${RESET}"
  output+=" | 🌿 ${GREEN}${git_branch}${RESET}${changes}"
fi

line2="🤖 ${CYAN}${model}${RESET}"
line2+=" | ${BAR_COLOR}[${bar}]${RESET} ${BAR_COLOR}${pct}%${RESET}"
line2+=" | ${SESSION_COLOR}${session_pct}%${RESET} ${GRAY}→${RESET} ${GRAY}${session_reset}${RESET}"
line2+=" | ${WEEKLY_COLOR}${weekly_pct}%${RESET} ${GRAY}→${RESET} ${GRAY}${weekly_reset}${RESET}"

printf "%b\n%b\n" "$output" "$line2"