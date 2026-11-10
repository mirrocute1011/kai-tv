# Kai TV ─ 每週學習影音頁（類 YouTube）

讓孩子每天在一個像 YouTube 的頁面裡，看完「今日任務」影片就拿到一顆 ⭐；集星解鎖獎勵。

## 怎麼開
- 雙擊 `啟動KaiTV.bat`：會開一個小黑視窗（本機伺服器）並自動用預設瀏覽器打開 http://localhost:8765/ 。黑視窗要留著，關掉就停止。
- 不能直接雙擊 `index.html` 開：YouTube 內嵌播放器會回「錯誤 153」（沒有來源網址）。
- 建議把 `啟動KaiTV.bat` 的捷徑放到桌面，並在 Chrome 把 localhost:8765 加入書籤。
- 觀看紀錄、星星、家長設定存在這台裝置的瀏覽器裡（localStorage）；換裝置不會同步。
- 家長後台：右上角 ⚙️ → PIN 預設 `1234`（可在後台改）。

## 每週更新 SOP（約 10 分鐘）
1. 把學校的 `PHIẾU BÁO BÀI` PDF 放進 `E:\個人資料\ROYAL_練習題\`。
2. 在 Claude 的 EDU 專案說「更新下週影音頁」→ Claude 讀 PDF、到 YouTube 找官方／可信教育頻道影片、核對可嵌入，寫成 `weeks/YYYY-MM-DD.json`（週一日期）。
3. `python3 build.py YYYY-MM-DD` → 產出 `index.html`（本週）與 `dist/YYYY-MM-DD.html`（存檔）。
4. 孩子的裝置重新整理 `index.html` 即是新的一週；上一週的星星紀錄留在瀏覽器（以週一日期分 key）。

## 檔案
- `template.html`：頁面模板（UI＋邏輯），一般不用動。
- `weeks/*.json`：每週資料；每部影片欄位 `id / subject / title / channel / len / core / note`。`core:true` ＝ 今日任務（計星）；`false` ＝ 延伸觀賞。
- `channels.json`：延伸頻道（Numberblocks／Blippi／樂樂TV／Alphablocks），頻道頁用上傳清單 `UU…` 嵌入播放。
- `build.py`：注入資料並檢查（ID 格式、重複、每天至少一部任務）。

## 家長後台功能
新增影片到某一天（貼網址即可，自動抓標題）、隱藏／標記已看、新增延伸頻道（頻道 ID）、獎勵階梯文字、名稱／PIN／看完判定門檻（預設看到 90%）、匯出 JSON、重設本週進度。

## 影片挑選原則
- 優先官方頻道（Numberblocks、Alphablocks、Blippi、VTV7 KIDS、樂樂TV）與教師自製課程（Lớp Cô Giang、Cô Thu 等越南小一 KNTT 教材）。
- 任務影片每天 4–5 部、合計約 30–45 分鐘；越語課程影片較長（15–20 分）可視情況改為延伸。
- 加入前用 `https://www.youtube.com/oembed?url=...` 確認可嵌入（200）。
