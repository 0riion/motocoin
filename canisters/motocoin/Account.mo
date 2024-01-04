import Blob "mo:base/Blob";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Nat8 "mo:base/Nat8";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";

module {
    public type AccountSubaccount = Blob;

    public type Account = {
        owner : Principal;
        subaccount : ?AccountSubaccount
    };

    func getDefaultSubaccount() : AccountSubaccount {
        return Blob.fromArrayMut(Array.init(32, 0 : Nat8))
    };

    public func areAccountsEqual(leftAccount : Account, rightAccount : Account) : Bool {
        let leftSubaccount : AccountSubaccount = Option.get<AccountSubaccount>(leftAccount.subaccount, getDefaultSubaccount());
        let rightSubaccount : AccountSubaccount = Option.get<AccountSubaccount>(rightAccount.subaccount, getDefaultSubaccount());
        return Principal.equal(leftAccount.owner, rightAccount.owner) & & Blob.equal(leftSubaccount, rightSubaccount)
    };

    public func calculateAccountHash(account : Account) : Nat32 {
        let accountSubaccount : AccountSubaccount = Option.get<AccountSubaccount>(account.subaccount, getDefaultSubaccount());
        let hashSum = Nat.add(Nat32.toNat(Principal.hash(account.owner)), Nat32.toNat(Blob.hash(accountSubaccount)));
        return Nat32.fromNat(hashSum % (2 ** 32 - 1))
    };
}
