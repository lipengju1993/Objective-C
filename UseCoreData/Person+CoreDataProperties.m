//
//  Person+CoreDataProperties.m
//  UseCoreData
//
//  Created by lipengju on 2019/12/3.
//  Copyright © 2019 lipengju. All rights reserved.
//
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Person"];
}

@dynamic name;
@dynamic age;

@end
