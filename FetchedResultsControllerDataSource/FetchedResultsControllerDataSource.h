//
//  FetchedResultsControllerDataSource.h
//  Here
//
//  Created by Noah Portes Chaikin on 9/1/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol FetchedResultsControllerDataSourceDelegate

- (void)configureCell:(id)cell withObject:(id)object;

@end

@interface FetchedResultsControllerDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, weak) id<FetchedResultsControllerDataSourceDelegate> delegate;
@property (strong, nonatomic) NSString *reuseIdentifier;

- (id)initWithTableView:(UITableView *)tableView;

@end
