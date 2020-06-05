//
//  ContentView.swift
//  test
//
//  Created by Syed Naveed on 08/01/2020.
//  Copyright © 2020 Abdul Qaadir Gilani. All rights reserved.
//

import SwiftUI


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
    @State var cb_btc_buy: Int = 0
    @State var cb_btc_sell: Int = 0
    @State var bi_btc_buy: Int = 0
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
    
    
    var body: some View {
        
        VStack {
            
            HStack {
                TextField("Enter amount", text: $amount)
                    //.textFieldStyle(.roundedBorder)
                    //.padding(10)
                
                VStack(alignment: .leading, content: {
                    HStack{
                        Text("\(crypto)")
                            .fontWeight(.heavy)
                        Image(systemName: expand1 ? "chevron.up" : "chevron.down")
                        .resizable()
                            .frame(width: 13, height: 6)
                    }
                    .onTapGesture {
                        self.expand1.toggle()
                    }
                    if expand1 {
                        Button(action: {
                            self.expand1.toggle()
                            self.crypto = "Bitcoin"
                        }) {
                            Text("Bitcoin")
                            
                        }.foregroundColor(.black)
                        
                        Button(action: {
                            self.expand1.toggle()
                            self.crypto = "Litecoin"
                        }) {
                            Text("Litecoin")
                                
                        }.foregroundColor(.black)
                        
                        Button(action: {
                            self.expand1.toggle()
                            self.crypto = "Ethereum"
                        }) {
                            Text("Ethereum")
                                
                        }.foregroundColor(.black)
                    }
                    
                    
                })
                    .padding(7)
                    .background(expand1 ? LinearGradient(gradient: Gradient(colors: [Color("DarkBlue"), Color("LightBlue")]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient: Gradient(colors: [Color("DarkBlue"), Color("LightBlue")]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(20)
                .animation(.spring())
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
            
            
            
        }
        .onAppear(perform: loadData)
        
        
    }
    
    
    func loadData(){
        cb_btc_buy = 6500
        bi_btc_buy = 6500
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
            amount_cb = Double((Int(amount) ?? 1)*cb_btc_buy)
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
            amount_bi = Double((Int(amount) ?? 1)*bi_btc_buy)
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
