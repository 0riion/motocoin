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
    }
}
