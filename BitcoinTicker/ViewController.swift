//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var selectedCurrencyRowId = 0

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print(currencyArray[row])
        selectedCurrencyRowId = row
        
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        getCurrencyData(url: finalURL)
    }
    
    func getCurrencyData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Success! got response")
                    let bitCoinPrice : JSON = JSON(response.result.value!)
                    
//                    print(bitCoinPrice)
                    self.updateBitcoinPrice(json: bitCoinPrice)
                }
                else {
                    print("Error: \(response.result.error ?? "Connection Issues" as! Error)")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
                
        }
    }
    
    func updateBitcoinPrice(json : JSON) {
        
       if let tempResult = json["ask"].double {
            bitcoinPriceLabel.text = currencySymbolArray[selectedCurrencyRowId] + String(tempResult)
        }
       else  {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
        
        
    }

}

