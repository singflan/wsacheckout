//
//	ReaderDemoController.m
//	Reader v2.7.0
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2013 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ManualViewController.h"
#import "ReaderViewController.h"
#import "UIImage+PDF.h"
#import "ManualViewCell.h"
#import "LoginController.h"
#import "ProgressHUD.h"

@interface ManualViewController () <ReaderViewControllerDelegate>

@end

@implementation ManualViewController

#pragma mark UIViewController methods


 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
 {
 // Custom initialization
 }
 
 return self;
 }


/*
 - (void)loadView
 {
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 }
 */

-(NSArray *)manualsArray {
    
    if (!_manualsArray) {
        
        NSString *manualsPath = [NSString stringWithFormat: @"%@/PDFs", [[NSBundle mainBundle] resourcePath]];
        NSFileManager *localFileManager= [[NSFileManager alloc] init];
        NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:manualsPath];
        NSMutableArray * arrayOfManuals = [[NSMutableArray alloc] initWithCapacity: 1];
        NSString *file;
        while (file = [dirEnum nextObject]) {

                [arrayOfManuals addObject: file];
        }
        
        _manualsArray = arrayOfManuals;
    }
    return _manualsArray;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    CGRect collectionViewRect = CGRectMake(0, 62, 768, 910);
    
    self.manualsCollection.delegate = self;
    self.manualsCollection.dataSource = self;
    self.manualsCollection.frame = collectionViewRect;
    self.manualsCollection.backgroundColor = [UIColor darkGrayColor];
    self.view.backgroundColor = [UIColor lightGrayColor];

    UINavigationBar *mapNavBar = [[UINavigationBar alloc] init];
    [mapNavBar setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    mapNavBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:mapNavBar];
    
    // create the logout button
    UIButton* logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem *logoutButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
    [navItem setLeftBarButtonItem:logoutButtonItem];
    
    [mapNavBar setItems:@[navItem]];
    mapNavBar.topItem.title = @"WSA CheckOut";
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [ProgressHUD show:@"Loading.  Please wait . . ."];
	
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    [ProgressHUD dismiss];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif
    
	[super viewDidUnload];
}

#pragma mark UICollectionView methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.manualsArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ManualCell";
    
    ManualViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *pdfName = [[NSString alloc] init];
    UIImage *manualImage = [[UIImage alloc] init];
    
    pdfName = [NSString stringWithFormat: @"PDFs/%@", [self.manualsArray objectAtIndex:indexPath.row]];
    manualImage = [UIImage imageWithPDFNamed:pdfName atSize:CGSizeMake(160,208) atPage:1];
    
    cell.manualThumbnail.image = manualImage;
    cell.backgroundColor = [UIColor whiteColor];
    cell.manualTitle.backgroundColor = [UIColor darkGrayColor];
    cell.manualTitle.text = [self.manualsArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:@"PDFs"];
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:[paths objectAtIndex:indexPath.row] password:nil];
    
    if (document !=nil) {
        
        CGRect readerRect = CGRectMake(0, 64, 768, 910);
        
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
        readerViewController.delegate = self;
        [self addChildViewController:readerViewController];
        readerViewController.view.frame = readerRect;
        [[self view] addSubview:readerViewController.view];
        
        [readerViewController didMoveToParentViewController:self];
    }
}

#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{

	[viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
    
}

- (void)didReceiveMemoryWarning
{
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif
    
	[super didReceiveMemoryWarning];
    self.manualsArray = nil;
}

@end