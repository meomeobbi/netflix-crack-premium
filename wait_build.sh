#!/bin/bash
# Poll GitHub Actions run until it completes, then download the IPA artifact.
# GITHUB_PAT must be set in the environment. Never write the token to a file.
set -u
RUN_ID="${RUN_ID:-42865076018}"
REPO="meomeobbi/netflix-crack-premium"
OUTDIR="$HOME/workspace/netflix-crack-premium"
CONCLUSION=""

for i in $(seq 1 30); do
  STATUS=$(curl -s -H "Authorization: token $GITHUB_PAT" \
    "https://api.github.com/repos/$REPO/actions/runs/$RUN_ID" \
    | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('status','?')+'|'+str(d.get('conclusion')))" 2>/dev/null)
  echo "poll $i: $STATUS"
  S="${STATUS%%|*}"
  C="${STATUS##*|}"
  if [ "$S" = "completed" ]; then
    CONCLUSION="$C"
    break
  fi
  sleep 30
done

echo "FINAL_CONCLUSION=$CONCLUSION"
if [ "$CONCLUSION" = "success" ]; then
  ART_URL=$(curl -s -H "Authorization: token $GITHUB_PAT" \
    "https://api.github.com/repos/$REPO/actions/runs/$RUN_ID/artifacts" \
    | python3 -c "import json,sys; d=json.load(sys.stdin); a=d['artifacts'][0]; print(a['archive_download_url'])")
  echo "artifact url: ${ART_URL%%\?*}"
  curl -sL -H "Authorization: token $GITHUB_PAT" "$ART_URL" -o "$OUTDIR/artifact.zip"
  cd "$OUTDIR" && unzip -o artifact.zip >/dev/null && ls -lh *.ipa
  # verify it is a real IPA (zip with Payload/*.app)
  IPA=$(ls *.ipa | head -1)
  unzip -l "$IPA" | head -8
else
  echo "Build did not succeed. Fetching failed job logs URL:"
  curl -s -H "Authorization: token $GITHUB_PAT" \
    "https://api.github.com/repos/$REPO/actions/runs/$RUN_ID/jobs" \
    | python3 -c "import json,sys; d=json.load(sys.stdin); [print(j['name'], j['status'], j.get('conclusion'), j.get('html_url')) for j in d.get('jobs',[])]"
fi
