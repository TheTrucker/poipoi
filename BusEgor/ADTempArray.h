//
//  ADTempArray.h
//  BusEgor
//
//  Created by Александр Дудырев on 06.12.16.
//  Copyright © 2016 Александр Дудырев. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface ADTempArray : NSObject

@property (strong, nonatomic) NSArray* tempArray;
@property (strong, nonatomic) NSString* nameArray;

- (instancetype)init;
- (instancetype)initWithArray:(NSArray*) array;

- (void) copyObject:(ADTempArray*) object;





@end
