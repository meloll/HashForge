#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════
#  HashForge — Validation Script
#  Reads a HashForge result .txt and validates each hash step
#  using OpenSSL as an independent implementation.
#
#  Usage: ./hashforge-validate.sh resultado.txt
# ════════════════════════════════════════════════════════════════

set -euo pipefail

# ── COLORS ───────────────────────────────────────────────────────
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

# ── HEADER ───────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}  HASHFORGE — VALIDATOR${NC}"
echo -e "${BOLD}════════════════════════════════════════════════════════════${NC}"
echo ""

# ── CHECK DEPENDENCIES ───────────────────────────────────────────
for cmd in openssl python3; do
  if ! command -v "$cmd" &>/dev/null; then
    echo -e "${RED}✗ '$cmd' not found. Please install it and try again.${NC}"
    exit 1
  fi
done

# ── CHECK ARGUMENT ────────────────────────────────────────────────
if [[ $# -lt 1 ]]; then
  echo -e "${YELLOW}Usage: $0 <hashforge-result.txt>${NC}"
  echo ""
  exit 1
fi

RESULT_FILE="$1"

if [[ ! -f "$RESULT_FILE" ]]; then
  echo -e "${RED}✗ File not found: $RESULT_FILE${NC}"
  exit 1
fi

echo -e "${DIM}  File   : $RESULT_FILE${NC}"

# ── READ PHRASE FROM FILE ─────────────────────────────────────────
PHRASE_LINE=$(grep -E "Frase\s*:|Phrase\s*:" "$RESULT_FILE" 2>/dev/null || true)

if [[ -z "$PHRASE_LINE" ]]; then
  echo -e "${RED}✗ Phrase not found in the file.${NC}"
  echo -e "${DIM}  Make sure to check 'include original phrase' when exporting from HashForge.${NC}"
  exit 1
fi

PHRASE=$(echo "$PHRASE_LINE" | sed 's/.*: //' | xargs)
echo -e "${DIM}  Phrase : $PHRASE${NC}"

# ── READ SALT FROM FILE ────────────────────────────────────────────
DEFAULT_SALT="hashforge-v2"
SALT_LINE=$(grep -E "Salt\s*:" "$RESULT_FILE" 2>/dev/null || true)

if [[ -z "$SALT_LINE" ]]; then
  SALT="$DEFAULT_SALT"
  echo -e "${YELLOW}  ⚠ Salt not found in file — using default: '${DEFAULT_SALT}'${NC}"
  echo -e "${DIM}    (this is expected if no KDF algorithm was used in the pipeline)${NC}"
else
  SALT=$(echo "$SALT_LINE" | sed 's/.*: //' | xargs)
  if [[ "$SALT" == "$DEFAULT_SALT" ]]; then
    echo -e "${DIM}  Salt   : $SALT ${YELLOW}(default)${NC}"
  else
    echo -e "${DIM}  Salt   : $SALT ${GREEN}(custom)${NC}"
  fi
fi

# ── PARSE PIPELINE FROM FILE ──────────────────────────────────────
PIPELINE_LINE=$(grep "Pipeline  :" "$RESULT_FILE" 2>/dev/null || grep "Pipeline   :" "$RESULT_FILE" 2>/dev/null || true)

if [[ -z "$PIPELINE_LINE" ]]; then
  echo -e "${RED}✗ Could not find Pipeline line in the file.${NC}"
  echo -e "${DIM}  Make sure the file was exported by HashForge.${NC}"
  exit 1
fi

PIPELINE=$(echo "$PIPELINE_LINE" | sed 's/.*: //' | tr -d '[:space:]')
IFS='→' read -ra ALGOS <<< "$PIPELINE"

echo -e "${DIM}  Pipeline: $(echo "$PIPELINE_LINE" | sed 's/.*: //')${NC}"
echo ""

# ── PARSE EXPECTED HASHES FROM FILE ──────────────────────────────
declare -a EXPECTED_HASHES

step=0
while IFS= read -r line; do
  if [[ "$line" =~ ^[[:space:]]*STEP[[:space:]]+[0-9]+ ]]; then
    step=$((step + 1))
    # next non-empty line is the hash value
    while IFS= read -r hashline; do
      hashline=$(echo "$hashline" | xargs)  # trim
      if [[ -n "$hashline" && "$hashline" != ────* && "$hashline" != ════* ]]; then
        EXPECTED_HASHES+=("$hashline")
        break
      fi
    done
  fi
done < "$RESULT_FILE"

TOTAL_STEPS=${#EXPECTED_HASHES[@]}

if [[ $TOTAL_STEPS -eq 0 ]]; then
  echo -e "${RED}✗ No hash steps found in the file.${NC}"
  exit 1
fi

echo -e "  Found ${BOLD}$TOTAL_STEPS step(s)${NC} to validate."
echo ""

# ── NORMALIZE PHRASE ──────────────────────────────────────────────
# Normalize: lowercase + remove spaces (same as HashForge)
NORMALIZED=$(echo -n "$PHRASE" | tr '[:upper:]' '[:lower:]' | tr -d ' ')
echo -e "${DIM}  Normalized: $NORMALIZED${NC}"
echo ""
echo -e "${BOLD}────────────────────────────────────────────────────────────${NC}"
echo ""

# ── HASH FUNCTIONS ────────────────────────────────────────────────

# Compute hash using OpenSSL — input is hex string (except first step)
# $1 = algorithm name, $2 = input (hex or initial string), $3 = is_first (1/0)
compute_hash() {
  local algo="$1"
  local input="$2"
  local is_first="$3"

  case "$algo" in
    SHA-1)
      if [[ "$is_first" == "1" ]]; then
        echo -n "$input" | openssl dgst -sha1 -hex | awk '{print $NF}'
      else
        echo "$input" | xxd -r -p | openssl dgst -sha1 -hex | awk '{print $NF}'
      fi
      ;;
    SHA-256)
      if [[ "$is_first" == "1" ]]; then
        echo -n "$input" | openssl dgst -sha256 -hex | awk '{print $NF}'
      else
        echo "$input" | xxd -r -p | openssl dgst -sha256 -hex | awk '{print $NF}'
      fi
      ;;
    SHA-384)
      if [[ "$is_first" == "1" ]]; then
        echo -n "$input" | openssl dgst -sha384 -hex | awk '{print $NF}'
      else
        echo "$input" | xxd -r -p | openssl dgst -sha384 -hex | awk '{print $NF}'
      fi
      ;;
    SHA-512)
      if [[ "$is_first" == "1" ]]; then
        echo -n "$input" | openssl dgst -sha512 -hex | awk '{print $NF}'
      else
        echo "$input" | xxd -r -p | openssl dgst -sha512 -hex | awk '{print $NF}'
      fi
      ;;
    PBKDF2-SHA256)
      local hash_algo="sha256"
      local salt="$SALT"
      if [[ "$is_first" == "1" ]]; then
        openssl kdf -keylen 32 -kdfopt "digest:${hash_algo}" \
          -kdfopt "pass:${input}" \
          -kdfopt "salt:${salt}" \
          -kdfopt "iter:100000" PBKDF2 2>/dev/null | tr -d ':' | tr '[:upper:]' '[:lower:]'
      else
        # input is hex — convert to raw bytes for password
        local raw_pass
        raw_pass=$(echo "$input" | xxd -r -p | base64)
        python3 - <<PYEOF
import hashlib, binascii, base64
key_hex = "$input"
key_bytes = bytes.fromhex(key_hex)
salt = b"$SALT"
dk = hashlib.pbkdf2_hmac("sha256", key_bytes, salt, 100000, dklen=32)
print(dk.hex())
PYEOF
      fi
      ;;
    PBKDF2-SHA512)
      if [[ "$is_first" == "1" ]]; then
        python3 - <<PYEOF
import hashlib
key = "$input".encode()
salt = b"$SALT"
dk = hashlib.pbkdf2_hmac("sha512", key, salt, 100000, dklen=32)
print(dk.hex())
PYEOF
      else
        python3 - <<PYEOF
import hashlib
key_bytes = bytes.fromhex("$input")
salt = b"$SALT"
dk = hashlib.pbkdf2_hmac("sha512", key_bytes, salt, 100000, dklen=32)
print(dk.hex())
PYEOF
      fi
      ;;
    HKDF-SHA256)
      python3 - <<PYEOF
import hashlib, hmac
def hkdf(hash_name, ikm, salt, info, length):
    prk = hmac.new(salt, ikm, hash_name).digest()
    okm = b""
    t = b""
    for i in range(1, -(-length // hashlib.new(hash_name).digest_size) + 1):
        t = hmac.new(prk, t + info + bytes([i]), hash_name).digest()
        okm += t
    return okm[:length]
ikm = "$input".encode() if "$is_first" == "1" else bytes.fromhex("$input")
result = hkdf("sha256", ikm, b"$SALT", b"hashforge-hkdf", 32)
print(result.hex())
PYEOF
      ;;
    HKDF-SHA512)
      python3 - <<PYEOF
import hashlib, hmac
def hkdf(hash_name, ikm, salt, info, length):
    prk = hmac.new(salt, ikm, hash_name).digest()
    okm = b""
    t = b""
    for i in range(1, -(-length // hashlib.new(hash_name).digest_size) + 1):
        t = hmac.new(prk, t + info + bytes([i]), hash_name).digest()
        okm += t
    return okm[:length]
ikm = "$input".encode() if "$is_first" == "1" else bytes.fromhex("$input")
result = hkdf("sha512", ikm, b"$SALT", b"hashforge-hkdf", 32)
print(result.hex())
PYEOF
      ;;
    *)
      echo "UNSUPPORTED"
      ;;
  esac
}

# ── VALIDATE EACH STEP ────────────────────────────────────────────
PASS=0
FAIL=0
SKIP=0
current="$NORMALIZED"
is_first=1

for i in "${!ALGOS[@]}"; do
  algo=$(echo "${ALGOS[$i]}" | xargs)  # trim whitespace
  expected="${EXPECTED_HASHES[$i]}"
  step_num=$((i + 1))

  echo -e "  ${BOLD}STEP $step_num // $algo${NC}"
  echo -e "  ${DIM}Expected : $expected${NC}"

  computed=$(compute_hash "$algo" "$current" "$is_first" 2>/dev/null || echo "ERROR")
  computed=$(echo "$computed" | xargs | tr '[:upper:]' '[:lower:]')

  echo -e "  ${DIM}Computed : $computed${NC}"

  if [[ "$computed" == "unsupported" ]]; then
    echo -e "  ${YELLOW}⚠ SKIP — algorithm '$algo' not supported by this validator${NC}"
    SKIP=$((SKIP + 1))
  elif [[ "$computed" == "error" || -z "$computed" ]]; then
    echo -e "  ${RED}✗ FAIL — computation error${NC}"
    FAIL=$((FAIL + 1))
  elif [[ "$computed" == "$expected" ]]; then
    echo -e "  ${GREEN}✓ PASS${NC}"
    PASS=$((PASS + 1))
    current="$computed"
  else
    echo -e "  ${RED}✗ FAIL — hash mismatch${NC}"
    FAIL=$((FAIL + 1))
    current="$computed"
  fi

  is_first=0
  echo ""
done

# ── SUMMARY ───────────────────────────────────────────────────────
echo -e "${BOLD}────────────────────────────────────────────────────────────${NC}"
echo ""
echo -e "  Results: ${GREEN}${PASS} passed${NC}  ${RED}${FAIL} failed${NC}  ${YELLOW}${SKIP} skipped${NC}  (total: $TOTAL_STEPS)"
echo ""

if [[ $FAIL -eq 0 && $SKIP -eq 0 ]]; then
  echo -e "  ${GREEN}${BOLD}✓ ALL STEPS VALIDATED SUCCESSFULLY${NC}"
elif [[ $FAIL -eq 0 ]]; then
  echo -e "  ${YELLOW}${BOLD}⚠ VALIDATION COMPLETE WITH SKIPPED STEPS${NC}"
else
  echo -e "  ${RED}${BOLD}✗ VALIDATION FAILED — hash mismatch detected${NC}"
fi

echo ""
echo -e "${BOLD}════════════════════════════════════════════════════════════${NC}"
echo ""

[[ $FAIL -eq 0 ]] && exit 0 || exit 1