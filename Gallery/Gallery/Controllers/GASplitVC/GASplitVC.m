//
//  GASplitVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GASplitVC.h"

// Models
#import "GAFileManager.h"

// Controllers
#import "GADirectoryInspectorVC.h"


@interface GASplitVC ()

@end

@implementation GASplitVC

#pragma mark - Constructors

- (id)init {
    self = [super init];
    if (self) {
        GADirectory *rootDirectory = [GAFileManager readSharedDirectory];
        
        UIViewController *mainVC = [GADirectoryInspectorVC newWithDirectory:rootDirectory];
        
        UIViewController *blueVC = [[UIViewController alloc] init];
        blueVC.view.backgroundColor = [UIColor blueColor];
        
        self.viewControllers = @[mainVC, blueVC];
    }
    return self;
}


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
