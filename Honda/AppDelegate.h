//
//  AppDelegate.h
//  Honda
//
//  Created by Reynald Marquez-Gragasin on 6/4/25.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

