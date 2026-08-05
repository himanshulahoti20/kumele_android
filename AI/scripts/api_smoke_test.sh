#!/usr/bin/env bash
#
# api_smoke_test.sh — manual smoke test against the REAL Kumele backend.
#
# The Swift unit tests in KumeleTests/APIServiceTests.swift run offline against a
# mock network manager — they prove the app's request/response handling logic is
# correct, but they cannot tell you whether a real backend actually matches that
# contract. This script hits the backend directly with curl so you can see the
# real, current response shape before/while wiring up a Service method.
#
# IMPORTANT: this targets the REAL backend found on 2026-07-24
# (http://84.247.131.180/api/v1, Swagger UI at http://84.247.131.180/docs) — NOT
# APIConstants.baseURL (https://testdomain.goodwish.com.np), which does not
# resolve via DNS at all. See AI/07_BackendContractFindings.md: this real
# backend's Auth contract does NOT match what Kumele/Services/Auth/AuthService.swift
# currently sends (different field names, no APIResponse<T> envelope, Bearer JWT
# not "Token <token>", access+refresh token pair not one userToken). The request
# bodies below use the REAL contract (from AI/api-reference/openapi.json), not the
# app's current assumptions — that's the point of this script: to show you the
# real shape so you know what the app's code needs to change to.
#
# See AI/03_APITestingWorkflow.md for the full testing checklist this feeds into,
# and AI/api-reference/endpoint-catalog.md for the full 211-endpoint catalog this
# only covers a slice of.
#
# WARNING:
#   - The `register` check creates a REAL account on the backend every time you
#     run it with GENERATE_UNIQUE_EMAIL=1 (the default). Don't run it repeatedly
#     without knowing how the backend/team wants test accounts cleaned up.
#   - `login`/`verify_email`/`users_profile` will fail without real credentials/a
#     real token — that's expected; they're here to show you the real error/response
#     shape, not to pass out of the box.
#
# Usage:
#   chmod +x AI/scripts/api_smoke_test.sh
#   ./AI/scripts/api_smoke_test.sh                        # run every check
#   ./AI/scripts/api_smoke_test.sh register                # run just one named check
#   ./AI/scripts/api_smoke_test.sh --token ACCESS_TOKEN    # supply a real access_token for authed endpoints
#   LOGIN_EMAIL=you@x.com LOGIN_PASSWORD=... ./AI/scripts/api_smoke_test.sh login
#
# Requires: curl, and jq if you want pretty-printed output (falls back to raw if absent).

set -uo pipefail

BASE_URL="${BASE_URL:-http://84.247.131.180/api/v1}"
TOKEN="${TOKEN:-}"
GENERATE_UNIQUE_EMAIL="${GENERATE_UNIQUE_EMAIL:-1}"

# --- arg parsing ---------------------------------------------------------
ONLY=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --token) TOKEN="$2"; shift 2 ;;
    --base-url) BASE_URL="$2"; shift 2 ;;
    -h|--help)
      grep -E '^#( |$)' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) ONLY="$1"; shift ;;
  esac
done

hr() { printf -- '--------------------------------------------------------------\n'; }

run() {
  local name="$1"
  if [[ -n "$ONLY" && "$ONLY" != "$name" ]]; then return 1; fi
  hr
  echo "### $name"
  hr
  return 0
}

# Populates the global AUTH_HEADER_ARGS array with -H "Authorization: Bearer ..."
# (or empty if no token). Every use below expands it as
# "${AUTH_HEADER_ARGS[@]+"${AUTH_HEADER_ARGS[@]}"}" rather than plain
# "${AUTH_HEADER_ARGS[@]}" because macOS ships bash 3.2, where `set -u` treats
# expanding an empty array as an unbound-variable error (fixed in bash 4+).
AUTH_HEADER_ARGS=()
set_auth_header_args() {
  if [[ -n "$TOKEN" ]]; then
    AUTH_HEADER_ARGS=(-H "Authorization: Bearer $TOKEN")
  else
    AUTH_HEADER_ARGS=()
  fi
}

# req METHOD URL [extra curl args...]
# Prints the pretty-printed body, then a separate "HTTP <code>" line.
# Does NOT append -w text into the same stream as the JSON body — jq errors on
# trailing non-JSON content and silently swallows it via the `|| cat` fallback,
# which was dropping the HTTP status line entirely in earlier versions of this
# script. Splitting them via a sentinel keeps both readable.
req() {
  local method="$1" url="$2"
  shift 2
  local sentinel="__SMOKETEST_STATUS__"
  local raw status body
  raw="$(curl -sS -X "$method" "$url" "$@" -w "${sentinel}%{http_code}")"
  status="${raw##*${sentinel}}"
  body="${raw%"${sentinel}${status}"}"
  if [[ -n "$body" ]]; then
    if command -v jq >/dev/null 2>&1; then
      printf '%s' "$body" | jq . 2>/dev/null || printf '%s\n' "$body"
    else
      printf '%s\n' "$body"
    fi
  fi
  echo "HTTP $status"
}

# --- checks ----------------------------------------------------------------

check_health() {
  run health || return 0
  echo "GET /health"
  req GET "$BASE_URL/health"
}

check_register() {
  run register || return 0
  local email="qa+smoketest@example.com"
  if [[ "$GENERATE_UNIQUE_EMAIL" == "1" ]]; then
    email="qa+smoketest-$(date +%s)@example.com"
  fi
  echo "POST /auth/signup (real SignupDto shape: email, password, firstName, lastName; NO confirm_password/name/above_legal_age on this backend)"
  echo "email: $email"
  req POST "$BASE_URL/auth/signup" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$email\",\"password\":\"Test1234\",\"firstName\":\"QA\",\"lastName\":\"SmokeTest\"}"
  echo "Expect: 201 with access_token/refresh_token/user_id/email/role/profile_status/isOnboardingCompleted/emailVerified — NOT the old {data,message,success} envelope."
}

check_login() {
  run login || return 0
  echo "POST /auth/login (expected to fail with 401 unless you supply real credentials via LOGIN_EMAIL/LOGIN_PASSWORD env vars)"
  req POST "$BASE_URL/auth/login" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"${LOGIN_EMAIL:-nonexistent@example.com}\",\"password\":\"${LOGIN_PASSWORD:-wrong-password}\"}"
}

check_verify_email() {
  run verify_email || return 0
  if [[ -z "$TOKEN" ]]; then
    echo "SKIPPED — real /auth/verify-email requires JWT-auth (you verify YOUR OWN email while logged in with --token ACCESS_TOKEN); it does not take an email+code pair anonymously like the app's current AuthService.verificationEmail does."
    return 0
  fi
  echo "POST /auth/verify-email (real VerifyEmailDto is just {otp}, authenticated)"
  req POST "$BASE_URL/auth/verify-email" \
    -H "Content-Type: application/json" \
    "${AUTH_HEADER_ARGS[@]+"${AUTH_HEADER_ARGS[@]}"}" \
    -d "{\"otp\":\"${VERIFY_CODE:-000000}\"}"
}

check_users_profile() {
  run users_profile || return 0
  if [[ -z "$TOKEN" ]]; then
    echo "SKIPPED — requires --token ACCESS_TOKEN (the access_token from a real /auth/login or /auth/signup response, sent as 'Authorization: Bearer <token>')"
    return 0
  fi
  echo "GET /users/profile"
  req GET "$BASE_URL/users/profile" "${AUTH_HEADER_ARGS[@]+"${AUTH_HEADER_ARGS[@]}"}"
}

check_hobbies_categories() {
  run hobbies_categories || return 0
  echo "GET /hobbies/categories (real backend is category -> hobbies, two-level; NOT a flat /api/hobbies/ list like the app currently assumes)"
  req GET "$BASE_URL/hobbies/categories"
}

check_hobbies_by_category() {
  run hobbies_by_category || return 0
  echo "GET /hobbies/categories/{id}/hobbies — run hobbies_categories first to get a real category id; this uses a placeholder id and will likely 404."
  req GET "$BASE_URL/hobbies/categories/${HOBBY_CATEGORY_ID:-placeholder-id}/hobbies"
}

check_events_list() {
  run events_list || return 0
  echo "GET /events (real backend is one unified list endpoint with query filters; NOT three separate list/matched/owned endpoints)"
  req GET "$BASE_URL/events?centerLat=27.6767339&centerLon=85.316805&radiusKm=100" \
    "${AUTH_HEADER_ARGS[@]+"${AUTH_HEADER_ARGS[@]}"}"
}

check_events_recommendations() {
  run events_recommendations || return 0
  if [[ -z "$TOKEN" ]]; then
    echo "SKIPPED — requires --token ACCESS_TOKEN (this is likely the real equivalent of the app's getEventMatched — confirm with backend team)"
    return 0
  fi
  echo "GET /events/recommendations"
  req GET "$BASE_URL/events/recommendations" "${AUTH_HEADER_ARGS[@]+"${AUTH_HEADER_ARGS[@]}"}"
}

check_blogs_feed() {
  run blogs_feed || return 0
  echo "GET /blogs/feed (cursor-based pagination; real equivalent of the app's fetchAllBlog/fetchAllBlogByCategory via ?hobbyCategoryId=)"
  req GET "$BASE_URL/blogs/feed?limit=5"
}

check_blogs_detail() {
  run blogs_detail || return 0
  echo "GET /blogs/{id} — uses a placeholder id and will likely 404; run blogs_feed first to get a real blog id."
  req GET "$BASE_URL/blogs/${BLOG_ID:-placeholder-id}" "${AUTH_HEADER_ARGS[@]+"${AUTH_HEADER_ARGS[@]}"}"
}

set_auth_header_args

echo "Base URL: $BASE_URL"
[[ -n "$TOKEN" ]] && echo "Using token: ${TOKEN:0:10}... (sent as Authorization: Bearer)" || echo "No token supplied — authenticated endpoints will be skipped. Get one from check_register/check_login's access_token field, then pass --token <access_token>."

# --- preflight: does the base URL even resolve? ---------------------------
# Skipped entirely for a bare IP literal (e.g. the real backend's 84.247.131.180)
# since there's nothing to resolve — `dig`/`nslookup` against a raw IP is not a
# meaningful DNS check and previously produced a false-positive warning here.
host="${BASE_URL#https://}"
host="${host#http://}"
host="${host%%/*}"
host="${host%%:*}"
if [[ "$host" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
  : # bare IP literal — no DNS involved, nothing to preflight
else
  resolved=""
  if command -v dig >/dev/null 2>&1; then
    resolved="$(dig +short "$host" 2>/dev/null)"
  elif command -v nslookup >/dev/null 2>&1; then
    resolved="$(nslookup "$host" 2>/dev/null | grep -A1 '^Name:' | grep 'Address' )"
  fi
  if [[ -z "$resolved" ]]; then
    echo
    echo "!!! WARNING: '$host' did not resolve via DNS on this machine."
    echo "!!! Every request below will likely fail with a connection error, not a real API response."
    echo "!!! If you're testing against APIConstants.baseURL (testdomain.goodwish.com.np) instead of the"
    echo "!!! real backend, note that host does not resolve at all — see AI/07_BackendContractFindings.md."
    echo
  fi
fi

check_health
check_register
check_login
check_verify_email
check_users_profile
check_hobbies_categories
check_hobbies_by_category
check_events_list
check_events_recommendations
check_blogs_feed
check_blogs_detail

hr
echo "Done. Compare each response's shape/fields against AI/07_BackendContractFindings.md and"
echo "AI/api-reference/openapi.json — NOT against the Codable models in Kumele/Models/, which were"
echo "written against a different, older API contract."
