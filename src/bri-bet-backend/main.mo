import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Option "mo:base/Option";
import Array "mo:base/Array";

actor {

  var balances : HashMap.HashMap<Principal, Nat> = HashMap.HashMap<Principal, Nat>(
    0, Principal.equal, Principal.hash
  );

  public query func icrc1_balance_of(who : Principal) : async Nat {
    Option.get(balances.get(who), 0);
  };

  public func mint(who : Principal, amount : Nat) : async () {
    let current = Option.get(balances.get(who), 0);
    balances.put(who, current + amount);
  };

  public query func icrc1_total_supply() : async Nat {
    var sum : Nat = 0;
    for ((_, amount) in balances.entries()) {
      sum += amount;
    };
    sum
  };

  public query func get_all_balances() : async [(Principal, Nat)] {
    Array.fromIter(balances.entries());
  };

};
