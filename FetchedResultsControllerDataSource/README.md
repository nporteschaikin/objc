# FetchedResultsControllerDataSource

In a Core Data application, this separates the `UITableViewDataSource` part of your view controller into its own class and handles populating and updating a table view with Core Data records.

### Usage

1. In your `UITableViewController`, import `FetchedResultsControllerDataSource.h`.  For the sake of clarity, I also import Core Data (it's already imported in the aforementioned file):
2. Add `FetchedResultsControllerDataSourceDelegate` as a class protocol (includes `configureCell:withObject` method to be part of the `UITableViewController` class):
3. Add `fetchedResultsControllerDataSource` as a property.
4. Add this to `viewDidLoad` (replace the argument values appropriately):

  ```objective-c
  NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                             managedObjectContext:managedObjectContext
                                                                                               sectionNameKeyPath:sectionNameKeyPath
                                                                                                        cacheName:cacheName];
  self.fetchedResultsControllerDataSource = [[FetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
  self.fetchedResultsControllerDataSource.reuseIdentifier = reuseIdentifier;
  self.fetchedResultsControllerDataSource.fetchedResultsController = fetchedResultsController;
  self.fetchedResultsControllerDataSource.delegate = self;
  ```

5. Write a `configureCell:withObject` method.
6. Profit.

### Credit

Issue 4 of [objc](http://www.objc.io/issue-4/full-core-data-application.html).
