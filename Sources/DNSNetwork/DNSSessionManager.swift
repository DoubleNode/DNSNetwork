//
//  DNSSessionManager.swift
//  DNSCore
//
//  Created by Darren Ehlers on 10/14/19.
//  Copyright © 2019 DoubleNode.com. All rights reserved.
//

import Alamofire
import Foundation

public protocol DNSSessionManagerProtocol {
    func success(with httpResponse: HTTPURLResponse, and responseObject: Any?)

    func serverError(with httpResponse: HTTPURLResponse, and responseObject: Any?)
    func dataError(with errorData: Data, and errorMessage: String)
    func unknownError(with error: Error)
    func noResponseError()
}

/*
public class DNSSessionManager: SessionManager {

    required init() {
        super.init()
        
        self.delegate.sessionDidFinishEventsForBackgroundURLSession = { session in
            
        }
    }

    @discardableResult
    public func sendTask(with request: URLRequestConvertible) -> DataRequest {
        return super.request(request)
    }
    
    /*
    - (NSURLSessionDataTask*)sendTaskWithRequest:(NSURLRequest*)request
                              serverErrorHandler:(void(^ _Nullable)(NSHTTPURLResponse* _Nullable httpResponse, id _Nullable responseObject))serverErrorHandler
                                dataErrorHandler:(void(^ _Nullable)(NSData* _Nullable errorData, NSString* _Nullable errorMessage))dataErrorHandler
                             unknownErrorHandler:(void(^ _Nullable)(NSError* _Nullable dataError))unknownErrorHandler
                           noResponseBodyHandler:(void(^ _Nullable)(void))noResponseBodyHandler
                               completionHandler:(void(^ _Nullable)(NSURLResponse* _Nonnull response, id _Nullable responseObject))completionHandler
    {
        return [super dataTaskWithRequest:request
                           uploadProgress:
                ^(NSProgress* _Nonnull uploadProgress)
                {
                }
                         downloadProgress:
                ^(NSProgress* _Nonnull downloadProgress)
                {
                }
                        completionHandler:
                ^(NSURLResponse* _Nonnull response, id _Nullable responseObject, NSError* _Nullable dataError)
                {
                    if (dataError)
                    {
                        DNCLog(DNCLL_Info, DNCLD_Networking, @"DATAERROR - %@", response.URL);
                        
                        if (dataError.code == NSURLErrorTimedOut)
                        {
                            NSHTTPURLResponse*  httpResponse;
                            if ([response isKindOfClass:NSHTTPURLResponse.class])
                            {
                                httpResponse    = (NSHTTPURLResponse*)response;
                            }
                            
                            if (!responseObject)
                            {
                                responseObject  = [NSString stringWithFormat:@"{ \"error\" : \"%@\", \"url\" : \"%@\" }", dataError.localizedDescription, dataError.userInfo[NSURLErrorFailingURLStringErrorKey]];
                            }
                            
                            DNCLog(DNCLL_Info, DNCLD_Networking, @"WILLRETRY - %@", response.URL);
                            [DNCThread afterDelay:0.2f
                                              run:
                             ^()
                             {
                                 serverErrorHandler ? serverErrorHandler(httpResponse, responseObject) : nil;
                             }];
                            return;
                        }
                        
                        NSData*    errorData   = dataError.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                        if (errorData.length)
                        {
                            NSString*  errorString = [NSString.alloc initWithData:errorData
                                                                         encoding:NSASCIIStringEncoding];
                            DNCLog(DNCLL_Debug, DNCLD_General, @"data=%@", errorString);
                        }
                        
                        if ([response isKindOfClass:NSHTTPURLResponse.class])
                        {
                            NSHTTPURLResponse*    httpResponse    = (NSHTTPURLResponse*)response;
                            if (httpResponse.statusCode == 500)
                            {
                                DNCLog(DNCLL_Info, DNCLD_Networking, @"WILLRETRY - %@", response.URL);
                                [DNCThread afterDelay:0.2f
                                                  run:
                                 ^()
                                 {
                                     serverErrorHandler ? serverErrorHandler(httpResponse, responseObject) : nil;
                                 }];
                                return;
                            }
                        }
                        
                        if (errorData)
                        {
                            id jsonData = [NSJSONSerialization JSONObjectWithData:errorData
                                                                          options:0
                                                                            error:nil];
                            if (jsonData)
                            {
                                NSString*  errorMessage = [self stringFromString:jsonData[@"error"]];
                                if (!errorMessage.length)
                                {
                                    id  jsonDataErrors  = jsonData[@"errors"];
                                    if ([jsonDataErrors isKindOfClass:NSArray.class] &&
                                        [jsonDataErrors count] > 0)
                                    {
                                        id  jsonDataErrorsError = jsonDataErrors[0];
                                        if ([jsonDataErrorsError isKindOfClass:NSDictionary.class])
                                        {
                                            errorMessage    = [self stringFromString:jsonDataErrorsError[@"message"]];
                                        }
                                    }
                                }
                                if (!errorMessage.length)
                                {
                                    errorMessage    = [self stringFromString:jsonData[@"errorDetails"]];
                                }
                                if (!errorMessage.length)
                                {
                                    errorMessage    = [self stringFromString:jsonData[@"errorMessage"]];
                                }
                                if (!errorMessage.length)
                                {
                                    errorMessage    = [self stringFromString:jsonData[@"data"][@"error"]];
                                }
                                if (!errorMessage.length)
                                {
                                    errorMessage    = [self stringFromString:jsonData[@"data"][@"message"]];
                                }
                                if (!errorMessage.length)
                                {
                                    errorMessage    = [self stringFromString:jsonData[@"message"]];
                                }
                                if (!errorMessage.length)
                                {
                                    errorMessage    = [self stringFromString:dataError.userInfo[NSLocalizedDescriptionKey]];
                                }
                                
                                dataErrorHandler ? dataErrorHandler((jsonData ?: errorData), errorMessage) : nil;
                                return;
                            }
                        }
                        
                        unknownErrorHandler ? unknownErrorHandler(dataError) : nil;
                        return;
                    }
                    
                    if (!responseObject)
                    {
                        noResponseBodyHandler ? noResponseBodyHandler() : nil;
                        return;
                    }
                    
                    completionHandler ? completionHandler(response, responseObject) : nil;
                }];
    }
    */

}

/*
- (NSURLSessionDataTask* _Nonnull)dataTaskWithRequest:(NSURLRequest* _Nonnull)request
             withData:(NSData* _Nonnull)data
   serverErrorHandler:(void(^ _Nullable)(NSHTTPURLResponse* _Nullable httpResponse,
                                            id _Nullable responseObject))serverErrorHandler
     dataErrorHandler:(void(^ _Nullable)(NSData* _Nullable errorData,
                                        NSString* _Nullable errorMessage))dataErrorHandler
  unknownErrorHandler:(void(^ _Nullable)(NSError* _Nullable dataError))unknownErrorHandler
noResponseBodyHandler:(void(^ _Nullable)(void))noResponseBodyHandler
    completionHandler:(void(^ _Nullable)(NSURLResponse* _Nonnull response,
                                        id _Nullable responseObject))completionHandler;
*/
*/
