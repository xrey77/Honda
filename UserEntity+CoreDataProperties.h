//
//  UserEntity+CoreDataProperties.h
//  Honda
//
//  Created by Reynald Marquez-Gragasin on 6/4/25.
//
//

#import "UserEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserEntity (CoreDataProperties)

+ (NSFetchRequest<UserEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *userid;
@property (nullable, nonatomic, copy) NSString *firstname;
@property (nullable, nonatomic, copy) NSString *lastname;
@property (nullable, nonatomic, copy) NSString *emailadd;
@property (nullable, nonatomic, copy) NSString *mobileno;
@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *role;
@property (nullable, nonatomic, copy) NSString *userpic;
@property (nullable, nonatomic, copy) NSDate *createdAt;
@property (nullable, nonatomic, copy) NSDate *updatedAt;

@end

NS_ASSUME_NONNULL_END
