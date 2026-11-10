# Kai TV local server - gives the YouTube embed a proper Referer (avoids error 153)
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$port = 8765
$url  = "http://localhost:$port/"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($url)
try { $listener.Start() } catch { Write-Host "Port $port already in use - opening browser only."; Start-Process $url; exit }
Start-Process $url
Write-Host "Kai TV is running at $url  (close this window to stop)"
$mime = @{ ".html"="text/html; charset=utf-8"; ".json"="application/json; charset=utf-8"; ".js"="text/javascript"; ".css"="text/css"; ".png"="image/png"; ".jpg"="image/jpeg"; ".svg"="image/svg+xml"; ".ico"="image/x-icon" }
while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $path = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath)
  if ($path -eq "/") { $path = "/index.html" }
  $file = Join-Path $root ($path -replace "/", "\")
  if ((Test-Path -LiteralPath $file -PathType Leaf) -and ($file.StartsWith($root))) {
    $bytes = [IO.File]::ReadAllBytes($file)
    $ext = [IO.Path]::GetExtension($file).ToLower()
    $ct = $mime[$ext]
    if (-not $ct) { $ct = "application/octet-stream" }
    $ctx.Response.ContentType = $ct
    $ctx.Response.Headers.Add("Cache-Control", "no-store")
    $ctx.Response.ContentLength64 = $bytes.Length
    $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  } else { $ctx.Response.StatusCode = 404 }
  $ctx.Response.Close()
}
