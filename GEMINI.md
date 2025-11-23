# Oil Business App - Gemini Context

## Project Overview

**Name:** Oil Business App (买油呗)
**Purpose:** Mobile application for gas stations to purchase oil/gas from depots.
**Platforms:** Android, iOS (Support for Phone, Tablet, Foldables).
**Tech Stack:**
*   **Framework:** Flutter 3.4+ / Dart 3.4+
*   **State Management:** Bloc / Cubit (flutter_bloc ^9.1.1), HydratedBloc for persistence.
*   **Navigation:** GoRouter (^16.0.0).
*   **Networking:** Dio (^5.2.1) + Retrofit (Code Generation).
*   **DI:** GetIt (^8.2.0).
*   **Storage:** Hive, SharedPreferences.
*   **UI Library:** TDesign Flutter, Custom Components.
*   **Code Generation:** Freezed, JSON Serializable, Build Runner.
*   **Task Runner:** `pnpm` (via `rps` tool) wraps project scripts.

## Development Workflow (OpenSpec)

**CRITICAL:** This project uses the **OpenSpec** workflow for all significant changes (features, refactors, architectural changes).

1.  **Check Instructions:** Read `openspec/AGENTS.md` for detailed protocols.
2.  **Propose Changes:**
    *   Create a new directory: `openspec/changes/<change-id>/` (kebab-case, verb-led, e.g., `add-login-feature`).
    *   Create `proposal.md`: Why, What, Impact.
    *   Create `tasks.md`: Implementation checklist.
    *   Create Spec Deltas: `openspec/changes/<change-id>/specs/<capability>/spec.md` using `## ADDED | MODIFIED | REMOVED Requirements`.
3.  **Validate:** Run `openspec validate <change-id> --strict`.
4.  **Implement:** Only after proposal approval. Follow `tasks.md`.
5.  **Archive:** After deployment, archive the change using `openspec archive`.

**Decision Tree:**
*   **Bug Fix (Restore behavior):** Fix directly.
*   **Typo/Comment:** Fix directly.
*   **New Feature / Breaking Change / Architecture:** **CREATE PROPOSAL**.

## Architecture & Structure

**Pattern:** Feature-first organization with a strict 4-layer architecture per page.

```
lib/
├── pages/                  # Feature Modules
│   └── [feature]/
│       ├── page.dart       # Route Entry (BasePage, BlocProvider)
│       ├── controller.dart # Business Logic (Cubit/Bloc)
│       ├── state.dart      # Immutable State (Freezed/Equatable)
│       ├── view.dart       # View Assembly (BlocListener, Layout)
│       └── widgets/        # Feature-specific widgets
├── widgets/                # Global Reusable Components
│   ├── base/               # Core: CommonText, CommonButton, etc.
│   ├── popup/              # Dialogs/BottomSheets
│   └── common/             # Business-specific shared widgets
├── global/                 # Global Layer
│   ├── app_controller.dart # HydratedCubit for global state
│   ├── service/            # Global API Services (Retrofit)
│   └── model/              # Global Models
├── net/                    # Networking (Interceptors, Response handling)
├── router/                 # GoRouter configuration (routes.dart)
├── config/                 # App Config (Env, Channel)
├── resources/              # Colors, Assets, Themes
└── utils/                  # Utilities (AppSizes, Log, Validators)
```

### Page Architecture Rules
1.  **page.dart:** Inherits `BasePage`. Mixes `BasicInitPage`. Provides `Bloc`.
2.  **controller.dart:** Inherits `Cubit` (page-level) or `HydratedCubit` (global). Holds `formKey`.
3.  **state.dart:** Immutable, must have `copyWith`.
4.  **view.dart:** `Stateless` or `Stateful`. Connects Bloc state to UI widgets. **NO complex logic.**

## Build & Run Commands

| Command | Description |
| :--- | :--- |
| `pnpm dev` | Run dev environment (oppo flavor) |
| `flutter run --flavor <flavor>` | Run specific flavor (oppo, vivo, xiaomi) |
| `pnpm gen_model` | Generate models (build_runner) |
| `pnpm gen_assets` | Generate static asset references |
| `pnpm gen_page` | Scaffold a new page (standard structure) |
| `pnpm build_android` | Build APK |
| `pnpm build_ios` | Build IPA |

**Environment Variables:**
*   `HTTP_ENV`: 1=Dev, 2=Pro

## Coding Standards

**Style:**
*   **Line Length:** 120 chars.
*   **Strings:** Single quotes (`'`).
*   **Naming:**
    *   Classes: `PascalCase`
    *   Methods/Vars: `camelCase`
    *   Files: `snake_case`
    *   Constants: `UPPER_SNAKE_CASE`
*   **Constructors:** Use `const` whenever possible.
*   **Logic Extraction:** Complex logic (parsing, calculations) must be extracted from `build()` methods into private helpers or Blocs/Cubits. `build()` should be declarative only.

**Linting:**
*   Strict rules in `analysis_options.yaml`.
*   **Pre-commit hook** enforces linting and formatting.

## UI/UX Guidelines

**Source of Truth:** The `UI_SPECIFICATION.md` document is the authoritative source for all UI components, color palettes, typography, sizing, and spacing. All UI development and refactoring must strictly adhere to this specification.

**Strict Component Usage:**
*   **Text:** MUST use `CommonText`.
*   **Buttons:** MUST use `CommonButton`.
*   **Inputs:** MUST use `CommonTextFormField`.
*   **Sizes:** MUST use `AppSizes.setWidth()`, `AppSizes.setHeight()`, `AppSizes.setFontSize()`. **NO hardcoded doubles.**
*   **Colors:** MUST use `CustomAppColor.of(context).xxx`. **NO hardcoded Colors.**
*   **Assets:** MUST use `AssetsImg`, `AssetsIcon` constants.

**Design System:**
*   **Font:** Urbanist (Main).
*   **Themes:** Light & Dark mode support (mandatory).
*   **Responsiveness:** Phone, Tablet (>600px), Foldable support.
*   **Consistency:** When refactoring or designing UI, ensure all pages maintain a unified UI style and theme color to preserve a consistent user experience.

## Key Directories

*   `openspec/`: Specifications and Change Proposals.
*   `scripts/`: Build, generation, and utility scripts.
*   `lib/net/`: Network layer (Dio setup, Interceptors).
*   `lib/widgets/base/`: The source of truth for basic UI components.
