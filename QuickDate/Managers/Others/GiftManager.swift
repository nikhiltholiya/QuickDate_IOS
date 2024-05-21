

import Foundation
import Alamofire
import QuickDateSDK

// TODO: If it's not necessary then delete it
class GiftManager {
    static let instance = GiftManager()
    
/*    func getGift(AccessToken:String, completionBlock: @escaping (_ Success: String?,_ SessionError: String?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.COMMON_CONSTANT_METHODS.GET_GIFTS_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.COMMON_CONSTANT_METHODS.GET_GIFTS_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    Logger.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(GiftModel.GiftSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(GiftModel.sessionErrorModel.self, from: data!)
                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }*/
    
    
    func getGifts(AccessToken:String, completionBlock: @escaping (_ Success: [GiftSuccessModel]?,_ SessionError: String?, Error?) ->()) {
        let params = [
            API.PARAMS.access_token: AccessToken
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.COMMON_CONSTANT_METHODS.GET_GIFTS_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.COMMON_CONSTANT_METHODS.GET_GIFTS_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil) {
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiStatus)")
                    if let data = (res["data"] as? [JSON]) {
                        let result = data.map({GiftSuccessModel(json: $0)})
                        completionBlock(result,nil,nil)
                    }
                }else if apiStatus ==  API.ERROR_CODES.E_400 {
                    Logger.verbose("apiStatus String = \(apiStatus)")
                    Logger.error("AuthError = \((res["message"] as? String ?? ""))")
                    completionBlock(nil,res["message"] as? String,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }

}
