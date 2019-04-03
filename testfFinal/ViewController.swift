//
//  ViewController.swift
//  testfFinal
//
//  Created by champis on 3/4/2562 BE.
//  Copyright © 2562 sdflerfff. All rights reserved.
//



//
//  ViewController.swift
//  appApiCountry
//
//  Created by Admin on 3/4/2562 BE.
//  Copyright © 2562 Admin. All rights reserved.
//

import UIKit
import Charts

struct jsonstruct:Decodable {
    let name:String
    let capital:String
    let alpha2Code:String
    let alpha3Code:String
    let region:String
    let subregion:String
    let population: Int
    
}

class ViewController: UIViewController,ChartViewDelegate {
    var testNa = [jsonstruct]()
    var country = [Double]()
    var population = [Double]()
    var name = [String]()
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let unitsSold = [2.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 17.0, 2.0, 4.0, 5.0, 4.0]
    @IBOutlet weak var chartView: CombinedChartView!
    
    @IBAction func OKNA(_ sender: Any) {
         self.setChart(xValues: name, yValuesLineChart:  country, yValuesBarChart: population)
        print(name)
        print(country)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getdata()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func getdata(){
        let jsonUrlString = "https://restcountries.eu/rest/v2/region/asia"
        guard let url = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, responds,err) in
            guard let data = data else {return}
            do {
                
                self.testNa = try JSONDecoder().decode([jsonstruct].self, from: data)
                for mainarr in self.testNa{
                    if mainarr.subregion == "Southern Asia" {
                        self.population.append(Double(mainarr.population)/10000000)
                        self.country.append(Double(mainarr.population)/100000000)
                        self.name.append(mainarr.name)                    }
                }
            } catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
            }.resume()
    }
    func setChart(xValues: [String], yValuesLineChart: [Double], yValuesBarChart: [Double]) {
        chartView.noDataText = "Please provide data for the chart."
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals2 : [BarChartDataEntry] = [BarChartDataEntry]()
        for i in 0..<xValues.count {
            yVals1.append(ChartDataEntry(x: Double(i), y: yValuesLineChart[i],data: xValues as AnyObject?))
            yVals2.append(BarChartDataEntry(x: Double(i), y: yValuesBarChart[i],data: xValues as AnyObject?))
        }
        
        let lineChartSet = LineChartDataSet(values: yVals1, label: "Line Data")
        let barChartSet: BarChartDataSet = BarChartDataSet(values: yVals2, label: "Bar Data")
        let data: CombinedChartData = CombinedChartData()
        data.barData=BarChartData(dataSets: [barChartSet])
        if yValuesLineChart.contains(0) == false {
            data.lineData = LineChartData(dataSets:[lineChartSet] )
            
        }
        chartView.data = data
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:xValues)
        chartView.xAxis.granularity = 1
    }
}
