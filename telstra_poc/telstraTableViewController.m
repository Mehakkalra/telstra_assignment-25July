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
#import "telstraTableViewCell.h"
#import "Details.h"

static NSString * const cellReuseIdentifier = @"cellReuseIdentifier";
CGFloat heightOfFetchedImage=0.0f;
CGFloat widthOfFetchedImage=0.0f;

@interface telstraTableViewController ()

@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) NSArray *valueOfTitle;
@property (strong, nonatomic) NSArray *valueOfRows;
@property (strong, nonatomic) NSArray *detailsArray;

@end

@implementation telstraTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.detailsArray = [[NSArray alloc]init];
    
    // registering tableview cell
    [self.tableView registerClass:[telstraTableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
    self.tableView.estimatedRowHeight = 400.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = button;
    
    [self getData];
    
}

-(void)refresh{
    [self.tableView reloadData];
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
            NSString *stringToReplace = [[filePath absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            NSString *setLatinEncoding = [NSString stringWithContentsOfFile:stringToReplace encoding:NSISOLatin1StringEncoding error:&error];
            
            NSData *resData = [setLatinEncoding dataUsingEncoding:NSUTF8StringEncoding];
            
            // serializing the data after using NSJSONSerialization and storing results globally.
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:resData options:kNilOptions error:&error];
            self.keys = [json allKeys];
            self.valueOfTitle =  [json valueForKey:[self.keys objectAtIndex:0]];
            [self.navigationItem setTitle:[json valueForKey:@"title"]];
            self.valueOfRows = [json valueForKey:[self.keys objectAtIndex:1]];
            NSMutableArray *detailsArray = [[NSMutableArray alloc] init];
            for(NSDictionary *factDictionary in self.valueOfRows) {
                Details *details = [[Details alloc] initWithDictionary:factDictionary];
                if (details) {
                    [detailsArray addObject:details];
                }
            }
            _detailsArray = detailsArray;
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
    return self.detailsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    telstraTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];

    Details *detailsObj = (Details *)[self.detailsArray objectAtIndex:indexPath.row];
    cell.details=detailsObj;

    
    //using SDWebImage framework for lazily loading images and caching
    [cell.imageInView sd_setShowActivityIndicatorView:YES];
    [cell.imageInView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    if (![detailsObj.detailURL isKindOfClass:[NSNull class]]) {
        [cell.imageInView sd_setImageWithURL:[NSURL URLWithString:detailsObj.detailURL]
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
                 heightOfFetchedImage = image.size.height;
                 widthOfFetchedImage = image.size.width;
                 

                 
                 
                                  [cell.imageInView mas_updateConstraints:^(MASConstraintMaker *make) {
                                      make.width.mas_equalTo(image.size.width);
                                      make.height.mas_equalTo(image.size.height);
                                  }];
               // [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
  
             }
         }];
    }


        return cell;
        
        }

        
#pragma Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 500.0;
}

@end
