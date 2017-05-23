//
//  TableViewCell.m
//  FlickrSearcher
//
//  Created by Admin on 22.05.17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "TableViewCell.h"
//#import "Masonry/Masonry.h"

#define defaultPadding 5
#define sizeCellWidth 310
#define sizeCellHeight 80
#define sizePicture 50
#define sizeTitleWidth 200
#define sizeTitleheight 20

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if(self){
        _myImageView=[[UIImageView alloc] initWithFrame:CGRectMake(defaultPadding, defaultPadding,
                                                            sizeCellWidth, sizeCellHeight)];
        
       _myImageView.backgroundColor=[UIColor redColor];
        [_myImageView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.width)];
        [self.contentView addSubview:_myImageView];
    }
    return self;
}

- (void) configureCellContentSizeWidth:(float) width height:(float)height
{
    [_myImageView setFrame:CGRectMake(0, 0, width, height)];
}
-(void) startLoading
{
    _myImageView.backgroundColor=[UIColor greenColor];
}

@end
