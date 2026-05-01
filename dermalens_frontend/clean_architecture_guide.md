# 📘 Clean Architecture Guide: MVVM with Provider

This document summarizes the architectural shift made in **DermaLens**. This pattern is the industry standard for building production-grade, maintainable Flutter applications.

---

## 1. The Core Problem: "Fat-Views"
In early development, it's common to put everything inside the `State` of a `StatefulWidget`. This creates **Fat-Views**:
- **UI Logic:** Building the buttons and layout.
- **Orchestration:** Showing loading dialogs, navigating after success.
- **Data Logic:** Calling APIs directly.
- **State Management:** Tracking `bool isLoading` manually everywhere.

**Result:** Files become 500+ lines long, hard to test, and impossible to reuse.

---

## 2. The Solution: Layered Architecture (MVVM)
We split the app into three distinct layers:

### A. The View (Pages / Widgets)
**Role:** Pure UI. It should only care about *how it looks*.
- **Constraint:** No API calls, no complex logic.
- **How it works:** It "listens" to a **Notifier** and builds the UI based on the current state.
- **Key Tool:** `StatelessWidget` + `Consumer`.

### B. The Notifier (ViewModel / "The Hook")
**Role:** The "Brain" of the screen.
- **Responsibility:** Holds state variables (e.g., `userData`, `isLoading`), calls services, and handles navigation/dialogs.
- **Mechanism:** Extends `ChangeNotifier`. When data changes, it calls `notifyListeners()`, which tells the UI to rebuild.
- **Location:** `lib/notifiers/`

### C. The Service (Data Layer)
**Role:** The worker. It only knows *how to talk to the outside world*.
- **Responsibility:** Raw HTTP requests, database queries, or file access.
- **Constraint:** It doesn't know about Flutter or the UI. It just returns data or throws errors.
- **Location:** `lib/services/`

---

## 3. Implementation Workflow

### Step 1: Global Registration
In `main.dart`, we use `MultiProvider` to "broadcast" our brain classes to the entire app.
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => HomeNotifier()),
    ChangeNotifierProvider(create: (_) => ChatNotifier()),
  ],
  child: const MyApp(),
)
```

### Step 2: The Notifier Logic
Move your UI-blocking logic here. Notice how it manages its own `isLoading` state.
```dart
class HomeNotifier extends ChangeNotifier {
  bool isLoading = false;

  Future<void> performScan(BuildContext context) async {
    isLoading = true;
    notifyListeners(); // UI updates to show loader

    try {
      await _service.doWork();
    } finally {
      isLoading = false;
      notifyListeners(); // UI updates to hide loader
    }
  }
}
```

### Step 3: The Consumer UI
The UI becomes a "dumb" reflection of the Notifier.
```dart
Consumer<HomeNotifier>(
  builder: (context, notifier, child) {
    if (notifier.isLoading) return CircularProgressIndicator();
    
    return ElevatedButton(
      onPressed: () => notifier.performScan(context),
      child: Text("Start Scan"),
    );
  },
)
```

---

## 4. Why is this better?
1.  **Clean Code:** Pages drop from 500 lines to 100 lines.
2.  **Testability:** You can test your `Notifier` logic without even launching the UI.
3.  **Consistency:** Every page works the same way.
4.  **Separation of Concerns:** If you change your Backend API, you only change the `Service`. If you change your layout, you only change the `Page`.

---

## 🛠️ Pro-Tip for your Knowledge:
In **React**, we use `useContext` or `Redux`. In **Flutter**, `Provider` + `ChangeNotifier` is essentially the same concept—it's a "Radio Station" (Notifier) broadcasting signals, and your widgets are the "Radios" (Consumers) tuned into that specific frequency.
