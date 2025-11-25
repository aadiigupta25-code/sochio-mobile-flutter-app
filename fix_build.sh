#!/bin/bash

# Flutter Build Fix Script
echo "Starting Flutter build fix..."

# Clean all build artifacts
echo "Cleaning build artifacts..."
flutter clean

# Remove pubspec.lock to force dependency resolution
echo "Removing pubspec.lock..."
rm -f pubspec.lock

# Remove .dart_tool directory
echo "Removing .dart_tool directory..."
rm -rf .dart_tool

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Verify package resolution
echo "Verifying package resolution..."
flutter pub deps

echo "Build fix complete. Now run: flutter build apk --release"