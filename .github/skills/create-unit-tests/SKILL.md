---
name: create-unit-tests
description: Generates unit test files for backend API endpoints and business logic
  using the test framework defined in workshop-stack.md. Use when asked to create
  unit tests, generate API tests, or produce a test suite for backend code.
---

# Skill — Create Unit Tests

## What You Do
Read the [BACKEND] issue file, the implemented backend code, and the
design document to produce a complete unit test suite that verifies
API endpoints and business logic behave correctly.

There are no separate UNIT-TEST issue files in this workflow. Unit tests
are derived from [BACKEND] issue files — the acceptance criteria in the
BACKEND issue define what must be tested, and the implemented code
defines how it was built.

Each test file maps to one [BACKEND] issue from `issues/`. Tests mock
external dependencies, cover the happy path and error scenarios, and
follow the arrange / act / assert pattern.

---

## Prerequisites — Read Before Writing Any Test

1. **`workshop-stack.md`** — extract:
   - `language` — programming language for the tests
   - `framework` — backend framework (determines how to test routes)
   - `unit_test_framework` — test runner and assertion library
   - `unit_tests_folder` — where test files are saved
   - `routes_folder` — where API routes are defined
   - `controllers_folder` — where business logic lives
   - `auth_middleware` — authentication middleware path
   - `orm` — ORM or data access pattern (determines mock strategy)
   - Schema or entity definitions path (`schema_file`, `entities_folder`,
     or equivalent)
   - `pre_built` — files to never modify
   - `test_user_email`, `test_user_password` — seed user credentials

2. **The [BACKEND] issue file in `issues/`** — extract:
   - Acceptance criteria to cover (these drive the test scenarios)
   - Parent User Story for context
   - Description of endpoints built and business rules enforced
   - Dependencies

3. **`docs/design/design-doc.md`** — extract:
   - API contracts — endpoint paths, HTTP methods, request and
     response shapes
   - Business rules and validation requirements
   - Error response shapes

4. **`docs/requirements/BRD.md`** — validate:
   - Domain entity names (use verbatim in test descriptions)
   - Role names and lifecycle states
   - Business rules that must be verified

5. **Implemented backend code** — read:
   - Route definitions (from `routes_folder`)
   - Controller or service logic (from `controllers_folder`)
   - Data model definitions (from `schema_file` or `entities_folder`)
   - Confirm actual endpoint paths, parameter names, and response
     shapes — never guess from the design doc alone

---

## Test File Naming and Location

Save all test files to `unit_tests_folder` defined in `workshop-stack.md`.

Name each file using the kebab-case feature name and the test framework's
convention:

| Framework | File naming pattern                               |
|-----------|---------------------------------------------------|
| Jest      | `{unit_tests_folder}/{feature-name}.test.ts`      |
| pytest    | `{unit_tests_folder}/test_{feature_name}.py`      |
| JUnit 5   | `{unit_tests_folder}/{FeatureName}Test.java`      |
| xUnit     | `{unit_tests_folder}/{FeatureName}Tests.cs`       |
| NUnit     | `{unit_tests_folder}/{FeatureName}Tests.cs`       |
| RSpec     | `{unit_tests_folder}/{feature_name}_spec.rb`      |

Derive the feature name from the [BACKEND] issue title — not from
hardcoded assumptions. Follow the language's file naming convention
(kebab-case, snake_case, PascalCase) as appropriate.

One test file per [BACKEND] issue. If a test file already exists for the
same feature, append new test cases rather than overwriting.

---

## Test File Structure

Every test file must follow this general structure, adapted to the
specific test framework:

```
Imports / requires
  - Test framework (Jest, pytest, JUnit, xUnit, etc.)
  - Module under test (routes, controllers, services)
  - Mock setup (ORM mocks, auth mocks)

/**
 * Feature: {Feature Name}
 * BRD References: {FR-XXX, FR-YYY}
 * BACKEND Issue: {issue-id}
 */

Test group / describe block — "{Feature Name} API"

  Setup / before-each
    - Initialise mocks
    - Reset state between tests
    - Configure test app or client with auth middleware

  Happy path tests
    - Correct input returns expected status and response shape

  Authentication tests
    - No token returns 401
    - Malformed token returns 401

  Validation tests
    - Missing required fields returns 400
    - Invalid field values return appropriate error

  Edge case / business rule tests
    - At least one domain-specific scenario per endpoint

  Teardown / after-each (if needed)
    - Clean up mocks
```

---

## Framework-Specific Patterns

The test framework is read from `workshop-stack.md` → `unit_test_framework`.
Use the idiomatic patterns for whichever framework is configured.

### Jest (TypeScript / JavaScript)
```typescript
import request from 'supertest'
import { app } from '../app'

describe('Loan API', () => {
  beforeEach(() => { jest.clearAllMocks() })

  it('should create a loan successfully', async () => {
    // Arrange — set up mock data
    // Act — call endpoint
    const res = await request(app).post('/api/loans').send(payload)
    // Assert — verify response
    expect(res.status).toBe(201)
    expect(res.body).toMatchObject({ id: expect.any(String) })
  })
})
```

### pytest (Python)
```python
import pytest
from fastapi.testclient import TestClient
from app.main import app

@pytest.fixture
def client():
    return TestClient(app)

class TestLoanAPI:
    def test_create_loan_success(self, client, mock_db):
        # Arrange
        payload = {"book_id": "1", "member_id": "1"}
        # Act
        response = client.post("/api/loans", json=payload)
        # Assert
        assert response.status_code == 201
        assert "id" in response.json()
```

### JUnit 5 (Java / Spring Boot)
```java
@WebMvcTest(LoanController.class)
class LoanControllerTest {

    @Autowired private MockMvc mockMvc;
    @MockBean private LoanService loanService;

    @Test
    void shouldCreateLoanSuccessfully() throws Exception {
        // Arrange
        when(loanService.create(any())).thenReturn(newLoan);
        // Act & Assert
        mockMvc.perform(post("/api/loans")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(payload)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.id").exists());
    }
}
```

### xUnit (C# / ASP.NET Core)
```csharp
public class LoanControllerTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public LoanControllerTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.WithWebHostBuilder(builder =>
            builder.ConfigureServices(services =>
                services.AddScoped(_ => Mock.Of<ILoanRepository>())))
            .CreateClient();
    }

    [Fact]
    public async Task CreateLoan_ReturnsCreated()
    {
        // Arrange
        var payload = new { BookId = "1", MemberId = "1" };
        // Act
        var response = await _client.PostAsJsonAsync("/api/loans", payload);
        // Assert
        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
    }
}
```

### NUnit (C#)
```csharp
[TestFixture]
public class LoanControllerTests
{
    private HttpClient _client;

    [SetUp]
    public void Setup() { /* initialise test server and mocks */ }

    [Test]
    public async Task CreateLoan_ReturnsCreated()
    {
        // Arrange — Act — Assert (same pattern as xUnit)
    }
}
```

### RSpec (Ruby)
```ruby
RSpec.describe "Loans API", type: :request do
  describe "POST /api/loans" do
    it "creates a loan successfully" do
      # Arrange
      payload = { book_id: 1, member_id: 1 }
      # Act
      post "/api/loans", params: payload, as: :json
      # Assert
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include("id")
    end
  end
end
```

> These are illustrative patterns only. Always adapt to the actual
> framework, folder structure, and coding conventions defined in
> `workshop-stack.md`.

---

## Mocking Strategy

Mock external dependencies — never use real databases or external
services in unit tests.

### What to mock
| Dependency | Mock approach |
|------------|---------------|
| ORM / data access layer | Mock repository or ORM client methods |
| Authentication middleware | Provide a fake token or bypass auth for unit tests |
| External APIs or services | Mock HTTP client or service interface |
| File system or storage | Mock file operations |

### How to determine mock approach
1. Read `workshop-stack.md` → `orm` to identify the data access pattern.
2. Read the implemented code to see how dependencies are injected.
3. Use the idiomatic mocking pattern for the test framework:
   - **Jest** → `jest.mock()`, `jest.fn()`
   - **pytest** → `unittest.mock.patch`, `@pytest.fixture`
   - **JUnit** → `@MockBean`, `Mockito.when()`
   - **xUnit** → `Moq`, `Mock.Of<T>()`
   - **NUnit** → `NSubstitute`, `Moq`
   - **RSpec** → `allow().to receive()`, `double()`

### Mock data
- Use realistic field names and values from the data model
- Include at least one record per categorical variant (enum value)
- Use test credentials from `workshop-stack.md` for auth tokens

Place mock setup files alongside test files in the `unit_tests_folder`
or in a `__mocks__` / `fixtures` / `testdata` subfolder, following the
convention of the test framework.

---

## Coverage Requirements

For each [BACKEND] issue, every endpoint or function referenced in the
issue's acceptance criteria must have the following tests:

### Mandatory Coverage
| Scenario | Required |
|----------|----------|
| Happy path — correct input returns expected status and response shape | Always |
| Auth — no credentials returns 401 Unauthorised | If endpoint is protected |
| Auth — malformed credentials returns 401 | If endpoint is protected |
| Validation — missing required fields returns 400 | If endpoint accepts input |
| Validation — invalid field values return appropriate error | If endpoint accepts input |
| Edge case — at least one business-rule-specific scenario | Always |

### Business Rule Edge Cases (derive from task and design doc)
Examples of edge cases to look for:
- Conflict — creating a duplicate resource
- Not found — referencing a non-existent resource
- Capacity exceeded — business limit reached
- State transition violation — invalid status change
- Forbidden — user lacks role permission

### What NOT to test
- Pre-built authentication flows (unless the task explicitly requires it)
- ORM internals or database driver behaviour
- Third-party library internals
- Frontend code or E2E scenarios

---

## Assertion Patterns

Use specific, meaningful assertions. Do not rely only on status codes.

### Always verify
1. **HTTP status code** — correct success and error codes
2. **Response body shape** — required fields are present with correct types
3. **Error response format** — matches the `api_error_format` defined in
   `workshop-stack.md` (if present)
4. **Side effects** — verify that the mock was called with the expected
   arguments (e.g. repository `.create()` was called with correct data)

### Assertion examples (framework-agnostic pseudocode)
```
// Verify status code
assert response.status == 201

// Verify response body has expected fields
assert response.body.id is not null
assert response.body.status == "Active"

// Verify mock was called correctly
assert mockRepository.create was called with { bookId: "1", memberId: "1" }

// Verify error response shape
assert response.body.error is not null
assert response.body.message contains "required"
```

---

## Steps

1. Read all files listed in [Prerequisites](#prerequisites--read-before-writing-any-test).
2. Read the [BACKEND] issue file to identify endpoints, acceptance
   criteria, and business rules that must be tested.
3. Read the implemented route and controller code from the paths defined
   in `workshop-stack.md`.
4. Map each acceptance criterion from the [BACKEND] issue to one or more
   test cases.
5. Determine the mocking strategy from the ORM and framework in use.
6. Write the test file following the [Test File Structure](#test-file-structure)
   and the idiomatic patterns for the configured `unit_test_framework`.
7. Write any shared mock setup files needed.
8. Save all files to `unit_tests_folder` using the
   [naming convention](#test-file-naming-and-location) for the framework.
9. Report what was created.

---

## Output Summary Format

After saving all test files, report:

```
Unit tests written:

  {unit_tests_folder}/{test-file-name}
    Covers: {issue-id} — {BACKEND issue title}
    Tests:  {N} test cases ({happy path} happy path, {auth} auth,
            {validation} validation, {edge} edge case)
    BRD:    FR-XXX, FR-YYY
    Mocks:  {list of mocked dependencies}

Run tests: {framework-specific test command}
```

The test command varies by framework:
| Framework | Command |
|-----------|---------|
| Jest      | `npm test` or `npx jest` |
| pytest    | `pytest {unit_tests_folder}` |
| JUnit 5   | `mvn test` or `./gradlew test` |
| xUnit     | `dotnet test` |
| NUnit     | `dotnet test` |
| RSpec     | `bundle exec rspec {unit_tests_folder}` |

---

## What Not To Do

- Do not modify production code — test files only
- Do not use real databases or external services — mock all dependencies
- Do not hardcode credentials — use values from `workshop-stack.md`
- Do not hardcode file paths — derive all paths from `workshop-stack.md`
- Do not assume a test framework — always read `unit_test_framework`
  from `workshop-stack.md`
- Do not test pre-built authentication unless the task explicitly requires it
- Do not write E2E tests — this skill produces unit tests only
  (use `create-playwright-tests` skill for E2E)
- Do not skip reading the implemented code — tests must match what was
  actually built, not just what the design doc describes
- Do not leave test-only markers (`test.only`, `@Disabled`, `skip`,
  `fdescribe`, `fit`) in committed files
- Do not write tests for functionality not covered by the [BACKEND]
  issue's acceptance criteria
