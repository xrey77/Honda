//
//  AddUserViewController.h
//  Honda
//
//  Created by Reynald Marquez-Gragasin on 6/4/25.
//
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <PDFKit/PDFKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddUserViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UIDocumentPickerDelegate, UIPrintInteractionControllerDelegate>

@property(nonatomic, strong)PDFDocument *pdfDocument;
@property(nonatomic, strong)PDFView *pdfView;
@property(nonatomic, strong)UIImage *pdfImage;

@property(strong, nonatomic)UITextField *firstName;
@property(strong, nonatomic)UITextField *lastName;
@property(strong, nonatomic)UITextField *emailAddress;
@property(strong, nonatomic)UITextField *mobileNo;
@property(strong, nonatomic)UITextField *userName;
@property(strong, nonatomic)UITextField *passWord;
@property(strong, nonatomic)UILabel *heading;

@property(nonatomic, strong)UISearchBar *searchBar;

@property(strong, nonatomic) UIBarButtonItem *previewBtnImage;
@property(strong, nonatomic) UIBarButtonItem *addBtnImage;
@property(strong, nonatomic) UIBarButtonItem *searchBtnImage;
@property(strong, nonatomic) UIBarButtonItem *searchButton;
@property(strong, nonatomic) UIBarButtonItem *icloudBtnImage;



@property(strong, nonatomic) UIBarButtonItem *closePDFPreview;
@property(strong, nonatomic) UIBarButtonItem *printerImage;

@property(strong, nonatomic) NSArray *barButtonItemsRight;
@property(strong, nonatomic)UIView *addView;
@property(strong, nonatomic)UIImageView *xMark;
@property(strong, nonatomic)UIButton *saveButton;

@property(strong, nonatomic)UITableView *tableView;

@property(strong, nonatomic)NSManagedObjectModel *managedObjectModel;
@property(strong, nonatomic)NSManagedObjectContext *managedObjectContext;
@property(strong, nonatomic)NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(strong, nonatomic)NSPersistentContainer *container;

@property(strong, nonatomic)NSMutableArray *userId;
@property(strong, nonatomic)NSMutableArray *fname;
@property(strong, nonatomic)NSMutableArray *lname;
@property(strong, nonatomic)NSMutableArray *email;
@property(strong, nonatomic)NSMutableArray *mobile;
@property(strong, nonatomic)NSMutableArray *users;



@property(strong, nonatomic)NSManagedObjectContext *context;
@property(strong, nonatomic)NSMutableSet *objSet;

@property (nonatomic) NSManagedObjectID *userID;
@property(strong, nonatomic)NSString *txt1;
@property(strong, nonatomic)NSString *txt2;
@property(strong, nonatomic)NSString *txt3;
@property(strong, nonatomic)NSString *txt4;
@property(strong, nonatomic)NSString *txt5;
@property(strong, nonatomic)NSString *txt6;
@property(strong, nonatomic)NSString *txt7;

@property (strong) NSData *dataContent;
@property(nonatomic, retain)UIDocumentPickerViewController *documentController;

@property(strong, nonatomic)NSFileManager *filemanager;
@property(strong, nonatomic)NSString *docsDir;


@end

NS_ASSUME_NONNULL_END
