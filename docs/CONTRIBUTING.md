# Contributing to MarketMate

First off, thank you for considering contributing to MarketMate! It's people like you that make MarketMate such a great tool.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)

## Code of Conduct

This project and everyone participating in it is governed by our commitment to maintain a welcoming and inclusive community. By participating, you are expected to uphold this code.

### Our Standards

- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/market-meet.git
   cd market-meet
   ```
3. **Set up the development environment** (see README.md)
4. **Create a branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples** to demonstrate the steps
- **Describe the behavior you observed** and what you expected
- **Include screenshots** if relevant
- **Note your environment** (OS, Flutter version, Node.js version, etc.)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a step-by-step description** of the suggested enhancement
- **Explain why this enhancement would be useful**
- **List some examples** of how it would be used

### Your First Code Contribution

Unsure where to begin? Look for issues labeled:

- `good-first-issue` - Issues that are good for newcomers
- `help-wanted` - Issues that need assistance

### Pull Requests

- Fill in the required template
- Follow the coding style guides
- Include relevant tests
- Update documentation as needed
- End all files with a newline

## Development Workflow

### Mobile App (Flutter)

1. Make your changes in the `mobile/` directory
2. Test your changes:
   ```bash
   cd mobile
   flutter test
   flutter analyze
   ```
3. Run the app to verify:
   ```bash
   flutter run
   ```

### Backend (Node.js)

1. Make your changes in the `backend/` directory
2. Test your changes:
   ```bash
   cd backend
   npm test
   npm run lint
   ```
3. Run the server to verify:
   ```bash
   npm run dev
   ```

## Coding Standards

### Flutter (Dart)

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused
- Use `const` constructors where possible
- Format code using `dart format`:
  ```bash
  dart format lib/
  ```

**Example:**
```dart
// Good
Future<List<Agent>> fetchNearbyAgents({
  required double latitude,
  required double longitude,
  double radiusKm = 10.0,
}) async {
  // Implementation
}

// Bad
Future<List<Agent>> fetch(lat, lng, r) async {
  // Implementation
}
```

### Node.js (JavaScript)

- Follow [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- Use meaningful variable and function names
- Use async/await for asynchronous operations
- Add JSDoc comments for functions
- Keep functions small and focused
- Use ES6+ features

**Example:**
```javascript
// Good
/**
 * Fetch agents within specified radius
 * @param {number} latitude - User's latitude
 * @param {number} longitude - User's longitude
 * @param {number} radius - Search radius in km
 * @returns {Promise<Array>} List of nearby agents
 */
async function fetchNearbyAgents(latitude, longitude, radius = 10) {
  // Implementation
}

// Bad
function fetch(lat, lng, r) {
  // Implementation
}
```

## Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification:

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks

### Examples

```bash
feat(mobile): add agent search filter

Add ability to filter agents by specialty and language.
Users can now narrow down search results for better matches.

Closes #123

---

fix(backend): resolve booking date validation error

Fixed issue where past dates were accepted for bookings.
Added proper date validation in booking controller.

Fixes #456

---

docs(readme): update installation instructions

Updated Firebase setup steps with latest SDK version.
```

## Pull Request Process

1. **Update documentation** if you've changed APIs or added features
2. **Update the README.md** with details of changes if needed
3. **Add tests** for new functionality
4. **Ensure all tests pass**:
   ```bash
   # Flutter
   cd mobile && flutter test

   # Backend
   cd backend && npm test
   ```
5. **Run linters**:
   ```bash
   # Flutter
   cd mobile && flutter analyze

   # Backend
   cd backend && npm run lint
   ```
6. **Create the Pull Request** with a clear title and description
7. **Link related issues** in the PR description
8. **Wait for review** - maintainers will review your PR
9. **Address feedback** if any changes are requested
10. **Celebrate** when your PR is merged!

### Pull Request Template

```markdown
## Description
Brief description of the changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## How Has This Been Tested?
Describe the tests you ran

## Checklist
- [ ] My code follows the project's coding standards
- [ ] I have performed a self-review of my code
- [ ] I have commented my code where necessary
- [ ] I have updated the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix/feature works
- [ ] New and existing tests pass locally

## Screenshots (if applicable)
Add screenshots here

## Related Issues
Closes #(issue number)
```

## Testing

### Writing Tests

#### Flutter Tests
```dart
// Example widget test
testWidgets('Agent card displays correct information', (WidgetTester tester) async {
  final agent = Agent(
    id: '1',
    name: 'John Doe',
    rating: 4.5,
    // ... other properties
  );

  await tester.pumpWidget(
    MaterialApp(
      home: AgentCard(agent: agent),
    ),
  );

  expect(find.text('John Doe'), findsOneWidget);
  expect(find.text('4.5'), findsOneWidget);
});
```

#### Backend Tests
```javascript
// Example API test
describe('GET /api/agents', () => {
  it('should return list of verified agents', async () => {
    const response = await request(app)
      .get('/api/agents')
      .expect(200);

    expect(response.body).toHaveProperty('agents');
    expect(Array.isArray(response.body.agents)).toBe(true);
  });
});
```

## Questions?

Don't hesitate to ask questions by:
- Opening an issue
- Reaching out to maintainers
- Checking existing documentation

Thank you for contributing to MarketMate! 🎉
