# CoreDataManager

By default, Xcode chooses to instantiate Core Data's components in `AppDelegate`.  This means, in order to use these components in other places, one must either:

- **Use dependency injection.** Apple's docs cite dependency injection as the preferred convention, but this is inflexible and repetitive, or
- **Use `[UIApplication delegate] to access AppDelegate.**  Housing global references isn't the intended purpose of AppDelegate ([separation of concerns](http://en.wikipedia.org/wiki/Separation_of_concerns)).

Here, Core Data is extracted into a [singleton](http://en.wikipedia.org/wiki/Singleton_pattern) class.  

- Core Data's shared components (persistent store coordinator, managed object model, managed object context) are instantiated on first call.
- This includes a few helper methods which simplify selecting and inserting entities.

### Usage

See [CoreDataManager/CoreDataManager.h](CoreDataManager/CoreDataManager.h).
