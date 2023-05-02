Form library for Flutter, offering controlled inputs, user-friendly validation and more.

## Features

Define your fields as usual:
```dart
class Form {
    final String username;
    final String password;
    final String repeatPassword;

    final bool wasEverSubmitted; // user tried to submit
    
    ...
}
```

Add field validation:
```dart
class Form {
  final String username;
  final String password;
  final String repeatPassword;
  
  Form({
    required this.username,
    required this.password,
    required this.repeatPassword,
  });

  late final usernameField = refield(username).validate((value) {
    if (value.length < 8) {
      return "Min 8 chars";
    } else if (value.length > 16) {
      return "Max 16 chars";
    } else if (isAlphanumeric(value)) {
      return "Only numbers and letters";
    }
    return null;
  });

  late final passwordField = refield(password).validate(
    (value) => value.length < 8 ? "At least 8 characters" : null,
  );

  late final repeatPasswordField = refield(repeatPassword).validate(
    (value) => value != password ? "Passwords should match" : null,
  );
}
```

Wrap your Flutter `TextField`s:
```dart
Widget build(BuildContext context) {
  final form = FormViewModel.of(context).form;
  return Column(
    children: [
      form.usernameField.builder(
        builder: (context, controller, errorText) => TextField(
          controller: controller, // provide controller
          decoration: InputDecoration(errorText: errorText),
          onChanged: formViewModel.onUsernameChanged, // formViewModel - is your state management instance. It could be ChangeNotifier, Cubit e.t.c.
        ),
      ),
      form.passwordField.builder(
        builder: (context, controller, errorText) => TextField(
          controller: controller,
          decoration: InputDecoration(errorText: errorText),
          onChanged: formViewModel.onPasswordChanged,
        ),
      ),
      form.repeatPasswordField.builder(
        builder: (context, controller, errorText) => TextField(
          controller: controller,
          decoration: InputDecoration(errorText: errorText),
          onChanged: formViewModel.onRepeatPasswordChanged,
        ),
      ),
    ]
  );
}
```
**Now it just works**!

## Adjust moment errors appear

It's not very practical and user-friendly to show errors as user types.
Let's change it with `ReformScope`!

Wrap your widget tree with `ReformScope` like that:

```dart
Widget build(BuildContext context) {
  return ReformScope(
    // example for Provider's `context.watch` 
    shouldShowError: (context, fieldState) => FormViewModel.of(context).wasEverSubmitted || fieldState.wasEverUnfocused,
    child: ... // your `Widget` with fields
  );
} 
```

Now error will become visible once:
* User submits your form. Since this moment it's appropriate to show errors as user types
* Field is unfocused after it was focused for the first time. It's appropriate to show user an error, once they finished typing.

## Handle submission

Let's have a quick look at `ChangeNotifier` submission implementation:

```dart
class FormViewModel extends ChangeNotifier {
  void submit() {
    this.form = form.copyWith(wasEverSubmitted: true);
    notifyListeners();

    // utility class to help with validation of multiple fields
    final isValid = Reform.isValid([
      form.usernameField,
      form.passwordField,
      form.repeatPasswordField,
    ]);

    if (isValid) {
      // POST request to your server
    }
  }
}
```