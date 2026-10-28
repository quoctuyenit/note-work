# note_work

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Deploy code
- `run Windows PowerShell as administrator`
- `run ./deploy.ps1`
- *Script sẽ tự động:*
  1. Build Flutter Web release
  2. Gắn mã version build chống dính cache cho PWA trên điện thoại (`?v=yyyyMMddHHmmss`)
  3. Push lên branch `gh-pages`
  4. Tự động xóa cache trên CDN jsDelivr (`https://purge.jsdelivr.net/...`)
- Check file code mới nhất trên CDN: https://cdn.jsdelivr.net/gh/quoctuyenit/note-work@gh-pages/main.dart.js
