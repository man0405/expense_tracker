# Expense Tracker

A full-featured Flutter expense tracking application with local storage and data visualization.


## Demo

https://github.com/user-attachments/assets/7562b23e-11fc-402f-9e35-eeb966d35676

## Features

### 🏠 Home Screen
- **View All Expenses**: Display all recorded expenses in a scrollable list
- **Current Month Filter**: Toggle to show only current month's expenses
- **Total Summary**: View total expenses and transaction count in a beautiful gradient card
- **Quick Actions**: 
  - Swipe to delete expenses
  - Tap to edit existing expenses
  - Add new expenses with floating action button
- **Category Icons**: Visual category identification with color-coded icons

### 📊 Statistics Screen
- **Pie Chart**: Visual breakdown of expenses by category with percentages
- **Bar Chart**: Daily expense tracking for the current month
- **Category Breakdown**: Detailed list with progress bars showing spending distribution
- **All-Time vs Monthly View**: Toggle between current month and all-time statistics
- **Summary Card**: Quick overview of total expenses and transaction count

### ➕ Add/Edit Expense
- **Form Validation**: Ensures all required fields are filled correctly
- **Fields**:
  - Title (required)
  - Amount (required, numeric validation)
  - Category (8 categories with icons)
  - Date (date picker)
  - Description (optional)
- **Edit Mode**: Pre-filled form when editing existing expenses

## Technical Stack

### Dependencies
- **hive & hive_flutter**: Local NoSQL database for offline storage
- **fl_chart**: Beautiful and customizable charts (pie and bar charts)
- **intl**: Date formatting and internationalization

### Project Structure
```
lib/
├── main.dart                          # App entry point
├── models/
│   ├── expense.dart                   # Expense model with Hive annotations
│   └── expense.g.dart                 # Generated Hive adapter
├── services/
│   └── expense_database.dart          # Database operations
├── constants/
│   └── categories.dart                # Expense categories with icons/colors
└── screens/
    ├── home_screen.dart               # Main expense list view
    ├── add_expense_screen.dart        # Add/Edit expense form
    └── statistics_screen.dart         # Charts and analytics
```

## Categories

The app includes 8 predefined expense categories:
- 🍽️ **Food** (Orange)
- 🚗 **Transport** (Blue)
- 🛍️ **Shopping** (Purple)
- 🎬 **Entertainment** (Pink)
- 🧾 **Bills** (Red)
- 💊 **Health** (Green)
- 🎓 **Education** (Teal)
- ⚙️ **Other** (Grey)

## Installation & Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd expense_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapter**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Usage

### Adding an Expense
1. Tap the **+** floating action button on the home screen
2. Fill in the expense details:
   - Enter a descriptive title
   - Specify the amount
   - Select a category from the dropdown
   - Choose the date (defaults to today)
   - Optionally add a description
3. Tap **Add Expense** to save

### Editing an Expense
1. Tap on any expense in the list
2. Modify the desired fields
3. Tap **Update Expense** to save changes

### Deleting an Expense
- Swipe an expense card from right to left
- The expense will be removed with a confirmation message

### Viewing Statistics
1. Tap the **bar chart icon** in the app bar
2. View:
   - Pie chart showing category distribution
   - Bar chart with daily expenses (monthly view)
   - Detailed category breakdown with percentages
3. Toggle between **Current Month** and **All Time** views

### Filtering Expenses
- Use the **date/infinity icon** in the home screen to toggle between:
  - All expenses
  - Current month only

## Data Storage

All expenses are stored locally using **Hive**, a lightweight and fast NoSQL database:
- **Offline-first**: Works without internet connection
- **Persistent**: Data survives app restarts
- **Fast**: Optimized for mobile performance
- **Type-safe**: Uses generated adapters for the Expense model

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web
```



## Future Enhancements

Potential features for future versions:
- Custom categories
- Recurring expenses
- Budget limits and alerts
- Export data (CSV, PDF)
- Cloud sync
- Multi-currency support
- Search and advanced filtering
- Dark mode theme


