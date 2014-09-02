//
//  FetchedResultsControllerDataSource.m
//  Here
//
//  Created by Noah Portes Chaikin on 9/1/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import "FetchedResultsControllerDataSource.h"

@interface FetchedResultsControllerDataSource ()
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (strong, nonatomic) NSString *reuseIdentifier;
@end

@implementation FetchedResultsControllerDataSource

- (id)initWithTableView:(UITableView *)tableView fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super init]) {
        self.tableView = tableView;
        self.fetchedResultsController = fetchedResultsController;
        self.reuseIdentifier = reuseIdentifier;
    }
    return self;
}

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    _tableView.dataSource = self;
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController {
    _fetchedResultsController = fetchedResultsController;
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:NULL];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[sectionIndex];
    return section.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    id cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier];
    [self.delegate configureCell:cell withObject:object];
    return cell;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath
                                   toIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
}

@end
