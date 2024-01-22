import Blob "mo:base/Blob";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Nat8 "mo:base/Nat8";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";

module {
    public type Subaccount = Blob;
    public type Account = {
        owner : Principal;
        subaccount : ?Subaccount
    };

    func _getDefaultSubaccount() : Subaccount {
        Blob.fromArrayMut(Array.init(32, 0 : Nat8))
    };

    public func accountsEqual(leftAccount : Account, rightAccount : Account) : Bool {
        let leftSubaccount : Subaccount = Option.get<Subaccount>(leftAccount.subaccount, _getDefaultSubaccount());
        let rightSubaccount : Subaccount = Option.get<Subaccount>(rightAccount.subaccount, _getDefaultSubaccount());
        Principal.equal(leftAccount.owner, rightAccount.owner) and Blob.equal(leftSubaccount, rightSubaccount)
    };

    public func accountsHash(account : Account) : Nat32 {
        let accountSubaccount : Subaccount = Option.get<Subaccount>(account.subaccount, _getDefaultSubaccount());
        let hashSum = Nat.add(Nat32.toNat(Principal.hash(account.owner)), Nat32.toNat(Blob.hash(accountSubaccount)));
        Nat32.fromNat(hashSum % (2 ** 32 - 1))
    };

    public func accountBelongToPrincipal(account : Account, principal : Principal) : Bool {
        Principal.equal(account.owner, principal)
    }
}
