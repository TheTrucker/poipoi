//
//  ADRouteIDTVC.m
//  BusEgor
//
//  Created by Александр Дудырев on 06.12.16.
//  Copyright © 2016 Александр Дудырев. All rights reserved.
//

#import "ADRouteIDTVC.h"
#import "ADServerManager.h"
#import "ADDetailTVC.h"



@interface ADRouteIDTVC ()
@property (strong, nonatomic) NSArray* arrayWithAllBus;

@property (strong, nonatomic) NSArray* searchArray;
@property (strong, nonatomic) NSMutableArray* resultArray;
@property (strong, nonatomic) NSMutableArray* checkMarkArray;

@property (strong, nonatomic) NSString* searchText;



@property (weak, nonatomic) ADDetailTVC* detailTVC;

@property (assign, nonatomic) NSInteger indexPathRow;

@end


@implementation ADRouteIDTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.arrayWithAllBus = [NSArray array];
    self.resultArray = [NSMutableArray array];

    UIBarButtonItem* bbItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                            target:self
                                                                            action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = bbItem;
    
    [[ADServerManager sharedManager] addObserver:self forKeyPath:@"resultArray" options:NSKeyValueObservingOptionNew context:nil];

}

- (void) viewWillAppear:(BOOL)animated {

    [self.tableView reloadData];
    
    self.detailTVC = nil; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) dealloc {

}

#pragma mark - PrivateMethod

- (void) refreshData {

    [[ADServerManager sharedManager] getAllBusWithBlock:nil];
    
}

- (UITableViewCell*) configureCell:(UITableViewCell*) cell forIndexPath:(NSIndexPath*) indexPath {
    
    ADTempArray* tArray = [self.resultArray objectAtIndex:indexPath.row - 1];

    cell.textLabel.text = tArray.nameArray;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", [tArray.tempArray count]];

    return cell;
}

- (void) searchGovermentNumber:(NSString*) searchText {
    
    if (!searchText || [searchText isEqualToString:@""]) {
        
        self.resultArray = [NSMutableArray arrayWithArray:self.arrayWithAllBus];
        [self.tableView reloadData];
        
        return;
    }
    
    [self.resultArray removeAllObjects];
    
    for (ADTempArray* tempArray in self.arrayWithAllBus) {
        
        NSMutableArray* mArray = [NSMutableArray array];

        for (ADBus* bus in tempArray.tempArray) {
            if ([bus busContainString:searchText]) {
                [mArray addObject:bus];
            }
        }
        if ([mArray count] || [tempArray.nameArray containsString:searchText]) {
            ADTempArray* tArray = [[ADTempArray alloc] initWithArray:mArray];
            tArray.nameArray = tempArray.nameArray;
            [self.resultArray addObject:tArray];
        }
    }
    [self.tableView reloadData];
}


#pragma mark - Observer

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                        context:(void *)context {
    NSLog(@"%@ observed", [self class]);
    
    NSArray* array = [NSArray arrayWithArray:[change objectForKey:@"new"]];
    self.arrayWithAllBus = array;
    
    
    if ([self.arrayWithAllBus count]) {
        
        [self searchGovermentNumber:self.searchText];
        [self.tableView reloadData];
        
        if (self.detailTVC) {
            ADTempArray* tempArray = [self.resultArray objectAtIndex:self.indexPathRow];
            [self.detailTVC newDataForTable:tempArray];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.resultArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"CellForRouteID";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    if (!indexPath.row) {
        
        NSInteger count = [[[ADServerManager sharedManager] arrayForGETRequest] count];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", count];
        cell.textLabel.text = @"Current bus";
        
        return cell;
    }
    
    if ([self.resultArray count]) {
        [self configureCell:cell forIndexPath:indexPath];
    }

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    if ([self.searchBarOutlet isFirstResponder]) {
        [self.searchBarOutlet resignFirstResponder];
    }

    ADDetailTVC* detailTVC = nil;
    
    if (!indexPath.row) {
        
        NSMutableArray* mArray = [[ADServerManager sharedManager] arrayForGETRequest];
        
        if ([mArray count]) {
            detailTVC = [[ADDetailTVC alloc] initWithCurrentBusArray:mArray];
            [self.navigationController pushViewController:detailTVC animated:YES];
        }

    } else {
        
        ADTempArray* tempArray = [self.resultArray objectAtIndex:indexPath.row - 1];
        if ([tempArray.tempArray count]) {
            detailTVC = [[ADDetailTVC alloc] initWithADTempArray:tempArray];
            
            self.indexPathRow = indexPath.row - 1;
            self.detailTVC = detailTVC;
            [self.navigationController pushViewController:detailTVC animated:YES];
        }
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    self.searchText = [searchText uppercaseString];
    
    if ([self.arrayWithAllBus count]) {
        [self searchGovermentNumber:self.searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    searchBar.text = nil;
    self.searchText = @"";
    
    [self searchGovermentNumber:self.searchText];
    [self.tableView reloadData];
}




@end
