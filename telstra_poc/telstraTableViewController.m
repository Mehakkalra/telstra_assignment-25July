//
//  telstraTableViewController.m
//  telstra_poc
//
//  Created by Mehak Kalra on 7/22/17.
//  Copyright © 2017 Mehak Kalra. All rights reserved.
//

#import "telstraTableViewController.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+WebCache.h"

static NSString * const cellReuseIdentifier = @"cellReuseIdentifier";

@interface telstraTableViewController ()

@property (strong, nonatomic) UIImageView *imagesInView;
@property (strong, nonatomic) UILabel* titleOfImage;
@property (strong, nonatomic) UILabel *descriptionOfImage;

@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) NSArray *valueOfTitle;
@property (strong, nonatomic) NSArray *valueOfRows;
@end

@implementation telstraTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // registering tableview cell
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
    self.tableView.estimatedRowHeight = 400.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self getData];
    
}

- (void)getData {
    // using afnetworking to fetch data from url
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        
        if(filePath != nil){
            NSString *myString = [[filePath absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            NSString *str = [NSString stringWithContentsOfFile:myString encoding:NSISOLatin1StringEncoding error:&error];
            
            NSData *resData = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            // serializing the data after using NSJSONSerialization and storing results globally.
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:resData options:kNilOptions error:&error];
            self.keys = [json allKeys];
            self.valueOfTitle =  [json valueForKey:[self.keys objectAtIndex:0]];
            [self.navigationItem setTitle:[json valueForKey:@"title"]];
            self.valueOfRows = [json valueForKey:[self.keys objectAtIndex:1]];
            [self.tableView reloadData];
        }
    }];
    [downloadTask resume];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.valueOfRows.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseIdentifier];
    }
    
    UIImageView *imageInView = [[UIImageView alloc] init];
    imageInView.tag = 1;
    
    UILabel *titleLabel= [[UILabel alloc] init];
    titleLabel.tag = 2;
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.tag = 3;
    descriptionLabel.numberOfLines = 0;
    
    // removing imageInView,titleLabel and description label to avoid overlap
    if ((([cell.contentView viewWithTag:1]) && ([cell.contentView viewWithTag:2] && ([cell.contentView viewWithTag:3]))))
        {
            [[cell.contentView viewWithTag:1]removeFromSuperview];
            [[cell.contentView viewWithTag:2]removeFromSuperview];
            [[cell.contentView viewWithTag:3]removeFromSuperview];
        }
        
        [cell.contentView addSubview:imageInView];
        [cell.contentView addSubview:titleLabel];
        [cell.contentView addSubview:descriptionLabel];
    
    
        NSDictionary *dict = self.valueOfRows[indexPath.row];
        NSString *titleFetched;
        NSString *descriptionFetched;
        NSString *referenceOfImage;
    
        // assigning empty string if cell is empty
        if([dict valueForKey:@"title"] != [NSNull null]){
            titleFetched = [dict valueForKey:@"title"];
        }
        else{
            titleFetched = @"";
        }
        
        if([dict valueForKey:@"description"] != [NSNull null]){
            descriptionFetched = [dict valueForKey:@"description"];
        }
        else{
            descriptionFetched = @"";
        }
        
        
        if([dict valueForKey:@"imageHref"] != [NSNull null]){
            referenceOfImage = [dict valueForKey:@"imageHref"];
            if([referenceOfImage containsString:@"http"])
                referenceOfImage = [referenceOfImage stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
        }
        else{
            referenceOfImage = @"";
        }
        
        int padding = 10;
    
        // use of masonry framework for setting up connstraints.
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.left.equalTo(@10);
        make.height.equalTo(@25);
         }];
        
        [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(padding);
        make.left.equalTo(@10);
        make.right.equalTo(@10);
        // make.height.equalTo(@50);
        }];
        
        
        [imageInView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descriptionLabel.mas_bottom).offset(padding);
        make.left.equalTo(@10);
        make.bottom.equalTo(@-5);
        make.width.mas_equalTo(100.f);
        make.height.mas_equalTo(100.f);
        }];
    
        
        
        if(titleLabel.text == nil && descriptionLabel.text == nil){
            titleLabel.text = titleFetched;
            descriptionLabel.text = descriptionFetched;
        }
        
    
        //using SDWenImage framework for lazily loading images and caching
        [imageInView sd_setShowActivityIndicatorView:YES];
        [imageInView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
        [imageInView sd_setImageWithURL:[NSURL URLWithString:referenceOfImage]
                       placeholderImage:nil
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if(error)
             {
                 // image is not available
             }
             else
             {
                 // image is available
                 //updating the imageView after loading image
                 
                 [imageInView mas_updateConstraints:^(MASConstraintMaker *make) {
                             make.top.equalTo(descriptionLabel.mas_bottom).offset(padding);
                             make.width.mas_equalTo(image.size.width);
                             make.height.mas_equalTo(image.size.height);
                 }];

                 
                 
             }
         }];

        return cell;
        
        }
        
#pragma Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

        
        @end
