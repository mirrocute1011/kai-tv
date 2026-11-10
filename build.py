#!/usr/bin/env python3
"""Kai TV 週頁建置：把 weeks/<週一日期>.json 與 channels.json 注入 template.html → index.html

用法：
  python3 build.py 2026-11-09          # 產出 index.html（給發布用）與 dist/2026-11-09.html（存檔）
  python3 build.py                     # 自動取 weeks/ 最新一週
"""
import json, sys, pathlib, re

ROOT = pathlib.Path(__file__).parent
weeks = sorted((ROOT / "weeks").glob("*.json"))
if not weeks:
    sys.exit("weeks/ 內沒有週資料")
target = (ROOT / "weeks" / f"{sys.argv[1]}.json") if len(sys.argv) > 1 else weeks[-1]
week = json.loads(target.read_text(encoding="utf-8"))
channels = json.loads((ROOT / "channels.json").read_text(encoding="utf-8"))

# 基本檢查：ID 格式、日期順序、每天至少一部 core
ids = set()
for d in week["days"]:
    cores = [v for v in d["videos"] if v.get("core")]
    assert cores, f"{d['date']} 沒有任何今日任務影片"
    for v in d["videos"]:
        assert re.fullmatch(r"[\w-]{11}", v["id"]), f"影片 ID 格式錯誤：{v}"
        assert v["id"] not in ids, f"重複影片：{v['id']}"
        ids.add(v["id"])

tpl = (ROOT / "template.html").read_text(encoding="utf-8")
safe = lambda o: json.dumps(o, ensure_ascii=False).replace("</", "<\\/")
html = tpl.replace("/*__WEEK__*/", safe(week)).replace("/*__CHANNELS__*/", safe(channels))
(ROOT / "index.html").write_text(html, encoding="utf-8")
(ROOT / "dist").mkdir(exist_ok=True)
(ROOT / "dist" / f"{week['weekStart']}.html").write_text(html, encoding="utf-8")
print(f"OK  {target.name} → index.html / dist/{week['weekStart']}.html  ({len(ids)} 部影片)")
