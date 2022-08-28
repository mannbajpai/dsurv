import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Iter "mo:base/Iter";

actor Token {

    // Debug.print("check");
    let owner : Principal = Principal.fromText("a3qcy-75fhv-dbv3h-xknem-tknst-cyjrt-rkopq-kvpot-xxamd-gsunr-kae");
    let totalSupply : Nat = 1000000000;
    let symbol : Text = "DANN";

    private stable var balanceEntries : [(Principal,Nat)] = []; 
    private var balances = HashMap.HashMap<Principal,Nat>(1,Principal.equal,Principal.hash);
    
    if (balances.size() < 1){
            balances.put(owner,totalSupply);
    };

    public query func checkBalance(who : Principal) : async Nat{

        let balance : Nat = switch (balances.get(who)){
            case null 0;
            case (?result) result;
        };

        return balance;
    };

    public query func getSymbol() : async Text {
        return symbol;
    };

    public shared(msg) func payOut() : async Text {

        if (balances.get(msg.caller) == null){

            let amount = 10000;
            let result = await transfer(msg.caller,amount);
            return result;

        } else {
            return "You've Already Claimed";
        }
        
    };

    public shared(msg) func transfer( to: Principal, amount: Nat) : async Text {
        let fromBal = await checkBalance(msg.caller);
        if (fromBal > amount){
            let newFromBal : Nat = fromBal - amount;
            balances.put(msg.caller, newFromBal);

            let toBal = await checkBalance(to);
            let newToBal = toBal + amount ;
            balances.put(to, newToBal);

            return "Success!!!"
        } else {
            return "Insufficient Balance";
        }
    };

    system func preupgrade() {
        balanceEntries := Iter.toArray(balances.entries());
    };

    system func postupgrade() {
        balances := HashMap.fromIter<Principal,Nat>(balanceEntries.vals(),1,Principal.equal,Principal.hash);
        if (balances.size() < 1){
            balances.put(owner,totalSupply);
        }
    };
}