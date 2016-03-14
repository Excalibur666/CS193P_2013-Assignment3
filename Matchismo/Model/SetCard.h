//
//  SetCard.h
//  Matchismo
//
//  Created by 王敏超 on 16/3/13.
//  Copyright © 2016年 Chao's Awesome App House. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card


//@property (nonatomic, strong) NSDictionary *features;
@property (nonatomic) NSInteger number;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *shaping;
@property (nonatomic, strong) NSString *color;

+ (NSUInteger)maxNumber;
+ (NSArray*)validSymbol;
+ (NSArray*)validShaping;
+ (NSArray*)validColor;

@end

