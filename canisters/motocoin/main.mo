import TrieMap "mo:base/TrieMap";
import Trie "mo:base/Trie";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Principal "mo:base/Principal";

import Account "Account";
import RemoteCanisterActor "RemoteCanister"

actor class MotoCoun() {
    public type Account = Account.Account;

    stable var coinData = {
        name : Text = "MotoCoin";
        symbol : Text = "MOC";
        var supply : Nat = 0
    };

    var ledger = TrieMap.TrieMap<Account, Nat>(Account.accountsEqual, Account.accountsHash);

    public query func getTokenName() : async Text {
        return coinData.name
    };

    public query func getTokenSymbol() : async Text {
        return coinData.symbol
    };

    public query func getBalance(account : Account) : async (Nat) {
        let userAccount : ?Nat = ledger.get(account);

        switch (userAccount) {
            case (null) { return 0 };
            case (?account) {
                return account
            }
        }
    };

    public shared ({ caller }) func transfer(sender : Account, receiver : Account, amount : Nat) : async Result.Result<(), Text> {
        let senderBalance : ?Nat = ledger.get(sender);

        switch (senderBalance) {
            case (null) {
                return #err("Your " # coinData.name # " balance is not enough!")
            };

            case (?senderBalance) {
                if (senderBalance < amount) {
                    return #err("Your " # coinData.name # " balance is not enough!")
                };

                ignore ledger.replace(sender, senderBalance - amount);

                let recipientBalance : ?Nat = ledger.get(receiver);
                switch (recipientBalance) {
                    case (null) {
                        ledger.put(receiver, amount);
                        return #ok()
                    };

                    case (?recipientBalance) {
                        ignore ledger.replace(receiver, recipientBalance + amount);
                        return #ok()
                    }
                }
            }
        }
    }
}
