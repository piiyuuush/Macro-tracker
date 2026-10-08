# Macro Tracker 🍏

A privacy-first, offline Flutter-based macro and weight tracking application that enables users to log daily food intake and visualize nutritional data. The app operates on a passive tracking philosophy—pure data visualization without unprompted dietary advice.

## 🚀 Features (v1.0)

*   **100% Offline & Private:** Built with a local SQLite database (via `drift`). No cloud dependency, telemetry, or tracking. Complete control over your data.
*   **Scientific Goal Calculation:** Automatically calculates your Basal Metabolic Rate (BMR) and Total Daily Energy Expenditure (TDEE) using the Mifflin-St Jeor equation. Dynamic macro splits adapt to your goals (Weight Loss, Maintenance, Weight Gain, Recomposition).
*   **Dynamic Macro Syncing:** Real-time bidirectional macro calculations. Adjust your total calories to proportionally scale your macros, or adjust your Protein/Carbs/Fat to automatically recalculate your total calories!
*   **Visual Dashboard:** Dynamic, real-time macro ring charts (built with `fl_chart`) tracking your daily progress against your active goals.
*   **Weight Tracking & Calendar:** A beautiful interactive line chart synchronized with a daily calendar grid to log and visualize your weight trends across weeks and months.
*   **Food Inventory (CRUD):** Easily build, manage, and delete a custom repository of the foods you eat. Supports both *Countable* items (units) and *Measurable* items (grams).
*   **AI-Assisted Food Logging:** Generates optimized prompts for you to copy-paste into ChatGPT, Gemini, or Claude to get nutritional info. Features a built-in **Magic Extract** button that uses Regex to automatically parse the AI's response and instantly fill in the nutritional values!
*   **Meal Grouping:** Long-press any food item to enter selection mode, pick multiple foods, and combine them into a single "Meal" (e.g., 3 eggs + 100g rice). The app automatically calculates the combined macros and saves it as a new custom meal that can be easily logged.
*   **Data Portability (JSON Backups):** Own your data. Export your entire history to a JSON backup and safely restore/import it later with smart data merging capabilities.
*   **Meal Reminders:** Set up local push notifications to gently remind you to log your food throughout the day.
*   **App Customization:** Fully supports system Dark Mode alongside an explicit AMOLED Black theme to save battery.

## 🛠️ Tech Stack

*   **Framework:** [Flutter](https://flutter.dev/) (Dart)
*   **Local Database:** [Drift](https://drift.simonbinder.eu/) (SQLite ORM)
*   **State Management:** [Riverpod](https://riverpod.dev/) (`flutter_riverpod`)
*   **Data Visualization:** [fl_chart](https://pub.dev/packages/fl_chart)
*   **Date Formatting:** `intl`

## 📋 Future Improvements Checklist (Roadmap)

- [ ] **Food Inventory Search & Filter:** Add a search bar to quickly find items in a large food inventory.
- [ ] **Macro Analytics:** Dedicated charts to analyze macro adherence trends over weeks/months (similar to the weight chart).
- [ ] **Water Intake Tracking:** A simple sub-tracker for daily hydration.
- [ ] **PDF Reports:** Enhance the export module to generate beautiful weekly or monthly PDF reports for coaches or dietitians.

## 💻 Getting Started

To run the project locally, ensure you have Flutter installed and configured.

```bash
# Clone the repository
git clone <repository-url>
cd macro_tracker

# Install dependencies
flutter pub get

# Generate Drift Database Files (if making changes to schema)
dart run build_runner build -d

# Run the app
flutter run
```
