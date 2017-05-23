//
//  TableViewController.m
//  FlickrSearcher
//
//  Created by Admin on 22.05.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "TableViewController.h"
#import "SearchResultModel.h"
#import "Image.h"
#import "TableViewCell.h"


@interface TableViewController () <UISearchBarDelegate>

@property (nonatomic,strong) UISearchBar *searchBar;
@property(strong,nonatomic) SearchResultModel *model;
@property (nonatomic,strong) NSOperationQueue * queue;
@property (nonatomic) NSInteger loadIndex;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar=[UISearchBar new];
    self.searchBar.placeholder=@"Поиск картинки";
    self.tableView.tableHeaderView=self.searchBar;
    self.tableView.rowHeight=[[UIScreen mainScreen] bounds].size.width;
    self.searchBar.delegate=self;
    [self.searchBar becomeFirstResponder];
    [self.tableView setContentInset:UIEdgeInsetsMake(30,0 ,0,0)];
    [self.searchBar sizeToFit];
    
    self.model=[SearchResultModel new];
    self.queue = [[NSOperationQueue alloc] init];
    _loadIndex=0;
}

#pragma mark - Search Bar Delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *request=searchBar.text;
        [searchBar endEditing:YES];
    _loadIndex=0;
    NSLog(@"new search @%@",request);
    if (request)
    {
        __weak typeof (self) weakself=self;
        [self.model getImages:request  withCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.tableView reloadData];
            });
        }];
        
        
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell* cell = [[TableViewCell alloc] initWithFrame:CGRectZero];
    Image *image=self.model.images[indexPath.row];
    if ((!image.image)&&(!image.isloading)) {
        NSLog(@"start load img ip=%ld isl=%d",indexPath.row,image.isloading);
        image.isloading=YES;
        [cell startLoading];
        NSOperation *loadImgOp = [[NSInvocationOperation alloc]
                                  initWithTarget:self
                                  selector:@selector(loadImageInBackground:)
                                  object:indexPath];
        [self.queue addOperation:loadImgOp];

//    cell.imageView.image = [UIImage imageNamed:@"image"];
//    __weak typeof(self) weakself=self;
//    [self.model downloadImage:indexPath withCompletionHandler:^(NSIndexPath *indexpath) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            TableViewCell * cell=[weakself.tableView cellForRowAtIndexPath:indexpath];
//            cell.myImageView.image = [self convertImageToGrayScale:image.image];
//            NSLog(@"load img");
//        });
//    }];
    }
    else
    {
        cell.myImageView.image = image.image;
    }
    return cell;
}
-(void)loadImageInBackground:(NSIndexPath *)itemIndexPath {
    Image *currentItem = _model.images[itemIndexPath.row];
    ////
    __weak typeof(self) weakself=self;
    [self.model downloadImage:itemIndexPath  withCompletionHandler:^(NSIndexPath *itemIndexPath ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    TableViewCell * cell=[weakself.tableView cellForRowAtIndexPath:itemIndexPath ];
                    currentItem.image=[self convertImageToGrayScale:currentItem.image];
                    cell.myImageView.image =currentItem.image;
                    NSLog(@"load img %ld ip=%ld",_loadIndex,itemIndexPath.row);
                    _loadIndex++;
                });
            }];
    
    //////
    
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:currentItem.url]];
//    UIImage *downloadedImage = [UIImage imageWithData:imageData];
//    downloadedImage=[self convertImageToGrayScale:downloadedImage];
//    __weak typeof(self) weakself=self;
//    TableViewCell * cell=[weakself.tableView cellForRowAtIndexPath:itemIndexPath];
   // [cell.myImageView.image performSelectorOnMainThread:@selector(setImage:)
   //                                  withObject:downloadedImage
     //                             waitUntilDone:YES];
}
- (UIImage *)convertImageToGrayScale:(UIImage *)image {
    
    NSLog(@"convert img");
    
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage; }
@end
