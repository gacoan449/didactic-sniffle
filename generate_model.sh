#!/bin/bash
echo "🔨 MEMBUAT KODE OTOMATIS SEMUA MODEL DENGAN FREEZED..."
echo "================================================"

flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs

echo ""
echo "✅ SELESAI: Semua copyWith, toJson, fromJson, == & hashCode SUDAH TERBUAT OTOMATIS!"
echo "================================================"
