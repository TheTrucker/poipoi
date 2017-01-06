//
//  ADDetailTVC.h
//  BusEgor
//
//  Created by Александр Дудырев on 06.12.16.
//  Copyright © 2016 Александр Дудырев. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADTempArray;

@interface ADDetailTVC : UITableViewController

- (instancetype)initWithCurrentBusArray:(NSArray*) array;
- (instancetype)initWithADTempArray:(ADTempArray*) array;

- (void) newDataForTable:(ADTempArray*) array;

@end
