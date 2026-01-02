# 🤝 Contributing to OPNsense Manager

Thank you for your interest in contributing to OPNsense Manager! This document provides guidelines and instructions for contributing to the project.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Building the Project](#building-the-project)
- [Development Guidelines](#development-guidelines)
- [Code Style](#code-style)
- [Submitting Changes](#submitting-changes)
- [Reporting Issues](#reporting-issues)

## 📜 Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive feedback
- Respect differing viewpoints and experiences

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: Version 3.10.4 or higher
- **Dart SDK**: Version 3.10.4 or higher
- **Android Studio** or **VS Code** with Flutter extensions
- **Git** for version control

For Android development:
- Android SDK (API 21 or higher)
- Android Studio or Android command-line tools

For iOS development (macOS only):
- Xcode 14.0 or higher
- CocoaPods

### 🔧 Development Setup

1. **Fork the repository**
   ```bash
   # Click the "Fork" button on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/opnsense_manager.git
   cd opnsense_manager
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/Etregin/OPNsense_Manager.git
   ```

4. **Install dependencies**
   ```bash
   flutter pub get
   ```

5. **Verify installation**
   ```bash
   flutter doctor
   ```

## 🏗️ Building the Project

### Android

#### Debug Build
```bash
flutter build apk --debug
```

#### Release Build
```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

#### Build App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### iOS

#### Debug Build
```bash
flutter build ios --debug
```

#### Release Build
```bash
flutter build ios --release
```

**Note**: iOS builds require a Mac with Xcode installed and proper code signing certificates.

### Running the App

#### On a connected device
```bash
flutter run
```

#### On a specific device
```bash
flutter devices  # List available devices
flutter run -d DEVICE_ID
```

#### In release mode
```bash
flutter run --release
```

## 💻 Development Guidelines

### General Principles

- **Follow Flutter and Dart best practices**
- **Use meaningful variable and function names**
- **Add comments for complex logic**
- **Keep functions small and focused** (Single Responsibility Principle)
- **Handle errors gracefully** with try-catch blocks and user-friendly messages
- **Test on multiple devices and screen sizes**
- **Ensure no breaking changes** to existing features without discussion
- **Write self-documenting code** when possible

### Architecture

- Follow the existing project structure
- Use proper separation of concerns (Models, Services, Screens, Widgets)
- Keep business logic in services, not in UI widgets
- Use state management appropriately (Provider, Riverpod, etc.)

### Security

- Never commit API keys, secrets, or credentials
- Use secure storage for sensitive data
- Validate all user inputs
- Follow HTTPS best practices
- Test security features thoroughly

## 🎨 Code Style

### Formatting

- **Run `flutter analyze`** before committing to catch potential issues
- **Use `dart format .`** to format all code consistently
- Follow the existing code structure and naming conventions
- Use **const constructors** where possible for better performance

### Dart Conventions

- Use **camelCase** for variables and functions
- Use **PascalCase** for classes and types
- Use **snake_case** for file names
- Add **`mounted` checks** for async BuildContext usage to prevent memory leaks

### Example
```dart
// Good
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});
  
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Future<void> _loadData() async {
    final data = await apiService.fetchData();
    if (!mounted) return; // Always check mounted before setState
    setState(() {
      // Update state
    });
  }
}
```

### Comments

```dart
// Good: Explain WHY, not WHAT
// Retry connection because OPNsense API may be temporarily unavailable
await _retryConnection();

// Bad: States the obvious
// Call retry connection function
await _retryConnection();
```

## 📤 Submitting Changes

### Creating a Pull Request

1. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

2. **Make your changes**
   - Write clean, documented code
   - Follow the code style guidelines
   - Test thoroughly

3. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add amazing feature"
   ```
   
   **Commit Message Guidelines:**
   - Use present tense ("Add feature" not "Added feature")
   - Use imperative mood ("Move cursor to..." not "Moves cursor to...")
   - First line should be 50 characters or less
   - Reference issues and pull requests when relevant

4. **Push to your fork**
   ```bash
   git push origin feature/amazing-feature
   ```

5. **Open a Pull Request**
   - Go to the original repository on GitHub
   - Click "New Pull Request"
   - Select your fork and branch
   - Fill out the PR template with:
     - Clear description of changes
     - Screenshots/videos if UI changes
     - Testing performed
     - Related issues

### Pull Request Checklist

- [ ] Code follows the project's style guidelines
- [ ] Self-review of code completed
- [ ] Comments added for complex code
- [ ] Documentation updated if needed
- [ ] No new warnings from `flutter analyze`
- [ ] Tested on Android (and iOS if possible)
- [ ] Screenshots/videos included for UI changes
- [ ] Related issues referenced in PR description

## 🐛 Reporting Issues

### Before Creating an Issue

1. **Search existing issues** to avoid duplicates
2. **Check the documentation** and README
3. **Try the latest version** to see if the issue is already fixed

### Creating a Good Issue

Use the issue template and include:

- **Clear title** describing the issue
- **App version** and device information
- **OPNsense version** you're connecting to
- **Steps to reproduce** the issue
- **Expected behavior** vs **actual behavior**
- **Screenshots or videos** if applicable
- **Error messages or logs** (remove sensitive information)
- **Additional context** that might be helpful

### Issue Labels

- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Improvements to documentation
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed

## 🧪 Testing

### Manual Testing

- Test on multiple Android versions (minimum API 21)
- Test on different screen sizes (phone and tablet)
- Test with different OPNsense versions
- Test all modified features thoroughly
- Test edge cases and error scenarios

### Before Submitting

```bash
# Run analyzer
flutter analyze

# Format code
dart format .

# Run tests (if available)
flutter test
```

## 📞 Getting Help

If you need help with contributing:

- **GitHub Discussions**: Ask questions and discuss ideas
- **GitHub Issues**: Report bugs or request features
- **Email**: etreginwow@gmail.com

## 🙏 Thank You!

Your contributions make OPNsense Manager better for everyone. We appreciate your time and effort!

---

**Happy Coding! 🚀**