//
//  LeftViewController.m
//  KnowledgeSummary
//
//  Created by tidy on 15/11/6.
//  Copyright © 2015年 shudong.gao. All rights reserved.
//

#import "LeftViewController.h"
#import "PhotoBroswerVC.h"
#define TAG_Image_Tag           100
#define TAG_Image_Delete_Tag    200
#define Max_Image_count  3

#define MAIN_W self.view.frame.size.width
#define MAIN_H self.view.frame.size.height
@implementation LeftViewController
{
    UIScrollView *scrollView;
    UIButton *addImageBtn;
    NSMutableArray *imageArray;
    UIImageView *preImageView;//头像
    UIScrollView *imageScroll;//自定义
    UIImageView *photoImage;//自定义
    
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    imageArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.view.backgroundColor = [UIColor yellowColor];
    [self setFrame];
}

-(void)setFrame{
    preImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 60, 100, 100)];
    [self.view addSubview:preImageView];
    preImageView.backgroundColor = [UIColor greenColor];
    preImageView.layer.masksToBounds = YES;
    preImageView.layer.cornerRadius = 50;

    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 180, MAIN_W-20, 50)];
    [scrollView setShowsHorizontalScrollIndicator:NO];//水平滚动
    [scrollView setShowsVerticalScrollIndicator:NO];//垂直滚动
    [self.view addSubview:scrollView];
    
    addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addImageBtn.frame =CGRectMake(0, 0, 50, 50);
    [addImageBtn setBackgroundImage:[UIImage imageNamed:@"btn-添加图片"] forState:UIControlStateNormal];
    [addImageBtn setBackgroundColor:[UIColor clearColor]];
    [addImageBtn addTarget:self action:@selector(goNextView:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:addImageBtn];
    
    //自定义
    UIButton *buttonAlbum = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonAlbum.frame = CGRectMake(40, 250, 100, 50);
    [buttonAlbum setTitle:@"打开相册" forState:UIControlStateNormal];
    [buttonAlbum addTarget:self action:@selector(photoFromAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonAlbum];
    
    UIButton *buttonCamera = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonCamera.frame = CGRectMake(150, 250, 100, 50);
    [buttonCamera setTitle:@"打开相机" forState:UIControlStateNormal];
    [buttonCamera addTarget:self action:@selector(photoFromCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonCamera];
}


#pragma mark 添加图片
-(void)goNextView:(id)sender{
    if (imageArray.count >= Max_Image_count) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能选择五张照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else{
        ZLPhotoPickerViewController *pickerVC = [[ZLPhotoPickerViewController alloc]init];
        pickerVC.topShowPhotoPicker = YES;
        pickerVC.minCount = Max_Image_count - imageArray.count;
        pickerVC.status = PickerViewShowStatusCameraRoll;
        pickerVC.delegate = self;
        [pickerVC showImg:self];
    }
}


#pragma mark 相册回调
-(void)pickerViewControllerDoneAsstes:(NSArray *)assets{
    if (assets.count > Max_Image_count) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能选择五张照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    if (assets.count > Max_Image_count) {
        NSRange range = NSMakeRange(0, Max_Image_count);
        NSArray *array = [assets subarrayWithRange:range];
        [imageArray addObjectsFromArray:array];
    }
    else{
        [imageArray addObjectsFromArray:assets];
    }
    [self imageView:imageArray];
}

#pragma mark 拍照代理
-(void)pickerCollectionViewSelectCamera:(ZLPhotoPickerViewController *)pickerVc{
    if (imageArray.count>Max_Image_count) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能选择五张照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else{
        UIImagePickerController *ctrl = [[UIImagePickerController alloc]init];
        ctrl.delegate = self;
        ctrl.sourceType = UIImagePickerControllerSourceTypeCamera;
        [pickerVc presentViewController:ctrl animated:YES completion:nil];
    }
}

#pragma mark 选择照片后的回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (imageArray.count >= Max_Image_count) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能选择五张照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }else{
            UIImage *image =info[@"UIImagePickerControllerOriginalImage"];
            preImageView.image = image;
            [imageArray addObject:image];
            [self imageView:imageArray];
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请使用真机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark 展示图片
-(void)imageView:(NSMutableArray *)array
{
    scrollView.contentSize = CGSizeMake(10+50*array.count, 0);
    for (int i= 0; i<array.count; i++) {
        ZLPhotoAssets *asset = array[i];
        UIButton *btn = (UIButton *)[scrollView viewWithTag:TAG_Image_Tag + i];
        if (btn!=nil) {
            [btn removeFromSuperview];
        }
        
        UIButton *iconView = [[UIButton alloc]initWithFrame:CGRectMake(0 + i*50+i*10, 0, 50, 50)];
        if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
            [iconView setBackgroundImage:asset.originImage forState:UIControlStateNormal];
        }else if([asset isKindOfClass:[UIImage class]]){
            [iconView setBackgroundImage:(UIImage *)asset forState:UIControlStateNormal];
        }
        
        iconView.imageView.clipsToBounds = YES;
        [iconView.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [iconView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [iconView.layer setBorderWidth:1.0];
        [iconView.layer setCornerRadius:3.0f];
        [iconView.layer setMasksToBounds:YES];
        [iconView setTag:TAG_Image_Tag+i];
        [iconView addTarget:self action:@selector(checkPic:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:iconView];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(35, 0, 15, 15);
        deleteBtn.backgroundColor = [UIColor clearColor];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"图片删除"] forState:UIControlStateNormal];
        deleteBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        deleteBtn.tag =TAG_Image_Delete_Tag+i;
        [deleteBtn addTarget:nil action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.layer.cornerRadius = 4.0f;
        [iconView addSubview:deleteBtn];
        
        
        [UIView animateWithDuration:0.3 animations:^{
            addImageBtn.frame = CGRectMake(0, 0, 50, 50);
            [addImageBtn setCenter:CGPointMake(addImageBtn.center.x+60*imageArray.count, addImageBtn.center.y)];
        } completion:^(BOOL finished) {
            [self reSetImageScroll];
        }];
    }
}

#pragma mark 重设scrollview
-(void)reSetImageScroll
{
    if (imageArray.count>=Max_Image_count) {
        [scrollView setContentSize:CGSizeMake(MAX(300, 10+imageArray.count*50), 50)];
        addImageBtn.hidden = YES;
    }else{
        addImageBtn.hidden = NO;
        [scrollView setContentSize:CGSizeMake(MAX(300, 10+(imageArray.count+1)*50), 50)];
    }
    
}

#pragma mark 删除
-(void)deleteBtn:(UIButton *)btn{
    [UIView animateWithDuration:0.3 animations:^{
        UIButton *needRemoveBtn = (UIButton *)[scrollView viewWithTag:TAG_Image_Tag+(btn.tag - TAG_Image_Delete_Tag)];
        [needRemoveBtn removeFromSuperview];
        for (int i =(int)btn.tag - TAG_Image_Delete_Tag +1; i<imageArray.count; i++) {
            UIButton *deBtn = (UIButton *)[scrollView viewWithTag:TAG_Image_Tag +i];
            [deBtn setCenter:CGPointMake(deBtn.center.x - 60, deBtn.center.y)];
            [deBtn setTag:deBtn.tag - 1];
            UIButton *btnDel = (UIButton *)[scrollView viewWithTag:TAG_Image_Delete_Tag +i];
            [btnDel setTag:btnDel.tag - 1];
        }
    } completion:^(BOOL finished) {
        [imageArray removeObjectAtIndex:btn.tag - TAG_Image_Delete_Tag];
        addImageBtn.hidden = NO;
        addImageBtn.frame = CGRectMake(0, 0, 50, 50);
        [UIView animateWithDuration:0.3 animations:^{
            [addImageBtn setCenter:CGPointMake(addImageBtn.center.x + 60*imageArray.count, addImageBtn.center.y)];
        }];
    }];
}

#pragma mark 展示
-(void)checkPic:(UIButton*)sender{
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypePush index:sender.tag - TAG_Image_Tag photoModelBlock:^NSArray *{
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:imageArray.count];
        for (NSUInteger i = 0; i<imageArray.count; i++) {
            PhotoModel *pdModel = [[PhotoModel alloc] init];
            ZLPhotoAssets *asset = imageArray[i];
            if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                pdModel.image = asset.originImage;
            }else if ([asset isKindOfClass:[UIImage class]]){
                pdModel.image = (UIImage *)asset;
            }
            pdModel.mid = i+10;
            [modelsM addObject:pdModel];
        }
        
        return modelsM;
    }];
}

#pragma mark - 自定义相册
-(void)photoFromAlbum:(UIButton*)btn{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:nil];
}
-(void)photoFromCamera:(UIButton*)btn{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;//设置类型为相机
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;//设置代理
        picker.allowsEditing = YES;//设置照片可编辑
        picker.sourceType = sourceType;
        
        //创建叠加层
        UIView *overLayView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 320, 100)];//取景器的背景图片，该图片中间挖掉了一块成透明，用了显示摄像头获取的照片
        UIImage *overLayImage = [UIImage imageNamed:@"pick_bg"];
        UIImageView *bgImageView = [[UIImageView alloc]initWithImage:overLayImage];
        [overLayView addSubview:bgImageView];
        picker.cameraOverlayView = overLayView;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;//选择前置摄像头或后置摄像头
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        NSLog(@"没有相机");
    }
}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
