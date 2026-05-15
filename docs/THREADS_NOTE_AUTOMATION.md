# THREADS to note Monetization Automation

## Goal

Create a repeatable system to move audience from Threads posts to note paid articles and maximize revenue with measurable improvement loops.

## Scope

This workflow intentionally focuses on safe and reusable local automation:

- content templates for 7-day Threads posting
- CTA variation design (soft / medium / hard)
- UTM tracking link generation
- daily KPI logging
- report generation with best CTA recommendation

It does not include direct auto-posting to Threads or note API publishing because platform policies, account risks, and API availability can vary.

## Why this is effective

1. Content and CTA are generated together, so message mismatch is reduced.
2. Every CTA has a distinct tracking URL.
3. KPI is logged per CTA, not only per day.
4. Weekly report outputs the best-performing CTA by revenue.
5. Next week content can reuse the winning CTA angle.

## Command flow

### 1) Initialize campaign

```bash
bash scripts/threads_note_automation.sh init \
  --campaign "may_growth" \
  --theme "副業ライティング" \
  --note-url "https://note.com/your_note/n/your_article" \
  --price "980"
```

Generated files:

- `.ai/reports/threads_note/<campaign>/campaign.env`
- `.ai/reports/threads_note/<campaign>/thread_posts_7days.md`
- `.ai/reports/threads_note/<campaign>/cta_variants.md`
- `.ai/reports/threads_note/<campaign>/note_outline.md`
- `.ai/reports/threads_note/<campaign>/tracking_links.csv`
- `.ai/reports/threads_note/<campaign>/kpi_log.csv`

### 2) Log daily KPI

```bash
bash scripts/threads_note_automation.sh log \
  --campaign "may_growth" \
  --date "2026-05-15" \
  --cta-id "cta_b" \
  --impressions 12000 \
  --clicks 420 \
  --sales 16 \
  --revenue 15680
```

### 3) Generate weekly report

```bash
bash scripts/threads_note_automation.sh report --campaign "may_growth"
```

Output:

- `.ai/reports/threads_note/<campaign>/report.md`

## KPI definitions

- impressions: Threads投稿の表示数
- clicks: noteリンクへのクリック数
- sales: note購入数
- revenue: 売上（円）
- CTR: clicks / impressions
- CVR: sales / clicks

## Operating rule (recommended)

- Post 1-2 times daily with one CTA variant each post.
- Keep cta_a, cta_b, cta_c rotation balanced for 7 days.
- Update KPI on the same day to avoid missing data.
- Pick weekly winner by revenue, then by CVR.
- Rebuild next 7-day content with the winning CTA angle.

## Risk notes

- Do not use fake urgency or false claims.
- Follow Threads and note terms.
- Keep claims evidence-based.
- If pricing changes mid-campaign, start a new campaign name for clean attribution.
