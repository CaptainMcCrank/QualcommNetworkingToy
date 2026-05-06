#!/usr/bin/env bash
# Diagnostic Library — WebApp / Service
#
# WebApp counterpart to diagnostic_library.sh (which targets IoT / Pi devices via SSH).
# Provides reusable diagnostic functions for webapp deployments. Source this file
# from troubleshooting scripts; do not execute it directly.
#
# Template location: Standards/Templates/diagnostic_library_webapp.sh
# Consumed by: scripts that the WebDev Validation Agent (06_WebDev) and
#              WebDev Deployment Troubleshooting Agent (06B_WebDev) author.
#
# Conventions:
#   - All functions prefixed `diag_` so callers can grep for them.
#   - Functions return non-zero on failure; do NOT exit.
#   - Functions write structured output to stdout; warnings/errors to stderr.
#   - No secrets are printed at any point. If a function would print a secret,
#     mask the value with ****.
#   - All functions accept their target via env vars or arguments; never hardcode.
#
# Required env vars (callers should export):
#   PROD_URL          # e.g., https://example.com  — base URL of the deployment
#   HOSTING           # vercel | netlify | cloudflare | flyio | render | k8s | self-hosted
# Optional:
#   EXPECTED_SHA      # the git SHA the deployment is supposed to be running
#   PROD_HOST         # derived from PROD_URL if absent

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

diag_require_url() {
  if [[ -z "$PROD_URL" ]]; then
    echo "ERROR: PROD_URL not set" >&2
    return 2
  fi
  : "${PROD_HOST:=$(echo "$PROD_URL" | sed -E 's|https?://([^/]+).*|\1|')}"
}

diag_now() { date -Iseconds; }

# ---------------------------------------------------------------------------
# 1. Hosting platform status
# ---------------------------------------------------------------------------

diag_platform_status() {
  case "${HOSTING:-}" in
    vercel)     curl -fsSL https://www.vercel-status.com/api/v2/summary.json    | jq -r '.status.indicator' 2>/dev/null ;;
    netlify)    curl -fsSL https://www.netlifystatus.com/api/v2/summary.json    | jq -r '.status.indicator' 2>/dev/null ;;
    cloudflare) curl -fsSL https://www.cloudflarestatus.com/api/v2/summary.json | jq -r '.status.indicator' 2>/dev/null ;;
    flyio)      curl -fsSL https://status.flyio.net/api/v2/summary.json         | jq -r '.status.indicator' 2>/dev/null ;;
    render)     curl -fsSL https://status.render.com/api/v2/summary.json        | jq -r '.status.indicator' 2>/dev/null ;;
    *)          echo "no-automated-status-for-$HOSTING" ;;
  esac
}

# ---------------------------------------------------------------------------
# 2. Healthcheck and SHA verification
# ---------------------------------------------------------------------------

diag_healthcheck() {
  diag_require_url || return $?
  local response code
  response=$(curl -sS -m 10 -w "\n%{http_code}" "$PROD_URL/healthz" 2>&1)
  code=$(echo "$response" | tail -1)
  echo "$response" | sed '$d'
  [[ "${code:0:1}" == "2" ]]
}

diag_running_sha() {
  diag_require_url || return $?
  curl -fsS -m 10 "$PROD_URL/healthz" 2>/dev/null | jq -r '.version // empty'
}

diag_sha_matches_expected() {
  diag_require_url || return $?
  if [[ -z "${EXPECTED_SHA:-}" ]]; then
    echo "ERROR: EXPECTED_SHA not set" >&2
    return 2
  fi
  local running
  running=$(diag_running_sha)
  if [[ "$running" == "$EXPECTED_SHA"* ]]; then
    echo "SHA OK: $running"
    return 0
  else
    echo "SHA MISMATCH: running=$running, expected=$EXPECTED_SHA" >&2
    return 1
  fi
}

# ---------------------------------------------------------------------------
# 3. DNS / TLS
# ---------------------------------------------------------------------------

diag_dns() {
  diag_require_url || return $?
  echo "A:    $(dig +short A    "$PROD_HOST" | tr '\n' ' ')"
  echo "AAAA: $(dig +short AAAA "$PROD_HOST" | tr '\n' ' ')"
  echo "CNAME: $(dig +short CNAME "$PROD_HOST" | tr '\n' ' ')"
}

diag_tls() {
  diag_require_url || return $?
  echo "" | timeout 10 openssl s_client -connect "${PROD_HOST}:443" -servername "$PROD_HOST" 2>/dev/null \
    | openssl x509 -noout -subject -issuer -dates 2>/dev/null
}

# ---------------------------------------------------------------------------
# 4. Response headers (cache, security, version)
# ---------------------------------------------------------------------------

diag_headers() {
  diag_require_url || return $?
  curl -sI -m 10 "$PROD_URL/" 2>&1
}

diag_cache_state() {
  diag_require_url || return $?
  diag_headers | grep -iE 'cf-cache-status|x-vercel-cache|x-amz-cf-pop|age|cache-control' | head -10
}

diag_security_headers() {
  diag_require_url || return $?
  diag_headers | grep -iE 'content-security-policy|strict-transport-security|x-frame-options|x-content-type-options|referrer-policy' | head -10
}

# ---------------------------------------------------------------------------
# 5. Recent deployments
# ---------------------------------------------------------------------------

diag_deployments() {
  case "${HOSTING:-}" in
    vercel)      vercel ls 2>&1 | head -20 ;;
    netlify)     netlify api listSiteDeploys --data='{"site_id":"'"${NETLIFY_SITE_ID:-}"'"}' 2>&1 | jq '.[:5] | map({id, state, deploy_time})' 2>/dev/null ;;
    cloudflare)  wrangler deployments list 2>&1 | head -20 ;;
    flyio)       flyctl releases --app "${FLY_APP:-}" 2>&1 | head -20 ;;
    k8s)         kubectl rollout history deployment/"${K8S_DEPLOYMENT:-}" 2>&1 | head -20 ;;
    self-hosted) git log --oneline -10; echo "---"; docker compose ps 2>/dev/null ;;
    *)           echo "no-deployment-listing-for-$HOSTING" >&2; return 2 ;;
  esac
}

# ---------------------------------------------------------------------------
# 6. Application logs (last hour)
# ---------------------------------------------------------------------------

diag_logs_recent() {
  case "${HOSTING:-}" in
    vercel)      vercel logs --since=1h 2>&1 | tail -200 ;;
    netlify)     netlify logs:function --site="${NETLIFY_SITE_ID:-}" 2>&1 | tail -200 ;;
    cloudflare)  timeout 30 wrangler tail --once 2>&1 ;;
    flyio)       flyctl logs --app "${FLY_APP:-}" 2>&1 | head -200 ;;
    k8s)         kubectl logs deployment/"${K8S_DEPLOYMENT:-}" --since=1h --tail=500 2>&1 ;;
    self-hosted) docker compose logs --since=1h --tail=500 2>&1 ;;
    *)           echo "no-log-source-for-$HOSTING" >&2; return 2 ;;
  esac
}

diag_log_errors() {
  diag_logs_recent | grep -iE 'error|fatal|exception|traceback|5[0-9]{2} ' | tail -30
}

# ---------------------------------------------------------------------------
# 7. Error-rate sampling
# ---------------------------------------------------------------------------

diag_error_rate_sample() {
  diag_require_url || return $?
  local n="${1:-20}" code non_2xx=0
  for ((i=0; i<n; i++)); do
    code=$(curl -sS -o /dev/null -w "%{http_code}" -m 10 "$PROD_URL/healthz" 2>/dev/null)
    [[ "${code:0:1}" != "2" ]] && ((non_2xx++))
  done
  echo "non-2xx: $non_2xx / $n"
  # Return non-zero if more than 5% non-2xx
  (( non_2xx * 20 <= n ))
}

diag_latency_sample() {
  diag_require_url || return $?
  local n="${1:-10}"
  for ((i=0; i<n; i++)); do
    curl -sS -o /dev/null -w "%{time_total}\n" -m 10 "$PROD_URL/healthz" 2>/dev/null
  done | awk '{s+=$1; if($1>m)m=$1} END{printf "samples=%d avg=%.3f max=%.3f\n", NR, s/NR, m}'
}

# ---------------------------------------------------------------------------
# 8. Smoke probe of critical endpoints
# ---------------------------------------------------------------------------

diag_critical_endpoints() {
  diag_require_url || return $?
  local endpoints=("$@")
  local failed=0
  for ep in "${endpoints[@]}"; do
    local code
    code=$(curl -sS -o /dev/null -w "%{http_code}" -m 10 "$PROD_URL$ep" 2>/dev/null)
    if [[ "${code:0:1}" == "2" ]] || [[ "${code:0:1}" == "3" ]]; then
      echo "PASS $ep -> $code"
    else
      echo "FAIL $ep -> $code"
      ((failed++))
    fi
  done
  return "$failed"
}

# ---------------------------------------------------------------------------
# 9. CDN cache state
# ---------------------------------------------------------------------------

diag_cdn_compare() {
  diag_require_url || return $?
  local cached fresh
  echo "Cached fetch:"
  curl -sI -m 10 "$PROD_URL/" 2>&1 | grep -iE 'cf-cache-status|x-vercel-cache|age|date' | head -5
  echo ""
  echo "Cache-bypass fetch:"
  curl -sI -m 10 -H "Cache-Control: no-cache" "$PROD_URL/?_cb=$(date +%s)" 2>&1 | grep -iE 'cf-cache-status|x-vercel-cache|age|date' | head -5
}

# ---------------------------------------------------------------------------
# 10. Recent git delta against last-known-good
# ---------------------------------------------------------------------------

diag_git_delta_since() {
  local lkg="${1:-}"
  [[ -z "$lkg" ]] && { echo "ERROR: pass last-known-good ref" >&2; return 2; }
  echo "Commits since $lkg:"
  git log --oneline "$lkg..HEAD" | head -20
  echo ""
  echo "Files changed:"
  git diff --stat "$lkg..HEAD" | tail -20
}

# ---------------------------------------------------------------------------
# Bundled snapshot (one-shot diagnostic capture for an incident)
# ---------------------------------------------------------------------------

diag_snapshot() {
  local out_dir="${1:-.troubleshooting/$(date +%Y-%m-%d_%H%M%S)}"
  mkdir -p "$out_dir"

  diag_platform_status                > "$out_dir/01_platform_status.txt"  2>&1
  diag_healthcheck                    > "$out_dir/02_healthcheck.txt"      2>&1
  diag_dns; diag_tls                  > "$out_dir/03_dns_tls.txt"          2>&1 < <(diag_dns; diag_tls)
  diag_headers                        > "$out_dir/04_headers.txt"          2>&1
  diag_deployments                    > "$out_dir/05_deployments.txt"      2>&1
  diag_logs_recent                    > "$out_dir/06_logs_recent.txt"      2>&1
  diag_error_rate_sample 20           > "$out_dir/07_error_rate.txt"       2>&1 || true
  diag_cdn_compare                    > "$out_dir/09_cdn_state.txt"        2>&1

  cat > "$out_dir/context.json" <<EOF
{
  "collected_at": "$(diag_now)",
  "production_url": "$PROD_URL",
  "expected_sha": "${EXPECTED_SHA:-}",
  "hosting_target": "${HOSTING:-}",
  "files": ["01_platform_status.txt","02_healthcheck.txt","03_dns_tls.txt","04_headers.txt","05_deployments.txt","06_logs_recent.txt","07_error_rate.txt","09_cdn_state.txt"]
}
EOF

  echo "Snapshot: $out_dir"
}
