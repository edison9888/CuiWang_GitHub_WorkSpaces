//
//  Step1ViewController.m
//  TQ_BaoMing_Online
//
//  Created by cui wang on 13-9-23.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "Step1ViewController.h"
#import "RootViewController.h"
#import "Step2ViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
@interface Step1ViewController ()

@end

@implementation Step1ViewController
@synthesize PassListValueDelegate;
@synthesize tableCell;
@synthesize tableview;
@synthesize leftArray;
@synthesize fieldArray;
@synthesize subArray;
@synthesize imageview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
  
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    leftArray = @[@"* 姓名 :",@"* 性别 :",@"* 联系电话 :",@"* 固定电话 :",@"* Email :",@"* 工作年限 :",@"* 学历 :",@"* 毕业院校 :",@"* 学生编号 :"];
    fieldArray = @[@"            姓名 ",@"            性别 ",@"            联系电话 ",@"            固定电话 ",@"            Email ",@"            工作年限 ",@"            学历 ",@"            毕业院校 ",@"            学生编号 "];
    subArray = @[@"name",@"sex",@"tel",@"phone",@"email",@"work_experience",@"education",@"school",@"admin_name",@"student_id"];
}
- (IBAction)chooseImage:(id)sender {
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    [sheet showInView:self.view];
    
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    //判断所点击view是否是UITextField或UITextView
//    if (![[touch view] isKindOfClass:[UITextField class]] && ![[touch view] isKindOfClass:[UITextView class]]) {
//        
//        for (UITextField * missField in fieldArray) {
//            [missField resignFirstResponder];
//        }
//    }
//}
#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    [self.imageview setImage:savedImage forState:UIControlStateNormal];
//    [self.imageview setImage:savedImage];
    
    self.imageview.tag = 100;
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}
#pragma mark - 表示图代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifer = @"CellIdentifier";
       NSInteger row = indexPath.row;
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellidentifer];
    if (cell == nil)
        {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifer];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.textLabel.textColor = [UIColor colorWithRGB:0x3a3a3a];
        
    }
    
 //--------输入框
    CGRect textFieldRect = CGRectMake(0.0, 0.0f, 185.0f, 31.0f);
    
    theTextField = [[UITextField alloc] initWithFrame:textFieldRect];
    [theTextField setBorderStyle:UITextBorderStyleBezel]; //外框类型
    if (row <= 7) {
        theTextField.returnKeyType = UIReturnKeyNext;
    }else {
        theTextField.returnKeyType = UIReturnKeyDone;
    }
    theTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    theTextField.clearButtonMode = YES;
    theTextField.tag = row;
    theTextField.delegate = self;
//    if ([dataArray count] < 9) {
//        [dataArray addObject:theTextField];
//    }
//    NSString * txt =((UITextField *)[dataArray objectAtIndex:row]).text;
//    if (txt.length > 0) {
//        theTextField.text = txt;
//    }
//    
    
    switch (row)
    {
        case 0: theTextField.text = name;
                    theTextField.keyboardType = UIKeyboardTypeDefault;
        break;
        case 1:theTextField.text = sex;
                    theTextField.keyboardType = UIKeyboardTypeDefault;
        break;
        case 2:theTextField.text = tel;
                    theTextField.keyboardType = UIKeyboardTypeNumberPad;
        break;
        case 3: theTextField.text = phone;
                    theTextField.keyboardType = UIKeyboardTypeNumberPad;
        break;
        case 4:theTextField.text = email;
                    theTextField.keyboardType = UIKeyboardTypeEmailAddress;
        break;
        case 5:theTextField.text = work_experience;
                    theTextField.keyboardType = UIKeyboardTypeNumberPad;
        break;
        case 6: theTextField.text = education;
                    theTextField.keyboardType = UIKeyboardTypeDefault;
        break;
        case 7:theTextField.text = school;
                    theTextField.keyboardType = UIKeyboardTypeDefault;
        break;
        case 8:theTextField.text = student_id;
                    theTextField.keyboardType = UIKeyboardTypeNumberPad;
        break;
        default:break;
    }
    
    theTextField.placeholder = [fieldArray objectAtIndex:row];
    
    cell.textLabel.text =  [leftArray objectAtIndex:row];
    
//--------取消选中颜色
    
UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
cell.selectedBackgroundView = backView;
cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];

    cell.accessoryView = theTextField;
    
 
    
    
    //此方法为关键方法
    [theTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    [theTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
        return cell;
}
- (void)textFieldDone:(id)sender {
    //[sender resignFirstResponder];
     NSLog(@"%@",[[sender superview] superview]);
    
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];//sender是文本字段，它是表单元视图的内容视图的一个子视图,[cell.contentView addSubview: textField];
    NSIndexPath *textFieldIndexPath = [self.tableview indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row];
    NSLog(@"row == %d",row);
    row++;
//    if (row >= 8) {
//        row = 0;
//    }
    NSIndexPath *newPath = [NSIndexPath indexPathForRow:row inSection:0];
    UITableViewCell *nextCell = [self.tableview cellForRowAtIndexPath:newPath];
    UITextField *nextField = (UITextField *)nextCell.accessoryView;
//    for (UIView *oneView in nextCell.accessoryView) {
//        if ([oneView isMemberOfClass:[UITextField class]]) {
//            nextField = (UITextField *)oneView;
//        }
//    }
    if (row == 9) {
        [nextField resignFirstResponder];
    } else {
        [nextField becomeFirstResponder];
    }
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    NSLog(@"tag == %d",textField.tag);
//    return YES;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}
//--------去掉多余空白
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
//单击一个cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableview deselectRowAtIndexPath:[tableview indexPathForSelectedRow] animated:YES];
}
#pragma mark - 防止键盘挡住


//--------------获取text
- (void)textFieldWithText:(UITextField *)textField

{
//    [dataArray replaceObjectAtIndex:textField.tag withObject:textField.text];
    switch (textField.tag)
    {
        case 0:name = textField.text;break;
        case 1:sex = textField.text;break;
        case 2:tel = textField.text;break;
        case 3:phone = textField.text;break;
        case 4:email = textField.text;break;
        case 5:work_experience = textField.text;break;
        case 6: education = textField.text;break;
        case 7:school = textField.text;break;
        case 8:student_id = textField.text;break;
        default:break;
    }
    
}




#pragma mark - 下一步
- (IBAction)nextPage:(id)sender {
//    NSLog(@"dataArray %@",dataArray);
    NSArray *saveArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"saveArray"];
    if ([saveArray count] > 0) {
        admin_name = [saveArray objectAtIndex:0];
    }
    //--------测试数据
    /*
    name = @"潘好";
    sex = @"女";
    tel = @"01082559208";
    phone = @"15311739162";
    email = @"haohaodecuicui@sina.cn";
    work_experience = @"3年";
    education = @"本科";
    school = @"北京大学";
    student_id = @"0001";
     */
    //--------测试数据--------
    if (name.length == 0 || sex.length == 0 || tel.length == 0 || phone.length == 0 || email.length == 0 || work_experience.length == 0 || education.length == 0 || school.length == 0 || student_id.length == 0 )
        {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请把信息填写完整后继续!";
        hud.margin = 10.f;
        hud.yOffset = 170.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:2];
        return;
    }
    else
        {
    NSArray * infoArray = @[name,sex,tel,phone,email,work_experience,education,school,admin_name,student_id,];
//    NSLog(@"%@",infoArray);
        [self netWorkwithData:infoArray];
        }
    
    
    
}
-(void)netWorkwithData:(NSArray *)dataArray
{
    //--------网络连接相关
    
#if NS_BLOCKS_AVAILABLE
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    __block NSString *loadStatus;
	[self.view addSubview:hud];
	hud.labelText = @"注册中...";
	
	[hud showAnimated:YES whileExecutingBlock:^{
        
        loadStatus  =   [self getDataFromURLUseString:@"http://bm.taiqiedu.com/site/login?r=rest/inserstu" dataArray:dataArray];
//        loadStatus = [self getDataFromURLUseString:@"http://bm.taiqiedu.com/site/login?r=rest/list"];
	} completionBlock:^{
		
        NSLog(@"userID == %@",loadStatus);
        //-------用户名密码错误
        if ([loadStatus isEqualToString:@"error"])
        {
        [hud removeFromSuperview];
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning1.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.delegate = self;
            
            [HUD show:YES];
            [HUD hide:YES afterDelay:3];
            
        }
        //---------下一步
        else
            {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:loadStatus forKey:@"userID"];
            [userDefaults setObject:[NSNumber numberWithInt:4] forKey:@"project_id"];
            [userDefaults synchronize];
            
            
    Step2ViewController *step2View = [Step2ViewController new];
    step2View.modalTransitionStyle = 2;
    self.PassListValueDelegate = step2View; // 设置代理
            
           //获取列表信息
            
            
       NSDictionary *listDic =      [self getDataFromURLUseString:@"http://bm.taiqiedu.com/site/login?r=rest/list"];
            
            if ([listDic count] > 0) {
                           [self.PassListValueDelegate setListlValue:listDic];
                   [self presentViewController:step2View animated:YES completion:^{
                       [hud removeFromSuperview];
                    }];
            } else
                {
                NSLog(@"没有课程返回!");
                }
            
            }
	}];
#endif
}


-(NSDictionary *)getDataFromURLUseString:(NSString *)urlSS
{
    
    //           NSURL *url = [NSURL URLWithString:@"http://bm.taiqiedu.com/site/login?r=rest/list"];
    //    ASIFormDataRequest* formRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    
    ASIFormDataRequest* formRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlSS]];
    [formRequest startSynchronous];
    NSError *error = [formRequest error];
    
    if (!error) {
        
        NSData *data = [formRequest responseData];
        //        NSString *tmp=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//        NSLog(@"字典里面的内容为-->%@", weatherDic );
        
//        for (NSDictionary * key in weatherDic)
//                 {
//                 NSLog(@"%@   %@",[key objectForKey:@"id"],[key objectForKey:@"name"]);
//                 }

//        NSLog(@"%@",[weatherDic objectForKey:@"cou"]);
//
//        return [weatherDic objectForKey:@"cou"];
        return weatherDic;
    }
    return nil;
}
//------登录
-(NSString *)getDataFromURLUseString:(NSString *)urlSS dataArray:(NSArray *)datasArray
{
    ASIFormDataRequest* formRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlSS]];
    for (int i = 0; i < [subArray count]; i++) {
        [formRequest setPostValue:[datasArray objectAtIndex:i] forKey:[subArray objectAtIndex:i]];
    }
    [formRequest startSynchronous];
    NSError *error = [formRequest error];
    
    if (!error) {
        
        NSData *data = [formRequest responseData];
                NSString *tmp=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"返回的数据为 :   %@",tmp);
        return tmp;
    }
    return @"error";
}
- (IBAction)backPage:(id)sender {
    RootViewController *rootView = [RootViewController new];
    [self presentViewController:rootView animated:YES completion:^{
//        <#code#>
    }];
}

#pragma mark - 强制横屏
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    //return YES;
}
@end
