//
//  AnalyticsEvent.swift
//  DemoApp
//
//  Created by Omkar Chougule on 11/05/26.
//

import Foundation

enum AnalyticsEvent: String {
    case appLaunched = "app_launched"
    case screenViewed = "screen_viewed"
    
    case loginStarted = "login_started"
    case loginSucceeded = "login_succeeded"
    case loginFailed = "login_failed"
    case registrationStarted = "registration_started"
    case registrationSucceeded = "registration_succeeded"
    case registrationFailed = "registration_failed"
    case emailAvailabilityChecked = "email_availability_checked"
    case sessionRestored = "session_restored"
    case sessionRestoreFailed = "session_restore_failed"
    case profileRefreshed = "profile_refreshed"
    case profileRefreshFailed = "profile_refresh_failed"
    case signedOut = "signed_out"
    
    case productsLoaded = "products_loaded"
    case productsLoadFailed = "products_load_failed"
    case productsNextPageLoaded = "products_next_page_loaded"
    case productsNextPageFailed = "products_next_page_failed"
    case productSearchSubmitted = "product_search_submitted"
    case productFiltersApplied = "product_filters_applied"
    case productFiltersCleared = "product_filters_cleared"
    case productCreated = "product_created"
    case productCreateFailed = "product_create_failed"
    case productUpdated = "product_updated"
    case productUpdateFailed = "product_update_failed"
    case productDeleted = "product_deleted"
    case productDeleteFailed = "product_delete_failed"
    
    case cartProductAdded = "cart_product_added"
    case cartProductQuantityUpdated = "cart_product_quantity_updated"
    case cartProductRemoved = "cart_product_removed"
    case cartCheckoutTapped = "cart_checkout_tapped"
    case cartOrderPlaced = "cart_order_placed"
}
