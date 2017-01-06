//
//  ADDetailTVC.m
//  BusEgor
//
//  Created by Александр Дудырев on 06.12.16.
//  Copyright © 2016 Александр Дудырев. All rights reserved.
//

#import "ADDetailTVC.h"
#import "ADServerManager.h"
#import "ADMapViewController.h"

@interface ADDetailTVC ()

@property (strong, nonatomic) NSArray* array;
@property (strong, nonatomic) NSMutableArray* checkMarkArray;
@property (strong, nonatomic) NSString* currentTitle;
@property (assign, nonatomic) BOOL isWithCurrentBusController;

@end

@implementation ADDetailTVC

- (instancetype)initWithCurrentBusArray:(NSArray*) array {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.array = [NSArray arrayWithArray:array];
        self.currentTitle = @"Currents bus";
        self.isWithCurrentBusController = YES;
    }
    return self;
}

- (instancetype)initWithADTempArray:(ADTempArray*) tempArray {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.array = [NSArray arrayWithArray:tempArray.tempArray];
        self.currentTitle = tempArray.nameArray;
        self.isWithCurrentBusController = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.checkMarkArray = [[ADServerManager sharedManager] arrayForGETRequest];
    
    UIBarButtonItem* bbItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                            target:self
                                                                            action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = bbItem;
    
    self.navigationItem.title = [NSString stringWithFormat:@"Detail for %@", self.currentTitle];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - PrivateMethod

- (void) refreshData {

    if (self.isWithCurrentBusController) {
        NSMutableArray* array = [[ADServerManager sharedManager] arrayForGETRequest];
        self.array = [NSArray arrayWithArray:array];
        
        [self.tableView reloadData];
    }
}

- (void) newDataForTable:(ADTempArray*) array {
    
    self.array = array.tempArray;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.array count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"CellForDetail";

    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    
    ADBus* bus = [self.array objectAtIndex:indexPath.row];
    
    NSString* stringWithNumber = [NSString stringWithFormat:@"%ld. Гос.Номер:%@", indexPath.row + 1, bus.gosNom];
    cell.textLabel.text = stringWithNumber;
    
    for (ADBus* busInArray in self.checkMarkArray) {
        
        if ([bus.gosNom isEqualToString:busInArray.gosNom]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    ADBus* bus = [self.array objectAtIndex:indexPath.row];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        for (ADBus* busInArray in self.checkMarkArray) {
            if ([bus.gosNom isEqualToString:busInArray.gosNom]) {
                [self.checkMarkArray removeObject:busInArray];
                break;
            }
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.checkMarkArray addObject:bus];
    }
    
    
    
    
//    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    ADMapViewController* mapVC = [story instantiateViewControllerWithIdentifier:@"ADMapViewController"];
//    
//    if(!indexPath.row) {
//        
//        mapVC.arrayWithOneRouteID = self.array;
//        
//    } else {
//        
//        ADBus* bus = [self.array objectAtIndex:indexPath.row - 1];
//        mapVC.bus = bus;
//    }
//    mapVC.routeID = self.currentTitle;
//    
//    [self.navigationController pushViewController:mapVC animated:YES];
 
}

@end
