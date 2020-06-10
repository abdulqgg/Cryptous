//
//  ContentView.swift
//  test
//
//  Created by Syed Naveed on 08/01/2020.
//  Copyright © 2020 Abdul Qaadir Gilani. All rights reserved.
//

import SwiftUI
struct TestTextfield: UIViewRepresentable {

    @Binding var amount: String

    var keyType: UIKeyboardType

    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
      textfield.keyboardType = keyType
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textfield.doneButtonTapped(button:)))
        toolBar.items = [doneButton]
        toolBar.setItems([doneButton], animated: true)
        textfield.inputAccessoryView = toolBar
        textfield.delegate = context.coordinator
        return textfield
    }

    func updateUIView(_ uiView: UITextField, context: Context) {

        uiView.text = amount
    }

    func makeCoordinator() -> Coordinator {
        Coordinator($amount)
    }

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var amount: String

        init(_ text: Binding<String>) {
            self._amount = text
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            amount = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""

            return true
        }
    }
}
extension  UITextField{
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
       self.resignFirstResponder()
    }

}
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
            .frame(minWidth: 0, maxWidth: 175)
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
    //Dropdown scroll wheel for currency
    @State var expand_curr = false
    @State var expand1 = false
    @State var list_curr: Array = ["GBP","USD","EUR"]
    @State var index_curr = 0
    //Dropdwon scroll wheel fro crypto
    @State var expand_crp = false
    @State var expand2 = false
    @State var list_crp: Array = ["Bitcoin","Litecoin","Ethereum"]
    @State var index_crp = 0
    
    var body: some View {
        
        VStack {
            
            HStack {
                TestTextfield(amount: $amount, keyType: UIKeyboardType.phonePad)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 25)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1))
                    .padding(.leading, 10)
                
                HStack {
                    Button(action: {
                        self.expand_curr.toggle()
                        self.expand1.toggle()
                        self.expand_crp = false
                        self.expand2 = false
                    }) {
                        Text("\(list_curr[index_curr])")
                        
                    }
                    if expand1 {
                        Image(systemName: "circle.fill")
                            .foregroundColor(Color.blue)
                    }
                    else{
                        Image(systemName: "circle")
                            .foregroundColor(Color.blue)
                    }
                    
                }
                
                HStack{
                    Button(action: {
                        self.expand_crp.toggle()
                        self.expand2.toggle()
                        self.expand_curr = false
                        self.expand1 = false
                    }) {
                        Text("\(list_crp[index_crp])")
                    }
                    if expand2 {
                        Image(systemName: "circle.fill")
                            .foregroundColor(Color.blue)
                    }
                    else{
                        Image(systemName: "circle")
                            .foregroundColor(Color.blue)
                    }
                }
                
                
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
            
                
            
            HStack (spacing: 15){
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
                        Text("Buy")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        if BuyImageChange {
                            Image(systemName: "cart.badge.plus.fill")
                        }else{
                            Image(systemName: "cart.badge.plus")
                        }
                        
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
                        Text("Sell")
                            .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        if SellImageChange {
                            Image(systemName: "cart.badge.minus.fill")
                        }else{
                            Image(systemName: "cart.badge.minus")
                        }
                        
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
                .navigationBarTitle(Text("Top Exchnages to \(buysell) \(list_crp[index_crp])"), displayMode: .inline)
                
                
            }.padding(.top, 7)
            
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
                                self.expand1.toggle()
                            }) {
                                Text("Done")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                                    .padding(.vertical)
                                    //.frame(width: gp.size.width)
                            }//.background(Color.white)
                            Spacer()
                        }
                        .frame(width: gp.size.width + 1000, height: gp.size.height + 15)
                        .border(Color.blue, width: 1)
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
                                self.expand2.toggle()
                            }) {
                                Text("Done")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                                    .padding(.vertical)
                                    //.frame(width: gp.size.width)
                            }//.background(Color.white)
                            Spacer()
                        }
                        .frame(width: gp.size.width + 1000, height: gp.size.height + 15)
                        .border(Color.blue, width: 1)
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
