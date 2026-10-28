# Thiết lập UTF-8 cho console PowerShell để hiển thị đúng tiếng Việt có dấu
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
if ($host.Name -eq 'ConsoleHost') {
    chcp 65001 > $null
}

# Stop khi có lỗi
$ErrorActionPreference = "Stop"

# Thông tin repo
$RepoName = "note-work"
$Username = "quoctuyenit"

# Đọc token từ file
$TokenPath = "D:\0.CODE\github_token.txt"
if (-Not (Test-Path $TokenPath)) {
    Write-Error "Không tìm thấy file token ở $TokenPath"
    exit 1
}
$Token = Get-Content $TokenPath | Out-String
$Token = $Token.Trim()

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Bắt đầu build & deploy Flutter Web release" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Build Flutter web (release)
flutter build web --release --base-href "/note-work/" --tree-shake-icons --dart2js-optimization O4 --pwa-strategy offline-first

# 2. Vào thư mục build
Set-Location build/web

# 3. Tạo mã phiên bản build theo thời gian (Cache-busting cho PWA trên điện thoại)
$BuildVersion = Get-Date -Format "yyyyMMddHHmmss"
Write-Host "Cập nhật mã phiên bản build: v$BuildVersion" -ForegroundColor Yellow

# Gán mã version vào index.html (đảm bảo đọc & ghi đúng chuẩn UTF-8)
(Get-Content index.html -Encoding UTF8) -replace '\{\{BUILD_VERSION\}\}', $BuildVersion | Set-Content index.html -Encoding UTF8

# 4. Đảm bảo git cho phép thư mục build/web
$webDir = (Get-Location).Path.Replace('\', '/')
git config --global --add safe.directory $webDir

# 5. Init repo tạm và cấu hình remote
git init
$RemoteUrl = "https://${Username}:${Token}@github.com/${Username}/${RepoName}.git"
$existingRemotes = git remote
if ($existingRemotes -contains "origin") {
    git remote set-url origin $RemoteUrl
} else {
    git remote add origin $RemoteUrl
}

# 6. Checkout hoặc reset branch gh-pages
git checkout -B gh-pages

# 7. Commit và push
git add .
git commit -m "Deploy Flutter Web v$BuildVersion" --allow-empty
git push -f origin gh-pages

# 8. Quay lại thư mục gốc
Set-Location ../..

# 9. Tự động Purge CDN jsDelivr để cập nhật ngay lập tức trên toàn cầu
Write-Host "Đang tự động xóa cache CDN jsDelivr..." -ForegroundColor Cyan
try {
    $purgeResult = Invoke-RestMethod -Uri "https://purge.jsdelivr.net/gh/${Username}/${RepoName}@gh-pages/main.dart.js" -Method Get
    Write-Host "Đã xóa cache jsDelivr thành công! (Status: $($purgeResult.status))" -ForegroundColor Green
} catch {
    Write-Warning "Không thể xóa cache jsDelivr tự động: $_"
}

Write-Host "==========================================" -ForegroundColor Green
Write-Host " Deploy hoàn tất thành công! v$BuildVersion" -ForegroundColor Green
Write-Host " PWA trên điện thoại sẽ tự động nhận code mới." -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
