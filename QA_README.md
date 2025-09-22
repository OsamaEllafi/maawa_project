# QA Testing Guide - MAAWA Flutter App v2.0.0

This document provides comprehensive testing procedures for the MAAWA Flutter app after the major upgrade to full API integration.

## 🧪 Testing Overview

### Test Environment Setup

1. **Backend Requirements**:
   - Laravel API running on production or LAN
   - Database with test data
   - All API endpoints functional

2. **App Configuration**:
   - Environment switching capability
   - Debug mode enabled for testing
   - Network connectivity to API

3. **Test Accounts**:
   - Tenant user account
   - Owner user account  
   - Admin user account

## 📱 Smoke Test Flow

Follow this sequence to verify core functionality:

### 1. App Launch & Environment Setup

**Test Steps**:
1. Launch the app
2. Navigate to Settings → Environment Configuration (dev tools)
3. Verify current environment is displayed
4. Switch between Production and LAN environments
5. Verify API base URL updates correctly

**Expected Results**:
- App launches without crashes
- Environment configuration is accessible in debug mode
- Environment switching works and persists
- API base URL displays correctly

### 2. Authentication Flow

**Test Steps**:
1. Start with fresh app installation
2. Navigate to Login screen
3. Enter valid credentials
4. Verify successful login
5. Test logout functionality
6. Test "Remember Me" functionality

**Expected Results**:
- Login screen displays correctly
- Valid credentials result in successful login
- JWT tokens are stored securely
- Logout clears tokens and redirects to login
- Session persists across app restarts

### 3. User Registration

**Test Steps**:
1. Navigate to Register screen
2. Fill in registration form with valid data
3. Submit registration
4. Verify account creation
5. Test email verification (if applicable)

**Expected Results**:
- Registration form validates input correctly
- Successful registration creates user account
- User is automatically logged in after registration
- Error handling for duplicate emails works

### 4. Password Reset

**Test Steps**:
1. Navigate to Forgot Password screen
2. Enter valid email address
3. Submit request
4. Check email for reset link
5. Use reset link to set new password

**Expected Results**:
- Forgot password request is sent successfully
- Reset email is received
- Password reset link works
- New password can be set and used for login

## 🏠 Property Management Testing

### Public Property Browsing

**Test Steps**:
1. Login as tenant user
2. Navigate to Home/Explore screen
3. Browse published properties
4. Test search functionality
5. Test filtering by type, price, etc.
6. View property details

**Expected Results**:
- Properties load from API correctly
- Search and filters work as expected
- Property details display complete information
- Images load properly
- Pagination works for large lists

### Owner Property Management

**Test Steps**:
1. Login as owner user
2. Navigate to Owner Dashboard
3. Create new property
4. Upload property images
5. Submit property for approval
6. Edit existing properties
7. Manage property media

**Expected Results**:
- Property creation form works correctly
- Image uploads succeed
- Property submission triggers approval workflow
- Property editing preserves data
- Media management (upload, delete, reorder) works

### Admin Property Moderation

**Test Steps**:
1. Login as admin user
2. Navigate to Admin Dashboard → Properties
3. View pending properties
4. Approve a property
5. Reject a property with reason
6. Unpublish a property

**Expected Results**:
- Pending properties list loads correctly
- Approval process updates property status
- Rejection includes reason and updates status
- Unpublishing removes property from public view

## 📅 Booking System Testing

### Tenant Booking Flow

**Test Steps**:
1. Login as tenant user
2. Browse properties and select one
3. Create booking request
4. View booking details
5. Cancel booking (if allowed)
6. View booking history

**Expected Results**:
- Booking creation works correctly
- Booking details display properly
- Cancellation follows business rules
- Booking history shows all user bookings

### Owner Booking Management

**Test Steps**:
1. Login as owner user
2. Navigate to Owner Bookings
3. View incoming booking requests
4. Accept a booking
5. Reject a booking with notes
6. Complete a booking

**Expected Results**:
- Booking requests display correctly
- Accept/reject actions update booking status
- Notes are saved with actions
- Completed bookings show in history

### Admin Booking Management

**Test Steps**:
1. Login as admin user
2. Navigate to Admin Dashboard → Bookings
3. View all bookings
4. Cancel a booking as admin
5. Verify cancellation reason is recorded

**Expected Results**:
- All bookings are visible to admin
- Admin cancellation works
- Cancellation reasons are properly recorded

## 💰 Wallet System Testing

### Wallet Operations

**Test Steps**:
1. Login as any user
2. Navigate to Wallet screen
3. View current balance
4. View transaction history
5. Test top-up functionality
6. Test withdrawal functionality

**Expected Results**:
- Wallet balance displays correctly
- Transaction history loads properly
- Top-up process works with idempotency
- Withdrawal process works correctly
- Transaction details are accurate

### Admin Wallet Management

**Test Steps**:
1. Login as admin user
2. Navigate to Admin Dashboard → Wallet
3. Select a user
4. Adjust wallet balance
5. Add adjustment reason
6. Verify adjustment appears in user's history

**Expected Results**:
- User selection works correctly
- Balance adjustments are processed
- Reasons are recorded
- Adjustments appear in user transaction history

## ⭐ Reviews System Testing

### Creating Reviews

**Test Steps**:
1. Login as tenant user
2. Complete a booking
3. Navigate to Reviews
4. Create review for property/owner
5. Rate and add text review
6. Submit review

**Expected Results**:
- Review creation form works
- Rating system functions correctly
- Review submission succeeds
- Review appears in property/user reviews

### Review Moderation

**Test Steps**:
1. Login as admin user
2. Navigate to Admin Dashboard → Reviews
3. View all reviews
4. Hide inappropriate review
5. Unhide previously hidden review
6. Add moderation notes

**Expected Results**:
- All reviews are visible to admin
- Hide/unhide actions work
- Moderation notes are saved
- Hidden reviews don't appear publicly

## 👥 User Management Testing

### Profile Management

**Test Steps**:
1. Login as any user
2. Navigate to Profile screen
3. Update profile information
4. Upload avatar image
5. Save changes
6. Verify updates persist

**Expected Results**:
- Profile form loads current data
- Updates are saved successfully
- Avatar upload works
- Changes persist across sessions

### KYC System

**Test Steps**:
1. Login as tenant/owner user
2. Navigate to KYC screen
3. Fill in KYC form
4. Submit KYC application
5. Verify submission status

**Expected Results**:
- KYC form validates input
- Submission creates KYC record
- Status updates correctly
- Admin can view and process KYC

### Admin User Management

**Test Steps**:
1. Login as admin user
2. Navigate to Admin Dashboard → Users
3. View user list
4. Promote user to owner
5. Demote owner to tenant
6. Lock/unlock user account

**Expected Results**:
- User list loads correctly
- Role changes work properly
- Account locking/unlocking functions
- Changes are reflected immediately

## 🔧 Developer Tools Testing

### Environment Configuration

**Test Steps**:
1. Enable debug mode
2. Access Settings → Environment Configuration
3. Switch between environments
4. Verify API calls use correct base URL
5. Test health check functionality

**Expected Results**:
- Environment switching works
- API calls use correct endpoints
- Health check returns status
- Configuration persists

### Error Handling

**Test Steps**:
1. Test with invalid credentials
2. Test with network disconnected
3. Test with invalid API responses
4. Test with server errors
5. Verify error messages are user-friendly

**Expected Results**:
- Invalid credentials show appropriate error
- Network errors are handled gracefully
- Server errors don't crash app
- Error messages are clear and actionable

## 🐛 Bug Reporting

### Bug Report Template

When reporting bugs, include:

1. **Environment**:
   - App version: 2.0.0
   - Device/OS: [e.g., iPhone 14, iOS 17]
   - API environment: [Production/LAN]

2. **Steps to Reproduce**:
   - Detailed step-by-step instructions
   - Screenshots if applicable

3. **Expected vs Actual Behavior**:
   - What should happen
   - What actually happens

4. **Additional Information**:
   - User role (tenant/owner/admin)
   - Network conditions
   - Error messages/logs

### Common Issues

1. **Authentication Issues**:
   - Check JWT token expiration
   - Verify API connectivity
   - Clear app data and retry

2. **Image Upload Issues**:
   - Check file size limits
   - Verify image format support
   - Test with different images

3. **Network Issues**:
   - Verify API endpoint accessibility
   - Check network connectivity
   - Test with different environments

## 📊 Performance Testing

### Load Testing

**Test Scenarios**:
1. Load large property lists
2. Test with slow network
3. Test with multiple concurrent users
4. Test image loading performance

**Expected Results**:
- App remains responsive
- Loading indicators work
- Pagination handles large datasets
- Images load efficiently

### Memory Testing

**Test Scenarios**:
1. Navigate between many screens
2. Load and unload large images
3. Test app over extended use
4. Check for memory leaks

**Expected Results**:
- No memory leaks detected
- App performance remains stable
- Images are properly cached and released

## 🔒 Security Testing

### Authentication Security

**Test Scenarios**:
1. Test token storage security
2. Verify token refresh mechanism
3. Test session timeout
4. Test unauthorized access attempts

**Expected Results**:
- Tokens are stored securely
- Refresh mechanism works
- Unauthorized access is blocked
- Session management is secure

### Data Security

**Test Scenarios**:
1. Verify sensitive data is not logged
2. Test input validation
3. Test API error handling
4. Verify secure communication

**Expected Results**:
- No sensitive data in logs
- Input validation prevents attacks
- API errors don't expose sensitive info
- HTTPS communication is enforced

## 📱 Device Testing

### Platform Testing

**Test Devices**:
- iOS devices (iPhone, iPad)
- Android devices (various screen sizes)
- Web browser (if applicable)

**Test Scenarios**:
1. App installation and launch
2. Screen rotation handling
3. Different screen sizes
4. Platform-specific features

### Accessibility Testing

**Test Scenarios**:
1. Screen reader compatibility
2. High contrast mode
3. Font size scaling
4. Touch target sizes

**Expected Results**:
- App is accessible to users with disabilities
- All features work with assistive technologies
- UI elements are properly sized and labeled

## 🚀 Release Testing

### Pre-Release Checklist

- [ ] All smoke tests pass
- [ ] No critical bugs open
- [ ] Performance benchmarks met
- [ ] Security testing completed
- [ ] Device testing completed
- [ ] Documentation updated
- [ ] Release notes prepared

### Post-Release Monitoring

- [ ] Monitor crash reports
- [ ] Track user feedback
- [ ] Monitor API performance
- [ ] Check error rates
- [ ] Verify analytics data

## 📞 Support Contacts

For technical issues:
- Development Team: [Contact Info]
- API Support: [Contact Info]
- QA Team: [Contact Info]

For user support:
- Customer Support: [Contact Info]
- Documentation: [Link to docs]

---

**Last Updated**: December 19, 2024
**Version**: 2.0.0
**QA Lead**: [Name]
