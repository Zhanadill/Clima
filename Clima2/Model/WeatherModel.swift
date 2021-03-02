//
//  WeatherModel.swift
//  Clima2
//
//  Created by Жанадил on 2/14/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import Foundation

struct WeatherModel{
    func getConditionImage(condition: Int) -> String{
           switch condition{
               case 200...232:
                   return "cloud.bolt"
               case 300...321:
                   return "cloud.drizzle"
               case 500...531:
                   return "cloud.rain"
               case 600...622:
                   return "cloud.snow"
               case 701...781:
                   return "cloud.fog"
               case 800:
                   return "sun.max"
               case 801...804:
                   return "cloud.bolt"
               default:
                   return "cloud"
           }
       }
}
