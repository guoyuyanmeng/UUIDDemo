//
//  ViewController.m
//  UUIDDemo
//
//  Created by kang on 2016/10/20.
//  Copyright © 2016年 kang. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import <AdSupport/AdSupport.h>

#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - set subviews
- (void) setSubViews {
    
    [self setUUIDLabel];
    [self setIdentifierLabel];
}

- (void) setUUIDLabel {

    UILabel *uuidLabel = [[UILabel alloc]init];
    uuidLabel.frame = CGRectMake(0, 0, self.view.frame.size
                                 .width-60, 40);
    uuidLabel.center = self.view .center;
    //    uuidLabel.lineBreakMode = NSLineBreakByCharWrapping;
    uuidLabel.numberOfLines = 3;
    uuidLabel.text = [self getUUID];
    uuidLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:uuidLabel];
}


- (void) setIdentifierLabel {
    
    UILabel *identifierLabel = [[UILabel alloc]init];
    identifierLabel.frame = CGRectMake(0, 0, self.view.frame.size
                                 .width-60, 40);
    identifierLabel.center = CGPointMake( self.view .center.x, self.view .center.y +80);
    //    uuidLabel.lineBreakMode = NSLineBreakByCharWrapping;
    identifierLabel.numberOfLines = 3;
    identifierLabel.text = [self getIDFV];
    identifierLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:identifierLabel];
}

#pragma mark - get


/**
 * UUID
 * UUID是Universally Unique Identifier的缩写,中文意思是全局唯一识别码.
 * 废弃：
 
 @return UUID
 */
- (NSString *) getUUID {

    NSString *uuid;
//    uuid = [[UIDevice currentDevice] uniqueIdentifier];
    return uuid;
}



/**
 * UDID
 *
 * UDID的全称是Unique Device Identifier，顾名思义，它就是苹果IOS设备的唯一识别码，它由40个字符的字母和数字组成。在很多需要限制一台设备一个账号的应用中经常会用到。在iOS5中可以获取到设备的UDID，iOS7中已经完全的禁用了它。iOS7之前的使用了的app如果在iOS7上运行，它不会返回设备的UDID，而是会返回一串字符串，以FFFFFFFF开头，跟着identifierForVendor的十六进制值。
 废弃：iOS6
 
 @return UDID
 */
- (NSString *) getUDID {

    NSString *udid;
//    udid = [[UIDevice currentDevice] uniqueIdentifier];
    return udid;
}


/**
 * IDFV
 *
 * IDFV的全拼是，identifier for vendor。 Vendor是CFBundleIdentifier（反转DNS格式）的前两部分。
     来自同一个运营商的应用运行在同一个设备上，此属性的值是相同的；
     不同的运营商应用运行在同一个设备上值不同。
     经测试，只要设备上有一个tencent的app，
     重新安装后的identifierForVendor值不变，
     如果tencent的app全部删除，
     重新安装后的identifierForVendor值改变。

 @return IDFV
 */
- (NSString *) getIDFV {
    
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return idfv;
}


/**
 * IDFA
 * 广告标示符 （identifier for Identifier）
 * 广告标示符，适用于对外：例如广告推广，换量等跨应用的用户追踪等。但如果用户完全重置系统（(设置程序 -> 通用 -> 还原 -> 还原位置与隐私) ，这个广告标示符会重新生成。另外如果用户明确的还原广告(设置程序-> 通用 -> 关于本机 -> 广告 -> 还原广告标示符) ，那么广告标示符也会重新生成。注意：如果程序在后台运行，此时用户“还原广告标示符”，然后再回到程序中，此时获取广 告标示符并不会立即获得还原后的标示符。必须要终止程序，然后再重新启动程序，才能获得还原后的广告标示符。在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，用户可以在 设置 -> 隐私 -> 广告追踪 里重置此id的值，或限制此id的使用。
 
 @return IDFA
 */
- (NSString *) getIDFA {

    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfa;
}


/**
 * MAC Adress
 * MAC（Media Access Control或者Medium Access Control）
 * MAC地址在网络上用来区分设备的唯一性，接入网络的设备都有一个MAC地址，他们肯定都是不同的，是唯一的。一部iPhone上可能有多个MAC地址，包括WIFI的、SIM的等，但是iTouch和iPad上就有一个WIFI的，因此只需获取WIFI的MAC地址就好了，也就是en0的地址。MAC地址就如同我们身份证上的身份证号码，具有全球唯一性。但在iOS7之后，如果请求Mac地址都会返回一个固定值。
 * 废弃：iOS7.0+

 @return MAC Adress
 */
- (NSString *) getMACAdress {

    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    NSLog(@"outString:%@", outstring);
    
    free(buf);
    
    return [outstring uppercaseString];
}

@end
