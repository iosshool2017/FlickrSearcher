//
//  TableViewCell.h
//  FlickrSearcher
//
//  Created by Admin on 22.05.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (strong,nonatomic) UIImageView *myImageView;

- (void) configureCellContentSizeWidth:(float) width height:(float)height;
-(void) startLoading;

@end
