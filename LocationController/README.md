# LocationController

A [singleton](http://en.wikipedia.org/wiki/Singleton_pattern) for handling `CLLocationManager` throughout your app.  This instantiates `CLLocationManager` as a class property and handles its delegate methods.  It emits a notification when the location changes.
