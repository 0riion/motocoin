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
}
