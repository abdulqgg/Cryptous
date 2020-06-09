//
//  ContentView.swift
//  test
//
//  Created by Syed Naveed on 08/01/2020.
//  Copyright © 2020 Abdul Qaadir Gilani. All rights reserved.
//

import SwiftUI

struct User: Codable {
    var symbol: String
    var price: String
}
struct User_cb: Codable {
    var data: User_cb1
}
struct User_cb1: Codable{
    var amount: String
}

typealias Response_cb = User_cb
typealias Response = User

struct GradientBackgroundStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: 150)
            .padding(5)
            .foregroundColor(.white)
            //.background(Color.gray)
            .background(LinearGradient(gradient: Gradient(colors: [Color("DarkBlue"), Color("LightBlue")]), startPoint: .leading, endPoint: .trailing))
            //.background(configuration.isPressed ? LinearGradient(gradient: Gradient(colors: [Color.red, Color("SoftRed")]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeIn)
    }
}


struct ContentView: View {
    // Inputs
    @State var buysell = "buy"
    @State var amount: String = ""
    @State var crypto: String = "Bitcoin"
    // Exchnages total amount (quantity * value)
    @State var amount_cb: Double = 0
    @State var amount_bi: Double = 0
    // Values of crypto (fetched by webapi)
    @State var cb_btc_buy: Double = 0
    @State var cb_btc_sell: Int = 0
    @State var bi_btc_buy: Double = 0
    @State var bi_btc_sell: Int = 0
    // Crypto exchange fees
    @State var cb_fees: Double = 0
    @State var bi_fees: Double = 0
    // Crypto payment methods
    @State var cb_paymeth: String = "Bank Transfer"
    @State var bi_paymeth: String = "BTC Deposit"
    // Crypto payment fees
    @State var cb_payfees: Double = 0
    @State var bi_payfees: Double = 0
    // Ranking of exchanges
    @State var first: Int = 0
    @State var second: Int = 0
    @State var first_name: String = "Coinbase Pro"
    @State var second_name: String = "Binance"
    // Button animation
    @State var BuyImageChange = false
    @State var SellImageChange = false
    // Dropdown animation
    @State var expand1 = false
    
    @State var expand_curr = false
    @State var list_curr: Array = ["GBP","USD","EUR"]
    @State var index_curr = 0
    
    @State var expand_crp = false
    @State var list_crp: Array = ["Bitcoin","Litecoin","Ethereum"]
    @State var index_crp = 0
    
    var body: some View {
        
        VStack {
            
            HStack {
                TextField("Enter amount", text: $amount)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 40)
                    .padding(.leading, 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1))
                    .padding(.leading, 10)
                    .keyboardType(UIKeyboardType.numberPad)
                
                Button(action: {
                    self.expand_curr.toggle()
                    self.expand_crp = false
                }) {
                    Text("\(list_curr[index_curr])")
                }
                
                Button(action: {
                    self.expand_crp.toggle()
                    self.expand_curr = false
                }) {
                    Text("\(list_crp[index_crp])")
                }

                
                
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
            
                
            
            HStack (spacing: 10){
                Button(action: {
                    self.buysell = "buy"
                    self.BuyImageChange.toggle()
                    self.SellImageChange = false
                    //print(self.buysell)
                    self.coinbase()
                    self.binance()
                    self.ranker()
                    self.fetchUsers_bi(amount: 0)
                    self.fetchUsers_cb(amount: 0)
                }) {
                    HStack {
                        if BuyImageChange {
                            
                            Image("buy")
                        }else{
                            Image("sell")}
                        
                        Text("Buy")
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                    }
                }.buttonStyle(GradientBackgroundStyle())
            
                Button(action: {
                    self.buysell = "sell"
                    self.SellImageChange.toggle()
                    self.BuyImageChange = false
                    //print(self.buysell)
                    self.coinbase()
                    self.binance()
                    self.ranker()
                }) {
                    HStack {
                        if SellImageChange {
                            Image("buy")
                        }else{
                            Image("sell")
                        }
                        
                        Text("Sell")
                            .fontWeight(.semibold)
                        .foregroundColor(Color.black)

                    }
                }.buttonStyle(GradientBackgroundStyle())
                
            }
            
            
            
            
            NavigationView{
                List{
                    Section(header: Text("\(first_name)")){
                        Text("\(first)")
                        Text("Fees: \(cb_fees)")
                        Text("\(cb_paymeth) \(cb_payfees)")
                    }
                    //.listRowBackground(Color("PaleBlue"))
                    Section(header: Text("\(second_name)")){
                        Text("\(second)")
                        Text("Fees: \(bi_fees)")
                        Text("\(cb_paymeth) \(cb_payfees)")
                    }
                    //.listRowBackground(Color.red)
                    Section(header: Text("\(second_name)")){
                        Text("\(second)")
                        Text("Fees: \(bi_fees)")
                        Text("\(cb_paymeth) \(cb_payfees)")
                    }
                }
                .navigationBarTitle(Text("Top Exchnages to \(buysell)"), displayMode: .inline)
                    
                
            }
            
            if expand_curr {
                
                Picker(selection: $index_curr, label: EmptyView()) {
                    ForEach(0 ..< list_curr.count) {
                        Text(self.list_curr[$0]).tag($0)
                    }
                }.labelsHidden()
                .overlay(
                    GeometryReader { gp in
                        VStack {
                            Button(action: {
                                self.expand_curr.toggle()
                            }) {
                                Text("Return")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                    .padding(.vertical)
                                    .frame(width: gp.size.width)
                            }.background(Color.white)
                            Spacer()
                        }
                        //.frame(width: gp.size.width, height: gp.size.height - 12)
                        //.border(Color.black, width: 8)
                    }
                )
                
            }
            if expand_crp {
                
                Picker(selection: $index_crp, label: EmptyView()) {
                    ForEach(0 ..< list_crp.count) {
                        Text(self.list_crp[$0]).tag($0)
                    }
                }.labelsHidden()
                .overlay(
                    GeometryReader { gp in
                        VStack {
                            Button(action: {
                                self.expand_crp.toggle()
                            }) {
                                Text("Return")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                    .padding(.vertical)
                                    .frame(width: gp.size.width)
                            }.background(Color.white)
                            Spacer()
                        }
                        //.frame(width: gp.size.width, height: gp.size.height - 12)
                        //.border(Color.black, width: 8)
                    }
                )
            }
            
            
        }
        .onAppear(perform: loadData)
        
        
    }
    func fetchUsers_bi(amount: Int) {
        let url:URL = URL(string: "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT")!

        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let err = err { print(err) }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                self.bi_btc_buy = Double(response.price) ?? 0
            } catch let err {
                print(err)
            }
        }.resume()
    }
    func fetchUsers_cb(amount: Int) {
        let url:URL = URL(string: "https://api.coinbase.com/v2/prices/BTC-USD/buy")!

        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let err = err { print(err) }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(Response_cb.self, from: data)
                print(response.data.amount)
                self.cb_btc_buy = Double(response.data.amount) ?? 0
            } catch let err {
                print(err)
            }
        }.resume()
    }
    
    func loadData(){
        
        
        cb_btc_buy = 6500
        //bi_btc_buy = 6500
        cb_btc_sell = 6500
        bi_btc_sell = 6500
    }
    
    func ranker(){
        var list_of_exchnages = [Double]()
        list_of_exchnages.append(amount_cb)
        list_of_exchnages.append(amount_bi)
        list_of_exchnages.sort()
        first = Int(list_of_exchnages[1])
        second = Int(list_of_exchnages[0])
        // first = more expensive
        // second = cheaper
        // for buy no1 = cheaper (so sell no1 = second)
        
        if buysell == "buy"{
            first = Int(list_of_exchnages[0]) // first = cheaper
            second = Int(list_of_exchnages[1]) // second = more expensive
            if first == Int(amount_cb){first_name = "Coinbase Pro"}
            else if first == Int(amount_bi){first_name = "Binance"}
            if second == Int(amount_bi){second_name = "Binance"}
            else if second == Int(amount_cb){second_name = "Coinbase Pro"}
        }
        else if buysell == "sell"{
            if first == Int(amount_cb){first_name = "Coinbase Pro"}
            else if first == Int(amount_bi){first_name = "Binance"}
            if second == Int(amount_bi){second_name = "Binance"}
            else if second == Int(amount_cb){second_name = "Coinbase Pro"}
        }

    }
    
    func coinbase(){
        if buysell == "buy"{
            amount_cb = Double((Int(amount) ?? 1)*Int(cb_btc_buy))
            if amount_cb < 100000{
                cb_fees = Double(amount_cb) * Double(0.0025)}
            else if amount_cb >= 100000 && amount_cb < 1000000{
                cb_fees = Double(amount_cb) * Double(0.0020)}
            else{cb_fees = Double(amount_cb) * Double(0.0018)}
            amount_cb += cb_fees
        }
        
        else if buysell == "sell"{
            amount_cb = Double((Int(amount) ?? 1)*cb_btc_sell)
            if amount_cb < 100000{
                cb_fees = Double(amount_cb) * Double(0.0025)}
            else if amount_cb >= 100000 && amount_cb < 1000000{
                cb_fees = Double(amount_cb) * Double(0.0020)}
            else{cb_fees = Double(amount_cb) * Double(0.0018)}
            amount_cb -= cb_fees
            
        }
    }

    func binance(){
        if buysell == "buy"{
            amount_bi = Double((Int(amount) ?? 1)*Int(bi_btc_buy))
            if Int(amount) ?? 1 <= 4500{
                bi_fees = Double(amount_bi) * Double(0.001)}
            else if Int(amount) ?? 1 <= 10000{
                bi_fees = Double(amount_bi) * Double(0.0009)}
            else if Int(amount) ?? 1 <= 20000{
                bi_fees = Double(amount_bi) * Double(0.0008)}
            else{bi_fees = Double(amount_bi) * Double(0.0007)}
            amount_bi += bi_fees
        }
            
        else if buysell == "sell"{
            amount_bi = Double((Int(amount) ?? 1)*bi_btc_sell)
            if Int(amount) ?? 1 <= 4500{
                bi_fees = Double(amount_bi) * Double(0.001)}
            else if Int(amount) ?? 1 <= 10000{
                bi_fees = Double(amount_bi) * Double(0.0009)}
            else if Int(amount) ?? 1 <= 20000{
                bi_fees = Double(amount_bi) * Double(0.0008)}
            else{bi_fees = Double(amount_bi) * Double(0.0007)}
            amount_bi -= bi_fees
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
