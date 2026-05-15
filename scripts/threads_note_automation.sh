#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash scripts/threads_note_automation.sh init \
    --campaign "<name>" \
    --theme "<topic>" \
    --note-url "<https://note.com/...>" \
    --price "<jpy>"

  bash scripts/threads_note_automation.sh log \
    --campaign "<name>" \
    --date "YYYY-MM-DD" \
    --cta-id "<cta_a|cta_b|cta_c>" \
    --impressions <n> \
    --clicks <n> \
    --sales <n> \
    --revenue <n>

  bash scripts/threads_note_automation.sh report \
    --campaign "<name>"
EOF
}

slugify() {
  local value="$1"
  value="$(printf "%s" "$value" | tr '[:upper:]' '[:lower:]')"
  value="$(printf "%s" "$value" | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-+|-+$//g')"
  printf "%s" "$value"
}

require_value() {
  local key="$1"
  local value="${2:-}"
  if [[ -z "$value" ]]; then
    echo "[error] missing value: $key"
    usage
    exit 1
  fi
}

validate_non_negative_integer() {
  local key="$1"
  local value="$2"
  if [[ ! "$value" =~ ^[0-9]+$ ]]; then
    echo "[error] ${key} must be a non-negative integer: ${value}"
    exit 1
  fi
}

validate_date() {
  local value="$1"
  if [[ ! "$value" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "[error] --date must be in YYYY-MM-DD format: ${value}"
    exit 1
  fi
}

validate_cta_id() {
  local value="$1"
  case "$value" in
    cta_a|cta_b|cta_c) ;;
    *)
      echo "[error] --cta-id must be one of: cta_a, cta_b, cta_c"
      exit 1
      ;;
  esac
}

ensure_campaign_slug() {
  local original="$1"
  local slug
  slug="$(slugify "$original")"
  if [[ -n "$slug" ]]; then
    printf "%s" "$slug"
    return
  fi

  printf "campaign-%s" "$(date +%Y%m%d%H%M%S)"
}

render_thread_posts() {
  local theme="$1"
  local note_url="$2"
  local price="$3"
  cat <<EOF
# Threads投稿セット（7日分）

## Day 1: 共感フック
- 投稿:
  「${theme}で迷っていた過去の自分へ。最初にやるべきことは1つだけ。遠回りを減らす地図を作ること。」
- CTA(soft):
  「実際に使ってる地図をnoteにまとめました。プロフィールからどうぞ」

## Day 2: 失敗談
- 投稿:
  「${theme}で一番ムダだったのは“全部やる”こと。やらないことを決めたら成果が出始めた。」
- CTA(medium):
  「捨てるべき行動リストをnoteに公開中。${price}円で読めます」

## Day 3: 具体ノウハウ
- 投稿:
  「${theme}で成果が出る人は、毎日の判断基準が同じ。テンプレ化するとブレない。」
- CTA(hard):
  「判断テンプレ3枚をnoteに置いてます。${note_url}」

## Day 4: 実績スクショ文脈
- 投稿:
  「この1週間で変わったのは“作業量”じゃなく“打ち手の順番”。先に順番を決めると強い。」
- CTA(soft):
  「順番設計の手順をnoteで解説しています」

## Day 5: FAQ形式
- 投稿:
  「Q. ${theme}はセンスが必要？ A. いえ、再現手順があればセンス不要です。」
- CTA(medium):
  「再現手順の完全版はnoteにまとめました（プロフィールリンク）」

## Day 6: 反論処理
- 投稿:
  「“今さら遅い”は勘違い。遅いのは開始時期ではなく、検証サイクルがないこと。」
- CTA(hard):
  「検証シート付きnoteはこちら: ${note_url}」

## Day 7: 期限オファー
- 投稿:
  「今週の質問を全部反映して、${theme}の手順を更新しました。」
- CTA(hard):
  「48時間だけ固定価格${price}円。詳しくはnoteへ: ${note_url}」
EOF
}

render_cta_variants() {
  local note_url="$1"
  local price="$2"
  cat <<EOF
# CTA variants

- cta_a (soft): 「続きはプロフィールのnoteにまとめました」
- cta_b (medium): 「実践テンプレをnoteで公開中（${price}円）」
- cta_c (hard): 「今すぐ読む: ${note_url}」
EOF
}

render_note_outline() {
  local theme="$1"
  local price="$2"
  cat <<EOF
# note記事アウトライン（販売向け）

1. 読者の課題定義（${theme}でつまずく理由）
2. ありがちな失敗3つ
3. 最短ルート（手順を番号付きで提示）
4. 実行テンプレ（そのまま使える形式）
5. 7日運用プラン
6. よくある質問
7. まとめ（次のアクション）

## 販売条件メモ
- 価格: ${price}円
- 想定読者: 初級〜中級
- 返金/注意事項: note規約に従う
EOF
}

append_log_row() {
  local csv_path="$1"
  local date="$2"
  local cta_id="$3"
  local impressions="$4"
  local clicks="$5"
  local sales="$6"
  local revenue="$7"
  local ctr cvr

  if [[ "$impressions" -eq 0 ]]; then
    ctr="0"
  else
    ctr="$(awk -v clk="$clicks" -v imp="$impressions" 'BEGIN {printf "%.4f", clk/imp}')"
  fi

  if [[ "$clicks" -eq 0 ]]; then
    cvr="0"
  else
    cvr="$(awk -v sale="$sales" -v clk="$clicks" 'BEGIN {printf "%.4f", sale/clk}')"
  fi

  printf "%s,%s,%s,%s,%s,%s,%s,%s\n" \
    "$date" "$cta_id" "$impressions" "$clicks" "$sales" "$revenue" "$ctr" "$cvr" >> "$csv_path"
}

build_report() {
  local csv_path="$1"
  local campaign="$2"

  if [[ ! -f "$csv_path" ]]; then
    echo "[error] no KPI log found: $csv_path"
    exit 1
  fi

  awk -F',' -v campaign="$campaign" '
    NR == 1 { next }
    {
      rows += 1
      imp += $3
      clk += $4
      sale += $5
      rev += $6
      cta_imp[$2] += $3
      cta_clk[$2] += $4
      cta_sale[$2] += $5
      cta_rev[$2] += $6
    }
    END {
      if (rows == 0) {
        print "# Report"
        print ""
        print "No data rows."
        exit 0
      }

      ctr = (imp == 0) ? 0 : clk / imp
      cvr = (clk == 0) ? 0 : sale / clk
      rpc = (clk == 0) ? 0 : rev / clk

      print "# Report: " campaign
      print ""
      print "- Logged days: " rows
      print "- Total impressions: " imp
      print "- Total clicks: " clk
      printf "- Total CTR: %.2f%%\n", ctr * 100
      print "- Total sales: " sale
      printf "- Total CVR: %.2f%%\n", cvr * 100
      print "- Total revenue (JPY): " rev
      printf "- Revenue per click (JPY): %.2f\n", rpc
      print ""
      print "## CTA breakdown"

      best_cta = ""
      best_rev = -1
      for (cta in cta_rev) {
        cta_ctr = (cta_imp[cta] == 0) ? 0 : cta_clk[cta] / cta_imp[cta]
        cta_cvr = (cta_clk[cta] == 0) ? 0 : cta_sale[cta] / cta_clk[cta]
        printf "- %s: imp=%d, clk=%d, CTR=%.2f%%, sales=%d, CVR=%.2f%%, revenue=%d\n",
          cta, cta_imp[cta], cta_clk[cta], cta_ctr * 100, cta_sale[cta], cta_cvr * 100, cta_rev[cta]
        if (cta_rev[cta] > best_rev) {
          best_rev = cta_rev[cta]
          best_cta = cta
        }
      }

      print ""
      print "## Recommendation"
      print "- Keep using " best_cta " as primary CTA."
      print "- Continue daily posting and log KPI immediately."
      print "- Rebuild next 7-day content around the best CTA angle."
    }
  ' "$csv_path"
}

command="${1:-}"
shift || true

if [[ -z "$command" ]]; then
  usage
  exit 1
fi

campaign=""
theme=""
note_url=""
price=""
date=""
cta_id=""
impressions=""
clicks=""
sales=""
revenue=""

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --campaign) campaign="${2:-}"; shift 2 ;;
    --theme) theme="${2:-}"; shift 2 ;;
    --note-url) note_url="${2:-}"; shift 2 ;;
    --price) price="${2:-}"; shift 2 ;;
    --date) date="${2:-}"; shift 2 ;;
    --cta-id) cta_id="${2:-}"; shift 2 ;;
    --impressions) impressions="${2:-}"; shift 2 ;;
    --clicks) clicks="${2:-}"; shift 2 ;;
    --sales) sales="${2:-}"; shift 2 ;;
    --revenue) revenue="${2:-}"; shift 2 ;;
    *)
      echo "[error] unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

require_value "--campaign" "$campaign"
campaign_slug="$(ensure_campaign_slug "$campaign")"
base_dir=".ai/reports/threads_note/${campaign_slug}"
kpi_csv="${base_dir}/kpi_log.csv"

case "$command" in
  init)
    require_value "--theme" "$theme"
    require_value "--note-url" "$note_url"
    require_value "--price" "$price"
    validate_non_negative_integer "--price" "$price"
    mkdir -p "$base_dir"

    {
      echo "campaign=${campaign}"
      echo "theme=${theme}"
      echo "note_url=${note_url}"
      echo "price=${price}"
    } > "${base_dir}/campaign.env"

    render_thread_posts "$theme" "$note_url" "$price" > "${base_dir}/thread_posts_7days.md"
    render_cta_variants "$note_url" "$price" > "${base_dir}/cta_variants.md"
    render_note_outline "$theme" "$price" > "${base_dir}/note_outline.md"

    cat > "${base_dir}/tracking_links.csv" <<EOF
channel,cta_id,url
threads,cta_a,${note_url}?utm_source=threads&utm_medium=social&utm_campaign=${campaign_slug}&utm_content=cta_a
threads,cta_b,${note_url}?utm_source=threads&utm_medium=social&utm_campaign=${campaign_slug}&utm_content=cta_b
threads,cta_c,${note_url}?utm_source=threads&utm_medium=social&utm_campaign=${campaign_slug}&utm_content=cta_c
EOF

    cat > "$kpi_csv" <<'EOF'
date,cta_id,impressions,clicks,sales,revenue,ctr,cvr
EOF

    echo "[ok] campaign initialized: ${base_dir}"
    ;;
  log)
    require_value "--date" "$date"
    require_value "--cta-id" "$cta_id"
    require_value "--impressions" "$impressions"
    require_value "--clicks" "$clicks"
    require_value "--sales" "$sales"
    require_value "--revenue" "$revenue"
    validate_date "$date"
    validate_cta_id "$cta_id"
    validate_non_negative_integer "--impressions" "$impressions"
    validate_non_negative_integer "--clicks" "$clicks"
    validate_non_negative_integer "--sales" "$sales"
    validate_non_negative_integer "--revenue" "$revenue"

    if [[ ! -f "$kpi_csv" ]]; then
      echo "[error] campaign not initialized: ${base_dir}"
      exit 1
    fi

    append_log_row "$kpi_csv" "$date" "$cta_id" "$impressions" "$clicks" "$sales" "$revenue"
    echo "[ok] KPI logged"
    ;;
  report)
    mkdir -p "$base_dir"
    report_file="${base_dir}/report.md"
    build_report "$kpi_csv" "$campaign" > "$report_file"
    echo "[ok] report generated: ${report_file}"
    ;;
  *)
    echo "[error] unknown command: $command"
    usage
    exit 1
    ;;
esac
