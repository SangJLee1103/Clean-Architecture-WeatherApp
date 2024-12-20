//
//  Date+Extension.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/20/24.
//

import Foundation

extension Date {
    func formatKoreanDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        return dateFormatter.string(from: date)
    }
    
}
