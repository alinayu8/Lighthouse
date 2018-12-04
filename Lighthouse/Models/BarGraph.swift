import Foundation

struct BarGraph {
    var month: String
    var value: Double
}

class DataGenerator {
    
    static var randomizedSale: Double {
        return Double(arc4random_uniform(10000) + 1) / 10
    }
    
    static func data() -> [BarGraph] {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        var bargraphs = [BarGraph]()
        
        for month in months {
            let bargraph = BarGraph(month: month, value: randomizedSale)
            bargraphs.append(bargraph)
        }
        
        return bargraphs
    }
}
