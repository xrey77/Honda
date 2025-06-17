//
//  ViewController.h
//  Honda
//
//  Created by Reynald Marquez-Gragasin on 6/4/25.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>

@interface ViewController : UIViewController<UINavigationControllerDelegate, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>

@property(strong, nonatomic) UIImageView *image1;
@property(strong, nonatomic) UIButton *button;

///RIGHT IMAGE
@property(strong, nonatomic) UIBarButtonItem *addBtnImage;
@property(strong, nonatomic) UIBarButtonItem *previewBtnImage;
@property(strong, nonatomic) NSArray *barButtonItemsRight;

@property(strong, nonatomic) UIBarButtonItem *logoBtnImage;
@property(strong, nonatomic) UIBarButtonItem *printerBtnImage;
@property(strong, nonatomic) NSArray *barButtonItemsLeft;

@property(nonatomic, retain)UIDocumentPickerViewController *documentController;
@property(nonatomic, retain)UIImagePickerController *imageController;
@property(strong, nonatomic)UIImageView *selectedImage;

@property(nonatomic, strong)PDFView *pdfView;
@property(nonatomic, strong)UIView *pdfContainer;
@property(nonatomic, strong)UIScrollView *scrollView;

@property(nonatomic, strong)UILabel *prodesc;

@property(nonatomic, strong)UIScrollView *scrollview;
@property(nonatomic, strong)UIView *bodyView;

@end

