Pure dart form validation and sanitization

## Validation

You could use `validate` extensions method on any value to convert it to validatable field:

Validation is identical to Flutter concept: if value is valid, validator should return null. Otherwise - error text:
```dart
final refield = refield("@my_username").validate(
  (v) => v.length >= 10 
    ? null 
    : "Username should be at least 10 characters"
);

refield.displayError // Username should be at least 10 characters
refield.isValid // false
refield.value // @my_username
```

## Sanitization

Sanitization comes in handy, when you apply formatting to your fields:
```dart
/// Note: `normalizerFunction` and `phoneValidatorFunction` are user-defined functions. 
/// You could code your own or use package from pub.dev
final phoneField = refield("+1 (323) 888-88-88")
  .sanitize((v) => normalizerFunction(v))
  .validate((v) => phoneValidatorFunction());

phoneField.originalValue // +1 (323) 888-88-88
phoneField.sanitizedValue // +13238888888
phoneField.isValid // true
```

If validation fails, sanitized value cannot be retrieved:
```dart
phoneField.isValid // false
phoneField.originalValue // +1 (323) 888-88-88
phoneField.sanitizedValue // throws StateError
```

## `Reform` utility class
There is a convinience class to validate several fields:
```dart
final isFormValid = Reform.isValid([firstNameField, lastNameField, emailField]); 

isFormValid // true
```