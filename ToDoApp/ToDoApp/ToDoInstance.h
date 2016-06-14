//
//  ToDoInstance.h
//  ToDoApp
//
//  Created by Matthew Harrison on 6/13/16.
//  Copyright © 2016 Matthew Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoInstance : NSObject

@property(nonatomic,strong) NSString *ToDoName;
@property(nonatomic,strong) NSString *ToDoDate;
@property(nonatomic,strong) NSString *ToDoLocation;
@property(nonatomic,strong) NSString *ToDoDescription;

@end
