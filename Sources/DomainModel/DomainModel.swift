struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    var newAmount : Int = amount
    
    switch currency {
    case "USD":do{
        switch to{
        case "GBP":do {
            newAmount = amount / 2
        }
        case "EUR":do {
            newAmount = Int(Double(amount) * 1.5)
        }
        case "CAN":do {
            newAmount = Int(Double(amount) * 1.25)
        }
        default:do {
            print("nothing changed")
        }
        }
    }
    case "GBP":do{
        switch to{
        case "USD":do {
            newAmount = amount * 2
        }
        case "EUR":do {
            return Money(amount: amount, currency: currency).convert("USD").convert("EUR")
        }
        case "CAN":do {
            return Money(amount: amount, currency: currency).convert("USD").convert("CAN")
        }
        default:do {
            print("nothing changed")
        }
        }
    }
    case "EUR":do{
        switch to{
        case "USD":do {
            newAmount = Int(Double(amount) / 1.5)
        }
        case "GBP":do {
            return Money(amount: amount, currency: currency).convert("USD").convert("GBP")
        }
        case "CAN":do {
            return Money(amount: amount, currency: currency).convert("USD").convert("CAN")
        }
        default:do {
            print("nothing changed")
        }
        }
    }
    case "CAN":do{
        switch to{
        case "USD":do {
            newAmount = Int(Double(amount) / 1.25)
        }
        case "GBP":do {
            return Money(amount: amount, currency: currency).convert("USD").convert("GBP")
        }
        case "EUR":do {
            return Money(amount: amount, currency: currency).convert("USD").convert("EUR")
        }
        default:do {
            print("nothing changed")
        }
        }
    }
    default:do{
        print("nothing changed")
    }
    }
    
    return Money(amount: newAmount, currency: to)
  }
    
    public func add(_ to: Money) -> Money {
        return Money(amount: to.convert(currency).amount + amount, currency: currency).convert(to.currency)
      }
      public func subtract(_ from: Money) -> Money {
        return Money(amount: from.convert(currency).amount - amount, currency: currency).convert(from.currency)
      }
}

////////////////////////////////////
// Job
//
public class Job {
    var title : String
    var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
      }
      
      public func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case .Hourly(let hourly):
            return Int(hourly * Double(hours))
        case .Salary(let salary):
            return salary
        }
      }
      
      public func raise(byAmount amt : Double) {
        switch type {
        case .Hourly(let hourly):
            type = .Hourly(hourly + amt)
        case .Salary(let salary):
            type = .Salary(salary + Int(amt))
        }
      }
    
    public func raise(byPercent pct : Double) {
      switch type {
      case .Hourly(let hourly):
          type = .Hourly(hourly * (1+pct))
      case .Salary(let salary):
        type = .Salary(Int(Double(salary) * (1+pct)))
      }
    }
}

////////////////////////////////////
// Person
//
public class Person {
  var firstName : String = ""
  var lastName : String = ""
  var age : Int = 0

  var _job : Job? = nil
  public var job : Job? {
    get { return self._job }
    set(value) {
        if age >= 16 {
            self._job = value
        } else {
            self._job = nil
        }
    }
  }
  
  var _spouse : Person? = nil
  public var spouse : Person? {
    get { return self._spouse }
    set(value) {
        if age >= 18 {
            self._spouse = value
        } else {
            self._spouse = nil
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    print("[Person: firstName: \(firstName) lastName: \(lastName) age: \(age) job: \(String(describing: job?.type)) spouse: \(String(describing: spouse?.firstName))]")
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: job?.type)) spouse:\(String(describing: spouse?.firstName))]"
  }
}

////////////////////////////////////
// Family
//
public class Family {
var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
        members.append(spouse1)
        members.append(spouse2)
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
  }
  
  open func haveChild(_ child: Person) -> Bool {
    for member in members {
        if member.age >= 21 {
            members.append(child)
            return true
        }
    }
    return false
  }
  
  open func householdIncome() -> Int {
    var income : Int = 0
    for member in members {
        if member.job != nil{
            switch (member.job!.type){
                case .Salary:
                    income += member.job!.calculateIncome(1)
                case .Hourly:
                    income += (member.job!.calculateIncome(2000))
                }
            //print("!!!!tested!!!!")
        }
    }
    return income
  }
}
