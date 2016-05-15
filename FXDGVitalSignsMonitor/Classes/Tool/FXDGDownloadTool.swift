

import UIKit
import AFNetworking
enum RequestType{
    case GET
    case POST
}
class FXDGDownloadTool: AFHTTPSessionManager {
    static let shareDownloadToll : FXDGDownloadTool = {
        let downloadTool = FXDGDownloadTool()
        //扩展AFNetwork识别"text/html"
        downloadTool.responseSerializer.acceptableContentTypes?.insert("text/html")
        
        return downloadTool
    }()
    
    
    
}
//mark:-请求封装
extension FXDGDownloadTool{
    func request(requestType : RequestType , URLString : String , parameters:[String : AnyObject] , finished:(result : AnyObject? , error : NSError?)->()){
        //定义成功/失败的闭包,在不同状态下finish的返回值不同
        let successCallBack = {(sessionDataTask:NSURLSessionDataTask, result : AnyObject?) -> Void in
            finished(result: result, error: nil)
        }
        let failureCallBack = {(sessionDataTask:NSURLSessionDataTask?, error : NSError) ->
            Void in
            finished(result: nil, error: error)
        }
        
        if requestType == .GET{
            GET(URLString, parameters: parameters,  progress: nil,success: successCallBack, failure: failureCallBack)
            
        } else{
            POST(URLString, parameters: parameters,  progress: nil,success: successCallBack, failure: failureCallBack)
        }
        
    }
    
    
}
//mark:-下载方法
extension FXDGDownloadTool{
    
    func downloadCommodityDate(offset : Int ,finished : (result :[[String : AnyObject]]? , error : NSError?)->() ){
        let commodityDateURLStr = "http://mobapi.meilishuo.com/2.0/twitter/popular.json"
        let parameters = ["offset" : "\(offset)", "limit" : "30", "access_token" : "b92e0c6fd3ca919d3e7547d446d9a8c2"]
        //        发送网络请求,下载完成的数据以闭包的方式返回
        request(.GET, URLString: commodityDateURLStr, parameters: parameters) { (result, error) -> () in
            //判断请求是否失败
            if error != nil{
                finished(result: nil, error: error)
                print("error")
                return
            }
            //判断result是否有值(请求成功但没有值)
            guard let result = result as? [String : AnyObject] else{
                finished(result: nil, error: NSError(domain: "服务器数据异常", code: -1100, userInfo: nil))
                return
            }
            //结果正常(返回值是一个字典数组)
            finished(result: result["data"] as? [[String : AnyObject]], error: nil)
            
        }
        
    }
    
}