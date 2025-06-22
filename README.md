# ⚡Tarsheed
# ⚡ Smart Energy Management App

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
![3](https://github.com/user-attachments/assets/6377923f-c949-45a6-b97b-0bb0353cb716)
![2](https://github.com/user-attachments/assets/d2ff0338-5f91-4aa9-ba30-e584e863a4c9)
![1](https://github.com/user-attachments/assets/18c9a239-ca53-449b-9d1b-a7db1cc3200e)
![10](https://github.com/user-attachments/assets/d5f058ba-94ca-4817-b64d-b5fc89c9d45d)
![9](https://github.com/user-attachments/assets/652d3558-4545-4871-b5a1-a521028b6411)
![8](https://github.com/user-attachments/assets/ca8329cf-8a5a-4d17-947c-f496597976af)
![7](https://github.com/user-attachments/assets/d29198ff-030e-416b-b343-15d05f630e21)
![6](https://github.com/user-attachments/assets/3499be76-b941-40c3-bfbe-e68203d088fa)
![5](https://github.com/user-attachments/assets/1b8e3a19-8a39-42f2-86d1-b0b146656a23)
![4](https://github.com/user-attachments/assets/96891366-8c7c-4099-91fb-270593e94777)


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
├── 📄 apis/
│   ├── api.dart
│   ├── dio_helper.dart
│   └── end_points.dart
├── 📄 error/
│   ├── custom_exceptions/
│   │   └── auth_exceptions.dart
│   ├── handlers/
│   │   ├── auth_exception_handler.dart
│   │   ├── dio_exception_handler.dart
│   │   ├── sqlite_exception_handler.dart
│   │   └── unexpected_exception_handler.dart
│   └── exception_manager.dart
├── 📄 routing/
│   └── navigation_manager.dart
├── 📄 services/
│   ├── app_initializer.dart
│   ├── bloc_observer.dart
│   ├── connectivity_services.dart
│   ├── dep_injection.dart
│   └── secure_storage_helper.dart
├── 📄 utils/
│   ├── image_manager.dart
│   ├── localization_manager.dart
│   └── theme_manager.dart
└── 📄 widgets/
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
│       ├── card_item.dart
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

### 3. **Notification System** (`src/notifications/`)
```
notifications/
├── 📁 cubit/
│   ├── notifications_cubit.dart
│   └── notifications_state.dart
├── 📁 data/
│   ├── models/
│   │   └── app_notification.dart
│   ├── repositories/
│   │   └── notifications_repository.dart
│   └── services/
│       ├── base_notifications_services.dart
│       └── notifications_services.dart
├── 📁 ui/
│   ├── screens/
│   │   └── notification_page.dart
│   └── widgets/
│       └── notification_widget.dart
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