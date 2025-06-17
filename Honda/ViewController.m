//
//  ViewController.m
//  Honda
//
//  Created by Reynald Marquez-Gragasin on 6/4/25.
//

#import "ViewController.h"
#import "AddUserViewController.h"
@import UniformTypeIdentifiers;

@interface ViewController ()

@end

@implementation ViewController
@synthesize addBtnImage,previewBtnImage,barButtonItemsRight,logoBtnImage,printerBtnImage,barButtonItemsLeft;
@synthesize documentController, imageController, selectedImage, pdfView, pdfContainer,scrollView;
@synthesize image1, button, prodesc, scrollview, bodyView;

- (void)viewDidLoad {
    [super viewDidLoad];
     
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0 ,0 ,self.view.frame.size.width ,self.view.frame.size.height)];
    scrollView.delegate= self;
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    scrollView.scrollEnabled= YES;
    scrollView.userInteractionEnabled= YES;
    [self.view addSubview:scrollView];
    scrollView.contentSize= CGSizeMake(self.view.frame.size.width ,self.view.frame.size.height*2);
    scrollview.bounces=NO;
    
    bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
    [scrollView addSubview:bodyView];
    
    
    image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400, 300)];
    image1.image = [UIImage imageNamed:@"1.png"];
    [self.view addSubview:image1];
    [bodyView addSubview:image1];

    self.prodesc = [[UILabel alloc] initWithFrame:CGRectMake(10, 260, 350, 50)];
    [self.prodesc setNumberOfLines:0];
    self.prodesc.text = @"The Honda Civic, HR-V, and BR-V are available in the Philippines for 2025, with prices ranging from ₱735,000 to ₱3.87 Million, according to www.zigwheels.ph. The Civic offers a 2.0L e:HEV full hybrid engine or a 1.5L turbocharged engine, while the HR-V is available as a gasoline hybrid. The BR-V is a gasoline-powered SUV with a 1.5L engine.\n\nHonda Civic:\n\n• Engine: Available with a 2.0L e:HEV full hybrid or a 1.5L turbocharged engine.\n\n• Engine: Available with a 2.0L e:HEV full hybrid or a 1.5L turbocharged engine.\n\n• Drivetrain: Front-wheel drive.\n\n• Body: Sedan.\n\n• Dimensions: Length: 4,681 mm, Width: 1,802 mm, Height: 1,415 mm.\n\n• Wheels: 17-18 inches.\n\n• Other features: 7-inch infotainment system with Apple CarPlay and Android Auto, Bose 12-speaker sound system, Honda SENSING suite of safety feature\n\n Honda City:\n\n•Body Type: Sedan\n\n• Engine: 1.5L engine\n\n• Drivetrain: Front-wheel drive\n\n• Features: 15-16 inch wheels, 4-6 airbags (depending on variant)\n\nHonda HR-V:\n\n• Body Type: Crossover\n\n• Body Type: Crossover\n\n• Engine: Gasoline or Gasoline Hybrid\n\n• Transmission: CVT\n\n• Drivetrain: Front-wheel drive";
    self.prodesc.textColor = UIColor.blackColor;
    self.prodesc.textAlignment = NSTextAlignmentJustified;
    self.prodesc.lineBreakMode = NSLineBreakByWordWrapping;
    [prodesc sizeToFit];
    self.prodesc.font = [UIFont fontWithName:@"Arial" size:16];
    [self.view addSubview:prodesc];
    [self.bodyView addSubview:prodesc];
    
    selectedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+500)];
    selectedImage.autoresizingMask = true;
    [self.view addSubview:selectedImage];
    
    ///RIGHT IMAGE
    addBtnImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"person.3.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapAddButton:)];
    previewBtnImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"doc.text.magnifyingglass"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapPrinterButton:)];

    barButtonItemsRight = [[NSArray alloc] initWithObjects: addBtnImage, previewBtnImage, nil];
    self.navigationItem.rightBarButtonItems = barButtonItemsRight;

    ///LEFT IMAGE
//    logoBtnImage = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"honda2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal style:UIBarButtonItemStylePlain target:self action:@selector(didTapAddButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"logo.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];

    pdfContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

}

- (void)viewWillDisappear:(BOOL)animated {
    [pdfView removeFromSuperview];
}

-(void)didTapAddButton:(UIBarButtonItem*)item{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddUserViewController *adduserVC = (AddUserViewController *)[storyboard instantiateViewControllerWithIdentifier:@"adduserVC"];
    [self.navigationController pushViewController:adduserVC animated:YES];
}

-(void)didTapPrinterButton:(UIBarButtonItem*)item{
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Report's Viewer" message:@"Please select pdf report location." preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"Photo Libraray" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

            self.navigationItem.rightBarButtonItems = nil;

            UIBarButtonItem *printerImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"printer.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapPrinterIcon:)];
            
            UIBarButtonItem *closeImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"xmark.square"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapCloseButton:)];

            self->barButtonItemsRight = [[NSArray alloc] initWithObjects: closeImage, printerImage, nil];
            self.navigationItem.rightBarButtonItems = self->barButtonItemsRight;
                        
            self.imageController = [[UIImagePickerController alloc]init];
            self.imageController.delegate = self;
            [self presentViewController:self.imageController animated:YES completion:nil];
            return;;
            
        }];
        [alert addAction:photoAction];
        UIAlertAction *icloudAction = [UIAlertAction actionWithTitle:@"iCloud Folder" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)  {
                             
            self->documentController = [[UIDocumentPickerViewController alloc] initForOpeningContentTypes:@[[UTType typeWithFilenameExtension:@"pdf"]]];
            self.documentController.delegate = self;
            [self presentViewController:self.documentController animated:YES completion:nil];
            
            UIBarButtonItem *printerImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"printer.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapPrinterIcon:)];
            
            UIBarButtonItem *closeImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"xmark.square"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapCloseButton:)];

            self->barButtonItemsRight = [[NSArray alloc] initWithObjects: closeImage, printerImage, nil];
            self.navigationItem.rightBarButtonItems = self->barButtonItemsRight;

            return;

        }];
        [alert addAction:icloudAction];

    
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)  {
            NSLog(@"%s","CANCELLED..");
            return;
        }];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];

}

//PDF CLOSE ICON
-(void)didTapCloseButton:(id)sender {
    self.navigationItem.rightBarButtonItems = nil;
    [self.pdfContainer removeFromSuperview];
    ///RIGHT IMAGE
    addBtnImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"person.3.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapAddButton:)];
    previewBtnImage = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"doc.text.magnifyingglass"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapPrinterButton:)];

    barButtonItemsRight = [[NSArray alloc] initWithObjects: addBtnImage, previewBtnImage, nil];
    self.navigationItem.rightBarButtonItems = barButtonItemsRight;
}

//PDF PRINTER ICON
-(void)didTapPrinterIcon:(id)sender {
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

//CONVERT IMAGE TO PDF IMAGEPICKERCONTROLLER
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    PDFDocument *pdf = [[PDFDocument alloc] init];
    PDFPage *page = [[PDFPage alloc] initWithImage:img];
    [pdf insertPage:page atIndex: [pdf pageCount]];
    pdfView = [[PDFView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    pdfView.autoScales = true;
    [self.pdfContainer addSubview:pdfView];
    [self.view addSubview:pdfContainer];
    pdfView.document = pdf;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSURL *urlx = urls.firstObject;
    [urlx startAccessingSecurityScopedResource];
    [urlx stopAccessingSecurityScopedResource];
    
    pdfView = [[PDFView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    pdfView.autoScales = true;
    [self.pdfContainer addSubview:pdfView];
    [self.view addSubview:pdfContainer];
    PDFDocument *doc;
    doc = [[PDFDocument alloc] initWithURL:urlx];
    pdfView.document = doc;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end


/**
 //==========PHPickerViewController================
 - (void)pickPhoto
 {
     UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
     imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     imagePicker.delegate = self;
     [self presentViewController:imagePicker animated:YES completion:nil];
 }

 // Implement UIImagePickerControllerDelegate method
 -(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
 {
     UIImage *image = info[UIImagePickerControllerOriginalImage];
     self.imageView.image = image;

     [picker dismissViewControllerAnimated:YES completion:nil];
 }
 
 */
