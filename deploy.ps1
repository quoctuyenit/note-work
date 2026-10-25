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
flutter build web --release --base-href "/note-work/" --tree-shake-icons --dart2js-optimization O4 --pwa-strategy offline-first

# Vào thư mục build
Set-Location build/web

# Thêm bước ép version cho service worker
(Get-Content flutter_service_worker.js) -replace "const CACHE_NAME = 'flutter-app-cache';", "const CACHE_NAME = 'flutter-app-cache-v$(Get-Date -Format yyyyMMddHHmmss)';" | Set-Content flutter_service_worker.js

# Đảm bảo git cho phép thư mục build/web
$webDir = (Get-Location).Path.Replace('\', '/')
git config --global --add safe.directory $webDir

# Init repo tạm
git init

# Dùng HTTPS + token
$RemoteUrl = "https://${Username}:${Token}@github.com/${Username}/${RepoName}.git"

# Thêm hoặc cập nhật remote origin
$existingRemotes = git remote
if ($existingRemotes -contains "origin") {
    git remote set-url origin $RemoteUrl
} else {
    git remote add origin $RemoteUrl
}

# Checkout hoặc reset branch gh-pages
git checkout -B gh-pages

# Commit và push
git add .
git commit -m "Deploy Flutter Web" --allow-empty
git push -f origin gh-pages

# Quay lại thư mục gốc
Set-Location ../..
