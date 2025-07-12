import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import Array "mo:base/Array"; // 👈 добавили!

actor Governance {
  stable var proposals : [Text] = [];

  public func greet() : async Text {
    return "Hello, Governance!";
  };

  public func addProposal(p : Text) : async Text {
    proposals := Array.append<Text>(proposals, [p]);
    return "Added proposal: " # p;
  };

  public func listProposals() : async [Text] {
    return proposals;
  };
};
