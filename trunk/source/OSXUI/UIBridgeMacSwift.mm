//
//  UIBridgeMacSwift.mm
//  fHash
//
//  Created by Sun Junwen on 2023/12/7.
//  Copyright © 2023 Sun Junwen. All rights reserved.
//

#import "UIBridgeMacSwift.h"

#include <stdlib.h>
#include <string>
#include <dispatch/dispatch.h>

#import <Cocoa/Cocoa.h>
#import "fHash-Swift-Header.h"

#include "Common/strhelper.h"
#include "Common/Utils.h"
#include "MacUtils.h"
#include "Common/Global.h"

using namespace std;
using namespace sunjwbase;

UIBridgeMacSwift::UIBridgeMacSwift(MainViewController *mainViewController)
:_mainViewControllerPtr(mainViewController)
{
}

UIBridgeMacSwift::~UIBridgeMacSwift()
{
}

void UIBridgeMacSwift::lockData()
{
    //MainViewController *mainViewController = _mainViewControllerPtr.get();
    //mainViewController.mainMtx->lock();
}

void UIBridgeMacSwift::unlockData()
{
    //MainViewController *mainViewController = _mainViewControllerPtr.get();
    //mainViewController.mainMtx->unlock();
}

void UIBridgeMacSwift::preparingCalc()
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MainViewController *mainViewController = _mainViewControllerPtr.get();
        [mainViewController onPreparingCalc];
    });
}

void UIBridgeMacSwift::removePreparingCalc()
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MainViewController *mainViewController = _mainViewControllerPtr.get();
        [mainViewController onRemovePreparingCalc];
    });
}

void UIBridgeMacSwift::calcStop()
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MainViewController *mainViewController = _mainViewControllerPtr.get();
        [mainViewController onCalcStop];
    });
}

void UIBridgeMacSwift::calcFinish()
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MainViewController *mainViewController = _mainViewControllerPtr.get();
        [mainViewController onCalcFinish];
    });
}

void UIBridgeMacSwift::showFileName(const ResultData& result)
{
    ResultDataSwift *resultSwift = UIBridgeMacSwift::ConvertResultDataToSwift(result);
    dispatch_async(dispatch_get_main_queue(), ^{
        MainViewController *mainViewController = _mainViewControllerPtr.get();
        [mainViewController onShowFileName:resultSwift];
    });
}

void UIBridgeMacSwift::showFileMeta(const ResultData& result)
{
    ResultDataSwift *resultSwift = UIBridgeMacSwift::ConvertResultDataToSwift(result);
    dispatch_async(dispatch_get_main_queue(), ^{
        MainViewController *mainViewController = _mainViewControllerPtr.get();
        [mainViewController onShowFileMeta:resultSwift];
    });
}

void UIBridgeMacSwift::showFileHash(const ResultData& result, bool uppercase)
{
    ResultDataSwift *resultSwift = UIBridgeMacSwift::ConvertResultDataToSwift(result);
    dispatch_async(dispatch_get_main_queue(), ^{
        MainViewController *mainViewController = _mainViewControllerPtr.get();
        [mainViewController onShowFileHash:resultSwift uppercase:uppercase];
    });
}

void UIBridgeMacSwift::showFileErr(const ResultData& result)
{
    ResultDataSwift *resultSwift = UIBridgeMacSwift::ConvertResultDataToSwift(result);
    dispatch_async(dispatch_get_main_queue(), ^{
        MainViewController *mainViewController = _mainViewControllerPtr.get();
        [mainViewController onShowFileErr:resultSwift];
    });
}

int UIBridgeMacSwift::getProgMax()
{
    return 200;
}

void UIBridgeMacSwift::updateProg(int value)
{
}

void UIBridgeMacSwift::updateProgWhole(int value)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MainViewController *mainViewController = _mainViewControllerPtr.get();
        [mainViewController onUpdateProgWhole:value];
    });
}

void UIBridgeMacSwift::fileCalcFinish()
{
}

void UIBridgeMacSwift::fileFinish()
{
}

ResultDataSwift *UIBridgeMacSwift::ConvertResultDataToSwift(const ResultData& result)
{
    ResultDataSwift *resultDataSwift = [[ResultDataSwift alloc] init];
    switch (result.enumState)
    {
        case ResultState::RESULT_NONE:
            resultDataSwift.state = ResultDataSwift.RESULT_NONE;
            break;
        case ResultState::RESULT_PATH:
            resultDataSwift.state = ResultDataSwift.RESULT_PATH;
            break;
        case ResultState::RESULT_META:
            resultDataSwift.state = ResultDataSwift.RESULT_META;
            break;
        case ResultState::RESULT_ALL:
            resultDataSwift.state = ResultDataSwift.RESULT_ALL;
            break;
        case ResultState::RESULT_ERROR:
            resultDataSwift.state = ResultDataSwift.RESULT_ERROR;
            break;
    }
    resultDataSwift.strPath = MacUtils::ConvertUTF8StringToNSString(tstrtostr(result.tstrPath));
    resultDataSwift.ulSize = result.ulSize;
    resultDataSwift.strMDate = MacUtils::ConvertUTF8StringToNSString(tstrtostr(result.tstrMDate));
    resultDataSwift.strVersion = MacUtils::ConvertUTF8StringToNSString(tstrtostr(result.tstrVersion));
    resultDataSwift.strMD5 = MacUtils::ConvertUTF8StringToNSString(tstrtostr(result.tstrMD5));
    resultDataSwift.strSHA1 = MacUtils::ConvertUTF8StringToNSString(tstrtostr(result.tstrSHA1));
    resultDataSwift.strSHA256 = MacUtils::ConvertUTF8StringToNSString(tstrtostr(result.tstrSHA256));
    resultDataSwift.strSHA512 = MacUtils::ConvertUTF8StringToNSString(tstrtostr(result.tstrSHA512));
    resultDataSwift.strError = MacUtils::ConvertUTF8StringToNSString(tstrtostr(result.tstrError));

    return resultDataSwift;
}
