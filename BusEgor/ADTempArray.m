//
//  ADTempArray.m
//  BusEgor
//
//  Created by Александр Дудырев on 06.12.16.
//  Copyright © 2016 Александр Дудырев. All rights reserved.
//

#import "ADTempArray.h"

@implementation ADTempArray

- (instancetype)init {
    self = [super init];
    if (self) {
        _tempArray = [NSArray array];
    }
    return self;
}

- (instancetype)initWithArray:(NSArray*) array {
    self = [super init];
    if (self) {
        _tempArray = [NSArray arrayWithArray:array];
    }
    return self;
}

- (void) copyObject:(ADTempArray*) object; {
    
    self.tempArray = object.tempArray;
    self.nameArray = object.nameArray;
    
}

@end
