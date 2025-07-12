import Nat "mo:base/Nat";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";

actor class Token(name: Text, symbol: Text, totalSupply: Nat) = this {
  stable var _balances = HashMap.HashMap<Principal, Nat>(0, Principal.equal, Principal.hash);
  stable var _totalSupply = totalSupply;
  let _name = name;
  let _symbol = symbol;

  // При инициализации вся эмиссия владельцу
  public func init(owner: Principal): async () {
    _balances.put(owner, _totalSupply);
  };

  public query func name(): async Text {
    _name
  };

  public query func symbol(): async Text {
    _symbol
  };

  public query func total_supply(): async Nat {
    _totalSupply
  };

  public query func balance_of(account: Principal): async Nat {
    switch (_balances.get(account)) {
      case (?balance) balance;
      case null 0;
    }
  };

  public func transfer(to: Principal, amount: Nat): async Bool {
    let caller = Principal.fromActor(this);
    let from = msg.caller;

    let fromBalance = switch (_balances.get(from)) {
      case (?balance) balance;
      case null 0;
    };

    if (fromBalance < amount) {
      return false;
    };

    _balances.put(from, fromBalance - amount);

    let toBalance = switch (_balances.get(to)) {
      case (?balance) balance;
      case null 0;
    };

    _balances.put(to, toBalance + amount);
    return true;
  };
}
