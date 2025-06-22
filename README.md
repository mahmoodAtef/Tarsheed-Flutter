# ⚡Tarsheed
## ⚡ Smart Energy Management App

A Flutter-based mobile application that helps users monitor and control electricity consumption in their homes through automation, device management, and real-time sensor integration.

---

## 📱 Features

- **Authentication:**
    - Login via Email/Password, Google, or Facebook
    - Sign up, email verification, forgot password, reset password
    - Secure local session handling

- **Automation Engine:**
    - Define routines based on triggers, conditions, and actions
    - Supports sensor-based automation (temperature, motion, window state, energy usage)
    - Built using BLoC and Observer Pattern for real-time response

- **Device & Sensor Management:**
    - Add/edit/delete devices and sensors across rooms
    - Monitor real-time sensor data from ESP32 (e.g., temperature, energy)
    - Organized per home and room for scalability

- **Reports & Suggestions:**
    - View energy consumption reports by device/room/time period
    - Smart suggestions powered by simple rules/AI for better savings

- **Settings:**
    - Update user info, change language, delete account

---
A Flutter-based mobile application that helps users monitor and control electricity consumption in their homes through automation, device management, and real-time sensor integration.
---
# App UI

![3](https://github.com/user-attachments/assets/5fc195cb-705d-460a-b917-8da5a3c2700a)
![4](https://github.com/user-attachments/assets/ec744f01-9cb1-42f8-89d0-919eeca19aa5)
![2](https://github.com/user-attachments/assets/e14131d6-3556-425d-94f9-9c0f0ce20199)
![7_PhotoGrid](https://github.com/user-attachments/assets/5dbcb37a-b2c1-4824-afb6-436086d7d0ab)
![5](https://github.com/user-attachments/assets/6aa20f3d-9fe1-4573-b044-929b36b356a0)
![6_PhotoGrid](https://github.com/user-attachments/assets/6209ab1e-8fdf-46fd-b6fc-980303c03c63)
![1](https://github.com/user-attachments/assets/fd2af91b-8deb-4f2b-99b7-070375510065)
![10_PhotoGrid](https://github.com/user-attachments/assets/3c1d7604-fed5-49b3-930d-03071b2e4ec7)
![9_PhotoGrid](https://github.com/user-attachments/assets/e0c82e40-b934-4557-b196-0d185c4ab74c)
![8_PhotoGrid](https://github.com/user-attachments/assets/f50fbf74-9789-47c2-94cc-2d06678c478d)

# Project Architecture

## 📁 Project Structure Overview

```
lib/
├── 📁 generated/           # Auto-generated files
├── 📁 l10n/               # Localization files
└── 📁 src/                # Main source code
    ├── 📁 core/           # Core utilities and configurations
    └── 📁 modules/        # Feature modules
        ├── 📁 automation/     # Automation features
        ├── 📁 dashboard/      # Dashboard features
        ├── 📁 notifications/  # Notification system
        └── 📁 settings/       # Settings management
```

## 🏗️ Architecture Layers

### 1. **Core Layer** (`src/core/`)
Foundation layer containing shared utilities and configurations:

```
core/
├── 📁 apis/
│   ├── api.dart
│   ├── dio_helper.dart
│   └── end_points.dart
├── 📁 error/
│   ├── custom_exceptions/
│   │   └── auth_exceptions.dart
│   ├── handlers/
│   │   ├── auth_exception_handler.dart
│   │   ├── dio_exception_handler.dart
│   │   ├── sqlite_exception_handler.dart
│   │   └── unexpected_exception_handler.dart
│   └── exception_manager.dart
├── 📁 routing/
│   └── navigation_manager.dart
├── 📁 services/
│   ├── app_initializer.dart
│   ├── bloc_observer.dart
│   ├── connectivity_services.dart
│   ├── dep_injection.dart
│   └── secure_storage_helper.dart
├── 📁 utils/
│   ├── image_manager.dart
│   ├── localization_manager.dart
│   └── theme_manager.dart
└── 📁 widgets/
    ├── appbar.dart
    ├── bottom_navigator_bar.dart
    ├── circle_background.dart
    ├── connectivity_widget.dart
    ├── core_widgets.dart
    ├── large_button.dart
    ├── rectangle_background.dart
    └── text_field.dart
```

### 2. **Feature Modules** (`src/modules/`)
Organized by feature domains following Clean Architecture:

#### **Authentication Module**
```
modules/auth/
├── 📁 bloc/
│   ├── auth_bloc.dart
│   ├── auth_event.dart
│   └── auth_state.dart
├── 📁 data/
│   ├── models/
│   │   ├── auth_info.dart
│   │   └── email_and_password.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── services/
│       ├── auth_local_services.dart
│       └── auth_remote_services.dart
├── 📁 ui/
│   ├── screens/
│   │   ├── login.dart
│   │   ├── sign_up_create_account.dart
│   │   ├── verify_code.dart
│   │   ├── verify_email.dart
│   │   └── verify_finish.dart
│   └── widgets/
│       ├── main_title.dart
│       ├── social_icon.dart
│       └── sup_title.dart
```

#### **Automation Module**
```
modules/automation/
├── 📁 cubit/
│   ├── automation_cubit.dart
│   └── automation_state.dart
├── 📁 data/
│   ├── models/
│   │   ├── action/
│   │   │   ├── action.dart
│   │   │   ├── device_action.dart
│   │   │   └── notification_action.dart
│   │   ├── condition/
│   │   │   ├── condition.dart
│   │   │   ├── device_condition.dart
│   │   │   └── sensor_condition.dart
│   │   └── trigger/
│   │       ├── schedule_trigger.dart
│   │       ├── sensor_trigger.dart
│   │       └── trigger.dart
│   ├── repositories/
│   │   └── repository.dart
│   └── services/
│       └── automation_services.dart
├── 📁 ui/
│   ├── screens/
│   │   ├── add_automation_screen.dart
│   │   ├── all_automations_screen.dart
│   │   ├── automation_details_screen.dart
│   │   └── edit_automation_screen.dart
│   └── widgets/
│       ├── automation_card.dart
│       └── components.dart
```

#### **Dashboard Module**
```

modules/dashboard/
├── 📁 bloc/
│   ├── dashboard_bloc.dart
│   ├── dashboard_event.dart
│   └── dashboard_state.dart
├── 📁 cubits/
│   ├── 📁 devices_cubit/
│   │   ├── devices_cubit.dart
│   │   └── devices_state.dart
│   ├── 📁 reports_cubit/
│   │   ├── reports_cubit.dart
│   │   └── reports_state.dart
│   └── 📁 sensors_cubit/
│       ├── sensor_cubit.dart
│       └── sensor_state.dart
├── 📁 data/
│   ├── 📁 models/
│   │   ├── ai_recommendations.dart
│   │   ├── category.dart
│   │   ├── consumption_interval.dart
│   │   ├── device.dart
│   │   ├── device_creation_form.dart
│   │   ├── device_usage.dart
│   │   ├── report.dart
│   │   ├── room.dart
│   │   ├── sensor.dart
│   │   └── sensor_category.dart
│   ├── 📁 repositories/
│   │   ├── 📁 devices/
│   │   │   └── devices_repository.dart
│   │   ├── 📁 report/
│   │   │   └── report_repository.dart
│   │   └── dashboard_repository.dart
│   └── 📁 services/
│       ├── 📁 devices/
│       │   └── devices_remote_services.dart
│       ├── 📁 report/
│       │   ├── report_remote_services.dart
│       │   ├── base_dashboard_services.dart
│       │   ├── dashboard_local_services.dart
│       │   └── dashboard_remote_services.dart
└── 📁 ui/
    ├── 📁 screens/
    │   ├── 📁 devices/
    │   │   ├── add_device_screen.dart
    │   │   └── devices.dart
    │   ├── 📁 reports/
    │   │   └── reports_page.dart
    │   ├── 📁 rooms/
    │   │   ├── add_room_screen.dart
    │   │   └── rooms_screen.dart
    │   ├── 📁 sensors/
    │   │   ├── add_sensor_form_page.dart
    │   │   └── sensors_screen.dart
    │   ├── home_dashboard_screen.dart
    │   ├── home_screen.dart
    │   └── payment_webview.dart
    └── 📁 widgets/
        ├── 📁 devices/
        │   ├── card_devices.dart
        │   ├── connected_devices_list.dart
        │   ├── delete_confirmation_dialog.dart
        │   ├── devices_filter_tabs.dart
        │   └── edit_device_dialog.dart
        ├── 📁 reports/
        │   ├── ai-sugg_card.dart
        │   ├── chart.dart
        │   ├── color_indicator.dart
        │   ├── energy_consumption_section.dart
        │   ├── report_large_card.dart
        │   └── usage_card.dart
        ├── 📁 rooms/
        │   └── room_card.dart
        ├── 📁 sensor/
        │   ├── delete_sensor_dialog.dart
        │   ├── sensor_card.dart
        │   ├── clock_widget.dart
        │   ├── connected_devices_indicator.dart
        │   ├── dashboard_item.dart
        │   ├── home_header.dart
        │   └── text_home_screen.dart

```

### 4. **Settings Module** (`src/settings/`)
```
settings/
├── 📁 cubit/
│   ├── settings_cubit.dart
│   └── settings_state.dart
├── 📁 data/
│   ├── models/
│   │   └── user.dart
│   ├── repositories/
│   │   └── settings_repository.dart
│   └── services/
│       ├── settings_local_services.dart
│       └── settings_remote_services.dart
├── 📁 ui/
│   ├── screens/
│   │   ├── edit_password_page.dart
│   │   ├── main_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── setting.dart
│   │   ├── show_dialog.dart
│   │   ├── splash_screen.dart
│   │   └── welcome_screen.dart
│   └── widgets/
│       └── components.dart
```

## 🎯 Architecture Principles

### **Clean Architecture**
- **Separation of Concerns**: Each layer has a specific responsibility
- **Dependency Inversion**: Higher layers depend on abstractions, not concretions
- **Testability**: Each layer can be tested independently

### **State Management**
- **BLoC Pattern**: For complex state management (Authentication, Dashboard)
- **Cubit Pattern**: For simpler state management (Settings, Notifications)

### **Data Flow**
```
UI Layer (Screens/Widgets)
    ↓
State Management (BLoC/Cubit)
    ↓
Repository Layer
    ↓
Services Layer (Remote/Local)
    ↓
Data Sources (API/Database)
```

## 🔧 Key Components

### **Core Services**
- **App Initializer**: Application bootstrap and configuration
- **Dependency Injection**: Service locator pattern
- **Navigation Manager**: Centralized routing
- **Connectivity Services**: Network state management
- **Secure Storage**: Encrypted local storage

### **Error Handling**
- **Exception Manager**: Centralized error handling
- **Custom Exceptions**: Domain-specific error types
- **Exception Handlers**: Type-specific error processing

### **Shared Widgets**
- **Core Widgets**: Reusable UI components
- **Theme Manager**: Consistent styling
- **Localization Manager**: Multi-language support

## 📱 Features

### **Authentication**
- User registration and login
- Email verification
- Password management
- Security settings

### **Dashboard**
- Device management
- Sensor monitoring
- Energy consumption tracking
- Reports and analytics
- AI recommendations

### **Automation**
- Rule-based automation
- Condition and trigger management
- Action execution
- Schedule management

### **Smart Home Control**
- Device control and monitoring
- Room-based organization
- Real-time sensor data
- Energy consumption analysis

### **Settings**
- User profile management
- Application preferences
- Security settings
- Notification preferences

## 🚀 Getting Started

1. **Clone the repository**
2. **Install dependencies**: `flutter pub get`
3. **Run the app**: `flutter run`

## 📝 Development Guidelines

- Follow Clean Architecture principles
- Use BLoC/Cubit for state management
- Implement proper error handling
- Write unit tests for business logic
- Follow Flutter/Dart best practices
- Use dependency injection for loose coupling

---

*This architecture provides a scalable, maintainable, and testable foundation for a comprehensive smart home management application.*
