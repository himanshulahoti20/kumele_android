# Kumele Android — AI Coding Rules

These rules apply to any AI assistant (Antigravity, Cursor, Gemini, etc.) working on this project.
Follow them strictly and consistently across all files.

---

## 1. Project Identity

- Package name: `kuemele` (note the spelling — used in all import paths)
- Flutter version: managed via FVM (`.fvmrc`). Always use `fvm flutter` not `flutter` for commands.
- State management: **flutter_bloc** (BLoC pattern). Never use `Provider`, `GetX`, or `setState` for business logic.
- Navigation: **go_router** (`lib/navigation/`). Never use `Navigator.push` directly for named routes.
- DI / Service locator: **get_it** (`lib/core/service_locator.dart`). Do not instantiate services manually.

---

## 2. Responsive Sizing

- **Always use `flutter_screenutil`** for sizes. Never use raw `double` literals for padding, font sizes, margin, or border radii.
  - Width/Height: `.w` / `.h`
  - Border radius: `.r`
  - Font sizes: `.sp`
  - Example: `16.w`, `12.h`, `8.r`, `14.sp`
- **No decimal sizing values.** Round all values to the nearest integer before applying screenutil suffixes.
  - ✅ `9.r` &nbsp; ❌ `8.68.r`
  - ✅ `7.h` &nbsp; ❌ `6.84.h`
- Use `context.responsive.isTablet` for tablet-specific logic (from `lib/core/responsive/responsive.dart`).
- Use `KumeleAssetWidget`'s internal scaling — do not manually apply `.w` to image dimensions passed to it.

---

## 3. Text & Typography

- **Never use `fontSize` raw doubles** outside of screenutil-scaled values (`.sp`).
- **Always get text style from `context.textTheme`**, not hardcoded `TextStyle`:
  ```dart
  // ✅ Correct
  style: context.textTheme.bodyLargeSemiBold.copyWith(color: ColorSet.textColor)

  // ❌ Wrong
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
  ```
- Available named styles on `context.textTheme` (from `lib/components/app_text_theme.dart`):
  `bodySmall`, `bodySmallBold`, `bodyMedium`, `bodyMediumSemiBold`, `bodyMediumBold`,
  `bodyLarge`, `bodyLargeSemiBold`, `bodyLargeBold`, `labelLargeSemiBold`,
  `titleMediumBold`, `headlineSmallSemiBold`, `heading2`, `displaySmallBold`
- The app font is **Plus Jakarta Sans**. Do not import or use other Google Fonts unless explicitly asked.
- Do not use the legacy `txt()` helper function for new code. Use `Text(...)` with `context.textTheme` instead.

---

## 4. Colors

- All colors come from `ColorSet` (`lib/components/app_colors.dart`). Never use raw `Colors.*` or hex values.
  ```dart
  // ✅ Correct
  color: ColorSet.textColor
  color: ColorSet.bg2Color
  color: ColorSet.tileFillColor
  color: ColorSet.revbg3Color

  // ❌ Wrong
  color: Colors.white
  color: Color(0xFF1A1A2E)
  ```
- Support both light and dark mode — `ColorSet` handles this automatically.

---

## 5. Asset Rendering

- **Always use `KumeleAssetWidget`** (`lib/widgets/kumele_asset_widget.dart`) for rendering any asset (SVG, PNG, network image).
  - Handles SVG vs raster detection automatically.
  - Handles error states and loading placeholders.
  - Do **not** use `AppSvgImage`, `SvgPicture.asset`, or `Image.asset` directly in new widgets.
- **Always reference assets via the generated `Assets` class** (`lib/gen/assets.gen.dart`), not string literals:
  ```dart
  // ✅ Correct
  assetPath: Assets.svg.iconArrow.path
  assetPath: Assets.images.profilePlaceholder.path

  // ❌ Wrong
  assetPath: 'assets/svg/icon_arrow.svg'
  assetPath: SVGAsset.icon_arrow
  ```
- For square icons, use `KumeleAssetWidget.square(assetPath: ..., size: 24.r)`.

---

## 6. Dialogs & Bottom Sheets

- **Dialogs**: Use `AppDialog.attach(context: ..., dialog: ...)` from `lib/modals/dialog/app_dialog.dart`.
  - Never use `showDialog` directly.
  - Always pass `onDismiss:` callback if you need to react to dialog closure (e.g., resetting state).
- **Bottom Sheets**: Use `AppBottomSheet` from `lib/modals/bottom_sheet/app_bottom_sheet.dart`.
  - Never use `showModalBottomSheet` directly.
- **Snackbars**: Use `SnackBarService` from `lib/core/snackbar/`. Never use `ScaffoldMessenger` directly.
- **Smart Dialog**: `SmartDialog.dismiss()` is only to be called inside dialog item callbacks — never used as a general navigation tool.

---

## 7. Buttons & Tap Handling

- Use `ClickWidget` from `lib/components/app_button.dart` for all custom tappable areas.
  - Do not use `GestureDetector` or `InkWell` for simple press interactions.
- Use `PrimaryButton` from `lib/components/app_button.dart` for primary CTA buttons.
- Never hardcode `onPressed: null` to disable a button — pass a conditional callback instead.

---

## 8. Input Fields

- All text fields must use `KumeleTextField` from `lib/components/kumele_text_field.dart`.
- Default vertical padding is built into `KumeleTextField` — do not wrap it in extra padding containers.
- Never set `fontSize` directly on a text field's style — use `context.textTheme` styles.

---

## 9. BLoC Pattern

- Events: named as `[Feature][Action]` (e.g., `SignupDateOfBirthChanged`, `SignupEmailChanged`).
- States: use `freezed` for immutability. Always use `copyWith` for state updates.
- BLoC files live in `lib/[feature]/bloc/`.
- Never access a BLoC outside of a `BlocBuilder`, `BlocListener`, or `BlocConsumer` widget tree.
- Use `context.read<MyBloc>().add(...)` for dispatching events, not `context.watch`.

---

## 10. Reusable Components

- **Before creating a new widget**, check `lib/components/` and `lib/widgets/` for an existing one.
- **Dropdown menus**: Use `KumeleDropdown` (`lib/components/kumele_dropdown.dart`).
  - Pass `List<String> items` and `onSelected(String value, int index)`.
  - Do not build item widgets externally — the widget handles item rendering internally.
- **Checkboxes**: Use `RACheck` from `lib/components/check.dart` for all checkbox UI.
- **Config / static lists**: Place shared config data (e.g., months, gender options, country codes) in the relevant `*_config.dart` file (e.g., `lib/auth/config/auth_config.dart`). Never hardcode lists inline in widgets.

---

## 11. File & Folder Conventions

| Type | Location |
|---|---|
| Feature BLoC | `lib/[feature]/bloc/` |
| Feature screens | `lib/[feature]/presentation/` |
| Feature sub-widgets | `lib/[feature]/presentation/widgets/` |
| Shared components | `lib/components/` |
| One-off/project widgets | `lib/widgets/` |
| Models / entities | `lib/models/` |
| Services | `lib/services/` |
| Navigation routes | `lib/navigation/` |
| Theme & asset keys | `lib/theme/` |
| Generated code | `lib/gen/` ← **never edit manually** |

- File names: `snake_case.dart`
- Class names: `PascalCase`
- Variable names: `camelCase`
- Private members: prefix with `_`

---

## 12. Code Quality

- Run `fvm flutter analyze` after every significant change. Zero new issues are acceptable.
- Never suppress lint warnings with `// ignore:` unless absolutely necessary, and always add a comment explaining why.
- Do not leave `TODO`, `FIXME`, or commented-out code blocks in committed files.
- All `StatefulWidget` lifecycle methods (`initState`, `dispose`) must call `super` first.
- Always check `mounted` before calling `setState` after an `async` gap.
- Never use `print()` — use the project logger if available.

---

## 13. What NOT to Do

- ❌ Do not use raw `double` sizing literals (use `.sp`, `.w`, `.h`, `.r`)
- ❌ Do not hardcode color hex values (use `ColorSet`)
- ❌ Do not use `txt()` helper in new code (use `Text` + `context.textTheme`)
- ❌ Do not use `AppSvgImage` or `SvgPicture.asset` in new code (use `KumeleAssetWidget`)
- ❌ Do not use `SVGAsset.*` string constants (use `Assets.svg.*` generated class)
- ❌ Do not use `Navigator.push` for feature navigation (use `go_router`)
- ❌ Do not use `showDialog` or `showModalBottomSheet` directly (use `AppDialog` / `AppBottomSheet`)
- ❌ Do not use `ScaffoldMessenger` for messages (use `SnackBarService`)
- ❌ Do not put business logic in widgets (put it in the BLoC)
- ❌ Do not create new widgets if an equivalent already exists in `lib/components/` or `lib/widgets/`
- ❌ Do not edit files in `lib/gen/` — they are auto-generated by `flutter_gen`
