//
//  UserEntity+CoreDataProperties.m
//  Honda
//
//  Created by Reynald Marquez-Gragasin on 6/4/25.
//
//

#import "UserEntity+CoreDataProperties.h"

@implementation UserEntity (CoreDataProperties)

+ (NSFetchRequest<UserEntity *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"UserEntity"];
}

@dynamic userid;
@dynamic firstname;
@dynamic lastname;
@dynamic emailadd;
@dynamic mobileno;
@dynamic username;
@dynamic password;
@dynamic role;
@dynamic userpic;
@dynamic createdAt;
@dynamic updatedAt;

@end
