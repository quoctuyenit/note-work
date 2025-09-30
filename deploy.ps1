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

# Build Flutter web (release)
flutter build web --base-href "/note-work/"

# Vào thư mục build
Set-Location build/web

# Thêm bước ép version cho service worker
(Get-Content flutter_service_worker.js) -replace "const CACHE_NAME = 'flutter-app-cache';", "const CACHE_NAME = 'flutter-app-cache-v$(Get-Date -Format yyyyMMddHHmmss)';" | Set-Content flutter_service_worker.js

# Init repo tạm
git init

# Dùng HTTPS + token
$RemoteUrl = "https://${Username}:${Token}@github.com/${Username}/${RepoName}.git"

# Xóa remote cũ nếu có, rồi add remote mới
git remote remove origin 2>$null
git remote add origin $RemoteUrl

# Checkout gh-pages
git checkout -b gh-pages

# Commit và push
git add .
git commit -m "Deploy Flutter Web"
git push -f origin gh-pages

# Quay lại thư mục gốc
Set-Location ../..
