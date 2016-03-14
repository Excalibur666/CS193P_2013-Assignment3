//
//  GameHistoryViewController.m
//  Matchismo
//
//  Created by 王敏超 on 16/3/14.
//  Copyright © 2016年 Chao's Awesome App House. All rights reserved.
//

#import "GameHistoryViewController.h"


@interface GameHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;
@end

@implementation GameHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    NSMutableAttributedString *allHistory = [[NSMutableAttributedString alloc] init];
    for (NSMutableAttributedString *eachHistory in self.history) {
        [allHistory appendAttributedString:eachHistory];
        [allHistory appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    self.historyTextView.attributedText = allHistory;
}




@end
