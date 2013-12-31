//
//  singleViewController.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-14.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "singleViewController.h"

@interface singleViewController ()

@end

@implementation singleViewController

@synthesize thisindex;
@synthesize singleTBView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithIndex:(int)index Data:(NSArray *)dataArray
{
    if(self = [super init])
        {
        //为子类增加属性进行初始化
        loadSingleDB  = [[myDB alloc]initWithDBName:@"ExamQuestionBank.db"];
        thisHistory = [History_Space new];
        self.thisindex = index;
        thisHistory = [dataArray objectAtIndex:0];
        
        NSArray *History_Serial  = [thisHistory.History_Serial componentsSeparatedByString:@","];
        NSArray *History_Choosed  = [thisHistory.History_Choosed componentsSeparatedByString:@"|"];
        NSArray *History_Right  = [thisHistory.History_Right componentsSeparatedByString:@"|"];
        
        choosed = [[History_Choosed objectAtIndex:(self.thisindex-1)] intValue];
        righted   = [History_Right       objectAtIndex:(self.thisindex-1)];
        
        NSString *sqlstring;
        if ([thisHistory.History_Table isEqualToString:@"SubType_Special"]) {
            sqlstring = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE Sub_Id='%@'",thisHistory.History_Table,[History_Serial objectAtIndex:(self.thisindex-1)]];
            //查询数据
            /*
            FMResultSet *rs= [loadSingleDB findinTable:sqlstring];
            
            while ([rs next])
                {
                thisSpecial = [[SubType_Special alloc]init];
                
                thisSpecial.Sub_Title               = [rs stringForColumn:@"Sub_Title"];
                thisSpecial.Sub_A                   = [rs stringForColumn:@"Sub_A"];
                thisSpecial.Sub_B                   = [rs stringForColumn:@"Sub_B"];
                thisSpecial.Sub_C                   = [rs stringForColumn:@"Sub_C"];
                thisSpecial.Sub_D                   = [rs stringForColumn:@"Sub_D"];
                thisSpecial.Sub_Right           = [rs stringForColumn:@"Sub_Right"];
                thisSpecial.Sub_Analyse        = [rs stringForColumn:@"Sub_Analyse"];
                }*/
        }
        else if ([thisHistory.History_Table isEqualToString:@"SubType_Real"])
            {
        sqlstring = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE Sub_Id='%@'",thisHistory.History_Table,[History_Serial objectAtIndex:(self.thisindex-1)]];
            //查询数据
            /*
            FMResultSet *rs= [loadSingleDB findinTable:sqlstring];
            
            while ([rs next])
                {
                thisReal = [[SubType_Real alloc]init];
                
                thisReal.Sub_Title               = [rs stringForColumn:@"Sub_Title"];
                thisReal.Sub_A                   = [rs stringForColumn:@"Sub_A"];
                thisReal.Sub_B                   = [rs stringForColumn:@"Sub_B"];
                thisReal.Sub_C                   = [rs stringForColumn:@"Sub_C"];
                thisReal.Sub_D                   = [rs stringForColumn:@"Sub_D"];
                thisReal.Sub_Right           = [rs stringForColumn:@"Sub_Right"];
                thisReal.Sub_Analyse        = [rs stringForColumn:@"Sub_Analyse"];
                }*/
            }
        else
            {
             sqlstring = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE Sub_Id='%@'",thisHistory.History_Table,[History_Serial objectAtIndex:(self.thisindex-1)]];
            //查询数据
            /*
            FMResultSet *rs= [loadSingleDB findinTable:sqlstring];
            
            while ([rs next])
                {
                thisFast = [[SubType_Fast alloc]init];
                
                thisFast.Sub_Title               = [rs stringForColumn:@"Sub_Title"];
                thisFast.Sub_A                   = [rs stringForColumn:@"Sub_A"];
                thisFast.Sub_B                   = [rs stringForColumn:@"Sub_B"];
                thisFast.Sub_C                   = [rs stringForColumn:@"Sub_C"];
                thisFast.Sub_D                   = [rs stringForColumn:@"Sub_D"];
                thisFast.Sub_Right           = [rs stringForColumn:@"Sub_Right"];
                thisFast.Sub_Analyse        = [rs stringForColumn:@"Sub_Analyse"];
                }*/
            }
        //查询数据
        FMResultSet *rs= [loadSingleDB findinTable:sqlstring];
        
        while ([rs next])
            {
            thisFast = [[SubType_Comm alloc]init];
            
            thisFast.Sub_Title               = [rs stringForColumn:@"Sub_Title"];
            thisFast.Sub_Name            = [rs stringForColumn:@"Sub_Name"];
            thisFast.Sub_A                   = [rs stringForColumn:@"Sub_A"];
            thisFast.Sub_B                   = [rs stringForColumn:@"Sub_B"];
            thisFast.Sub_C                   = [rs stringForColumn:@"Sub_C"];
            thisFast.Sub_D                   = [rs stringForColumn:@"Sub_D"];
            thisFast.Sub_Right           = [rs stringForColumn:@"Sub_Right"];
            thisFast.Sub_Analyse        = [rs stringForColumn:@"Sub_Analyse"];
            }
        
        }
    return self;
}
-(void)loadView
{
    [super loadView];
    [self.maskBtn setImage:[UIImage imageNamed:@"zhuce_1.png"] forState:UIControlStateNormal];
    [self.maskBtn setImage:[UIImage imageNamed:@"zhuce_2.png"] forState:UIControlStateHighlighted];
    
    right = [[UIImageView alloc]initWithFrame:CGRectMake(273, 15, 25, 25)];
    
    botLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 420, 320, 40)];
    
    [self.view addSubview:right];
    [self.view addSubview:botLB];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLB.font = [UIFont systemFontOfSize:12.0];
    self.titleLB.text = thisHistory.History_Time;
    [self.theTableView reloadData];
    UILabel *titleLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 30)];
    titleLB.font = [UIFont systemFontOfSize:13.0f];
    titleLB.textAlignment = 1;
    titleLB.backgroundColor = [UIColor clearColor];
    titleLB.textColor = [UIColor blackColor];
    NSArray *answerArray = @[@"空",@"A",@"B",@"C",@"D"];
    NSString *userchoose = [answerArray objectAtIndex:choosed];
    NSString *astring = [NSString stringWithFormat:@"正确答案是 %@ ,您的答案是 %@",righted,userchoose];
    if ([righted isEqualToString:userchoose]) {
        right.image = [UIImage imageNamed:@"RightBG.png"];
    }else
        {
        right.image = [UIImage imageNamed:@"WrongBG.png"];
        }
    titleLB.text = astring;
    [botLB addSubview:titleLB];
}



-(void)loadTableView:(UITableView *)thetableView TableViewStyle:(UITableViewStyle )style
{
    self.singleTBView = thetableView;
    singleTBView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 59.0, self.view.width, self.view.height-100) style:UITableViewStylePlain];
    singleTBView.rowHeight = 40.0;
    //    thetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    singleTBView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    singleTBView.backgroundColor = [UIColor clearColor];
    singleTBView.separatorStyle = UITableViewCellSeparatorStyleNone;
    singleTBView.scrollEnabled = YES;
    singleTBView.backgroundView = nil;
    singleTBView.dataSource = self;
    singleTBView.delegate = self;
    [self.view addSubview:singleTBView];
}

-(void)maskBtnDidClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"关闭单独页面------回调");//这里打个断点，点击按钮模态视图移除后会回到这里
    }];
}

//------生成cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = [indexPath row];

    static NSString  *CellIdentifier = @"CellIdentifier";
    static NSString *cellIdentifier = @"cell";
    static NSString *cellIDF = @"cellIDF";
    UITableViewCell *cell ;
    
    //-------题干
    if (row == 0)
        {
        cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
            {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //  自定义图片
            UILabel  *imageView=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 230, 42)];
            imageView.tag = 11;
            imageView.backgroundColor = [UIColor clearColor];
            imageView.font = [UIFont systemFontOfSize:14.0];
            
            //  自定义主标题
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 0, 30, 42)];
            titleLabel.tag = 12;
            titleLabel.numberOfLines = 1;
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:18.0];
            titleLabel.textColor = UIColorFromRGB(0x2C7CFF);
            
            //  自定义副标题
            UILabel *title2Label = [[UILabel alloc]initWithFrame:CGRectMake(275, 0, 30, 42)];
            title2Label.tag = 13;
            title2Label.backgroundColor = [UIColor clearColor];
            title2Label.numberOfLines = 1;
            title2Label.font = [UIFont systemFontOfSize:14.0];
            
            UILabel *textView = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 300, 150)];
            textView.tag = 14;
            textView.backgroundColor = [UIColor clearColor];
                      
            //  加载到cell视图
            [cell.contentView addSubview:textView];
            [cell.contentView addSubview:imageView];
            [cell.contentView addSubview:titleLabel];
            [cell.contentView addSubview:title2Label];
            }
        //  设置大标题
        UILabel *title = (UILabel *)[cell.contentView viewWithTag:11];
        title.textColor = [UIColor grayColor];
        
        title.text = [NSString stringWithFormat:@"%@-%@",thisHistory.History_Type,thisHistory.History_Name] ;//练习类型;
        
        //设置数字
        UILabel *titlelabel = (UILabel *)[cell.contentView viewWithTag:12];
        titlelabel.text = [NSString stringWithFormat:@"%d",self.thisindex];
        
        //设置个数
        UILabel *title2label = (UILabel *)[cell.contentView viewWithTag:13];
        title2label.text = [NSString stringWithFormat:@"| %d",thisHistory.History_Total ];
        
        UILabel *text2View = (UILabel*)[cell.contentView viewWithTag:14];
        CGFloat contentWidth = 300;//label的宽
        //        [text2View sizeToFit];
        UIFont *font = [UIFont systemFontOfSize:14.0];
        text2View.font = font;
        CGSize size = [thisFast.Sub_Title sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        text2View.numberOfLines = 0;
        CGRect rect = [text2View textRectForBounds:text2View.frame limitedToNumberOfLines:0];
        if (size.height<100) {
            size.height+= 100;
        }
        rect.size = size;
        text2View.frame = rect;
        NSString *titleStr = [[[CommClass sharedInstance] flattenHTML:thisFast.Sub_Title trimWhiteSpace:YES] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        text2View.text = titleStr;
       
        }
    //--------解析
    else if ( row == 1 )
        {
        cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIDF];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDF];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = [UIColor greenColor];
        }
        
        NSString *analyseStr;
        if (thisFast.Sub_Analyse) {
            analyseStr = [NSString stringWithFormat:@"解析  %@",thisFast.Sub_Analyse];
        } else {
            analyseStr = @"解析  无";
        }
        cell.textLabel.text = [[[CommClass sharedInstance] flattenHTML:analyseStr trimWhiteSpace:YES] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        }
    //-------题目
    else {
        
        cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.contentView.backgroundColor = [UIColor clearColor];
            //            cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
            UIImageView  *imageViews=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 21, 21)];
            imageViews.tag = 21;
            
            UILabel  *txtView=[[UILabel alloc] initWithFrame:CGRectMake(40, 5, 240, 30)];
            txtView.tag = 22;
            
            [cell.contentView addSubview:txtView];
            [cell.contentView addSubview:imageViews];
        }
        //  设置image图片
        UIImageView *imageviewss = (UIImageView *)[cell.contentView viewWithTag:21];
        
        //  设置选项内容
        UILabel *txt2View = (UILabel *)[cell.contentView viewWithTag:22];
        txt2View.textColor = [UIColor grayColor];
        
        CGFloat contentWidth = 300;//label的宽
        UIFont *font = [UIFont systemFontOfSize:12.0];
        txt2View.font = font;
        
        txt2View.numberOfLines = 0;
        
        if (row == 2) {
            imageviewss.image = [UIImage imageNamed:@"A.png"];
            CGSize size = [thisFast.Sub_A sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            if (size.width>260) {
                size.width =260;
            }
            CGRect rect = [txt2View textRectForBounds:txt2View.frame limitedToNumberOfLines:0];
            rect.size = size;
            imageviewss.frame = CGRectMake(10, (cell.frame.size.height-21)/2, 21, 21);
            txt2View.frame = CGRectMake(40, (cell.frame.size.height-size.height)/2, size.width, size.height);
             txt2View.text = [[[CommClass sharedInstance] flattenHTML:thisFast.Sub_A trimWhiteSpace:YES] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        }
        else if(row == 3)
            {
            imageviewss.image = [UIImage imageNamed:@"B.png"];
            CGSize size = [thisFast.Sub_B sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            if (size.width>260) {
                size.width =260;
            }
            CGRect rect = [txt2View textRectForBounds:txt2View.frame limitedToNumberOfLines:0];
            rect.size = size;
            imageviewss.frame = CGRectMake(10, (cell.frame.size.height-21)/2, 21, 21);
            txt2View.frame = CGRectMake(40, (cell.frame.size.height-size.height)/2, size.width, size.height);
            txt2View.text = [[[CommClass sharedInstance] flattenHTML:thisFast.Sub_B trimWhiteSpace:YES] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
            }
        else if(row == 4)
            {
            imageviewss.image = [UIImage imageNamed:@"C.png"];
            CGSize size = [thisFast.Sub_C sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            if (size.width>260) {
                size.width =260;
            }
            CGRect rect = [txt2View textRectForBounds:txt2View.frame limitedToNumberOfLines:0];
            rect.size = size;
            imageviewss.frame = CGRectMake(10, (cell.frame.size.height-21)/2, 21, 21);
            txt2View.frame = CGRectMake(40, (cell.frame.size.height-size.height)/2, size.width, size.height);
            txt2View.text = [[[CommClass sharedInstance] flattenHTML:thisFast.Sub_C trimWhiteSpace:YES] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
            }
        else
        {
        imageviewss.image = [UIImage imageNamed:@"D.png"];
        CGSize size = [thisFast.Sub_D sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        if (size.width>260) {
            size.width =260;
        }
        
        CGRect rect = [txt2View textRectForBounds:txt2View.frame limitedToNumberOfLines:0];
        rect.size = size;
        imageviewss.frame = CGRectMake(10, (cell.frame.size.height-21)/2, 21, 21);
        txt2View.frame = CGRectMake(40, (cell.frame.size.height-size.height)/2, size.width, size.height);
        txt2View.text = [[[CommClass sharedInstance] flattenHTML:thisFast.Sub_D trimWhiteSpace:YES] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        }
        
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell自适应高度
    CGFloat contentWidth = 300;//label的宽
    UIFont *font = [UIFont systemFontOfSize:14.0];
    NSString *string = nil;
    if (indexPath .row == 0) {
        string = thisFast.Sub_Title;//前面Label中需要显示的内容
        CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        if (size.height<100) {
            size.height+= 100;
        }
        return 40 +size.height;//最低50的高，根据label的高度调整cell的高度。
    }
    else if (indexPath.row == 1)
        {
        string = thisFast.Sub_Analyse;
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        return 40 +size.height;
        }
    else
        {
         UIFont *font2 = [UIFont systemFontOfSize:12];
        if (indexPath.row == 2) {
            NSString *string2 = thisFast.Sub_A;
            CGSize size2 = [string2 sizeWithFont:font2 constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            return 40 +size2.height;//最低50的高，根据label的高度调整cell的高度。
        }
        else if(indexPath.row == 3)
            {
            NSString *string2 = thisFast.Sub_B;
            CGSize size2 = [string2 sizeWithFont:font2 constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            return 40 +size2.height;//最低50的高，根据label的高度调整cell的高度。
            }
        else if (indexPath.row == 4)
            {
            NSString *string2 = thisFast.Sub_C;
            CGSize size2 = [string2 sizeWithFont:font2 constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            return 40 +size2.height;//最低50的高，根据label的高度调整cell的高度。
            }
        else
            {
            NSString *string2 = thisFast.Sub_D;
            CGSize size2 = [string2 sizeWithFont:font2 constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            return 40 +size2.height;//最低50的高，根据label的高度调整cell的高度。
            }
        }
   
//    
//    
//    if (indexPath.row == 0) {
//        return 200;
//    }
//	return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
