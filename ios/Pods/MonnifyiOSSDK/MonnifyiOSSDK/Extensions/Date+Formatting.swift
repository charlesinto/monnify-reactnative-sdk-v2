import Foundation

extension Date {
    var age: Int? {
        
        let calender =  Calendar.current
        
        let ageComponents = calender.dateComponents([.year], from: calender.startOfDay(for: self), to: calender.startOfDay(for: Date()))

        return ageComponents.year
    }

    var string: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, MMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
    
    var asDayMonthString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
    
    var asDayFullMonthString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy"
        return dateFormatter.string(from: self)
    }
}
