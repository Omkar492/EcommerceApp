# EcommerceApp

EcommerceApp is a SwiftUI iOS application that demonstrates a production-minded shopping and user-management experience. 

It includes authentication, product browsing, product CRUD, filtering, search, pagination, cart review, user CRUD, analytics tracking, cancellable async networking, retry handling, and test coverage.

## Screenshots

| Login | Register | Products |
|---|---|---|
| <img width="1206" height="2622" alt="Login" src="https://github.com/user-attachments/assets/59955976-8e43-4787-be82-e41659c9655c" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-08-19 at 10 04 09" src="https://github.com/user-attachments/assets/328cae37-1dce-4226-812e-05446d3df206" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-08-19 at 10 04 59" src="https://github.com/user-attachments/assets/6d2baf51-af22-4bdc-957d-d10952bda887" /> |

| Product Details | Product Form | Filters |
|---|---|---|
| <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-08-19 at 10 06 44" src="https://github.com/user-attachments/assets/584c27de-0c79-43e2-bc5b-e2f42839dac0" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-08-19 at 10 07 59" src="https://github.com/user-attachments/assets/c0261432-8411-4fd6-a23f-876f258a32fd" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-08-19 at 10 08 52" src="https://github.com/user-attachments/assets/adff0537-286b-46ff-9886-9c23ced90c45" /> |

| Cart Review | Users | Profile |
|---|---|---|
| <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-08-19 at 10 09 52" src="https://github.com/user-attachments/assets/962e94c4-1619-4197-8ceb-d1ebef3e8d1e" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-08-19 at 10 10 14" src="https://github.com/user-attachments/assets/933cab01-b247-4d72-aee1-6d100b1c365c" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-08-19 at 10 10 53" src="https://github.com/user-attachments/assets/1185a831-5ab3-4a3d-9dd5-ecaa873f310c" /> |

## Features

- Email/password login with token-based session handling
- User registration with avatar URL support
- Session restore using locally persisted auth tokens
- Token refresh flow when profile requests receive unauthorized responses
- Profile screen with refresh and sign-out support
- Tab-based SwiftUI navigation after authentication
- Product listing with pull-to-refresh
- Product search by title, description, category, and price
- Product filtering with draft/apply/clear behavior
- Infinite pagination for product browsing
- Product detail screen
- Create, update, and delete product flows
- Shopping cart with shared app-level cart state
- Cart quantity updates with steppers
- Cart item removal
- Cart totals and item count summary
- Order confirmation flow
- User list with remote avatar loading
- Create and update user flows
- Swipe actions for editing users
- Loading, empty, success, and error states
- Analytics event tracking for screens, auth, products, filters, search, cart, and user actions
- Cancellable in-flight requests when views disappear
- Retry engine for transient network failures
- Unit tests and UI test targets
- Fastlane setup for automation

## Tech Stack

- Swift
- SwiftUI
- Observation framework
- Swift Concurrency
- URLSession-based networking
- Kingfisher for remote image loading
- XCTest
- XCUITest
- Fastlane

## Architecture

The MVVM project is organized around feature modules and shared core utilities.

```text
DemoApp/
├── ContentView.swift
├── DemoAppApp.swift
└── Core/
    ├── Analytics/
    ├── Cart/
    ├── Login/
    ├── Models/
    ├── Products/
    ├── Users/
    └── Utilities/
        ├── Client/
        ├── Concurrency/
        ├── Error/
        └── Networking/
```

## Main Modules

### Authentication

The login module handles user authentication, registration, profile fetching, token persistence, token refresh, session restoration, and sign out.

Key files:

```text
DemoApp/Core/Login/View/LoginView.swift
DemoApp/Core/Login/View/RegisterView.swift
DemoApp/Core/Login/View/ProfileView.swift
DemoApp/Core/Login/ViewModel/LoginViewModel.swift
DemoApp/Core/Login/Service/LoginService.swift
DemoApp/Core/Login/Models/AuthModels.swift
```

### Products

The products module supports listing, searching, filtering, pagination, product detail, creation, update, and deletion.

Key files:

```text
DemoApp/Core/Products/View/ProductsView.swift
DemoApp/Core/Products/View/ProductCardView.swift
DemoApp/Core/Products/View/ProductDetailView.swift
DemoApp/Core/Products/View/ProductFormView.swift
DemoApp/Core/Products/View/ProductFilterView.swift
DemoApp/Core/Products/ViewModel/ProductsViewModel.swift
DemoApp/Core/Products/Service/ProductService.swift
DemoApp/Core/Products/Models/Product.swift
DemoApp/Core/Products/Models/ProductFilter.swift
```

### Cart

The cart module manages cart state, item quantities, item removal, totals, review, and order completion.

Key files:

```text
DemoApp/Core/Cart/View/CartReviewView.swift
DemoApp/Core/Cart/ViewModel/CartViewModel.swift
DemoApp/Core/Cart/Models/CartItem.swift
DemoApp/Core/Cart/Models/CartDestination.swift
```

### Users

The users module handles listing users, displaying user rows with remote avatars, creating users, and updating existing users.

Key files:

```text
DemoApp/Core/Users/View/UserListView.swift
DemoApp/Core/Users/View/UserRowView.swift
DemoApp/Core/Users/View/UserFormView.swift
DemoApp/Core/Users/ViewModel/UserListViewModel.swift
DemoApp/Core/Users/Service/UserService.swift
DemoApp/Core/Users/Model/User.swift
```

### Networking

The networking layer provides typed API requests, reusable HTTP clients, retry behavior, route definitions, and error handling.

Key files:

```text
DemoApp/Core/Utilities/Networking/APIRequest.swift
DemoApp/Core/Utilities/Networking/HTTPClient.swift
DemoApp/Core/Utilities/Networking/RetryEngine.swift
DemoApp/Core/Utilities/Networking/APIRoutes.swift
DemoApp/Core/Utilities/Error/NetworkError.swift
DemoApp/Core/Utilities/Client/APIClient.swift
```

### Analytics

Analytics events are centralized through a shared analytics manager and typed event definitions.

Key files:

```text
DemoApp/Core/Analytics/AnalyticsManager.swift
DemoApp/Core/Analytics/AnalyticsEvent.swift
```

## App Flow

1. The app starts in `ContentView`.
2. `LoginViewModel` attempts to restore a saved session.
3. If no session exists, the user sees the login flow.
4. After authentication, the user enters the main tab interface.
5. The authenticated app contains four tabs:
   - Products
   - Cart
   - Users
   - Profile

## Networking Behavior

DemoApp uses typed API request models and async/await networking. The retry engine retries transient failures for safe HTTP methods and selected status codes.

Retryable status codes include:

```text
408
429
500...599
```

Retryable URL errors include common connection, DNS, timeout, and offline failures.

## Testing

The project includes unit and UI test targets.

```text
DemoAppTests/
DemoAppUITests/
```

Run tests from Xcode with:

```text
Command + U
```

Or from the terminal:

```sh
xcodebuild test \
  -project DemoApp.xcodeproj \
  -scheme DemoApp \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Fastlane

Fastlane is included for automation.

Install dependencies:

```sh
bundle install
```

Run the available lane:

```sh
bundle exec fastlane ios custom_lane
```

Fastlane files:

```text
fastlane/Fastfile
fastlane/Appfile
fastlane/README.md
Gemfile
Gemfile.lock
```

## Requirements

- macOS
- Xcode
- iOS Simulator
- Ruby and Bundler for Fastlane usage

## Getting Started

1. Clone the repository.

```sh
git clone https://github.com/Omkar492/EcommerceApp
cd DemoApp
```

2. Open the project in Xcode.

```sh
open DemoApp.xcodeproj
```

3. Select a simulator.

4. Build and run the app.

```text
Command + R
```

## Project Highlights

- Clean feature-based folder organization
- SwiftUI-first implementation
- Observable view models
- Async/await service layer
- Typed models for requests and responses
- Shared mutation and loading states
- Cancellable requests for better lifecycle behavior
- Retry support for unstable network conditions
- User-friendly empty, loading, and error states
- Modular services for easier testing and replacement


## Author

Built by Omkar  ❤️
