import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";

actor Token {
  type Account = Principal;
  type Balance = Nat;

  // Просто обычный var — не stable!
  var balances = HashMap.HashMap<Account, Balance>(10, Principal.equal, Principal.hash);

  // Жёстко укажем владельца для теста (твоя Principal ID)
  let owner : Principal = Principal.fromText("aaaaa-aa"); // Замени на свой Principal если хочешь

  public func initialize(amount : Balance) : async () {
    balances.put(owner, amount);
  };

  public query func icrc1_balance_of(account : { owner : Principal; subaccount : ?Blob }) : async Balance {
    switch (balances.get(account.owner)) {
      case (?value) value;
      case (null) 0;
    }
  };

  public func icrc1_transfer(args : {
    from_subaccount : ?Blob;
    to : { owner : Principal; subaccount : ?Blob };
    amount : Balance;
    fee : ?Nat;
    memo : ?Blob;
    created_at_time : ?Nat64;
  }) : async { ok : Nat } {
    let from = owner; // отправитель — жёстко зашитый owner
    let to = args.to.owner;

    let sender_balance = switch (balances.get(from)) {
      case (?b) b;
      case (null) 0;
    };

    if (sender_balance < args.amount) {
      return { ok = 0 };
    };

    balances.put(from, sender_balance - args.amount);

    let recipient_balance = switch (balances.get(to)) {
      case (?b) b;
      case (null) 0;
    };

    balances.put(to, recipient_balance + args.amount);

    return { ok = args.amount };
  };
};
