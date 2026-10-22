# StudyFlow: Study Planner and Focus Timer

CS310 Mobile Application Development - Group Number 19

*Nazim Mammadov, Javidan Gasimli, Alimert Demirel*

### **StudyFlow** is a mobile study planner for university students, developed using **Flutter**. It aims to help students organize courses, manage assignment and exam deadlines, and stay focused with a built in study timer. All in one simple app.

## App Overview

### What does it do?

StudyFlow will allow students to keep track of their courses, assignments, and exams while planning focused study sessions. A configurable focus/break timer will help users structure their study time. App data will be stored locally on the device, allowing the app to work offline.

### Who is it for?

StudyFlow is intended for university students, especially those taking multiple courses who want a useful study & planning tool.

### What problem does it address?

University students often manage several courses at once, with deadlines scattered across different platforms. This can make it difficult to keep track of upcoming work and organize study time. StudyFlow aims to bring course deadlines, tasks, and study sessions into one convenient place.

## Planned Core Features

- **Course management:** Add, edit, and delete courses with a name and label.
- **Task and deadline tracking:** Create tasks linked to courses, with titles, due dates, priorities, notes, and completion status.
- **Task list views:** Sort tasks by deadline and filter them by course or completion status.
- **Focus timer:** Configure focus and break durations; start, pause, and reset the timer, optionally linking a session to a task.
- **Local reminders:** Receive device notifications before deadlines and when timer sessions end.
- **Study session history:** Save completed focus sessions with their associated course and duration.

## Optional Features

- *Weekly study statistics and charts*

- *A calendar view of deadlines*

- *Dark mode and theme settings*

- *Data export/backup to a file*
  

## Planned Technologies

| Technology | Purpose |
| --- | --- |
| **Flutter (Dart)** | Mobile app development |
| **SQLite** (using sqflite or drift, to be decided) | Local storage for courses, tasks, and study sessions |
| **`shared_preferences`** | Local storage for basic app settings |
| **Local notifications** (package to be decided) | Deadline and timer reminders |

**--- Our project is designed to work without a backend, cloud database, user accounts, or external APIs ---**

## Team Members

| Member | Step 1 Responsibilities |
| --- | --- |
| **Nazim Mammadov** | Step 1 coordinator; meetings and TA communication; core features, data requirements, potential challenges; final review and submission |
| **Javidan Gasimli** | GitHub repository setup, collaborators, Flutter `.gitignore`, and make the initial commit |
| **Alimert Demirel** | README.md (title, description, group details) and the App Overview section of the proposal |

## Potential Challenges

During development, we expect to encounter some technical challenges:

- Implementing reliable local notifications and handling permissions.
- Maintaining timer accuracy while the app runs in the background.
- Managing application state across different screens.
- Designing and maintaining a consistent SQLite database.
- Handling dates, deadlines, and time zones correctly.
- Coordinating team contributions through GitHub and avoiding merge conflicts.

## Repository

[StudyFlow on GitHub](https://github.com/Javidan57/studyflow)
> **Project status:** Proposal and building. The features described are planned.


---

*This README will be updated as development progresses.*
