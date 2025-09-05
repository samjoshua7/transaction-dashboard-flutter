# 📊 Transaction Dashboard App

A **Flutter-based cross-platform app** that allows users to manage transactions/tasks in a **Kanban-style dashboard**.  
Users can add, edit, drag & drop, and organize their tasks into categories like **Pending**, **Completed**, and **Flagged**.  
Built as part of a technical recruitment challenge 🚀.

---

## ✨ Features

- 📝 **Add Transactions**  
  - Add a new transaction using the floating `+` button.  
  - A pop-up modal appears with fields: **Name, Amount, Date, Status**.

- ✏️ **Edit Transactions**  
  - Tap on any card to open the same modal and update details.

- 📌 **Categorized View**  
  - Transactions are grouped into three sections:
    - **Pending**
    - **Completed**
    - **Flagged**

- 🔄 **Drag & Drop**  
  - Long-press and drag a card to another category.

- 🌗 **Dark/Light Mode**  
  - Toggle theme using the AppBar action button.

- 🔍 **Search Functionality**  
  - Search bar filters transactions by name.

- 💾 **Persistent Storage**  
  - Transactions are stored locally using **SharedPreferences**.  
  - Sample data is preloaded from `assets/transactions.json`.

- 📱 **Responsive UI**  
  - Each section scrolls horizontally (left ↔ right).  
  - Works on different screen sizes (Android, iOS, Web).

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)  
- **Language**: Dart  
- **Local Storage**: SharedPreferences  
- **UI Widgets**: Material Design components

---

## 📂 Project Structure

```
lib/
 ┣ models/
 ┃ ┗ transaction.dart        # Data model for a transaction
 ┣ screens/
 ┃ ┗ home_page.dart          # Main dashboard screen
 ┣ widgets/
 ┃ ┗ transaction_card.dart   # Custom transaction card widget
 ┗ main.dart                 # Entry point + theme toggle
assets/
 ┗ transactions.json         # Sample data
```

---

## 🚀 Getting Started

### 1. Prerequisites
- Install [Flutter SDK](https://docs.flutter.dev/get-started/install)  
- Install an IDE (VS Code / Android Studio)  
- Ensure Android/iOS emulator or a physical device is ready

### 2. Clone the Repository
```bash
git clone https://github.com/your-username/transaction_dashboard.git
cd transaction_dashboard
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Run the App
```bash
flutter run
```

---

## 📸 Screenshots (still working...)

| Light Mode | Dark Mode |
|------------|-----------|
| ![Light Screenshot](assets/screenshots/light.png) | ![Dark Screenshot](assets/screenshots/dark.png) |

---

## 🔮 Future Improvements
- 🔔 Notifications & reminders  
- 📤 Export transactions as CSV/PDF  
- ☁️ Sync with backend (Firebase/Node.js API)  
- 👥 Multi-user support  

---

## 👨‍💻 Author
Built with ❤️ by Sam Joshua  
For technical recruitment demonstration.
