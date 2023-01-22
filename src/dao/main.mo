import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Hash "mo:base/Hash";
import List "mo:base/List";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Prelude "mo:base/Prelude";






actor {
    //My discord is: iri#1598
    //Feel free to DM me any question.

    stable var proposalsID = 0;
    stable var proposalEntries : [(Int, Proposal)] = [];

    func natHash(n : Int) : Hash.Hash { 
        Text.hash(Int.toText(n));
    };

    let proposals = HashMap.fromIter<Int, Proposal>(proposalEntries.vals(), Iter.size(proposalEntries.vals()), Int.equal, natHash);


    





    type Proposal = {
        creator : Account;
        payload : Text;
        status: {#Open; #Passed; #Rejected;};
        timestamp : Int;
        votes : (Nat,Nat);
        voters : List.List<Principal>;
    };// TO DEFINE;


    type Status ={
        #Open;
        #Passed;
        #Rejected;
    };

    type Account = {
   owner: Principal;
   subaccount: ?Subaccount;
 };

    public type Subaccount = [Nat8];
    public type Account__1 = { owner : Principal; subaccount : ?Subaccount };
    public type Balance__1 = Nat;



    type Tokens={
        amount:Nat;
    };

    let MotokoToken : actor {icrc1_balance_of : shared query Account__1 -> async Balance__1;
    } = actor("db3eq-6iaaa-aaaah-abz6a-cai");



    public func getMbBalance(id:Principal) : async Nat {
        let account1 : Account__1 = {owner = id; subaccount = null};
        let total: Nat = await MotokoToken.icrc1_balance_of(account1);
        return total;
  }; 
  

    

    public shared({caller}) func submit_proposal(this_payload : Text) : async {#Ok : Proposal; #Err : Text} {


        let balance = await getMbBalance(caller);
        

        proposalsID += 1;
        var timeStamp = Time.now();

        var newProposal : Proposal ={
            creator = {owner = caller; subaccount = null;};
            payload = this_payload;
            status = #Open;
            timestamp = timeStamp;
            voters = List.nil<Principal>();
            votes = (0,0);
        };

        proposals.put(proposalsID,newProposal);

        return #Ok(newProposal);
        
    };

    public shared({caller}) func vote(proposal_id : Int, yes_or_no : Bool) : async {#Ok : (Nat, Nat); #Err : Text} {
        

        var proposal : ?Proposal = await get_proposal(proposal_id);
        switch(proposal) {
            case(null) {return #Err("Null Proposal" );};
            case(?something) {return #Ok(0,0); };
        };
        return #Err("Not implemented yet " );
    };

    public query func get_proposal(id : Int) : async ?Proposal {
        return proposals.get(id);
    };
    
    public query func get_all_proposals() : async [(Int, Proposal)] {
        Iter.toArray<(Int,Proposal)>(proposals.entries());
    };


    system func preupgrade() {
    proposalEntries := Iter.toArray<(Int,Proposal)>(proposals.entries());
  };

  system func postupgrade() {
    proposalEntries := [];
  };


};