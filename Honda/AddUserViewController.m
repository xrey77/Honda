//
//  AddUserViewController.m
//  Honda
//
//  Created by Reynald Marquez-Gragasin on 6/4/25.
//

#import "AddUserViewController.h"
#import "AppDelegate.h"
#import "UserEntity+CoreDataClass.h"
@import UniformTypeIdentifiers;

@interface AddUserViewController () {
    AppDelegate *xappDelegate;
}
@end


@implementation AddUserViewController
@synthesize firstName,lastName,emailAddress,mobileNo,userName,passWord,heading,addBtnImage,barButtonItemsRight,addView,xMark,saveButton;
@synthesize tableView, managedObjectContext, managedObjectModel, persistentStoreCoordinator, users, container,fname,lname, objSet, userId,userID;
@synthesize txt1,txt2,txt3,txt4,txt5,txt6,txt7,searchBtnImage, searchButton, searchBar, previewBtnImage, closePDFPreview, printerImage;
@synthesize pdfView, pdfDocument, pdfImage, documentController;
@synthesize dataContent, filemanager, docsDir, mobile, email, icloudBtnImage;
@synthesize context;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blueColor;

//    filemanager = [NSFileManager defaultManager];
//    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    docsDir = dirPaths[0];

    pdfDocument = [[PDFDocument alloc] init];
    pdfView = [[PDFView alloc] init];

    xappDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = xappDelegate.persistentContainer.viewContext;

    icloudBtnImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"link.icloud"] style:UIBarButtonItemStylePlain target:self action:@selector(getIcloudData:)];
    
    addBtnImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapAddButton:)];

    searchBtnImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"magnifyingglass"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapSearchButton:)];

    previewBtnImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"doc.text.magnifyingglass"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapPreviewButton:)];

    
    barButtonItemsRight = [[NSArray alloc] initWithObjects: addBtnImage,searchBtnImage, previewBtnImage,icloudBtnImage,nil];
    self.navigationItem.rightBarButtonItems = barButtonItemsRight;
    
    self->users = [[NSMutableArray alloc] init];
    self->tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];
    [self.view addSubview:self->tableView];
    [self->tableView setDelegate:self];
    [self->tableView setDataSource:self];
    self->userId = [[NSMutableArray alloc] init];
    self->fname = [[NSMutableArray alloc] init];
    self->lname = [[NSMutableArray alloc] init];
    self->email = [[NSMutableArray alloc] init];
    self->mobile = [[NSMutableArray alloc] init];

    [self->tableView reloadData];
    
    searchBar = [UISearchBar new];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 44.0)];
    searchBar.placeholder = @"search Last Name";
    [searchBar setShowsCancelButton:YES];
    [searchBar setShowsCancelButton:true animated:true];
    searchBar.autocorrectionType = false;
    searchBar.autocapitalizationType = false;
    [searchBar sizeToFit];
    [self fetchUser];
}

///ACTIVATE SEARCH BAR DELEGATE (important)
- (void)viewWillAppear:(BOOL)animated {
    searchBar.delegate = self;
    searchBar.userInteractionEnabled=YES;
    [searchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = false;
    self.navigationItem.titleView = nil;
    addBtnImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapAddButton:)];
    searchBtnImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"magnifyingglass"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapSearchButton:)];

    previewBtnImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"doc.text.magnifyingglass"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapPreviewButton:)];

    barButtonItemsRight = [[NSArray alloc] initWithObjects: addBtnImage, searchBtnImage, previewBtnImage, nil];
    self.navigationItem.rightBarButtonItems = barButtonItemsRight;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {

        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserEntity"];
         request.predicate = [NSPredicate predicateWithFormat:@"lastname contains[c] %@", searchText];
        [userId removeAllObjects];
        [fname removeAllObjects];
        [lname removeAllObjects];

        NSArray *results = [context executeFetchRequest:request error:nil];
        if (results.count > 0) {
            for (NSArray  *key in results) {
                [self->userId addObject: [key valueForKey:@"userid"]];
                [self->fname addObject: [key valueForKey:@"firstname"]];
                [self->lname addObject: [key valueForKey:@"lastname"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });


        }
        results = nil;
        request = nil;
    } else {
        [userId removeAllObjects];
        [fname removeAllObjects];
        [lname removeAllObjects];
        [self fetchUser];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    }
}

//SEARCH ICON
-(void)didTapSearchButton:(UIBarButtonItem*)item{
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.titleView = searchBar;
    [searchBar setShowsCancelButton:YES];
    searchBar.searchResultsButtonSelected = true;
    searchBar.showsSearchResultsButton = true;
    [searchBar setNeedsFocusUpdate];
    [searchBar resignFirstResponder];
}

//PDF PREVIEW
- (void)didTapPreviewButton:(UIBarButtonItem*)item{
    
    closePDFPreview = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"xmark.square"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapCloseButton:)];
    
    printerImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"printer.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapPrinterButton:)];

    self.navigationItem.rightBarButtonItems = nil;
    barButtonItemsRight = [[NSArray alloc] initWithObjects: closePDFPreview, printerImage, nil];
    self.navigationItem.rightBarButtonItems = barButtonItemsRight;
    [self printPreview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self->fname count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
           cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
       }

    NSString *row1 = self->fname[indexPath.row];
    NSString *row2 = @" ";
    NSString *row3 = self->lname[indexPath.row];
    NSString *row4 = [row1 stringByAppendingString:row2];
    
    cell.textLabel.text = [row4 stringByAppendingString:row3];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated: false];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.txt1 = self.fname[indexPath.row];
    self.txt2 = self.lname[indexPath.row];
    self.txt7 = self.userId[indexPath.row];
    [self editUser];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
            //remove the deleted object from your data source.
            //If your data source is an NSMutableArray, do this
            [self.fname removeObjectAtIndex:indexPath.row];
            self.userID = self.userId[indexPath.row];
            [self deleteUser: self.userId[indexPath.row]];
            [tableView reloadData]; // tell table to refresh now
    }
}

-(void)didTapAddButton:(UIBarButtonItem*)item{
    addView = [[UIView alloc] init];
    addView.frame = CGRectMake(30, 90, self.view.frame.size.width-60, self.view.frame.size.height-210);
    addView.backgroundColor = UIColor.redColor;
    addView.layer.borderColor = UIColor.systemRedColor.CGColor;
    addView.layer.masksToBounds = true;
    addView.clipsToBounds = true;
    addView.layer.cornerRadius = 25;
    addView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    [self.view addSubview:addView];

    heading = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, self.view.frame.size.width-60, 40))];
    heading.text = @"User's Core Data";
    heading.backgroundColor = UIColor.grayColor;
    heading.textColor = UIColor.whiteColor;
    heading.textAlignment = NSTextAlignmentCenter;
    heading.font = [UIFont fontWithName:@"Arial" size:20];
    [self.addView addSubview:heading];
    
    xMark = [[UIImageView alloc]initWithFrame:CGRectMake(self.heading.frame.size.width-35,10,25, 25)];
    xMark.image = [UIImage systemImageNamed:@"multiply.square"];
    xMark.userInteractionEnabled = true;
    UITapGestureRecognizer *tapCloseGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(closeEntry:)];
    tapCloseGesture.numberOfTapsRequired = 1;
    [tapCloseGesture setDelegate:nil];
    [xMark addGestureRecognizer:tapCloseGesture];
    xMark.backgroundColor = UIColor.clearColor;
    xMark.tintColor = UIColor.whiteColor;
    [self.addView addSubview:xMark];
    
    firstName = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, 280, 40)];
    firstName.borderStyle = UITextBorderStyleRoundedRect;
    firstName.returnKeyType = UIReturnKeyDone;
    firstName.autocapitalizationType = false;
    firstName.placeholder = @"enter your First Name";
    [self.addView addSubview:firstName];

    lastName = [[UITextField alloc] initWithFrame:CGRectMake(20, 110, 280, 40)];
    lastName.borderStyle = UITextBorderStyleRoundedRect;
    lastName.returnKeyType = UIReturnKeyDone;
    lastName.autocapitalizationType = false;
    lastName.placeholder = @"enter your Last Name";
    [self.addView addSubview:lastName];

    emailAddress = [[UITextField alloc] initWithFrame:CGRectMake(20, 160, 280, 40)];
    emailAddress.borderStyle = UITextBorderStyleRoundedRect;
    emailAddress.returnKeyType = UIReturnKeyDone;
    emailAddress.autocapitalizationType = false;
    emailAddress.placeholder = @"enter your Email Address";
    [self.addView addSubview:emailAddress];

    mobileNo = [[UITextField alloc] initWithFrame:CGRectMake(20, 210, 280, 40)];
    mobileNo.borderStyle = UITextBorderStyleRoundedRect;
    mobileNo.autocapitalizationType = false;
    mobileNo.returnKeyType = UIReturnKeyDone;
    mobileNo.placeholder = @"enter your Mobile No.";
    [self.addView addSubview:mobileNo];

    userName = [[UITextField alloc] initWithFrame:CGRectMake(20, 260, 280, 40)];
    userName.borderStyle = UITextBorderStyleRoundedRect;
    userName.returnKeyType = UIReturnKeyDone;
    userName.autocapitalizationType = false;
    userName.placeholder = @"enter Username";
    [self.addView addSubview:userName];

    passWord = [[UITextField alloc] initWithFrame:CGRectMake(20, 310, 280, 40)];
    passWord.borderStyle = UITextBorderStyleRoundedRect;
    passWord.returnKeyType = UIReturnKeyDone;
    passWord.placeholder = @"enter Password";
    passWord.autocapitalizationType = false;
    passWord.secureTextEntry = true;
    [self.addView addSubview:passWord];
    
    saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveButton addTarget:self action:@selector(didSavebuttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setFrame:CGRectMake(50, 360, 220, 40)];
    [saveButton setTitle:@"save entry" forState:UIControlStateNormal];
    [saveButton setExclusiveTouch:true];
    saveButton.backgroundColor = UIColor.blueColor;
    saveButton.tintColor = UIColor.whiteColor;
    saveButton.layer.cornerRadius = 20;
    saveButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:22];
    [self.addView addSubview:saveButton];
}

-(void)editUser {
    [self getUser:self.txt7];
    addView = [[UIView alloc] init];
    addView.frame = CGRectMake(30, 90, self.view.frame.size.width-60, self.view.frame.size.height-210);
    addView.backgroundColor = UIColor.redColor;
    addView.layer.borderColor = UIColor.systemRedColor.CGColor;
    addView.layer.masksToBounds = true;
    addView.clipsToBounds = true;
    addView.layer.cornerRadius = 25;
    addView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    [self.view addSubview:addView];

    heading = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, self.view.frame.size.width-60, 40))];
    heading.text = @"Update User's Data";
    heading.backgroundColor = UIColor.grayColor;
    heading.textColor = UIColor.whiteColor;
    heading.textAlignment = NSTextAlignmentCenter;
    heading.font = [UIFont fontWithName:@"Arial" size:20];
    [self.addView addSubview:heading];
    
    xMark = [[UIImageView alloc]initWithFrame:CGRectMake(self.heading.frame.size.width-35,10,25, 25)];
    xMark.image = [UIImage systemImageNamed:@"multiply.square"];
    xMark.userInteractionEnabled = true;
    UITapGestureRecognizer *tapCloseGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(closeEntry:)];
    tapCloseGesture.numberOfTapsRequired = 1;
    [tapCloseGesture setDelegate:nil];
    [xMark addGestureRecognizer:tapCloseGesture];
    xMark.backgroundColor = UIColor.clearColor;
    xMark.tintColor = UIColor.whiteColor;
    [self.addView addSubview:xMark];
    
    firstName = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, 280, 40)];
    firstName.borderStyle = UITextBorderStyleRoundedRect;
    firstName.returnKeyType = UIReturnKeyDone;
    firstName.text = self.txt1;
    firstName.autocapitalizationType = false;
    [self.addView addSubview:firstName];

    lastName = [[UITextField alloc] initWithFrame:CGRectMake(20, 110, 280, 40)];
    lastName.borderStyle = UITextBorderStyleRoundedRect;
    lastName.returnKeyType = UIReturnKeyDone;
    lastName.text = self.txt2;
    lastName.autocapitalizationType = false;
    [self.addView addSubview:lastName];

    emailAddress = [[UITextField alloc] initWithFrame:CGRectMake(20, 160, 280, 40)];
    emailAddress.borderStyle = UITextBorderStyleRoundedRect;
    emailAddress.returnKeyType = UIReturnKeyDone;
    emailAddress.text = self.txt3;
    emailAddress.autocapitalizationType = false;
    emailAddress.enabled = false;
    [self.addView addSubview:emailAddress];

    mobileNo = [[UITextField alloc] initWithFrame:CGRectMake(20, 210, 280, 40)];
    mobileNo.borderStyle = UITextBorderStyleRoundedRect;
    mobileNo.autocapitalizationType = false;
    mobileNo.text = self.txt4;
    mobileNo.returnKeyType = UIReturnKeyDone;
    [self.addView addSubview:mobileNo];

    userName = [[UITextField alloc] initWithFrame:CGRectMake(20, 260, 280, 40)];
    userName.borderStyle = UITextBorderStyleRoundedRect;
    userName.returnKeyType = UIReturnKeyDone;
    userName.autocapitalizationType = false;
    userName.text = self.txt5;
    [self.addView addSubview:userName];

    passWord = [[UITextField alloc] initWithFrame:CGRectMake(20, 310, 280, 40)];
    passWord.borderStyle = UITextBorderStyleRoundedRect;
    passWord.returnKeyType = UIReturnKeyDone;
    passWord.autocapitalizationType = false;
    passWord.secureTextEntry = true;
    passWord.text = self.txt5;
    [self.addView addSubview:passWord];
    
    saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveButton addTarget:self action:@selector(didUpdateTapped:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setFrame:CGRectMake(50, 360, 220, 40)];
    [saveButton setTitle:@"update" forState:UIControlStateNormal];
    [saveButton setExclusiveTouch:true];
    saveButton.backgroundColor = UIColor.blueColor;
    saveButton.tintColor = UIColor.whiteColor;
    saveButton.layer.cornerRadius = 20;
    saveButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:22];
    [self.addView addSubview:saveButton];
}

-(void)closeEntry: (id)sender {
    [self.addView removeFromSuperview];
    [self->tableView reloadData];
}

-(void)didSavebuttonTapped:(id)sender {

    NSUUID *uuid = [NSUUID UUID];
    NSString *strUUID = [uuid UUIDString];
    
    NSManagedObject *user = [NSEntityDescription insertNewObjectForEntityForName:@"UserEntity" inManagedObjectContext:context];
    [user setValue:firstName.text forKey:@"firstname"];
    [user setValue:lastName.text forKey:@"lastname"];
    [user setValue:emailAddress.text forKey:@"emailadd"];
    [user setValue:mobileNo.text forKey:@"mobileno"];
    [user setValue:userName.text forKey:@"username"];
    [user setValue:passWord.text forKey:@"password"];
    [user setValue:@"Admin" forKey:@"role"];
    [user setValue:strUUID forKey:@"userid"];
    [user setValue:@"user.png" forKey:@"userpic"];
    [user setValue:NSDate.now forKey:@"createdAt"];
    [user setValue:NSDate.now forKey:@"updatedAt"];
    [xappDelegate saveContext];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert Message!" message:@"New User added, continue?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self clearInput];
        return;
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    [self fetchUser];

}

-(void)didUpdateTapped:(id)sender {
    [self updateUser: self.txt7];
}

-(void)updateUser:(NSString *)param {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserEntity"];
     request.predicate = [NSPredicate predicateWithFormat:@"userid == %@", param];
     request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"userid" ascending:YES]];

     NSArray *results = [context executeFetchRequest:request error:nil];
    if (results.count > 0) {
        NSLog(@"%s", "found...");
        for (NSArray  *key in results) {
            [key setValue:firstName.text forKey:@"firstname"];
            [key setValue:lastName.text forKey:@"lastname"];
            [key setValue:mobileNo.text forKey:@"mobileno"];
        }
        [xappDelegate saveContext];
    } else {
        NSLog(@"%s", "not found...");
    }
    results = nil;
    request = nil;
}

//FETCH USERS DATA
-(void)fetchUser {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserEntity"];
    NSArray *results = [context executeFetchRequest:request error:nil];
    [userId removeAllObjects];
    [fname removeAllObjects];
    [lname removeAllObjects];
    [email removeAllObjects];
    [mobile removeAllObjects];


    for (NSArray  *key in results) {
//        NSLog(@"%@",[key valueForKey:@"firstname"]);
        [self->userId addObject: [key valueForKey:@"userid"]];
        [self->fname addObject: [key valueForKey:@"firstname"]];
        [self->lname addObject: [key valueForKey:@"lastname"]];
        [self->email addObject: [key valueForKey:@"emailadd"]];
        [self->mobile addObject: [key valueForKey:@"mobileno"]];

    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

//DELETE ALL USERS
-(IBAction)deleteAllRecords:(id)sender {
    NSError *error = nil;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"UserEntity"];
    request.includesPropertyValues = false;
    NSArray *deleteArray = [context executeFetchRequest:request error:&error];
        for (NSManagedObject* object in deleteArray)
        {
            
            [context deleteObject:object];
        }
        NSLog(@"%s","deleted...");
    
        [managedObjectContext save:&error];
}

//-(void)findLastname:(NSString *)param {
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserEntity"];
//     request.predicate = [NSPredicate predicateWithFormat:@"lastname == %@", param];
//     request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"userid" ascending:YES]];
//
//     NSArray *results = [context executeFetchRequest:request error:nil];
//    if (results.count > 0) {
////        NSLog(@"%s", "found...");
//        for (NSArray  *key in results) {
//            NSLog(@"%@",[key valueForKey:@"firstname"] );
//            NSLog(@"%@",[key valueForKey:@"lastname"] );
//            NSLog(@"%@",[key valueForKey:@"emailadd"] );
//            NSLog(@"%@",[key valueForKey:@"mobileno"] );
//            NSLog(@"%@",[key valueForKey:@"username"] );
//            NSLog(@"%@",[key valueForKey:@"password"] );
//            NSLog(@"%@",[key valueForKey:@"userpic"] );
//            NSLog(@"%@",[key valueForKey:@"role"] );
//        }
//
//    } else {
//        NSLog(@"%s", "not found...");
//    }
//    results = nil;
//    request = nil;
//
//}

//DELETE USER
-(void)deleteUser:(NSString *)param {
    
    NSError *error = nil;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"UserEntity"];
    request.predicate = [NSPredicate predicateWithFormat:@"userid == %@", param];
    request.includesPropertyValues = false;
    NSArray *deleteArray = [context executeFetchRequest:request error:&error];
    for (NSManagedObject* object in deleteArray)
    {
        [context deleteObject:object];
    }
    [context save:&error];
    request = nil;
}

-(void)getUser:(NSString *)param {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserEntity"];
     request.predicate = [NSPredicate predicateWithFormat:@"userid == %@", param];
     request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"userid" ascending:YES]];

     NSArray *results = [context executeFetchRequest:request error:nil];
    if (results.count > 0) {
        for (NSArray  *key in results) {
            self.txt3 = [key valueForKey:@"emailadd"];
            self.txt4 = [key valueForKey:@"mobileno"];
            self.txt5 = [key valueForKey:@"username"];
            self.txt6 = [key valueForKey:@"password"];
        }

    } else {
        NSLog(@"%s", "not found...");
    }
    results = nil;
    request = nil;

}

//CLEAR UITEXTFIELD AND STRINGS
-(void)clearInput {
    firstName.text = nil;
    lastName.text = nil;
    emailAddress.text = nil;
    mobileNo.text = nil;
    userName.text = nil;
    passWord.text = nil;
    txt1 = nil;
    txt2 = nil;
    txt3 = nil;
    txt4 = nil;
    txt5 = nil;
    txt6 = nil;
    txt7 = nil;
}

-(void)showSearchBarButton:(BOOL *)shouldShow {
    if (shouldShow) {
        searchBtnImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"doc.text.magnifyingglass"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapSearchButton:)];

        barButtonItemsRight = [[NSArray alloc] initWithObjects: addBtnImage,searchBtnImage, nil];
        self.navigationItem.rightBarButtonItems = barButtonItemsRight;
        return;
    }
    else
    {
        self.navigationItem.rightBarButtonItems = nil;

    }
}

-(void)didTapCloseButton:(id)sender{
    addBtnImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapAddButton:)];
    searchBtnImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"magnifyingglass"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapSearchButton:)];

    previewBtnImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"doc.text.magnifyingglass"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapPreviewButton:)];

    barButtonItemsRight = [[NSArray alloc] initWithObjects: addBtnImage, searchBtnImage, previewBtnImage, nil];
    self.navigationItem.rightBarButtonItems = barButtonItemsRight;
    [pdfView removeFromSuperview];
    
}


- (UIImage *)drawPDFfromURL:(CGPDFDocumentRef)documentRef {
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(documentRef, 1);
    CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFCropBox);

    UIGraphicsBeginImageContext(pageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, CGRectGetMinX(pageRect),CGRectGetMaxY(pageRect));
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, -(pageRect.origin.x), -(pageRect.origin.y));
    CGContextDrawPDFPage(context, pageRef);

    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}


    -(void)printPreview {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM-dd-yyyy HH:mm:ss a"];
        
        NSString *sub1 = @"As of ";
        NSString *sub2 = [dateFormatter stringFromDate:[NSDate date]];
        NSString *date = [sub1 stringByAppendingString:sub2];
        self->users = [[NSMutableArray alloc] initWithObjects:self->fname,self->lname, self->email,self->mobile, nil];
        
        NSString *htmlData = @"<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\">";
        htmlData = [htmlData stringByAppendingFormat:@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"];
        htmlData = [htmlData stringByAppendingFormat:@"<title>Objective-C Core Data Report</title></head><body>"];
        htmlData = [htmlData stringByAppendingFormat:@"<center><h3 style=\"margin-top:80px;\">User's Core Data Report</h3><h5 style=\"margin-top: -10px;\">"];

        htmlData = [htmlData stringByAppendingFormat:@"%s", date.UTF8String];
        
        htmlData = [htmlData stringByAppendingFormat:@"</h5><table style=\"margin-top: 50px;border-style:inset; border-width:thin\">"];
        htmlData = [htmlData stringByAppendingFormat:@"<thead style=\"background-color: lightgray;\">"];
        htmlData = [htmlData stringByAppendingFormat:@"<tr style=\"border-style:inset; border-width:thin\">"];
        htmlData = [htmlData stringByAppendingFormat:@"<td style=\"width: 50px;border-style:inset; border-width:thin\">#</th>"];
        htmlData = [htmlData stringByAppendingFormat:@"<td style=\"width: 150px;border-style:inset; border-width:thin\">Firstname</th>"];
        htmlData = [htmlData stringByAppendingFormat:@"<td style=\"width: 150px;border-style:inset; border-width:thin\">Lastname</th>"];
        htmlData = [htmlData stringByAppendingFormat:@"<td style=\"width: 200px;border-style:inset; border-width:thin\">Email Address</th>"];
        htmlData = [htmlData stringByAppendingFormat:@"<td style=\"width: 130px;border-style:inset; border-width:thin\">Mobile No.</th>\"</tr></thead><tbody>"];

        for (NSInteger idx = 0; idx < [self.users[0] count]; idx++)
        {
            htmlData = [htmlData stringByAppendingFormat:@"<tr><td style=\"width: 50px;border-style:inset; border-width:thin\">"]; //1</td>"];
            htmlData = [htmlData stringByAppendingFormat:@"%ld",(long)idx+1];
            
            htmlData = [htmlData stringByAppendingFormat:@"</td><td style=\"width: 150px;border-style:inset; border-width:thin\">"];

            htmlData = [htmlData stringByAppendingFormat:@"%@", self->users[0][idx]];
            
            htmlData = [htmlData stringByAppendingFormat:@"</td><td style=\"width: 150px;border-style:inset; border-width:thin\">"];
            
            htmlData = [htmlData stringByAppendingFormat:@"%@", self->users[1][idx]];
            
            htmlData = [htmlData stringByAppendingFormat:@"</td><td style=\"width: 200px;border-style:inset; border-width:thin\">"];
            
            htmlData = [htmlData stringByAppendingFormat:@"%@", self->users[2][idx]];

            htmlData = [htmlData stringByAppendingFormat:@"</td><td style=\"width: 130px;border-style:inset; border-width:thin\">"]; //23423</td></tr>"];

            htmlData = [htmlData stringByAppendingFormat:@"%@", self->users[3][idx]];

            htmlData = [htmlData stringByAppendingFormat:@"</td></tr>"];
        }
        htmlData = [htmlData stringByAppendingFormat:@"</tbody></table></center></body></html>"];
        
        UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
        render.headerHeight = 30.0f;
        render.footerHeight = 30.0f;

        UIMarkupTextPrintFormatter *htmlFormatter = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText: htmlData];
        htmlFormatter.startPage = 0;
        [render addPrintFormatter: htmlFormatter startingAtPageAtIndex: 0];
        
        //Assign Printable Rect
        CGRect page = CGRectMake(0, 0, 595.2, 841.8);// A4, 72 dpi
        [render setValue:[NSValue valueWithCGRect:page] forKey:@"paperRect"];
        [render setValue:[NSValue valueWithCGRect:page] forKey:@"printableRect"];

        //Create PDF Context and Draw
        NSMutableData* pdfData = [[NSMutableData alloc] init];
        UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, NULL);
        
        for (int i=0; i<render.numberOfPages; i++) {
            UIGraphicsBeginPDFPage();
            [render drawPageAtIndex:i inRect: UIGraphicsGetPDFContextBounds()];
        }
        
        UIGraphicsEndPDFContext();
                
        NSURL *fileURL = [[[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:true error:nil] URLByAppendingPathComponent:@"honda.pdf"];
        //WRITE PDF FILE
        [pdfData writeToURL:fileURL atomically:true ];

        //VIEW PDF FILE
        pdfView = [[PDFView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        pdfView.autoScales = true;
        [self.view addSubview:pdfView];
        PDFDocument *doc;
        doc = [[PDFDocument alloc] initWithURL:fileURL];
        pdfView.document = doc;
    }

//SEND TO PRINTER
-(void)didTapPrinterButton:(id)sender{
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Print View";
    
    UIPrintInteractionController *printerViewController = [UIPrintInteractionController sharedPrintController];
    printerViewController.printInfo = printInfo;
    printerViewController.printingItem = newImage;
    printerViewController.showsPaperSelectionForLoadedPapers = true;
        
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
      if (!completed && error) {
        NSLog(@"Printing could not complete because of error: %@", error);
      }
    };
    [printerViewController presentAnimated:YES completionHandler:completionHandler];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSURL *urlx = urls.firstObject;
    [urlx startAccessingSecurityScopedResource];
    [urlx stopAccessingSecurityScopedResource];
    NSLog(@"ICLOUDE PATH : %@",urlx);
}

/// DOCUMENTS
// Called whenever the application reads data from the file system
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    self.dataContent = [[NSData alloc] initWithBytes:[contents bytes] length:[contents length]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noteModified" object:self];
    return YES;
}

// Called whenever the application (auto)saves the content of a note
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    return self.dataContent;
}


- (void)getIcloudData:(id)sender {

    //--Get data back from iCloud --//
    id token = [[NSFileManager defaultManager] ubiquityIdentityToken];
    if (token == nil)
    {
        NSLog(@"ICloud Is not LogIn");
    }
    else
    {
        NSLog(@"ICloud Is LogIn");
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM-dd-yyyy HH:mm:ss a"];
        
        NSString *sub1 = @"As of ";
        NSString *sub2 = [dateFormatter stringFromDate:[NSDate date]];
        NSString *date = [sub1 stringByAppendingString:sub2];
        self->users = [[NSMutableArray alloc] initWithObjects:self->fname,self->lname, self->email,self->mobile, nil];
        
        NSString *htmlData = @"<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\">";
        htmlData = [htmlData stringByAppendingFormat:@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"];
        htmlData = [htmlData stringByAppendingFormat:@"<title>Objective-C Core Data Report</title></head><body>"];
        htmlData = [htmlData stringByAppendingFormat:@"<center><h3 style=\"margin-top:80px;\">User's Core Data Report</h3><h5 style=\"margin-top: -10px;\">"];

        htmlData = [htmlData stringByAppendingFormat:@"%s", date.UTF8String];
        
        htmlData = [htmlData stringByAppendingFormat:@"</h5><table style=\"margin-top: 50px;border-style:inset; border-width:thin\">"];
        htmlData = [htmlData stringByAppendingFormat:@"<thead style=\"background-color: lightgray;\">"];
        htmlData = [htmlData stringByAppendingFormat:@"<tr style=\"border-style:inset; border-width:thin\">"];
        htmlData = [htmlData stringByAppendingFormat:@"<td style=\"width: 50px;border-style:inset; border-width:thin\">#</th>"];
        htmlData = [htmlData stringByAppendingFormat:@"<td style=\"width: 150px;border-style:inset; border-width:thin\">Firstname</th>"];
        htmlData = [htmlData stringByAppendingFormat:@"<td style=\"width: 150px;border-style:inset; border-width:thin\">Lastname</th>"];
        htmlData = [htmlData stringByAppendingFormat:@"<td style=\"width: 200px;border-style:inset; border-width:thin\">Email Address</th>"];
        htmlData = [htmlData stringByAppendingFormat:@"<td style=\"width: 130px;border-style:inset; border-width:thin\">Mobile No.</th>\"</tr></thead><tbody>"];

        for (NSInteger idx = 0; idx < [self.users[0] count]; idx++)
        {
            htmlData = [htmlData stringByAppendingFormat:@"<tr><td style=\"width: 50px;border-style:inset; border-width:thin\">"]; //1</td>"];
            htmlData = [htmlData stringByAppendingFormat:@"%ld",(long)idx+1];
            
            htmlData = [htmlData stringByAppendingFormat:@"</td><td style=\"width: 150px;border-style:inset; border-width:thin\">"];

            htmlData = [htmlData stringByAppendingFormat:@"%@", self->users[0][idx]];
            
            htmlData = [htmlData stringByAppendingFormat:@"</td><td style=\"width: 150px;border-style:inset; border-width:thin\">"];
            
            htmlData = [htmlData stringByAppendingFormat:@"%@", self->users[1][idx]];
            
            htmlData = [htmlData stringByAppendingFormat:@"</td><td style=\"width: 200px;border-style:inset; border-width:thin\">"];
            
            htmlData = [htmlData stringByAppendingFormat:@"%@", self->users[2][idx]];

            htmlData = [htmlData stringByAppendingFormat:@"</td><td style=\"width: 130px;border-style:inset; border-width:thin\">"]; //23423</td></tr>"];

            htmlData = [htmlData stringByAppendingFormat:@"%@", self->users[3][idx]];

            htmlData = [htmlData stringByAppendingFormat:@"</td></tr>"];
        }
        htmlData = [htmlData stringByAppendingFormat:@"</tbody></table></center></body></html>"];
        
        UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
        render.headerHeight = 30.0f;
        render.footerHeight = 30.0f;

        UIMarkupTextPrintFormatter *htmlFormatter = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText: htmlData];
        htmlFormatter.startPage = 0;
        [render addPrintFormatter: htmlFormatter startingAtPageAtIndex: 0];
        
        //Assign Printable Rect
        CGRect page = CGRectMake(0, 0, 595.2, 841.8);// A4, 72 dpi
        [render setValue:[NSValue valueWithCGRect:page] forKey:@"paperRect"];
        [render setValue:[NSValue valueWithCGRect:page] forKey:@"printableRect"];

        //Create PDF Context and Draw
        NSMutableData* pdfData = [[NSMutableData alloc] init];
        UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, NULL);
        
        for (int i=0; i<render.numberOfPages; i++) {
            UIGraphicsBeginPDFPage();
            [render drawPageAtIndex:i inRect: UIGraphicsGetPDFContextBounds()];
        }
        
        UIGraphicsEndPDFContext();
                
        NSURL *fileURL = [[[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:true error:nil] URLByAppendingPathComponent:@"honda.pdf"];
        
        //WRITE PDF FILE
        [pdfData writeToURL:fileURL atomically:true ];
        
           NSURL *url = [[NSFileManager defaultManager]URLForUbiquityContainerIdentifier:@"com.Reynald-Gragasin.Honda"];
           [[[NSFileManager alloc]init]setUbiquitous:YES itemAtURL:fileURL destinationURL:url error:nil];
    
            NSFileManager *fileManager = [NSFileManager defaultManager];
            @try {
                if ([fileManager fileExistsAtPath:fileURL.path] == YES) {
                
                    NSData *pdfData = [NSData dataWithContentsOfFile:fileURL.path];
                    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[@"SELECT DESTINATION", pdfData] applicationActivities:nil];

                    
                    activityViewController.excludedActivityTypes = @[UIActivityTypeMarkupAsPDF];
                    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
                    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo];
                    activityViewController.excludedActivityTypes = @[UIActivityTypeMessage];
                    activityViewController.excludedActivityTypes = @[UIActivityTypeMail];
                    activityViewController.excludedActivityTypes = @[UIActivityTypePrint];
                    activityViewController.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard];
                    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact];
                    activityViewController.excludedActivityTypes = @[UIActivityTypePostToFlickr];
                    activityViewController.excludedActivityTypes = @[UIActivityTypePostToVimeo];
                    activityViewController.excludedActivityTypes = @[UIActivityTypePostToTencentWeibo];
    
    
                    activityViewController.popoverPresentationController.sourceView = self.view;
                    if (activityViewController == nil){
                        return;
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController:activityViewController animated:YES completion:^{}];
                    });
    
                   
    
                } else {
                    NSLog(@"%s","not found...");
                }
    
            } @catch (NSException *exception) {
                    NSLog(@"An exception occurred: %@", [exception reason]);
                }

    }
}


@end
