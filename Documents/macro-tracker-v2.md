# Diet Macro Tracker - Enhanced Specification

## Project Overview
A privacy-first, offline Flutter-based macro tracking application that enables users to log daily food intake and visualize nutritional data. The app collects user input, and gives LLM-prompts which user can paste into popular chatbots like gemini or chatgpt, to get output in which it would be easy for extraction, utimately it only provides data visualization without providing dietary guidance or recommendations.

**Core Philosophy:** Passive tracking, no advice—pure data visualization and logging.

---

## 1. Technical Stack & Architecture

### Framework
- **Flutter** (latest stable version)
- **Local Storage:** SQLite with Drift ORM for data persistence
- **State Management:** Riverpod or Provider for reactive state
- **Data Visualization:** fl_chart for macro ring charts, calendar heatmaps
- **Date Handling:** intl and timezone packages for date operations

### Data Model
- **User Profile:** Goals, measurements, units (kg/lbs, cm/inches)
- **Food Items:** Name, macro breakdown (calories, carbs, protein, fat, fiber), serving size, measurement type
- **Food Logs:** Date, time, food item, quantity consumed, macros for that serving
- **Meals (Groups):** Named collections of food items entered together (e.g., "Breakfast Bundle")
- **LLM Prompts:** Stored templates and user responses for macro extraction

---

## 2. Onboarding Flow

### Step 1: User Info Collection
**User inputs:**
- Name
- Age
- Gender
- Height (with unit selector: cm/inches)
- Current weight (with unit selector: kg/lbs)
- Activity level (sedentary, lightly active, moderately active, very active, extremely active)
- Goal (weight loss, maintenance, weight gain)
- Target loss/gain rate (lbs/kg per week)

### Step 2: Macro Goal Setting (Two Paths)

#### Path A: LLM-Assisted (Recommended)
1. App generates a pre-formatted prompt based on user data:
   ```
   Example Prompt Template:
   "Based on a [GENDER], [AGE] years old, [HEIGHT]cm, [CURRENT_WEIGHT]kg, with [ACTIVITY_LEVEL] activity level, aiming for [GOAL] of [RATE] per week, what should be the daily macro targets for:
   - Calories (kcal)
   - Protein (g)
   - Carbohydrates (g)
   - Fat (g)
   - Fiber (g)
   
   Return ONLY the response in this exact format:
   Calories: [NUMBER]
   Protein: [NUMBER]
   Carbs: [NUMBER]
   Fat: [NUMBER]
   Fiber: [NUMBER]"
   ```

2. User copies this prompt, pastes into any external LLM (ChatGPT, Claude, Gemini, etc.)
3. User pastes LLM response into app text field
4. App parses the response (regex-based extraction) and populates macro goals
5. User reviews and confirms

#### Path B: Manual Input
- User directly inputs daily targets for: Calories, Protein, Carbs, Fat, Fiber

### Step 3: Confirmation & First Dashboard Load
- Display calculated daily targets
- Show onboarding completion screen
- Navigate to Dashboard

---

## 3. Core Screens & Navigation

### 3.1 Dashboard Screen (Home)

#### Section A: Macro Ring Chart
- **Visual:** Concentric rings for: Calories (outer), Protein, Carbs, Fiber (inner)
- **Color Coding:** Each macro has a distinct color (customizable in profile)
- **Display Format:** Ring segments filled proportionally to daily goal
  - Filled = consumed / goal (0-100%+)
  - Color intensity darkens if over goal (optional visual overflow indicator)
- **Center Text:** "Current Macro %", total calories consumed today

#### Section B: Weekly Progress Bar
- **Timeline:** Monday → Sunday (week starts per locale or user preference)
- **Format:** 7 horizontal bars (one per day) stacked vertically
  - Current day: Full color, shows overall macro % (average of all 4 macros)
  - Past days: Full color, shows overall macro %
  - Future days: Grayed out (disabled state)
- **Interaction:** Tap any day to refresh dashboard to show that day's data
- **Logic for Overall %:**
  ```
  daily_overall_percent = (protein_percent + carbs_percent + fiber_percent + calories_percent) / 4
  ```
  Cap displayed value at 150% for visual consistency

#### Section C: Recent Food Logs
- **Display:** List of last 3-5 food entries logged today
- **Format per entry:**
  ```
  [Food Name] · [Quantity] [Unit]
  [Timestamp HH:MM] · [Calories] kcal
  ```
- **Interaction:** Tap to edit/delete; swipe to delete (with undo option)

#### Section D: Floating Action Button (FAB)
- **Icon:** Plus sign
- **Function:** Opens "Add Food Log" modal (see Section 4.1)

---

### 3.2 Food Screen (Inventory)

#### Section A: Food Items List (Categorized)
- **Grouping:** Alphabetically or by user-created categories (Breakfast, Snacks, Meals, etc.)
- **Expandable Categories:** Tap to show/hide items within category
- **Format per food item:**
  ```
  [Food Name]
  [Macros: XXX cal · XXg P · XXg C · XXg F]
  ```
- **Interaction:**
  - Tap item: View/edit macro details
  - Long-press: Delete or duplicate item
  - Swipe: Quick log (opens confirmation modal to add this food today)

#### Section B: Meals (Grouped Foods)
- **Visual Separation:** "Saved Meals" section below individual food items
- **Format per meal:**
  ```
  [Meal Name] (contains X items)
  [Total Macros: XXX cal · XXg P · XXg C · XXg F]
  ```
- **Interaction:**
  - Tap meal: Expand to show constituent items
  - Tap meal name again: Log entire meal in one tap (asks for multiplier, e.g., "1x" or "0.5x")
  - Long-press: Edit or delete meal

#### Section C: Floating Action Button (FAB)
- **Primary Action:** Plus icon
- **Opens:** Bottom sheet with two options:
  1. **Add Food Item** → Opens "Add Food Item" form
  2. **Create Meal** → Multi-select from existing food items, name meal, save

#### Section D: Search Bar (Optional Enhancement)
- Quick search across food items and meals
- Filter by category

---

### 3.3 Calendar Screen (Extended View)

#### Section A: Month Heatmap
- **Display:** Full month grid (Monday-Sunday rows)
- **Color Gradient per day:**
  - Green (0-50% of macro goal average): Under target
  - Yellow/Orange (50-100%): On track
  - Red (100%+): Over target
  - Gray: Future dates or no data
- **Current Day Indicator:** Border or badge showing today
- **Interaction:** Tap any day to load that day's detailed view

#### Section B: Selected Day Macro Ring Chart
- **Same visualization** as Dashboard, but for the selected day
- **Display below heatmap**
- **Default:** Today's data on app launch

#### Section C: Selected Day Food Log (Detailed)
- **Format:** Timeline of all food entries for selected day, sorted by time
  ```
  HH:MM [Food Name] · [Quantity] [Unit]
       [Calories] kcal | [Protein]g P | [Carbs]g C | [Fiber]g F
  ```
- **Interaction:**
  - Tap entry: Edit or delete
  - Delete: Swipe or long-press with confirmation

#### Section D: Daily Summary (Below Food Log)
- **Totals for selected day:**
  ```
  Total: XXX / XXX kcal | XXg / XXg P | XXg / XXg C | XXg / XXg F
  ```
- **Visual Indicators:** Badges showing "Under," "On Track," or "Over" for each macro

---

### 3.4 Profile Screen (Settings)

#### Section A: User Info (Editable)
- Name, Age, Gender
- Height, Current Weight
- Activity Level
- Goal (Weight Loss/Maintenance/Gain) + Target Rate
- **Update Button:** Recalculate TDEE and refresh app if relevant fields changed

#### Section B: Macro Goals (Editable)
- Display current targets: Calories, Protein, Carbs, Fat, Fiber
- **Options per macro:**
  - Manually edit target value
  - **Generate via LLM:** Open same LLM prompt modal as onboarding
- **Save Button:** Confirm changes

#### Section C: Preferences
- **Units:** kg/lbs, cm/inches (toggle with app refresh)
- **Week Start Day:** Monday/Sunday/Saturday
- **Color Scheme:** Light/Dark/System
- **Macro Ring Colors:** Customizable color picker for each macro

#### Section D: Data Management
- **Export:** Generate CSV of all food logs (last 3/6/12 months, all-time)
- **Clear Data:** Warning dialog before wiping all logs
- **Reset Defaults:** Restore onboarding defaults

#### Section E: About
- App version, Flutter version
- Open-source attribution (licenses for packages)
- Contact/Feedback option

---

## 4. Modal & Form Specifications

### 4.1 Add Food Log Modal (Dashboard FAB)

#### Layout
- **Header:** "Log Food Item"
- **Step 1: Search/Select Food**
  - Dropdown or searchable list of existing food items
  - Search bar to filter
  - "Add New Food" button if item doesn't exist (opens 4.2)
  
- **Step 2: Quantity Input**
  - Numeric input field
  - Unit dropdown (inherited from food item)
  - Example: "250 g" or "2 (eggs)"

- **Step 3: Macros Preview**
  - Display calculated macros for this serving:
    ```
    Calories: XXX kcal
    Protein: XXg | Carbs: XXg | Fat: XXg | Fiber: XXg
    ```

- **Step 4: Timestamp (Optional)**
  - Pre-filled with current time
  - Allows editing (e.g., logging past meals)

- **Buttons:**
  - **Cancel** (dismiss)
  - **Save** (add to today's log, refresh dashboard immediately)
  - **Save & Log Another** (add and keep modal open for next entry)

---

### 4.2 Add Food Item Form (Food Screen + Fallback from 4.1)

#### Two Paths: Known vs. Unknown Macros

#### Path A: User Knows Macros (Quick Add)
1. **Food Name** (text input)
2. **Measurement Type** (dropdown):
   - Countable (egg, apple, slice, etc.)
   - Measurable (g, ml, cup, oz, tbsp, etc.)
3. **Macro Inputs per 1 unit:**
   - Calories (kcal)
   - Protein (g)
   - Carbs (g)
   - Fat (g)
   - Fiber (g)
4. **Category** (text input or dropdown from existing)
5. **Save Button**

#### Path B: User Doesn't Know Macros (LLM-Assisted)
1. **Food Name** (text input)
2. **Measurement Type** (same dropdown as Path A)
3. **LLM Request Button:** "Get Macros from AI"
   
   - App generates prompt:
   ```
   "I need nutritional information for [FOOD_NAME] measured in [MEASUREMENT_TYPE].
   Please provide the nutritional content per 1 [MEASUREMENT_TYPE] (e.g., per 1 egg, per 100g, per 1 cup).
   
   Return ONLY the response in this exact format:
   Calories: [NUMBER]
   Protein: [NUMBER]
   Carbs: [NUMBER]
   Fat: [NUMBER]
   Fiber: [NUMBER]"
   ```
   
   - User copies prompt, gets LLM response, pastes back into app
   - App extracts macros using regex/structured parsing
   - Pre-fills macro fields with extracted values

4. **Macro Input Fields:** (optional override)
   - Allows editing extracted values if needed

5. **Category** (text input or dropdown)

6. **Save Button:** Adds food to Food screen inventory

---

### 4.3 Create Meal Modal (Food Screen FAB Option 2)

#### Layout
1. **Meal Name** (text input)
2. **Food Items Selector:**
   - Multi-select list of existing food items
   - Checkbox per item
   - Display macro totals as items are selected (live update)
3. **Selected Items Preview:**
   ```
   [Food Name] (checked) · [Quantity] [Unit]
   Total: XXX cal | XXg P | XXg C | XXg F
   ```
4. **Buttons:**
   - **Cancel**
   - **Create Meal** (saves and returns to Food screen)

---

## 5. Data Validation & Error Handling

### Input Validation
- All numeric inputs: Positive numbers, reasonable ranges
  - Macros: 0-10,000 kcal per item, 0-500g per macro
  - Weight: 20-500 kg, height: 50-250 cm
  - Age: 10-120 years
- Food name: Non-empty, max 100 characters
- Meal name: Non-empty, max 100 characters

### LLM Response Parsing
- **Regex patterns for extraction:**
  ```
  Calories:\s*(\d+(?:\.\d+)?)
  Protein:\s*(\d+(?:\.\d+)?)
  Carbs:\s*(\d+(?:\.\d+)?)
  Fat:\s*(\d+(?:\.\d+)?)
  Fiber:\s*(\d+(?:\.\d+)?)
  ```
- **Fallback:** If parsing fails, highlight extracted text and ask user to manually confirm values
- **Validation:** Warn if parsed macro values seem unreasonable (e.g., 50,000 kcal per egg)

### Offline Handling
- All data operations are local (no internet required)
- LLM prompts are generated but require user to manually copy/paste (by design)

---

## 6. Key Interactions & User Flows

### Flow 1: Typical Daily Logging
1. Open app → Dashboard loads today's data
2. Tap FAB → Add Food Log modal
3. Select food item, enter quantity, confirm time
4. Log saved, dashboard refreshes immediately (macro rings update, recent logs update)
5. Repeat as needed throughout day

### Flow 2: Updating Macro Goals
1. Profile screen → Macro Goals section
2. Option A: Manually edit values
3. Option B: Tap "Generate via LLM," follow same flow as onboarding
4. Save, app recalculates today's progress against new goals

### Flow 3: Viewing Historical Data
1. Calendar screen → Tap any past date
2. Macro ring updates, food log populates for that day
3. Tap past food entry → Edit or delete
4. Changes reflect in calendar heatmap if date is visible

### Flow 4: Managing Recurring Meals
1. Food screen → Log similar items multiple times
2. Create Meal → Multi-select items, name (e.g., "Default Breakfast")
3. Future days: Tap saved meal → Log all items with one action

---

## 7. Visual & UX Specifications

### Color Palette (Customizable in Profile)
- **Default Macro Colors:**
  - Calories: Red (#FF6B6B)
  - Protein: Blue (#4ECDC4)
  - Carbs: Yellow (#FFE66D)
  - Fiber: Green (#95E1D3)
- **Status Colors:**
  - On Track (50-100%): Green (#51CF66)
  - Over Goal (100%+): Red (#FF6B6B)
  - Under Goal (0-50%): Gray (#ADB5BD)

### Typography
- **Headlines:** 18-20sp, bold
- **Body:** 14-16sp, regular
- **Labels:** 12-14sp, medium

### Spacing & Layout
- Padding: 16dp standard, 8dp compact
- Card elevation: 2-4dp
- FAB: Fixed at bottom-right, 56x56dp

### Micro-interactions
- FAB: Ripple on tap, slight scale animation
- List items: Smooth fade on delete, undo toast
- Modal: Slide up from bottom with momentum
- Charts: Subtle animation on first load (0.5s fill animation)

---

## 8. Data Storage Schema (SQLite via Drift)

### Tables

#### users
```
id (int, primary key)
name (String)
age (int)
gender (String: M/F/Other)
height (double, in cm)
current_weight (double, in kg)
activity_level (String enum)
goal (String enum: loss/maintenance/gain)
goal_rate (double)
created_at (DateTime)
updated_at (DateTime)
```

#### macro_goals
```
id (int, primary key)
user_id (int, foreign key)
calories_target (int)
protein_target (double)
carbs_target (double)
fat_target (double)
fiber_target (double)
updated_at (DateTime)
```

#### food_items
```
id (int, primary key)
user_id (int, foreign key)
name (String)
category (String, nullable)
measurement_type (String: countable/measurable)
measurement_unit (String: g, ml, cup, egg, slice, etc.)
calories_per_unit (double)
protein_per_unit (double)
carbs_per_unit (double)
fat_per_unit (double)
fiber_per_unit (double)
created_at (DateTime)
```

#### food_logs
```
id (int, primary key)
user_id (int, foreign key)
food_item_id (int, foreign key)
quantity (double)
logged_date (DateTime, date only)
logged_time (DateTime, with time)
calories (double, calculated)
protein (double, calculated)
carbs (double, calculated)
fat (double, calculated)
fiber (double, calculated)
created_at (DateTime)
```

#### meals
```
id (int, primary key)
user_id (int, foreign key)
name (String)
created_at (DateTime)
```

#### meal_items (junction table)
```
id (int, primary key)
meal_id (int, foreign key)
food_item_id (int, foreign key)
```

---

## 9. Success Criteria & Testing

### Functional Requirements
- [ ] Onboarding completes without crashes
- [ ] LLM prompt parsing extracts macros with 100% accuracy for standard formats
- [ ] Daily logs persist after app restart
- [ ] Calendar correctly displays historical data
- [ ] Macro calculations are accurate (no rounding errors >0.1g)
- [ ] FAB and modals respond to taps within 100ms
- [ ] App works completely offline (no network calls)

### Performance
- [ ] App launch: <2 seconds
- [ ] Food log saves: <500ms
- [ ] Calendar render: <1 second for full month
- [ ] Database queries: <100ms average

### User Experience
- [ ] All forms are intuitive and require <3 taps per entry
- [ ] Visual feedback for every action (toast, animation, or refresh)
- [ ] Error messages are clear and actionable

---

## 10. Future Enhancement Ideas (Out of Scope)

- Export to PDF for weekly/monthly reports
- Barcode scanning for food macros (integration with external DB)
- Recipe builder (automated macro summation)
- Water intake tracking
- Meal timing recommendations (not guidance, just visual patterns)
- Dark mode with OLED optimization
- Multi-language support
- Cloud backup (opt-in, encrypted)
- Wearable integration (Apple Health, Google Fit export)

---

## 11. Development Roadmap (MVP → V1.0)

### MVP (Core Features)
1. Onboarding + Profile
2. Dashboard with macro rings + weekly bar
3. Food item management (CRUD)
4. Food logging (add, edit, delete)
5. Basic Calendar view

### V0.5 (Stability)
- LLM prompt integration (onboarding + food items)
- Meal grouping
- Data export (CSV)
- Bug fixes from MVP testing

### V1.0 (Polish)
- Calendar heatmap with full month view
- Profile customization (colors, units)
- Historical data analysis
- UI/UX refinements
- Performance optimization

---

## 12. Notes for AI Implementation

- **Stateless Parsing:** All LLM prompt responses are regex-based; no ML model inference needed in-app
- **Locale-Aware:** Use Dart's `intl` for date/number formatting per device locale
- **Responsive Design:** Test on phone sizes 4.5" to 6.7"
- **Accessibility:** Ensure sufficient color contrast, WCAG AA compliant
- **Privacy:** All data stored locally; no telemetry or analytics
