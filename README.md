# Macro Tracker 🍏

A privacy-first, offline Flutter-based macro tracking application that enables users to log daily food intake and visualize nutritional data. The app operates on a passive tracking philosophy—pure data visualization without unprompted dietary advice.

## 🚀 Features Implemented (v0.5)

*   **100% Offline & Private:** Built with a local SQLite database (via `drift`). No cloud dependency, telemetry, or tracking.
*   **AI-Assisted Food Logging:** 
    *   Generates optimized prompts for you to copy-paste into ChatGPT, Gemini, or Claude to get nutritional info for your custom foods.
    *   Features a built-in **Magic Extract** button that uses Regex to automatically parse the AI's response and instantly fill in the nutritional values (Calories, Protein, Carbs, Fat, Fiber) in the Food Inventory.
*   **Scientific Goal Calculation:** Automatically calculates your Basal Metabolic Rate (BMR) and Total Daily Energy Expenditure (TDEE) using the Mifflin-St Jeor equation during onboarding, complete with dynamic macro splits (Protein/Carbs/Fat) based on your weight goals. Validates all inputs to ensure realistic physiological bounds.
*   **Multi-step Onboarding:** A clean, colorful, multi-step welcome flow to establish your body metrics and daily target goals on your first launch.
*   **Visual Dashboard:** Dynamic, real-time macro ring charts (built with `fl_chart`) tracking your daily progress against your active goals.
*   **Food Inventory (CRUD):** Easily build, manage, and delete a custom repository of the foods you eat.
*   **Quick Food Logging:** One-tap action from the dashboard to log a food item with a specific quantity multiplier.
*   **Data Export (CSV):** Own your data. Export your entire food logging history locally to a `.csv` file directly from the profile page.

## 🛠️ Tech Stack

*   **Framework:** [Flutter](https://flutter.dev/) (Dart)
*   **Local Database:** [Drift](https://drift.simonbinder.eu/) (SQLite ORM)
*   **State Management:** [Riverpod](https://riverpod.dev/) (`flutter_riverpod`)
*   **Data Visualization:** [fl_chart](https://pub.dev/packages/fl_chart)
*   **Date Formatting:** `intl`

## 📋 Future Improvements Checklist (Roadmap)

While the core functionality (MVP -> v0.5) is actively running, here is the checklist for upcoming v1.0 and extended features:

- [ ] **Calendar Heatmap:** Upgrade the basic calendar list view to a monthly heatmap showing daily adherence (Green = Under, Red = Over target).
- [ ] **Meal Grouping (DB Ready):** Implement the UI to group multiple food items into a saved "Meal" (e.g. "Default Breakfast") to log them all at once.
- [ ] **Editable Profile:** Allow the user to edit their profile metrics (Weight, Goals) and recalculate goals after onboarding is complete.
- [ ] **Food Inventory Search & Filter:** Add a search bar to quickly find items in a large food inventory.
- [ ] **App Customization:** Add support for Dark Mode/OLED themes and allow the user to select custom colors for their Macro rings.
- [ ] **Historical Analytics:** Dedicated charts to analyze macro adherence trends over weeks/months.
- [ ] **Water Intake Tracking:** A simple sub-tracker for daily hydration.
- [ ] **PDF Reports:** Enhance the CSV export to generate beautiful weekly or monthly PDF reports.

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
