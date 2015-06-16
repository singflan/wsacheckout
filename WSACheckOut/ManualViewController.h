//
//  ManualViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 1/7/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManualViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *manualsCollection;
@property (strong, nonatomic) NSArray *manualsArray;

@end
